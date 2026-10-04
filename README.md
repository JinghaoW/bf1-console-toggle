# BF1 Console Toggle

A Windows batch script that temporarily changes existing `EnableConsole` values in Battlefield 1 settings and restores backed-up files after `bf1.exe` exits.

## 使用方法 / Usage

1. Close Battlefield 1 before running the script. / 先退出游戏。
2. Download `BF1_Console_Pure_Toggle.bat` and double-click it. / 下载并双击脚本。
3. Start Battlefield 1 and keep the script window open. / 启动游戏，保持脚本窗口打开。
4. Exit the game normally; the script restores the original settings. / 正常退出游戏后恢复原始配置。

Requires Windows and built-in Windows PowerShell. No additional software is required.

## Scope and limitations / 适用范围与限制

- Targets Battlefield 1 only. Other Battlefield versions are not supported.
- Uses `%USERPROFILE%\Documents\Battlefield 1\settings`; redirected Documents folders, including some OneDrive setups, may not be detected.
- Backs up `PROFSAVE`, `PROFSAVE_backup`, and `PROFSAVE_profile` to `%TEMP%\BF1_Console_Backup`.
- Searches the first `EnableConsole` occurrence in each file and changes the first ASCII `1` within the following 64 bytes to `0`. This heuristic is not a validated configuration parser and effectiveness is not guaranteed for every game build.
- Restores whole files, so settings changed during that session can be overwritten.
- Closing the script window or shutting down Windows prevents automatic restoration. If backups remain, restore them manually before running again: a new run deletes the previous backup folder.
- Do not run multiple instances simultaneously: the temporary paths are shared.
- This changes game configuration; it does not block a keyboard key system-wide.
- Windows/game execution has not been tested as part of repository preparation.

## Privacy / 隐私

The script contains no hard-coded personal username, email, password, access token, or personal absolute path. It has no network requests or telemetry. Configuration backups and its generated PowerShell script remain local; do not upload them to this repository.

## License

MIT. See [LICENSE](LICENSE).
