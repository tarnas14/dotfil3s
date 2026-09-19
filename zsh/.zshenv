export EDITOR=nvim
# firefox-like applications will know to use wayland
export MOZ_ENABLE_WAYLAND=1
# for qt applications
export QT_QPA_PLATFORM="wayland;xcb"
# same for electron
ELECTRON_OZONE_PLATFORM_HINT=auto
# wayland help for java apps (hawk tuah)
_JAVA_AWT_WM_NOREPARENTING=1

# .net
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# NEXT
export NEXT_TELEMETRY_DISABLED_1
