-------------------------------------
-- UIList
-- @usage
-- local list = UIList()
-------------------------------------
local UIList = class( "UIList", UIControl )

-------------------------------------
-- construct
-------------------------------------
function UIList:initialize()
    UIControl.initialize( self )

    self.listHeight = 0
    self:setEnabled( true )
end

-------------------------------------
-- update calculated height on child add
-------------------------------------
function UIList:addChild( child )
    UIControl.addChild( self, child )
    self.listHeight = self.listHeight + child:getHeight()
    self:resetSize()
end

function UIList:removeChild( child )
    UIControl.removeChild( self, child )
    self.listHeight = self.listHeight - child:getHeight()
    self:resetSize()
end

function UIList:setSize( width, height )
    --height does nothing on purpose
    self:resetSize()
    UIControl.setWidth( self, width )
end

function UIList:setWidth( width )
    self:resetSize()
    UIControl.setWidth( self, width )
end

function UIList:setHeight( height ) return end

function UIList:setAnchor( x, y )
    --children are based on anchor so incase
    --we update the anchor post addChild we
    --need to reposition everything on new anchor
    UIControl.setAnchor( self, x, y )
    self:resetSize()
end

-------------------------------------
-- reset size
-------------------------------------
function UIList:resetSize()
    local lastChild = nil
    local anchorX, anchorY = self:getAnchor()
    local w = self:getWidth()
    UIControl.setHeight( self,self.listHeight )
    for key, child in pairs( self.children ) do
        local xOffset = -w * anchorX

        if lastChild ~= nil then
            child:setPos( xOffset, lastChild:getY() + lastChild:getHeight() )
        else
            child:setPos( xOffset, -self.listHeight * anchorY )
        end
        --stretch all children to width
        child:setWidth( self:getWidth() )

        lastChild = child
    end
end

return UIList
