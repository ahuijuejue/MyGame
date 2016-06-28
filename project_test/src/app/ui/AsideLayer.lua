local AsideLayer = class("AsideLayer",function ()
	return display.newColorLayer(cc.c4b(0,0,0,100))
end)
local asideImage = "Plot_Hero_100.png"
local talkImage = "Plot_Shading.png"

function AsideLayer:ctor()
	self.index = 1
	self.text = {}
	self.name = ""

	self.asider = display.newSprite(asideImage)
	self.asider:setAnchorPoint(0,0)
	self.asider:setPosition(0,0)
	self:addChild(self.asider,2)

	self.talkBox = display.newSprite(talkImage)
	self.talkBox:setAnchorPoint(0.5,0)
	self.talkBox:setPosition(display.cx,0)
	self:addChild(self.talkBox)

	self.nameLabel = base.TalkLabel.new({
				        text=" ",
				        size=24,
				    })
	self.nameLabel:setAnchorPoint(0,0.5)
	self.nameLabel:setPosition(550,190)
	self.talkBox:addChild(self.nameLabel)

	self.label = base.TalkLabel.new({
        text=" ",
        size=24,
        dimensions = cc.size(400, 300),
    })
	self.label:setPosition(600,463-32*self.label:getLines())
	self.label:setAnchorPoint(0,1)
	self.talkBox:addChild(self.label)

	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.onTouch))
end

--需要显示的旁白
function AsideLayer:setAside(text)
	self.text = text
end

function AsideLayer:setTalk()
	if self.label then
		self.label:removeFromParent()
		self.label = base.TalkLabel.new({
	        text=self.text[self.index],
	        size=24,
	        dimensions = cc.size(400, 300),
	    })
		self.label:setPosition(600,463-32*self.label:getLines())
		self.label:setAnchorPoint(0,1)
		self.talkBox:addChild(self.label)
	end
end

function AsideLayer:setAsideName(name)
	if self.nameLabel then
		self.nameLabel:removeFromParent()
		self.nameLabel = base.TalkLabel.new({
	        text=name,
	        size=30,
	    })
		self.nameLabel:setAnchorPoint(0,0.5)
		self.nameLabel:setPosition(550,190)
		self.talkBox:addChild(self.nameLabel)
	end
end

function AsideLayer:setCallback(callback)
	self.callback = callback
end

function AsideLayer:onTouch(event)
	if event.name == "began" then
		return true
	elseif event.name == "ended" then
		self.index = self.index+1
		if self.index > #self.text then
			if self.callback then
				self.callback(self)
			end
			self:removeFromParent(true)
		else
			self:setTalk()
		end
	end
end

return AsideLayer