--
-- Author: zsp
-- Date: 2015-06-23 15:03:02
--

--[[
  控制角色的移动的按钮
--]]
local CtrlButton = class("CtrlButton",function()
    return display.newNode()
end)

function CtrlButton:ctor(images, options)

   	self.sprite = display.newSprite(images)
   	self.sprite:addTo(self)
   	self.name = options.name or ""

    self.flipX_ = options and options.flipX
    --self.flipY_ = options and options.flipY

    if self.flipX_ then
    	self.sprite:setFlippedX(self.flipX_)
    end

    self.state = "normal"

end

function CtrlButton:checkTouchInSprite_(x, y)
	
    return self:getCascadeBoundingBox():containsPoint(cc.p(x, y))
end

function CtrlButton:onTouch_(event)

    local name, x, y = event.name, event.x, event.y
    if name == "began" then
        -- self.touchBeganX = x
        -- self.touchBeganY = y
        if not self:checkTouchInSprite_(x, y) then return false end

        self.state = "press"
       -- self.fsm_:doEvent("press")
       -- self:dispatchEvent({name = UIButton.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
       	
       	self:doButtonEvent()
        return true
    end

    local touchInTarget = self:checkTouchInSprite_(x, y)
    --self:checkTouchInSprite_(self.touchBeganX, self.touchBeganY) and self:checkTouchInSprite_(x, y)

    if name == "moved" then
        if touchInTarget and self.state ~= "press" then
          
           	self.state = "press"

           	self:doButtonEvent()

        elseif not touchInTarget and self.state == "press" then
        	self.state = "release"
          
            self:doButtonEvent()
        end
    else


        if name == "ended" and touchInTarget then

           self.state = "release"

           self:doButtonEvent()
        end

        if name == "cancelled" and touchInTarget then
        	--todo
        	self.state = "release"

        	self:doButtonEvent()
        end

    end
end

function CtrlButton:doButtonEvent()
	 --print(self.name.."=="..self.state)
	 if self.callback then
     	self:callback(self)
   end
end

function CtrlButton:onButtonEvent(callback)
	self.callback = callback
end


function CtrlButton:setButtonEnabled(enabled)
   -- self:setTouchEnabled(enabled)
    return self
end

return CtrlButton