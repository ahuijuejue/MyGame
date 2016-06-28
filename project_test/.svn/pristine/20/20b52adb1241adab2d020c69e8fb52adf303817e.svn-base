local NoticeNode = class("NoticeNode",function ()
	return cc.ClippingRegionNode:create()
end)

local scheduler = require("framework.scheduler")

function NoticeNode:ctor()
	self.text = ""

	self.sprite = display.newSprite("Notice_Bar.png")
    self.sprite:setAnchorPoint(0,0)
    self:addChild(self.sprite)

	self.label = createOutlineLabel({text = self.text})
    self.label:setAnchorPoint(0,0.5)
    self.sprite:addChild(self.label)

    self:setClippingRegion(cc.rect(0,0,560,38))
end

function NoticeNode:setCallback(func)
	self.callback = func
end

function NoticeNode:setLabel(text,x,y)
    self.label:setString(text)
    self.width = self.label:getContentSize().width
    self.posX = x
    self.posY = y
    self.label:setPosition(self.posX,self.posY)
    self.timer = scheduler.scheduleGlobal(handler(self,self.updateLabelPos),0)
end

function NoticeNode:updateLabelPos()
    self.posX = self.posX - 2
    self.label:setPosition(self.posX,self.posY)
    if self.posX < -self.width then
        scheduler.unscheduleGlobal(self.timer)
        self.timer = nil
        if self.callback then
            self.callback()
        end
    end
end

return NoticeNode