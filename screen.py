import keyboard
import screen_brightness_control as sbc
import tkinter as tk

# --- CONFIGURATION ---
DEFAULT_BRIGHTNESS = 15 # Fallback if the current brightness cannot be detected
CUSTOM_BRIGHTNESS = DEFAULT_BRIGHTNESS
# ---------------------


def print_startup_help():
    print(r"""
   ____  _             _       _ _
  / ___|| |_ _   _  __| |_   _| (_)  __ _ 
  \___ \| __| | | |/ _` | | | | | | / _` |
   ___) | |_| |_| | (_| | |_| | | || (_| |
  |____/ \__|\__,_|\__,_|\__,_|_|_| \__,_|
""")
    print("StudyLight is running.")
    print(f"Starting brightness: {CUSTOM_BRIGHTNESS}%")
    print("Ctrl+Shift+Q  Toggle a fullscreen white screen and maximum brightness.")
    print("Ctrl+Alt+B  Toggle brightness between the configured level and 100%.")
    print("Ctrl+C  Exit StudyLight from this terminal.")
    print()


def detect_starting_brightness():
    global CUSTOM_BRIGHTNESS, current_brightness
    try:
        brightness = sbc.get_brightness()
        if isinstance(brightness, (list, tuple)):
            if not brightness:
                raise ValueError("No display brightness values were returned")
            values = [int(float(value)) for value in brightness]
            CUSTOM_BRIGHTNESS = values[0]
            if all(value == CUSTOM_BRIGHTNESS for value in values):
                current_brightness = CUSTOM_BRIGHTNESS
        else:
            CUSTOM_BRIGHTNESS = int(float(brightness))
            current_brightness = CUSTOM_BRIGHTNESS
    except Exception as e:
        print(f"Warning: Could not detect current brightness; using {DEFAULT_BRIGHTNESS}%: {e}")


# Track whether the brightness is currently maxed out
is_maxed = False
current_brightness = None
white_window = None
white_screen_active = False

def set_brightness(value):
    global is_maxed, current_brightness
    if current_brightness == value:
        is_maxed = value == 100
        return
    try:
        sbc.set_brightness(value)
        current_brightness = value
        is_maxed = value == 100
        print(f"Brightness set to {value}%")
    except Exception as e:
        print(f"Error changing brightness: {e}")


def toggle_brightness():
    set_brightness(CUSTOM_BRIGHTNESS if is_maxed else 100)


def toggle_white_screen():
    global white_window, white_screen_active

    if not white_screen_active:
        set_brightness(100)

        if white_window is None:
            white_window = tk.Toplevel(root)
            white_window.configure(bg="white")
            white_window.attributes("-topmost", True)

        white_window.deiconify()
        white_window.attributes("-fullscreen", True)
        white_window.lift()
        white_screen_active = True
    else:
        white_window.withdraw()
        white_screen_active = False
        set_brightness(CUSTOM_BRIGHTNESS)


detect_starting_brightness()
print_startup_help()

# Set the initial baseline brightness when the script starts
try:
    sbc.set_brightness(CUSTOM_BRIGHTNESS)
except Exception as e:
    print(f"Warning: Could not set initial brightness: {e}")

# Register hotkeys and run Tkinter on the main thread.
root = tk.Tk()
root.withdraw()
keyboard.add_hotkey('ctrl+shift+q', lambda: root.after(0, toggle_white_screen))
keyboard.add_hotkey('ctrl+alt+b', lambda: root.after(0, toggle_brightness))

root.mainloop()
