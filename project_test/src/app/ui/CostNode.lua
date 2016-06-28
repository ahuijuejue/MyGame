local CostNode = class("CostNode",function ()
	return display.newNode()
end)

function CostNode:ctor(param1,param2,image)
	self.button = createButtonWithLabel(param1,param2)
	self:addChild(self.button)

	self:createCost(image)
end

function CostNode:createCost(image)
	self.costLabel = createOutlineLabel({text = "",size = 18})
	self.costLabel:setPosition(-80,0)
	self.costLabel:setAnchorPoint(1,0.5)
	self:addChild(self.costLabel)

	self.icon = display.newSprite(image)
	self.icon:setScale(0.8)
	self:addChild(self.icon)
end

function CostNode:setTag(tag)
	self.button:setTag(tag)
end

function CostNode:onButtonClicked(callback)
	self.button:onButtonClicked(callback)
end

function CostNode:setButtonLabelString(string)
	self.button:setButtonLabelString(string)
end

function CostNode:setButtonEnabled(enabled)
	self.button:setButtonEnabled(enabled)
end

function CostNode:setString(string)
	self.costLabel:setString(formatNumber(string))

	local posX = self.costLabel:getContentSize().width
	self.icon:setPosition(-100-posX,0)
end

function CostNode:setColor(color)
	self.costLabel:setColor(color)
end

return CostNode