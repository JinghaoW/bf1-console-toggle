@echo off
setlocal
title Battlefield 1 Console Temporary Disable

set "DIR=%USERPROFILE%\Documents\Battlefield 1\settings"
set "PS1=%TEMP%\bf1_console_toggle.ps1"
set "BACKUP=%TEMP%\BF1_Console_Backup"

if not exist "%DIR%\PROFSAVE" (
    echo Cannot find:
    echo %DIR%\PROFSAVE
    pause
    exit /b 1
)

if exist "%BACKUP%" rmdir /s /q "%BACKUP%"
mkdir "%BACKUP%"

copy /y "%DIR%\PROFSAVE" "%BACKUP%\PROFSAVE" >nul

if exist "%DIR%\PROFSAVE_backup" (
    copy /y "%DIR%\PROFSAVE_backup" "%BACKUP%\PROFSAVE_backup" >nul
)

if exist "%DIR%\PROFSAVE_profile" (
    copy /y "%DIR%\PROFSAVE_profile" "%BACKUP%\PROFSAVE_profile" >nul
)

> "%PS1%" echo $dir = '%DIR%'
>>"%PS1%" echo $files = @('PROFSAVE','PROFSAVE_backup','PROFSAVE_profile')
>>"%PS1%" echo $pattern = [Text.Encoding]::ASCII.GetBytes('EnableConsole')
>>"%PS1%" echo foreach($name in $files) {
>>"%PS1%" echo     $path = Join-Path $dir $name
>>"%PS1%" echo     if (!(Test-Path $path)) { continue }
>>"%PS1%" echo     $bytes = [IO.File]::ReadAllBytes($path)
>>"%PS1%" echo     for($i=0; $i -le $bytes.Length-$pattern.Length; $i++) {
>>"%PS1%" echo         $match = $true
>>"%PS1%" echo         for($j=0; $j -lt $pattern.Length; $j++) {
>>"%PS1%" echo             if($bytes[$i+$j] -ne $pattern[$j]) { $match=$false; break }
>>"%PS1%" echo         }
>>"%PS1%" echo         if($match) {
>>"%PS1%" echo             for($k=$i+$pattern.Length; $k -lt [Math]::Min($i+$pattern.Length+64,$bytes.Length); $k++) {
>>"%PS1%" echo                 if($bytes[$k] -eq 49) {
>>"%PS1%" echo                     $bytes[$k] = 48
>>"%PS1%" echo                     [IO.File]::WriteAllBytes($path,$bytes)
>>"%PS1%" echo                     Write-Host "Patched: $name"
>>"%PS1%" echo                     break
>>"%PS1%" echo                 }
>>"%PS1%" echo             }
>>"%PS1%" echo             break
>>"%PS1%" echo         }
>>"%PS1%" echo     }
>>"%PS1%" echo }

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS1%"

echo.
echo Console setting patched.
echo Start Battlefield 1 now.
echo Keep this window open.
echo.

:WAITSTART
tasklist /FI "IMAGENAME eq bf1.exe" 2>NUL | find /I "bf1.exe" >NUL
if errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto WAITSTART
)

echo BF1 detected.
echo Waiting for BF1 to close...

:WAITEXIT
tasklist /FI "IMAGENAME eq bf1.exe" 2>NUL | find /I "bf1.exe" >NUL
if not errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto WAITEXIT
)

echo.
echo BF1 closed. Restoring original files...

copy /y "%BACKUP%\PROFSAVE" "%DIR%\PROFSAVE" >nul

if exist "%BACKUP%\PROFSAVE_backup" (
    copy /y "%BACKUP%\PROFSAVE_backup" "%DIR%\PROFSAVE_backup" >nul
)

if exist "%BACKUP%\PROFSAVE_profile" (
    copy /y "%BACKUP%\PROFSAVE_profile" "%DIR%\PROFSAVE_profile" >nul
)

del "%PS1%" >nul 2>&1
rmdir /s /q "%BACKUP%"

echo Restored.
timeout /t 3 >nul

endlocal
exit