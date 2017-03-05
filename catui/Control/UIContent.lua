--[[
The MIT License (MIT)

Copyright (c) 2016 WilhanTian  田伟汉, 2017 Thomas Wills

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

-------------------------------------
-- UIContent
-- A scroll container, default with two scrollbar
-- @usage
-- local content = UIContent()
-- content:setSize(100, 100) -- set frame size
-- content:setContentSize(450, 450) -- set content size
-------------------------------------
local UIContent = UIControl:extend("UIContent", {
    backgroundColor = nil,
    barSize         = 12,
    minWidth        = 0,
    minHeight       = 0,

    contentCtrl     = nil,
    vBar            = nil,
    hBar            = nil,
    resizeSE        = nil,
    resizeDown      = false,
    resizable       = false
})

-------------------------------------
-- construct
-------------------------------------
function UIContent:init()
    UIControl.init(self)

    self:initTheme()

    self:setClip(true)
    self:setEnabled(true)
    self.events:on(UI_wheel_MOVE, self.onwheelMove, self)
    self.events:on(UI_DRAW, self.onDraw, self)

    self.contentCtrl = UIControl:new()
    UIControl.addChild(self, self.contentCtrl)

    -- Vertical
    self.vBar = UIScrollBar:new()
    self.vBar:setDir("vertical")
    self.vBar.events:on(UI_ON_SCROLL, self.onVBarScroll, self)
    UIControl.addChild(self, self.vBar)

    -- Horizontal
    self.hBar = UIScrollBar:new()
    self.hBar:setDir("horizontal")
    self.hBar.events:on(UI_ON_SCROLL, self.onHBarScroll, self)
    UIControl.addChild(self, self.hBar)

    -- Resize
    self.resizeSE = UINode:new()
    self.resizeSE.events:on(UI_MOUSE_DOWN, self.onResizeDown, self)
    self.resizeSE.events:on(UI_MOUSE_MOVE, self.onResizeMove, self)
    self.resizeSE.events:on(UI_MOUSE_UP, self.onResizeUp, self)
    UIControl.addChild(self, self.resizeSE)

    self:resizable(false)
end

-------------------------------------
-- init Theme Style
-- @tab _theme
-------------------------------------
function UIContent:initTheme(_theme)
    local theme = UITheme or _theme
    self.barSize         = theme.content.barSize
    self.backgroundColor = theme.content.backgroundColor
end

-------------------------------------
-- (callback)
-- draw self
-------------------------------------
function UIContent:onDraw()
    local box = self:getBoundingBox()
    local r, g, b, a = love.graphics.getColor()
    local color = self.backgroundColor
    love.graphics.setColor(color[1], color[2], color[3], color[4])
    love.graphics.rectangle("fill", box:getX(), box:getY(), box:getWidth(), box:getHeight())

    local x, y = self.resizeSE:getPos()
    local w, h = self.resizeSE:getPos()
    love.graphics.line(
        x + w * 0.9,
        y + h * 0.1,
        x + w * 0.1,
        y + h * 0.9
    )

    love.graphics.setColor(r, g, b, a)
end

-------------------------------------
-- (callback)
-- can we resize the window
-------------------------------------
function UIContent:resizable(resize)
    self.resizeSE.resizeable = resize
    self.resizeSE.enabled    = resize
    self.resizeSE.visible    = resize
end

-------------------------------------
-- (callback)
-- on bar down
-------------------------------------
function UIContent:onResizeDown(x, y)
    self.resizeDown = true
end

-------------------------------------
-- (callback)
-- on bar move
-------------------------------------
function UIContent:onResizeMove(x, y, dx, dy)
    if not self.resizeDown then return end

    local thisX, thisY = self:getPos()
    local thisW, thisH = self:getSize()
    local offsetX, offsetY = thisX + dx, thisY + dy

    self:setSize( thisW + dx, thisH + dy )
end

-------------------------------------
-- (callback)
-- on bar up
-------------------------------------
function UIContent:onResizeUp(x, y)
    self.resizeDown = false
end

-------------------------------------
-- (callback)
-- on bar down
-------------------------------------
function UIContent:onBgDown(x, y)
    x, y = self:globalToLocal(x, y)

    if self.dir == "vertical" then
        self:setBarPos(y / self:getHeight())
    else
        self:setBarPos(x / self:getWidth())
    end
end

-------------------------------------
-- (callback)
-- on mouse wheel move
-------------------------------------
function UIContent:onwheelMove(x, y)
    if x ~= 0 and self:getWidth() > self.contentCtrl:getWidth() then
        return false
    end

    if y ~= 0 and self:getHeight() > self.contentCtrl:getHeight() then
        return false
    end

    if x ~= 0 then
        local offsetR = x / self:getContentWidth() * 3
        self.hBar:setBarPos(self.hBar:getBarPos() - offsetR)
    end

    if y ~= 0 then
        local offsetR = y / self:getContentHeight() * 3
        self.vBar:setBarPos(self.vBar:getBarPos() - offsetR)
    end

    return true
end

-------------------------------------
-- (callback)
-- on vertical scroll
-------------------------------------
function UIContent:onVBarScroll(ratio)
    local offset = -ratio * self:getContentHeight()
    self.contentCtrl:setY(offset)
end

-------------------------------------
-- (callback)
-- on horizontal scroll
-------------------------------------
function UIContent:onHBarScroll(ratio)
    local offset = -ratio * self:getContentWidth()
    self.contentCtrl:setX(offset)
end

-------------------------------------
-- (callback)
-- set minimum size
-------------------------------------
function UIContent:setMinSize(width, height)
    if width < 0 then width = 0 end
    if height < 0 then height = 0 end
    self.minWidth = width
    self.minHeight = height
end

-------------------------------------
-- (override)
-------------------------------------
function UIContent:setSize(width, height)
    if width < self.minWidth then 
        width = self.minWidth
    end
    if height < self.minHeight then 
        height = self.minHeight
    end
    UIControl.setSize(self, width, height)
    self:resetBar()
end

-------------------------------------
-- (callback)
-- set minimum size
-------------------------------------
function UIContent:setMinWidth(width)
    if width < 0 then width = 0 end
    self.minWidth = width
end

-------------------------------------
-- (override)
-------------------------------------
function UIContent:setWidth(width)
    if width < self.minWidth then 
        width = self.minWidth
    end
    UIControl.setWidth(self, width)
    self:resetBar()
end

-------------------------------------
-- (callback)
-- set minimum size
-------------------------------------
function UIContent:setMinHeight(height)
    if height < 0 then height = 0 end
    self.minHeight = height
end

-------------------------------------
-- (override)
-------------------------------------
function UIContent:setHeight(height)
    if height < self.minHeight then 
        height = self.minHeight
    end
    UIControl.setHeight(self, height)
    self:resetBar()
end

-------------------------------------
-- get content control
-- @treturn UIControl content control
-------------------------------------
function UIContent:getContent()
    return self.contentCtrl
end

-------------------------------------
-- set content size
-- @number width
-- @number height
-------------------------------------
function UIContent:setContentSize(width, height)
    self.contentCtrl:setSize(width, height)
    self:resetBar()
end

-------------------------------------
-- get content size
-- @treturn number width
-- @treturn number height
-------------------------------------
function UIContent:getContentSize()
    return self.contentCtrl:getSize()
end

-------------------------------------
-- get content width
-- @treturn number width
-------------------------------------
function UIContent:getContentWidth()
    return self.contentCtrl:getWidth()
end

-------------------------------------
-- get content height
-- @treturn number height
-------------------------------------
function UIContent:getContentHeight()
    return self.contentCtrl:getHeight()
end

-------------------------------------
-- set content offset
-- @number x
-- @number y
-------------------------------------
function UIContent:setContentOffsetPos(x, y)
    self.contentCtrl:setPos(x, y)
    self:resetBar()
end

-------------------------------------
-- set content x offset
-- @number x
-------------------------------------
function UIContent:setContentOffsetX(x)
    self.contentCtrl:setX(x)
    self:resetBar()
end

-------------------------------------
-- set content y offset
-- @number y
-------------------------------------
function UIContent:setContentOffsetY(y)
    self.contentCtrl:setY(y)
    self:resetBar()
end

-------------------------------------
-- (override)
-------------------------------------
function UIContent:addChild(child, depth)
    self.contentCtrl:addChild(child, depth)
end

-------------------------------------
-- (override)
-------------------------------------
function UIContent:removeChild(child)
    self.contentCtrl:removeChild(child)
end

-------------------------------------
-- reset bar size & position
-------------------------------------
function UIControl:resetBar()
    local w, h = self:getSize()

    self.vBar:setSize(self.barSize, h - self.barSize)
    self.vBar:setPos(w - self.barSize, 0)

    self.hBar:setSize(w - self.barSize, self.barSize)
    self.hBar:setPos(0, h - self.barSize)

    local cw, ch = self:getContentSize()
    self.vBar:setRatio(ch/h)
    self.hBar:setRatio(cw/w)

    if self.resizable then
        self.resizeSE:setSize(self.barSize, self.barSize)
        self.resizeSE:setPos(w - self.barSize, h - self.barSize)
    end
end

return UIContent
