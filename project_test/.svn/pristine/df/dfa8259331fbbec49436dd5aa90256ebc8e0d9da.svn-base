local TutorialLayer = class("TutorialLayer",function ()
	return display.newLayer()
end)

local tip = "talk_box_2.png"
local finger = "shou.png"

function TutorialLayer:ctor(rect)
	self.rect = rect
	self:createTutorialSprite()
	self:setTouchSwallowEnabled(true)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.onTouch))
end

function TutorialLayer:createTutorialSprite()
	self.animation = createAnimation("tap%04d.png",16,0.03)

	local posX = self.rect.x + self.rect.width/2
	local posY = self.rect.y + self.rect.height/2
	self.tSprite = display.newSprite()
	self.tSprite:setPosition(posX,posY)
	self.tSprite:setScale(1.5)
	self:addChild(self.tSprite)

	self.finger = display.newSprite(finger)
	self.finger:setPosition(posX+47,posY-47)
	self.finger:setVisible(false)
	self:addChild(self.finger)
end

function TutorialLayer:showAnimation()
	self.finger:setVisible(true)
	transition.playAnimationForever(self.tSprite,self.animation)
end

function TutorialLayer:showTip(text,x,y,scale)
	local sprite = display.newSprite(tip)
	local posX = x or self.rect.x + self.rect.width + 130
	local posY = y or self.rect.height/2+self.rect.y
	sprite:setPosition(posX,posY)
	self:addChild(sprite)

	self.tipLabel = display.newTTFLabel({text = text,size = 18,align = cc.ui.TEXT_ALIGN_CENTER})
	self.tipLabel:setPosition(335,70)
	self.tipLabel:setColor(display.COLOR_BLACK)
	sprite:addChild(self.tipLabel)

	if scale then
		sprite:setScaleX(scale)
		self.tipLabel:setScaleX(scale)
	end
end

function TutorialLayer:setTips(text)
	self.tipLabel:setString(text)
end

function TutorialLayer:setCallback(callback)
	self.callback = callback
end

function TutorialLayer:onTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		if self:touchInTutorial(point) then
			self.touchIn = true
		end
		return true
	elseif event.name == "ended" then
		if self:touchInTutorial(point) and self.touchIn then
			AudioManage.playSound("Click.mp3")
			if self.callback then
				self.callback(self)
			end
		else
            local param = {text = "表乱摸啦~",size = 30,color = display.COLOR_RED}
			showToast(param)
		end
		self.touchIn = false
	end
end

function TutorialLayer:touchInTutorial(point)
	if self.rect and cc.rectContainsPoint(self.rect,point) then
		return true
	end
	return false
end

return TutorialLayer