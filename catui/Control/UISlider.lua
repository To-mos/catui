--[[
The MIT License (MIT)

Copyright (c) 2017 Thomas Wills

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

    self.token = UINode:new()
    self.token.events:on(UI_MOUSE_DOWN, self.onMouseDown, self)
    self.token.events:on(UI_MOUSE_MOVE, self.onMouseMove, self)
    self.token.events:on(UI_MOUSE_UP, self.onMouseUp, self)
    
    self:initTheme()

    self.token:setSize(self.height, self.height)
    self:addChild(self.token)

    self:setEnabled(true)
    self.events:on(UI_DRAW, self.onDraw, self)
end

-------------------------------------
-- init Theme Style
-- @tab _theme
-------------------------------------
function UISlider:initTheme(_theme)
    local theme = UITheme or _theme
    self.width        = theme.slider.width
    self.height       = theme.slider.height
    self.barColor     = theme.slider.barColor
    self.barThickness = theme.slider.barThickness

    --override defaults for sliders theme
    self.token.upColor      = theme.slider.upColor
    self.token.downColor    = theme.slider.downColor
    self.token.hoverColor   = theme.slider.hoverColor
    self.token.disableColor = theme.slider.disableColor
end

-------------------------------------
-- (callback)
-- draw self
-------------------------------------
function UISlider:onDraw()
    local box  = self:getBoundingBox()
    local x, y = box.left, box.top
    local w, h = box:getWidth(), box:getHeight()

    local r, g, b, a = love.graphics.getColor()
    local lineWidth  = love.graphics.getLineWidth()
    local color      = self.barColor

    -- love.graphics.rectangle( 'fill', x, y, self.width, self.height )

    --line
    love.graphics.setLineWidth( self.barThickness )
    love.graphics.setColor( color[1], color[2], color[3], color[4] )

    love.graphics.line(x, y + h * 0.5, x + w, y + h * 0.5)

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

    local bar = self.token

    local after = bar:getX() + dx
    if after < 0 then
        after = 0
    elseif after + bar:getWidth() > self:getWidth() then
        after = self:getWidth() - bar:getWidth()
    end
    self.tokenPosRatio = after / (self:getWidth() - bar:getWidth())

    self:setBarPos(self.tokenPosRatio)
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
    self.token:setSize(height, height)
end

-------------------------------------
-- (override)
-------------------------------------
function UISlider:setWidth(width)
    UIControl.setWidth(self, width)
end

-------------------------------------
-- (override)
-------------------------------------
function UISlider:setHeight(height)
    UIControl.setHeight(self, height)
    self.token:setSize(self.height, self.height)
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
end

-------------------------------------
-- set bar position with ratio
-- @number ratio
-------------------------------------
function UISlider:setBarPos(ratio)
    if ratio < 0 then ratio = 0 end
    if ratio > 1 then ratio = 1 end

    self.tokenPosRatio = ratio
    self.token:setX((self:getWidth() - self.token:getWidth()) * ratio)
    self.token:setY(0)

    self.events:dispatch(UI_ON_SCROLL, ratio)
end

-------------------------------------
-- get bar position with ratio
-- @treturn number ratio
-------------------------------------
function UISlider:getBarPos()
    return self.tokenPosRatio
end

return UISlider
