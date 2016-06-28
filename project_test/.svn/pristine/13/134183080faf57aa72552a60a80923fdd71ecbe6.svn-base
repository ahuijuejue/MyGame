--[[
宝箱中包含物品展示层
]]

local ChestItemLayer = class("ChestItemLayer", function()
	return display.newNode()
end)

ChestItemLayer.chestNames = {
	"Chest_Name1.png",
	"Chest_Name2.png",
	"Chest_Name3.png",
}

function ChestItemLayer:ctor()		
	self.itemCount = 0
	self.itemPadding = 100

	self:initView()
end

function ChestItemLayer:initView()
	
	display.newSprite("Chest_Item_Back.png")
	:addTo(self)
	:pos(0, 20)

	self.itemLayer = display.newNode()
	:addTo(self)
	:pos(-150, 0)

	self.nameWidget = base.Grid.new()
	:addTo(self)
	:pos(-150, 72)
end

function ChestItemLayer:addItem(item, num)
	item:scale(0.7)

	display.newSprite("Number_Circle2.png")
	:addTo(item)
	:pos(40, -40)
	:zorder(10)

	base.Label.new({text=tostring(num), size=22})
	:align(display.CENTER)
	:addTo(item)
	:pos(40, -40)
	:zorder(10)

	item:addTo(self.itemLayer)
	:pos(self.itemCount * self.itemPadding, 0)

	self.itemCount = self.itemCount + 1

	return self
end

function ChestItemLayer:removeItems()
	self.itemLayer:removeAllChildren()
	self.itemCount = 0
end 

function ChestItemLayer:setName(name)
	local widget = display.newSprite(name)
	self.nameWidget:setBackgroundImage(widget)
end 

function ChestItemLayer:setNameWithIndex(index)
	self:setName(self.chestNames[index])
end 

return ChestItemLayer
