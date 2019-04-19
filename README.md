# cascade-windows-spoon

A Hammerspoon Spoon module to handle cascading open windows for an application.

## What do I use this for

Like most tools that I create, this one helps me get back to the window I'm looking for, which is usually burried under a thousand windows in a thousand tabs... I ran across what I felt was a fairly easy to understand structure for a Hammerspoon Spoon in [miro-windows-manager](https://github.com/miromannino/miro-windows-manager), and from that I started playing around.  I had implemented this as an AppleScript/Automator process back in the day, though evolution of MacOS has not been a friend to that process.  In any case, on to the purpose and usage of this Spoon.  

Especially with browser windows, I find it much easier to locate what I'm looking for if I can read the TAB titles for the window.  Doing a traditional `cascade` of the windows allows me to see all of the TAB titles at once.  At which point I can bring that window to the foreground and use miro-windows-manager functionality to position that window however I would like. Clearly only useful for applications that can spawn multiple windows.  With this spoon you define a key command to each application you would like to cascade and give it some plot points, offset, and screen to move it to, and good to go.

## Installation

This will create a ~/tmp temp file in your home directory and clone the repository into it, then move the Spoon to the ~/.hammerspoon/Spoons install directory.  Then add the base loading lines into your ~/.hammerspoon/init.lua file.  Once complete you can clean up the ~/tmp/miro-windows-manager directory as you see fit.

```bash
mkdir ~/tmp

cd ~/tmp && git clone https://github.com/cmaahs/cascade-windows-spoon.git
cd ~/tmp/cascade-windows-spoon
mv CascadeWindows.spoon ~/.hammerspoon/Spoons

if grep -Fxq 'local hyper = {"ctrl", "alt", "cmd"}' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'local hyper = {"ctrl", "alt", "cmd"}' >> ~/.hammerspoon/init.lua
fi

if grep -Fxq 'hs.loadSpoon("CascadeWindows")' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'hs.loadSpoon("CascadeWindows")' >> ~/.hammerspoon/init.lua
fi

if grep -Fxq 'hs.window.animationDuration = 0.3' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'hs.window.animationDuration = 0.3' >> ~/.hammerspoon/init.lua
fi
if grep -Fxq 'spoon.CascadeWindows:bindHotkeys({ g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 0, 0, 1200, 700 }, offset = { 75, 40 }, screen = 'Color LCD'}, i = { keys = {hyper, "i"}, app = 'iTerm2', start = { 250, 0, 600, 500 }, offset = { 30, 30 }, screen = 'Color LCD'}, s = { keys = {hyper, "s"}, app = 'Sublime Text', start = { 250, 0, 700, 650 }, offset = { 30, 30 }, screen = 'Color LCD'},})' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'spoon.CascadeWindows:bindHotkeys({ g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 0, 0, 1200, 700 }, offset = { 75, 40 }, screen = 'Color LCD'}, i = { keys = {hyper, "i"}, app = 'iTerm2', start = { 250, 0, 600, 500 }, offset = { 30, 30 }, screen = 'Color LCD'}, s = { keys = {hyper, "s"}, app = 'Sublime Text', start = { 250, 0, 700, 650 }, offset = { 30, 30 }, screen = 'Color LCD'},})' >> ~/.hammerspoon/init.lua
fi
if grep -Fxq 'spoon.CascadeWindows._logger.level = 3' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'spoon.CascadeWindows._logger.level = 3' >> ~/.hammerspoon/init.lua
fi

if grep -Fxq 'spoon.CascadeWindows:DisplayScreenInfo()' ~/.hammerspoon/init.lua
then
    echo "line already exists."
else
    echo 'spoon.CascadeWindows:DisplayScreenInfo()' >> ~/.hammerspoon/init.lua
fi

```

## Configuration

The configuration file looks like this:

```lua
local hyper = {"ctrl", "alt", "cmd"}
hs.loadSpoon("CascadeWindows")
spoon.CascadeWindows:bindHotkeys({
  g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
  i = { keys = {hyper, "i"}, app = 'iTerm2', start = { 790, 0, 1920, 1360 }, offset = { 30, 30 }, screen = 'DELL U3818DW'},
  s = { keys = {hyper, "s"}, app = 'Sublime Text', start = { 790, 0, 1920, 1360 }, offset = { 30, 30 }, screen = 'DELL U3818DW'},
})
spoon.CascadeWindows._logger.level = 3
spoon.CascadeWindows:DisplayScreenInfo()
```

If you are using miro-windows-manager, you likely already have the hyper line.

The breakdown of the application configuration lines are:

```plaintext
g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
^ - bound key, also   ^ here, however that one isn't used, carry over from miro-windows-manager code.

g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
              ^^^^^ This defines the held keys used to activate with the bound key

g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
                                  ^^^^^^^^^^^^^ Name of the application

g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
                                                            ^^^  ^. ^^^^. ^^^
                                                             |   |   |     └ height the window will take on during the move  
                                                             |   |   └ width the window will take on during the move
                                                             |   └ vertical (y) position of the upper left corner of the window
                                                             └ horizonal (x) position of the upper left corner of the window

g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
                                                                                            ^^  ^^
                                                                                            |   └ number added to the vertical (y) of `start` when placing additional windows
                                                                                            └ number added to the horizontal (x) of `start` when placing additional windows

g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 2200, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
                                                                                                                ^^^^^^^^^^^^ The name of the screen the windows should be placed upon
```

The last line calls a utility function that dumps the names and resolutions of the attached monitors to the Hammerspoon `console`.  This can be commented out once you have a list of your attached monitors.  This line can also be pasted directly into the `console` command line.  The logger level needs to be 3 or higher for the info lines from that function to actually output.

```lua
spoon.CascadeWindows._logger.level = 3
spoon.CascadeWindows:DisplayScreenInfo()
```

## TODO

- Add start positions either by monitor, or as a default setting when the chosen screen is not available.  For instance when you leave the house and only have your laptop screen.  People do still leave the house right?
  - start -> start_desired = { x, y , w, h }
  - + start_default = { x, y, w, h }
- Add a utility script to dump the running Appliction names to the console.
