--[[
活动排名层
]]

local ActivityRankingLayer = class("ActivityRankingLayer", function()
	return display.newNode()
end)

function ActivityRankingLayer:ctor()
	self:initData()
	self:initView()
	self:setNodeEventEnabled(true)
end

function ActivityRankingLayer:initData()
	self.requestCount = 0
end

function ActivityRankingLayer:initView()
	-- 战报列表 

	local starX = 50
    
    self.listView_ = base.TableView.new({
		viewRect = cc.rect(0, 0, 720, 276),
		itemSize = cc.size(720, 105),
	})
	:addTo(self)
	:pos(starX, 10)

	local height = 300 
	base.Label.new({
		text = "排名",
		size = 20,
	})
	:align(display.CENTER)
	:addTo(self)
	:pos(starX + 60, height)

	base.Label.new({
		text = "等级",
		size = 20,
	})
	:align(display.CENTER)
	:addTo(self)
	:pos(starX + 310, height)

	base.Label.new({
		text = "角色名",
		size = 20,
	})
	:align(display.CENTER)
	:addTo(self)
	:pos(starX + 420, height)

	base.Label.new({
		text = "战斗力",
		size = 20,
	})
	:align(display.CENTER)
	:addTo(self)
	:pos(starX + 570, height)
end

function ActivityRankingLayer:updateData()
	if self.requestCount > 0 then 
		self:updateListData()
		self:updateListView()
	else 
		self:netShow()
	end 
end

function ActivityRankingLayer:updateView()
	
end

function ActivityRankingLayer:netShow()
	NetHandler.request("CommonRankingShow", {
			data = {param1 = 3},
			onsuccess = function()
		self:updateListData()
		self:updateListView()

		self.requestCount = self.requestCount + 1
	end}, self) 
end 

function ActivityRankingLayer:updateListData()
	local data = RankData:getRank("sword") 
	self.data = data.teams
	self.rank = data.rank 			-- 排名 
	self.rankMax = data.rankMax 	-- 历史最高 
end 

function ActivityRankingLayer:updateListView()
	self.listView_
	:resetData()	
	:addItems(table.nums(self.data), function(event)
		local index = event.index
		local data = self.data[index]			
		local grid = event.target:getFreeItem()
		if not grid then 
			grid = app:createView("arena.RankGrid")
			grid:setIconBorder(ArenaData:getDefaultBorder())
		end 
					
		if index <= 3 then 
			grid:setBackground(string.format("rank_bar_%d.png", index))			
		else 
			grid:setBackground("rank_bar_n.png")			
		end 

		grid:setLevel(data.level)
		grid:setName(data.name)
		grid:setBattle(data:getScore())
		grid:setRank(data.rank)
		grid:setIcon(data.icon)

		return grid			
	end)
	:reload()

	return self 
end

function ActivityRankingLayer:onExit()
	NetHandler.removeTarget(self) 
end 

return ActivityRankingLayer