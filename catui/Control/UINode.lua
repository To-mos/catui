-------------------------------------
local UINode = UIControl:extend( "UINode", {
    isHoved = false,
    isPressed = false,

    upColor = nil,
    downColor = nil,
    hoverColor = nil,
    disableColor = nil,
    resizeNode = false
} )

-------------------------------------
-- construct
-------------------------------------
function UINode:init()
    UIControl.init(self)

    self:initTheme()
    self:setEnabled(true)

    self.events:on(UI_DRAW, self.onDraw, self)
    self.events:on(UI_MOUSE_ENTER, self.onMouseEnter, self)
    self.events:on(UI_MOUSE_LEAVE, self.onMouseLeave, self)
    self.events:on(UI_MOUSE_DOWN, self.onMouseDown, self)
    self.events:on(UI_MOUSE_UP, self.onMouseUp, self)
end

-------------------------------------
-- init Theme Style
-- @tab _theme
-------------------------------------
function UINode:initTheme(_theme)
    local theme = UITheme or _theme

    self.width        = theme.node.width
    self.height       = theme.node.height
    self.upColor      = theme.node.upColor
    self.downColor    = theme.node.downColor
    self.hoverColor   = theme.node.hoverColor
    self.disableColor = theme.node.disableColor
end

-------------------------------------
-- (callback)
-- draw self
-------------------------------------
function UINode:onDraw()
    local box  = self:getBoundingBox()
    local x, y = box:getX(), box:getY()
    local w, h = box:getWidth(), box:getHeight()

    local lineWidth = love.graphics.getLineWidth()
    local r, g, b, a = love.graphics.getColor()
    local color = nil

    -- button themes 按钮本身
    if self.isPressed then
        color = self.downColor
    elseif self.isHoved then
        color = self.hoverColor
    elseif self.enabled then
        color = self.upColor
    else
        color = self.disableColor
    end
    -- print(color[1], color[2], color[3], color[4])
    --handles color
    love.graphics.setColor(color[1], color[2], color[3], color[4])

    self:drawOOBox( "fill", x, y, w, h )

    
    
    if self.resizeNode then
        local color = self.upColor
        love.graphics.setColor(color[1], color[2], color[3], color[4])
        love.graphics.rectangle("fill", x, y, w, h)

        color = self.hoverColor
        love.graphics.setColor(color[1], color[2], color[3], color[4])
        love.graphics.setLineWidth(2)
        love.graphics.line(
            x + w * 0.9,
            y + h * 0.1,
            x + w * 0.1,
            y + h * 0.9
        )
        love.graphics.line(
            x + w * 0.9,
            y + h * 0.4,
            x + w * 0.4,
            y + h * 0.9
        )
        love.graphics.line(
            x + w * 0.9,
            y + h * 0.7,
            x + w * 0.7,
            y + h * 0.9
        )
    end

    love.graphics.setColor(r, g, b, a)
    love.graphics.setLineWidth(lineWidth)
end

-------------------------------------
-- set button up color
-- @tab color color = {r, g, b, a}
-------------------------------------
function UINode:setUpColor(color)
    print("sETTING UP: ",color[1], color[2], color[3], color[4])
    self.upColor = color
end

-------------------------------------
-- set button down color
-- @tab color color = {r, g, b, a}
-------------------------------------
function UINode:setDownColor(color)
    self.downColor = color
end

-------------------------------------
-- set button hover color
-- @tab color color = {r, g, b, a}
-------------------------------------
function UINode:setHoverColor(color)
    self.hoverColor = color
end

-------------------------------------
-- set button disable color
-- @tab color color = {r, g, b, a}
-------------------------------------
function UINode:setDisableColor(color)
    self.disableColor = color
end

-------------------------------------
-- (callback)
-- on mouse enter
-------------------------------------
function UINode:onMouseEnter()
    print('enter')
    self.isHoved = true
    if love.mouse.getSystemCursor("hand") then
        love.mouse.setCursor(love.mouse.getSystemCursor("hand"))
    end
end

-------------------------------------
-- (callback)
-- on mouse level
-------------------------------------
function UINode:onMouseLeave()
    print('leave')
    self.isHoved = false
    love.mouse.setCursor()
end

-------------------------------------
-- (callback)
-- on mouse down
-------------------------------------
function UINode:onMouseDown(x, y)
    self.isPressed = true
end

-------------------------------------
-- (callback)
-- on mouse up
-------------------------------------
function UINode:onMouseUp(x, y)
    self.isPressed = false
end

function UINode:setColor( color )
    self.color = color
end

return UINode
