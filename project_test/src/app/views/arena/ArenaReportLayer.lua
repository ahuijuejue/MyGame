--[[
竞技场战报层
]]

local ArenaReportLayer = class("ArenaReportLayer", function( ... )
	return display.newNode()
end)

function ArenaReportLayer:ctor()
	self:initData()
	self:initView()
end

function ArenaReportLayer:initData()		
	self.data = ArenaReport:getReportList()
end

function ArenaReportLayer:initView(data)

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

	display.newSprite("word_report.png"):addTo(self.layer_)
	:pos(480, 540)	

------------------------------------------------------
    -- 战报列表     
    base.GridView.new({
		rows = 1,
		viewRect = cc.rect(0, 0, 730, 385),
		itemSize = cc.size(730, 110),
		-- page = true,
		})
	:addTo(self.layer_)
	:pos(115, 94)
	:addItems(table.nums(self.data), function(event)
		local index = event.index
		local data = self.data[index]			
		local grid = base.Grid.new()
			:setBackgroundImage("rank_bar_n.png")
			:addItems({					
				display.newSprite(ArenaData:getDefaultBorder()):pos(-110, 0):scale(0.7),
				display.newSprite(data.icon):pos(-110, 0):scale(0.7),
				display.newSprite("Banner_Level.png"):pos(-140, 28),
				base.Label.new({text=tostring(data.level), size=18}):pos(-140, 28):align(display.CENTER),
				base.Label.new({text=data.name}):pos(-35, 20),
				base.Label.new({text=data:getTimeString(), color = cc.c3b(255,255,0)}):pos(-35, -20),				
			})
		if data.win then 
			grid:addItems({
				display.newSprite("Icon_Win.png"):pos(-220, 0),
				display.newSprite("RankUp.png"):pos(230, -5):align(display.BOTTOM_CENTER),
				base.Label.new({text=tostring(data.offset), color=cc.c3b(0,255,0)}):pos(230, -20):align(display.CENTER)
				})
		else 
			grid:addItems({
				display.newSprite("Icon_Lose.png"):pos(-220, 0),
				display.newSprite("RankDown.png"):pos(230, -5):align(display.BOTTOM_CENTER),
				base.Label.new({text=tostring(data.offset), color=cc.c3b(255,0,0)}):pos(230, -20):align(display.CENTER)
				})
		end 
					
		return grid			
	end)
	:reload()

	-- 关闭按钮
	CommonButton.close():addTo(self.layer_):pos(850, 530)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		self:onEvent_{name="close"}		
	end)
end 

function ArenaReportLayer:onEvent(listener)
	self.eventListener = listener 

	return self 
end

function ArenaReportLayer:onEvent_(event)
	if not self.eventListener then return end  

	event.target = self 
	self.eventListener(event)
end



return ArenaReportLayer


