#!/usr/bin/env python3
"""Zoom and reading mode for kitty, as one toggle with two ways in.

    map alt+a>z       kitten reading_mode.py zoom     # the focused window alone, full width
    map alt+a>shift+z kitten reading_mode.py 0.5      # the same, padded to a centred half-width column
    map alt+a>shift+z kitten reading_mode.py 0.5 +2   # ... and the font two points bigger

Both keys enter, and while either mode is on both keys leave it: zoom exits with
alt+a z, reading mode exits with alt+a z or alt+a Shift+z. Leaving puts back the
padding, the previous layout and the font.

Runs inside the kitty process (no_ui), so it works on the window and tab directly.
The state lives on the window object; kitty re-executes this file on every key
press, so module globals would not survive between presses.
"""
from typing import Any, List, Tuple

STATE_ATTR = "_reading_mode"


def main(args: List[str]) -> str:
    return ""  # nothing to draw, everything happens in handle_result


from kittens.tui.handler import result_handler  # noqa: E402


def parse(args: List[str]) -> Tuple[float, str]:
    """-> (padding ratio, font argument). A ratio of 0 means zoom without padding."""
    params = [a for a in args if not a.endswith(".py")]
    mode = params[0] if params else "0.5"
    font = params[1] if len(params) > 1 else ""
    if mode == "zoom":
        return 0.0, font
    return max(0.1, min(1.0, float(mode))), font


@result_handler(no_ui=True)
def handle_result(args: List[str], answer: str, target_window_id: int, boss: Any) -> str:
    # returns a one-line status; `kitten @ kitten reading_mode.py ...` prints it, a key mapping ignores it
    try:
        return toggle(args, target_window_id, boss)
    except Exception:
        import traceback

        return traceback.format_exc()


def toggle(args: List[str], target_window_id: int, boss: Any) -> str:
    from kitty.fast_data_types import get_os_window_size, pt_to_px

    w = boss.window_id_map.get(target_window_id) or boss.active_window
    if w is None:
        return "no window"
    tab = w.tabref()
    if tab is None:
        return "window has no tab"
    ratio, font = parse(args)

    state = getattr(w, STATE_ATTR, None)
    if state is not None:
        # either key leaves, whichever mode is on
        if state.get("padded"):
            w.patch_edge_width("padding", "left", None)
            w.patch_edge_width("padding", "right", None)
        if state.get("layout_changed") and tab.current_layout.name == "stack":
            tab.last_used_layout()
        if state.get("font"):
            boss.change_font_size(False, None, 0)
        delattr(w, STATE_ATTR)
        tab.relayout()
        return f"off (window {w.id}, layout {tab.current_layout.name})"

    layout_changed = False
    if tab.current_layout.name != "stack":
        tab.goto_layout("stack")
        layout_changed = True
    w.scroll_prompt_to_bottom()  # what `combine : toggle_layout stack : scroll_prompt_to_bottom` did

    if ratio <= 0:
        setattr(w, STATE_ATTR, {"padded": False, "layout_changed": layout_changed, "font": False})
        tab.relayout()
        return f"zoom on (window {w.id}, layout {tab.current_layout.name})"

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
    setattr(w, STATE_ATTR, {"padded": True, "layout_changed": layout_changed, "font": bool(font)})
    tab.relayout()
    return (
        f"reading on (window {w.id}, layout {tab.current_layout.name}, "
        f"os window {width_px}px, padding {pad_pt:.1f}pt each side)"
    )
