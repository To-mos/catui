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
-- UISlider
-- @usage
-- local bar = UISlider()
-- bar:setSize(100, 20)
-- bar:setDir("vertical")
-------------------------------------
local UISlider = UIControl:extend("UISlider", {
    value      = 0,
    minValue   = 0,
    maxValue   = 100,
    numOfTicks = 10,

    upColor         = nil,
    downColor       = nil,
    hoverColor      = nil,
    backgroundColor = nil,

    dir         = "vertical", --horizontal
    ratio       = 3, --bar proportions
    bar         = nil,
    mouseDown   = false,
    barPosRatio = 0
})

-------------------------------------
-- construct
-------------------------------------
function UISlider:init()
    UIControl.init(self)

    self.bar = UINode()
    self.bar.events:on(UI_MOUSE_DOWN, self.onMouseDown, self)
    self.bar.events:on(UI_MOUSE_MOVE, self.onMouseMove, self)
    self.bar.events:on(UI_MOUSE_UP, self.onMouseUp, self)
    self:addChild(self.bar)

    self:initTheme()

    self:setEnabled(true)
    self.events:on(UI_DRAW, self.onDraw, self)
end

-------------------------------------
-- (callback)
-- draw self
-------------------------------------
function UISlider:onDraw()
    local box = self:getBoundingBox()
    local x, y = box.left, box.top
    local w, h = box:getWidth(), box:getHeight()

    local r, g, b, a = love.graphics.getColor()
    local lineWidth  = love.graphics.getLineWidth()
    local color      = self.barColor

    --line
    love.graphics.setLineWidth( self.barThickness )
    love.graphics.setColor( color[1], color[2], color[3], color[4] )

    --draw segments between ends
    -- for i = 0, self.numOfTicks, 1 do
        
    --     love.graphics.setLineWidth(self.stroke)
    --     love.graphics.setColor(color[1], color[2], color[3], color[4])
    --     love.graphics.line()
    --     love.graphics.setLineWidth(self.stroke)
    -- end

    love.graphics.setLineWidth( lineWidth )
    love.graphics.setColor( r, g, b, a )
end

-------------------------------------
-- init Theme Style
-- @tab _theme
-------------------------------------
function UISlider:initTheme(_theme)
    local theme = UITheme or _theme
    self.width        = theme.slider.width
    self.height       = theme.slider.height
    self.upColor      = theme.slider.upColor
    self.downColor    = theme.slider.downColor
    self.hoverColor   = theme.slider.hoverColor
    self.disableColor = theme.slider.disableColor
    self.barColor     = theme.slider.barColor
    self.barThickness = theme.slider.barThickness

    self.token:setUpColor(self.upColor)
    self.token:setDownColor(self.downColor)
    self.token:setHoverColor(self.hoverColor)
end

-------------------------------------
-- set bar scroll direction
-- @string dir "vertical" or "horizontal", default is vertical
-------------------------------------
function UISlider:setDir(dir)
    self.dir = dir
    self:reset()
end

-------------------------------------
-- get bar scroll direction
-- @treturn string direction
-------------------------------------
function UISlider:getDir()
    return self.dir
end

-------------------------------------
-- (callback)
-- on bar down
-------------------------------------
function UISlider:onMouseDown(x, y)
    self.mouseDown = true
end

-------------------------------------
-- (callback)
-- on bar move
-------------------------------------
function UISlider:onMouseMove(x, y, dx, dy)
    if not self.mouseDown then return end

    local bar = self.bar

    if self.dir == "vertical" then
        local after = bar:getY() + dy
        if after < 0 then
            after = 0
        elseif after + bar:getHeight() > self:getHeight() then
            after = self:getHeight() - bar:getHeight()
        end
        self.barPosRatio = after / (self:getHeight() - bar:getHeight())
    else
        local after = bar:getX() + dx
        if after < 0 then
            after = 0
        elseif after + bar:getWidth() > self:getWidth() then
            after = self:getWidth() - bar:getWidth()
        end
        self.barPosRatio = after / (self:getWidth() - bar:getWidth())
    end

    self:setBarPos(self.barPosRatio)
end

-------------------------------------
-- (callback)
-- on bar up
-------------------------------------
function UISlider:onMouseUp(x, y)
    self.mouseDown = false
end

-------------------------------------
-- (override)
-------------------------------------
function UISlider:setSize(width, height)
    UIControl.setSize(self, width, height)
    self:reset()
end

-------------------------------------
-- (override)
-------------------------------------
function UISlider:setWidth(width)
    UIControl.setWidth(self, width)
    self:reset()
end

-------------------------------------
-- (override)
-------------------------------------
function UISlider:setHeight(height)
    UIControl.setHeight(self, height)
    self:reset()
end

-------------------------------------
-- set bar up color
-- @tab color
-------------------------------------
function UISlider:setUpColor(color)
    self.upColor = color
end

-------------------------------------
-- set bar down color
-- @tab color
-------------------------------------
function UISlider:setDownColor(color)
    self.downColor = color
end

-------------------------------------
-- set bar hover color
-- @tab color
-------------------------------------
function UISlider:setHoverColor(color)
    self.hoverColor = color
end

-------------------------------------
-- set bar position with ratio
-- @number ratio value: 0-1
-------------------------------------
function UISlider:setRatio(ratio)
    self.ratio = ratio < 1 and 1 or ratio
    self:reset()
end

-------------------------------------
-- reset contorl
-------------------------------------
function UISlider:reset()
    local ratio = self.ratio
    if self.dir == "vertical" then
        self.bar:setWidth(self:getWidth())
        self.bar:setHeight(self:getHeight() / ratio)
    else
        self.bar:setWidth(self:getWidth() / ratio)
        self.bar:setHeight(self:getHeight())
    end
    self:setBarPos(self.barPosRatio)
end

-------------------------------------
-- set bar position with ratio
-- @number ratio
-------------------------------------
function UISlider:setBarPos(ratio)
    if ratio < 0 then ratio = 0 end
    if ratio > 1 then ratio = 1 end

    self.barPosRatio = ratio
    if self.dir == "vertical" then
        self.bar:setX(0)
        self.bar:setY((self:getHeight() - self.bar:getHeight()) * ratio)
    else
        self.bar:setX((self:getWidth() - self.bar:getWidth()) * ratio)
        self.bar:setY(0)
    end

    self.events:dispatch(UI_ON_SCROLL, ratio)
end

-------------------------------------
-- get bar position with ratio
-- @treturn number ratio
-------------------------------------
function UISlider:getBarPos()
    return self.barPosRatio
end

return UISlider
