-- Copyright (c) 2019 Christopher Maahs
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this 
-- software and associated documentation files (the "Software"), to deal in the Software 
-- without restriction, including without limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
-- to whom the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies
-- or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

--- === CascadeWindows ===
---
--- With this Spoon you will be able to target a specific application (Google Chrome, iTerm2, Sublime Text) and assign a hyper key to cascade the open windows.
--- Official homepage for more info and documentation:
--- [https://github.com/cmaahs/cascade-windows-spoon](https://github.com/cmaahs/cascade-windows-spoon)
--- 
-- ## TODO

local obj={}
obj.__index = obj

-- Metadata
obj.name = "CascadeWindows"
obj.version = "0.1"
obj.author = "Christopher Maahs <cmaahs@gmail.com>"
obj.homepage = "https://github.com/cmaahs/cascade-windows-spoon"
obj.license = "MIT - https://opensource.org/licenses/MIT"

local logger = hs.logger.new(obj.name)
obj._logger = logger
logger.i("Loading ".. obj.name)


-- ## Public variables

-- Comment: Lots of work here to save users a little work. Previous versions required users to call
-- MiroWindowsManager:start() every time they changed GRID. The metatable work here watches for those changes and does the work :start() would have done.
package.path = package.path..";Spoons/".. ... ..".spoon/?.lua"

-- ## Internal

function getscreen(s)
  screen = hs.screen(s)
  if not screen then
    return hs.screen{x=0,y=0}
  end
  return screen
end

-- ### Utilities

-- ## Public
-- spoon.CascadeWindows._logger.level = 3
-- spoon.CascadeWindows:DisplayScreenInfo()
function obj:DisplayScreenInfo()
  local screens = hs.screen.allScreens()
  for _, newScreen in ipairs(screens) do
    local coord = newScreen:frame()
    logger.i('Display: '.. newScreen:name())
    logger.i('    ( x='.. coord.x ..', y='.. coord.y ..', w='.. coord.w ..', h='.. coord.h ..' )')
  end
end

function obj:cascade(appinfo)
  -- layout stacked apps
    local numberWindows = 0
    local offset = appinfo.offset
    logger.d('Running on '.. appinfo.app)
    local stack = hs.application.find(appinfo.app)
    if stack then
      local allWin = stack:allWindows()
      for i, win in pairs(allWin) do
        if not stack:isHidden() and win and win:subrole() == 'AXStandardWindow' then
          local wcoord = win:frame()

          local preferred_original = appinfo.start
          local preferred_position = {}
          for i=1, #preferred_original do
            preferred_position[i] = preferred_original[i]
          end

          if appinfo.screen then
            whichscreen = scrn(appinfo.screen)
            if whichscreen then
              if win:screen():id() ~= whichscreen:id() then
                win:moveToScreen(whichscreen)
              end
              win:setFrameInScreenBounds()
            end
          end

          if preferred_position then
            coord = whichscreen:frame()
            preferred_position[1] = preferred_position[1] + ( offset[1] * numberWindows ) + coord.x
            preferred_position[2] = preferred_position[2] + ( offset[2] * numberWindows ) + coord.y
            win:setFrame(hs.geometry.rect(preferred_position))
            win:focus()
          end
          numberWindows = numberWindows + 1
        end
      end
    end
end

-- ## Spoon mechanics (`bind`, `init`)

obj.hotkeys = {}

--- MiroWindowsManager:bindHotkeys()
--- Method
--- Binds hotkeys for CacadeWindows
---
--- Parameters:
---  * applist - A table containing hotkey details for defined applications:
---
--- A configuration example:
--- ``` lua
--- local hyper = {"ctrl", "alt", "cmd"}
--- hs.loadSpoon("CascadeWindows")
--- start { x, y, w, h } and offset { x, y }
--- offset represents each new windows's starting position (upper left) in relation to the `start` position (x,y)
--- spoon.CascadeWindows:bindHotkeys({
---  g = { keys = {hyper, "g"}, app = 'Google Chrome', start = { 290, 0, 1600, 900 }, offset = { 75, 40 }, screen = 'DELL U3818DW'},
---  i = { keys = {hyper, "i"}, app = 'iTerm2', start = { 790, 0, 1920, 1360 }, offset = { 30, 30 }, screen = 'DELL U3818DW'},
---  s = { keys = {hyper, "s"}, app = 'Sublime Text', start = { 790, 0, 1920, 1360 }, offset = { 30, 30 }, screen = 'DELL U3818DW'},
--- })
--- spoon.CascadeWindows._logger.level = 3
--- ```
---
function obj:bindHotkeys(applist)
  logger.i("Bind Hotkeys for CascadeWindows")

  for key,appdef in pairs(applist) do
    self.hotkeys[#self.hotkeys + 1] = hs.hotkey.bind(
      applist[key].keys[1],
      key,
      function() self:cascade(appdef) end)
  
  end

end

--- MiroWindowsManager:init()
--- Method
--- Currently does nothing (implemented so that treating this Spoon like others won't cause errors).
function obj:init()
  -- void (but it could be used to initialize the module)
end

return obj