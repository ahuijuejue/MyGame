local UIPushButton = require("framework.cc.ui.UIPushButton")

local PushButton = class("PushButton", UIPushButton)

function PushButton:ctor(images, options)
	PushButton.super.ctor(self, images, options)

	self.clickedComb = 1
	self.preclickedTime = 0
	self.combDur = 0.3
    self.data = {}
end

function PushButton:setData(key, value)
    self.data[key] = value
    return self
end

function PushButton:getData(key)
    return self.data[key]
end

function PushButton:onTouch_(event)
    local name, x, y = event.name, event.x, event.y
    if name == "began" then
        self.touchBeganX = x
        self.touchBeganY = y
        if not self:checkTouchInSprite_(x, y) then return false end
        self.fsm_:doEvent("press")
        self:dispatchEvent({name = self.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        return true
    end

    -- must the begin point and current point in Button Sprite
    local touchInTarget = self:checkTouchInSprite_(self.touchBeganX, self.touchBeganY)
                        and self:checkTouchInSprite_(x, y)
    if name == "moved" then
        if touchInTarget and self.fsm_:canDoEvent("press") then
            self.fsm_:doEvent("press")
            self:dispatchEvent({name = self.PRESSED_EVENT, x = x, y = y, touchInTarget = true})
        elseif not touchInTarget and self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = self.RELEASE_EVENT, x = x, y = y, touchInTarget = false})
        end
    else
        if self.fsm_:canDoEvent("release") then
            self.fsm_:doEvent("release")
            self:dispatchEvent({name = self.RELEASE_EVENT, x = x, y = y, touchInTarget = touchInTarget})
        end
        if name == "ended" and touchInTarget then
        	local curTime = os.time()
        	if curTime - self.preclickedTime > self.combDur then
        		self.clickedComb = 1
        	else
        		self.clickedComb = self.clickedComb + 1
        	end
        	self.preclickedTime = curTime
            self:dispatchEvent({name = self.CLICKED_EVENT, x = x, y = y, touchInTarget = true, comb = self.clickedComb})
        end
    end
end

return PushButton