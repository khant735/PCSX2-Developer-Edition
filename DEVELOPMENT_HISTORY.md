# PCSX2 Developer Edition development history

- Batch 22: fixed Advanced Settings crash from null SettingsInterface.
- Batch 23: restored SVG flag support via Qt6Svg.dll and qsvg plugins.
- Batch 25: added Advanced Settings Game List Logging toggle to suppress repetitive GameList.cpp warnings and playtime messages without disabling emulator errors, BIOS logs, or custom IOP tracing.
- 2026-11-19: imported upstream PCSX2 Git history to `upstream-master` and `developer` at `f0c84e93813ae3d5e9eefd0ac9edf1bbd86e315f`.
- 2026-11-19: installed manual LLVM-MinGW workflow and build script on `developer`; requires frozen environment release asset and customized source import.

Windows executable linked in historical Batch 25 environment but not verified running on Windows.
