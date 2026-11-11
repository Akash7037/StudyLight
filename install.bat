@echo off
setlocal
title StudyLight Installer

call :banner
echo This installer sets up StudyLight for your Windows user account.
echo It needs Python 3 and an internet connection to install its dependencies.
echo.

if not exist "%~dp0screen.py" (
    echo ERROR: screen.py is missing. Keep install.bat beside screen.py.
    exit /b 1
)
if not exist "%~dp0requirements.txt" (
    echo ERROR: requirements.txt is missing. Keep it beside install.bat.
    exit /b 1
)
if not exist "%~dp0studylight.bat" (
    echo ERROR: studylight.bat is missing. Keep it beside install.bat.
    exit /b 1
)
if not exist "%~dp0uninstall.ps1" (
    echo ERROR: uninstall.ps1 is missing. Keep it beside install.bat.
    exit /b 1
)

set "PYTHON="
where py >nul 2>nul
if not errorlevel 1 (
    py -3 --version >nul 2>nul
    if not errorlevel 1 set "PYTHON=py -3"
)
if not defined PYTHON (
    where python >nul 2>nul
    if not errorlevel 1 (
        python --version >nul 2>nul
        if not errorlevel 1 set "PYTHON=python"
    )
)
if not defined PYTHON (
    echo ERROR: Python 3 was not found. Install Python 3, then run this installer again.
    echo During Python setup, enable the option to add Python to PATH.
    exit /b 1
)

set "INSTALL_DIR=%LOCALAPPDATA%\Programs\StudyLight"
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"
if errorlevel 1 (
    echo ERROR: Could not create "%INSTALL_DIR%".
    exit /b 1
)

copy /Y "%~dp0screen.py" "%INSTALL_DIR%\screen.py" >nul
if errorlevel 1 (
    echo ERROR: Could not copy screen.py.
    exit /b 1
)
copy /Y "%~dp0requirements.txt" "%INSTALL_DIR%\requirements.txt" >nul
if errorlevel 1 (
    echo ERROR: Could not copy requirements.txt.
    exit /b 1
)
copy /Y "%~dp0studylight.bat" "%INSTALL_DIR%\studylight.bat" >nul
if errorlevel 1 (
    echo ERROR: Could not copy studylight.bat.
    exit /b 1
)
copy /Y "%~dp0uninstall.ps1" "%INSTALL_DIR%\uninstall.ps1" >nul
if errorlevel 1 (
    echo ERROR: Could not copy uninstall.ps1.
    exit /b 1
)

if not exist "%INSTALL_DIR%\.venv\Scripts\python.exe" (
    echo Creating a private Python environment...
    %PYTHON% -m venv "%INSTALL_DIR%\.venv"
    if errorlevel 1 (
        echo ERROR: Could not create the Python environment.
        exit /b 1
    )
)

echo Installing StudyLight dependencies...
"%INSTALL_DIR%\.venv\Scripts\python.exe" -m pip install -r "%INSTALL_DIR%\requirements.txt"
if errorlevel 1 (
    echo ERROR: Dependency installation failed. Check your internet connection and retry.
    exit /b 1
)

echo Adding StudyLight to your user PATH...
powershell -NoProfile -Command "$d = $env:INSTALL_DIR; $p = [Environment]::GetEnvironmentVariable('Path', 'User'); if ($null -eq $p) { $p = '' }; $found = $false; foreach ($x in $p.Split(';')) { if ([string]::Equals($x, $d, [StringComparison]::OrdinalIgnoreCase)) { $found = $true } }; if (-not $found) { if ([string]::IsNullOrWhiteSpace($p)) { $p = $d } else { $p = $p.TrimEnd(';') + ';' + $d }; [Environment]::SetEnvironmentVariable('Path', $p, 'User') }"
if errorlevel 1 (
    echo ERROR: Could not update your user PATH.
    echo StudyLight was installed to "%INSTALL_DIR%".
    echo You can run "%INSTALL_DIR%\studylight.bat" directly.
    exit /b 1
)

echo.
echo Installation complete!
echo Close and reopen Command Prompt, then type: studylight
echo The command runs until you press Ctrl+C in its terminal.
echo Share install.bat, screen.py, requirements.txt, studylight.bat, and uninstall.ps1 with friends.
echo Each friend should extract all five files into one folder and run install.bat.
echo.
pause
exit /b 0

:banner
echo.
echo        * * * STUDYLIGHT * * *
echo          Brightness helper
echo.
exit /b 0
