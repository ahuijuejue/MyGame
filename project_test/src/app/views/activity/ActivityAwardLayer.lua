--[[
战力活动 活动奖励层
]]

local ActivityAwardLayer = class("ActivityAwardLayer", function()
	return display.newNode()
end)

function ActivityAwardLayer:ctor()
	self:initData()
	self:initView()
	self:updateListView()
end

function ActivityAwardLayer:initData()
	self.listData = SwordActivityData:getRankingAwardList()
	self.labelText = SwordActivityData:getNotiString(1)
end

function ActivityAwardLayer:initView()

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

function ActivityAwardLayer:updateData()
	
end

function ActivityAwardLayer:updateView()
	
end

function ActivityAwardLayer:updateListView()
	self.listView_
	:resetData()
	:addSection(
		{	
			count = #self.listData,			
			getItem = handler(self, self.getItemGrid),
		})		
	:reload()
end

-- 排名图片
local rankImages = {
	"sword_activity_rank1.png",
	"sword_activity_rank2.png",
	"sword_activity_rank3.png",
	"sword_activity_rank4.png",
	"sword_activity_rank5.png",
	"sword_activity_rank6.png",
	"sword_activity_rank7.png",
	"sword_activity_rank8.png",
	"sword_activity_rank9.png",
	"sword_activity_rank10.png",
}

function ActivityAwardLayer:getItemGrid(event)
	local grid = base.Grid.new()
	local data = self.listData[event.index]

	grid:addItem(display.newSprite("sword_cell.png"))

	-- 排名
	local rankNum = display.newSprite(rankImages[event.index])	
	:pos(-289, 0)	
	
	grid:addItem(rankNum)
	
	-- 物品
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

return ActivityAwardLayer

