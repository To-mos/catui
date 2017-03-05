-------------------------------------
local UINode = UIControl:extend( "UINode", {
    isHoved = false,
    isPressed = false,

    upColor = nil,
    downColor = nil,
    hoverColor = nil,
    disableColor = nil,
    
    dir = "vertical", --horizontal
    ratio = 3, --bar占多少比例
    bar = nil,
    barDown = false,
    barPosRatio = 0,
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

    local r, g, b, a = love.graphics.getColor()

    if self.color ~= nil then
        local color = self.color
        --handles color
        love.graphics.setColor( color[1], color[2], color[3], color[4] )
    end

    if self.angle ~= 0 then
        local nwX, nwY = rotatePt( x, y, x + w * 0.5, y + h * 0.5, self.angle )          --top left
        local neX, neY = rotatePt( x + w, y, x + w * 0.5, y + h * 0.5, self.angle )      --top right
        local seX, seY = rotatePt( x + w, y + h, x + w * 0.5, y + h * 0.5, self.angle )  --bottom right
        local swX, swY = rotatePt( x, y + h, x + w * 0.5, y + h * 0.5, self.angle )      --bottom left

        love.graphics.polygon(
            'fill', 
            nwX, nwY,
            neX, neY,
            seX, seY,
            swX, swY
        )
    else
        love.graphics.rectangle( 'fill', x, y, w, h )
    end

    love.graphics.setColor(r, g, b, a)
end

-------------------------------------
-- (callback)
-- on mouse enter
-------------------------------------
function UINode:onMouseEnter()
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
    self.isHoved = false
    love.mouse.setCursor()
end

function UINode:setColor( color )
    self.color = color
end

return UINode
