#!/usr/bin/env python3
"""Reading mode for kitty.

The active window alone in the stack layout (as Alt+a z does), plus horizontal
padding so the text is a centred column a fraction of the OS window wide.
Pressing the key again puts padding, layout and font back.

    map alt+a>shift+z kitten reading_mode.py 0.5      # column half the window wide
    map alt+a>shift+z kitten reading_mode.py 0.5 +2   # and the font two points bigger

Runs inside the kitty process (no_ui), so it works on the window and tab directly.
The toggle state lives on the window object; kitty re-executes this file on
every key press, so module globals would not survive between presses.
"""
from typing import Any, List

STATE_ATTR = "_reading_mode"


def main(args: List[str]) -> str:
    return ""  # nothing to draw, everything happens in handle_result


from kittens.tui.handler import result_handler  # noqa: E402


def parse(args: List[str]) -> "tuple[float, str]":
    params = [a for a in args if not a.endswith(".py")]
    ratio = float(params[0]) if params else 0.5
    font = params[1] if len(params) > 1 else ""
    return max(0.1, min(1.0, ratio)), font


@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Any) -> str:
    # returns a one-line status; `kitten @ kitten reading_mode.py 0.5` prints it, the key mapping ignores it
    try:
        return toggle(args, target_window_id, boss)
    except Exception:
        import traceback
        return traceback.format_exc()


def toggle(args: List[str], target_window_id: int, boss: Any) -> str:
    from kitty.fast_data_types import get_os_window_size, pt_to_px

    w = boss.window_id_map.get(target_window_id) or boss.active_window
    if w is None:
        return "reading mode: no window"
    tab = w.tabref()
    if tab is None:
        return "reading mode: window has no tab"
    ratio, font = parse(args)

    state = getattr(w, STATE_ATTR, None)
    if state is not None:
        # leave: default padding, previous layout, default font
        w.patch_edge_width("padding", "left", None)
        w.patch_edge_width("padding", "right", None)
        if state.get("layout_changed") and tab.current_layout.name == "stack":
            tab.last_used_layout()
        if state.get("font"):
            boss.change_font_size(False, None, 0)
        delattr(w, STATE_ATTR)
        tab.relayout()
        return f"reading mode off (window {w.id}, layout {tab.current_layout.name})"

    layout_changed = False
    if tab.current_layout.name != "stack":
        tab.goto_layout("stack")
        layout_changed = True
    if font:
        op = font[0] if font[0] in "+-*/" else None
        boss.change_font_size(False, op, float(font[1:] if op else font))

    # width of the OS window in pixels; fall back to this window's own extent
    size = get_os_window_size(w.os_window_id) or {}
    width_px = size.get("width")
    if not width_px:
        g = w.geometry
        width_px = (g.right - g.left) + w.effective_padding("left") + w.effective_padding("right")
    px_per_pt = pt_to_px(1000.0, w.os_window_id) / 1000.0 or 1.0
    pad_pt = (width_px * (1.0 - ratio) / 2.0) / px_per_pt

    w.patch_edge_width("padding", "left", pad_pt)
    w.patch_edge_width("padding", "right", pad_pt)
    setattr(w, STATE_ATTR, {"layout_changed": layout_changed, "font": bool(font)})
    tab.relayout()
    return f"reading mode on (window {w.id}, layout {tab.current_layout.name}, os window {width_px}px, padding {pad_pt:.1f}pt each side)"
