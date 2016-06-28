--[[
战力奖励层
]]

local SwordAwardLayer = class("SwordAwardLayer", function()
	return display.newNode()
end)

function SwordAwardLayer:ctor()
	self:initData()
	self:initView()
	self:updateListView()
end

function SwordAwardLayer:initData()
	self.listData = SwordActivityData:getSwordAwardList()
	self.labelText = SwordActivityData:getNotiString(2)
end

function SwordAwardLayer:initView()
	-- 列表
	self.listView_ = base.GridViewOne.new({
		viewRect = cc.rect(0, 0, 830, 288),
		itemSize = cc.size(830, 96),
	}):addTo(self)
	:pos(0, 0)

	-- 提示
	display.newSprite("sword_horn.png")
	:addTo(self)
	:pos(360, 305)

	base.Label.new({
		text = self.labelText,
		size = 18,
		color = CommonView.color_green(),
		border = false,
	})
	:addTo(self)
	:pos(120, 305)
end

function SwordAwardLayer:updateData()
	
end

function SwordAwardLayer:updateView()
	
end

function SwordAwardLayer:updateListView()
	self.listView_
	:resetData()
	:addSection(
		{	
			count = #self.listData,			
			getItem = handler(self, self.getItemGrid),
		})		
	:reload()
end

function SwordAwardLayer:getItemGrid(event)
	local grid = base.Grid.new()
	local data = self.listData[event.index]

	grid:addItem(display.newSprite("sword_cell.png"))

	local str = string.format("%d", data.battle)
	grid:addItem(base.Label.new({text=str, size=26}):pos(-200, -10))

	grid:addItem(display.newSprite("sword_word_sword.png"):pos(-289, -15))
	
	for i,v in ipairs(data.items) do
		local posX = (i-1) * 100 
		local item = UserData:createItemView(v.itemId, {scale=0.7})
		:pos(posX, 0)

		item:addItem(base.Label.new({text=tostring(v.count),
			size=18}):align(display.CENTER_RIGHT)
			:pos(35, -30)
		)			

		grid:addItem(item)
	end

	return grid 
end

return SwordAwardLayer