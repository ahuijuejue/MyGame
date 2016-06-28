--[[
竞技场排名层
]]

local ArenaRankLayer = class("ArenaRankLayer", function( ... )
	return display.newNode()
end)

function ArenaRankLayer:ctor()
	self:initData()
	self:initView()
end

function ArenaRankLayer:initData()	
	local data = RankData:getRank("arena") 
	self.data = data.teams
	self.rank = data.rank 			-- 竞技场排名 
	self.rankMax = data.rankMax 	-- 历史最高 
end

function ArenaRankLayer:initView(data)

	-- 灰层背景	
	CommonView.blackLayer2()
    :addTo(self)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
	self.layer_ = layer_

-- 主层
-----------------------------------------------------
-- 背景框
    CommonView.backgroundFrame3()
    :addTo(self.layer_)
	:pos(480, 280)	

	-- 标题
	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(480, 540)	

	display.newSprite("Word_Arena_Rank.png"):addTo(self.layer_)
	:pos(480, 540)	

------------------------------------------------------
-- 信息
	-- 排名
	base.Label.new({text="您的排名：", color=cc.c3b(213,157,106), size=20})
	:addTo(self.layer_):pos(200, 485)

	local str = string.format("%d", self.rank)
	base.Label.new({text=str, size=22})
	:addTo(self.layer_):pos(310, 485)

	-- 历史最高
	base.Label.new({text="历史最高：", color=cc.c3b(213,157,106), size=20})
	:addTo(self.layer_):pos(400, 485)

	str = string.format("%d", self.rankMax)
	base.Label.new({text=str, size=22})
	:addTo(self.layer_):pos(510, 485)

	-- 发奖时间
	base.Label.new({text="每日21:00结算奖励", color=cc.c3b(161,124,95), size=19})
	:addTo(self.layer_):pos(590, 500)
	
    
-----------------------------------------------------------------------
    -- 战报列表 
    
    self.listView_ = base.TableView.new({
		rows = 1,
		-- freeMode = true,
		viewRect = cc.rect(0, 0, 730, 420),
		itemSize = cc.size(730, 105),
		})
	:addTo(self.layer_)
	:pos(115, 45)
	

	-- 关闭按钮
	CommonButton.close():addTo(self.layer_):pos(850, 530)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		self:onEvent_{name="close"}		
	end)
end 

function ArenaRankLayer:onEvent(listener)
	self.eventListener = listener 

	return self 
end

function ArenaRankLayer:onEvent_(event)
	if not self.eventListener then return end  

	event.target = self 
	self.eventListener(event)
end

function ArenaRankLayer:updateShow()
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

return ArenaRankLayer


