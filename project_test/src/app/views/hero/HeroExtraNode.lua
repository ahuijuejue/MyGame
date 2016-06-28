local HeroExtraNode = class("HeroExtraNode",function ()
	return display.newNode()
end)

local extraImage = "GearPlus_Award_Banner.png"
local bgImage = "hero_info_bg.png"

function HeroExtraNode:ctor(title)
	self.valueList = {}
	self:createButton()
	self:createTitle(title)
end

function HeroExtraNode:createButton()
	local param = {normal = bgImage, pressed = bgImage}
	self.button = cc.ui.UIPushButton.new(param)
	self:addChild(self.button)
end

function HeroExtraNode:createTitle(title)
	local titleBg = display.newSprite(extraImage)
	titleBg:setPosition(0,25)
	self.button:addChild(titleBg)

	local param = {text = title,color = display.COLOR_WHITE, size = 22}
	self.titleLabel = createOutlineLabel(param)
	self.titleLabel:setPosition(118,17)
	titleBg:addChild(self.titleLabel)
end

function HeroExtraNode:setNodeCallback(callback)
	self.button:onButtonClicked(callback)
end

function HeroExtraNode:setValues(types,values)
	for i=1,#self.valueList do
		local node = self.valueList[i]
		node:removeFromParent()
		node = nil
	end
	self.valueList = {}
	if types then
		for i=1,#types do
			local text = GET_ABILITY_TEXT(tonumber(types[i])).."+"..values[i]
			local param = {text = text, color = display.COLOR_WHITE, size = 18}
			local label = display.newTTFLabel(param)
			label:setPosition(0,(1-i)*20-8)
			self.button:addChild(label)
			table.insert(self.valueList,label)
		end
	else
		local param = {text = GET_TEXT_DATA("TEXT_NO_EXTRA"), color = display.COLOR_WHITE, size = 20}
		local label = display.newTTFLabel(param)
		label:setPosition(0,-20)
		self.button:addChild(label)
		table.insert(self.valueList,label)
	end
end

return HeroExtraNode