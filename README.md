[TOC]

# wxgtk

## GTK3/Vala (minimum 3.22) port of "wX" US Advanced Weather application (open source GPL3)

```
wxgtk is an efficient and configurable method to access weather content from the NWS, NSSL WRF, and blitzortung.org.
Software is provided \"as is\". Use at your own risk. Use for educational purposes and non-commercial purposes only.
Do not use for operational purposes.  Copyright 2020, 2021, 2022 joshua.tee@gmail.com .
Privacy Policy: this app does not collect any data from the user or the user’s device.
Please report bugs or suggestions via email."
wxvala is licensed under the GNU GPLv3 license. For more information on the license please go here:"
http://www.gnu.org/licenses/gpl-3.0.en.html
```

## Differences from mobile versions (similar in content to wXL23 but native desktop with keyboard shortcuts, etc):
- Nexrad Level 2 is not supported. See the wXL23 [FAQ](https://gitlab.com/joshua.tee/wxl23/-/blob/master/doc/FAQ.md#why-is-level-2-radar-not-the-default) for why I can't provide a good experience with this.
- No notifications or widgets
- No Radar color palette editor
- You must compile it yourself
- Best effort support from me (ie Mobile support takes priority)

## How to add your location
- From the main screen, tap the gear icon in the upper left.
- From the Settings window, tap the "Add Location" tab.
- Enter the name of your city in the text box, as type you will start getting matches. The best match will auto populate the name/lat/lon fields.
- If you want a differen result, tap button that most closely matches your location.
- Tap the save button, when all fields clear the new location has been saved.
- Close settings window
- From the main screen use the drop down to choose your new location

### Performance:
- Using Wayland on a Linux based desktop is optimal

### Output to local filesystem (file should NOT exist before running program for first time):
- `$HOME/.config/joshuatee.wx@gmail.com/wxgtk.conf`

## Compile and run
1. Perform the [steps](https://gitlab.com/joshua.tee/wxgtk/-/blob/main/README_OS.md) for your operating system, you will probably need 8GB of memory for compilation. I have used a 4GB Raspberry PI 400 (keyboard model) to compile.
2. Download the code and and compile/run
```bash
git clone https://gitlab.com/joshua.tee/wxgtk.git
cd wxgtk
./makeAll.bash
```
3. After compilation you can simply launch with script
```bash
./run.bash
```

## Special thanks to the creators of
- [GTK](https://gtk.org/)
- [Vala](https://gitlab.gnome.org/GNOME/vala)
- [Vala Language Server](https://github.com/Prince781/vala-language-server)
- [vala-vscode - Vala support for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=prince781.vala)
