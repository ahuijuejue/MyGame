
local RotateItem = class("RotateItem", function()
	return base.Grid.new()
end)

function RotateItem:ctor()
	-- body
	self.colorSprite_ = {}
end
--@param sprite 会变暗的元件
function RotateItem:addSprite(sprite)
	-- body
	sprite:addTo(self)
	table.insert(self.colorSprite_, sprite)

	return self 
end

function RotateItem:getSprites()
	return self.colorSprite_
end 

function RotateItem:removeSprites()
	for i,v in ipairs(self.colorSprite_) do
		v:removeSelf()
	end
	self.colorSprite_ = {}

	return self 
end 

function RotateItem:setColor(color)
	for i,v in ipairs(self.colorSprite_) do
		v:setColor(color)
	end
	return self 
end 

return RotateItem




