# StudyLight

[![Python](https://img.shields.io/badge/Python-3.x-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Interface](https://img.shields.io/badge/Interface-Command_Line-6A5ACD)](https://github.com/Akash7037/StudyLight)

StudyLight is a small Windows command-line utility for quickly changing display brightness while you study. It can also show a fullscreen white screen.

## Features

- Start the app from Command Prompt with `studylight`.
- Toggle between your chosen brightness and 100%.
- Show or hide a fullscreen white screen.
- Install dependencies in a dedicated Python virtual environment.
- Register the command in your user PATH with the included installer.

## Requirements

- Windows
- Python 3 installed and available on PATH (the `py -3` launcher is also supported)
- Internet access during installation to download Python dependencies

Brightness control depends on your display and hardware. Some external monitors may not support software brightness control.

## Installation

1. Download the project using **Code → Download ZIP** on GitHub, then extract the ZIP. Alternatively, clone it:

   ```cmd
   git clone https://github.com/Akash7037/StudyLight.git
   cd StudyLight
   ```

2. Double-click `install.bat`, or run it from Command Prompt:

   ```cmd
   install.bat
   ```

   The installer copies the app to `%LOCALAPPDATA%\Programs\StudyLight`, creates a private virtual environment, installs the packages from `requirements.txt`, and adds the install directory to your user PATH.

3. Close and reopen Command Prompt, then start StudyLight:

   ```cmd
   studylight
   ```

If Python is not installed, install Python 3 first and enable **Add Python to PATH** in its installer. Then run `install.bat` again.

## Usage

| Shortcut | Action |
| --- | --- |
| `Ctrl+Q` | Toggle the fullscreen white screen and maximum brightness |
| `Ctrl+W` | Toggle brightness between the configured level and 100% |
| `Ctrl+C` | Exit StudyLight from the Command Prompt window |

The normal brightness is set to **15%** by default. To change it, edit `CUSTOM_BRIGHTNESS` near the top of `screen.py`, then run `install.bat` again so the installed copy is updated.

## Share with a friend

Share the project ZIP or repository link. The recipient should extract the ZIP, keep `install.bat`, `studylight.bat`, `screen.py`, and `requirements.txt` together, and run `install.bat`. Each Windows account needs to install StudyLight separately.

## Dependencies

- [`keyboard`](https://pypi.org/project/keyboard/) — global keyboard shortcuts
- [`screen-brightness-control`](https://pypi.org/project/screen-brightness-control/) — display brightness control
- Tkinter — fullscreen white window (included with most standard Windows Python installations)

## Troubleshooting

- **`studylight` is not recognized:** Close and reopen Command Prompt after installation. If it still fails, run `%LOCALAPPDATA%\Programs\StudyLight\studylight.bat` directly.
- **Python is not found:** Install Python 3 and enable **Add Python to PATH**, then rerun `install.bat`.
- **Brightness does not change:** Your display may not support software brightness control. Check that the display is connected and try its physical brightness controls.
- **A shortcut does not work:** Keep StudyLight running in its Command Prompt window and ensure another application is not intercepting the same shortcut.

## License

No license has been specified yet. All rights remain with the copyright holder unless a license is added to this repository.
