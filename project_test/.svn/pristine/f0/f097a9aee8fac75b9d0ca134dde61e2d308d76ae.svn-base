--[[
艾恩葛朗特 选择敌人界面 
]]
local AincradSelectEnemyScene = class("AincradSelectEnemyScene", base.Scene)

function AincradSelectEnemyScene:initView()	
	self:autoCleanImage()
	-- 背景
	-- CommonView.background_aincrad()
	-- :addTo(self)
	-- :center()
	app:createView("aincrad.AincradBackground")
	:addTo(self)

	CommonView.blackLayer3()
	:addTo(self)

	display.newSprite("main_bottom_bg.png")
	:addTo(self)
	:pos(display.cx, display.top - 30)

	display.newSprite("main_bottom_bg.png")
	:flipY(true)
	:addTo(self)
	:pos(display.cx, display.bottom + 30)

	-- 按钮层
	app:createView("widget.MenuLayer", {wealth="castle"}):addTo(self)	
	:onBack(function(layer)
		self:pop()
	end)

	
---------------------------------------------------------------------
	-- 背景框 
	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(480, 520)

	display.newSprite("word_select_enemy.png"):addTo(self.layer_)
	:pos(480, 520)

---------------------------------------------------------------------
	-- 队伍层 
	self.teamLayer = display.newNode():addTo(self.layer_)

---------------------------------------------------------------------
	-- 刷新按钮 
	app:createView("aincrad.AincradButton"):addTo(self)
	:pos(display.left + 80, display.bottom + 28)	
	:zorder(1)
	:onEvent(function()
		app:pushScene("AincradScene")
	end) 

	-- buff层 
	app:createView("aincrad.AincradBar"):addTo(self)
	:pos(display.cx + 170, display.bottom + 30) 

	-- 积分层
	app:createView("aincrad.AincradScoreWidgetLayer")
	:addTo(self)
	:pos(display.left + 150, display.bottom + 30)
	:zorder(1)

	
end 

-- 开始挑战
--@param data 队伍数据 
function AincradSelectEnemyScene:onButtonStart(data)	
	app:pushScene("AincradReadyScene", {{team=data}})

end 

--------------------------------------------

function AincradSelectEnemyScene:updateData()
	self.userLv = UserData:getUserLevel()
	self.floor = AincradData:getCurrentFloor()
end 

function AincradSelectEnemyScene:updateView()
	if AincradData:getSelectedTeam() then 
		self:showSingleTeam()
	else 
		self:showThreeTeam()
	end 
end 

-- 显示已经选择了的队伍
function AincradSelectEnemyScene:showSingleTeam()
	self.teamLayer:removeAllChildren()
	
	local y = display.cy + 80 
	local x = display.cx 
	self:createTeam(AincradData:getSelectedTeam(), x, y)
	:addTo(self.teamLayer):pos(480, 315)
end 

-- 已经预选队伍
function AincradSelectEnemyScene:showThreeTeam()
	self.teamLayer:removeAllChildren()
	local teams = AincradData:getTeams() 
	local nTeam = table.nums(teams) 
	local addX = 205
	local posX = 480 - (nTeam - 1) * addX / 2 
	local posY = 315

	local y = display.cy + 80 
	local x = display.cx - 45 - nTeam * 100 / 2 

	for i,v in ipairs(teams) do
		local x1 = x + i * 100 
		self:createTeam(v, x1, y)
		:addTo(self.teamLayer):pos((i - 1) * addX + posX, posY)				
	end
end 

--@param x 显示队员条的x坐标
--@param y 显示队员条的y坐标

local wordColors = {
	cc.c3b(95, 208, 255),
	cc.c3b(248, 49, 255),	
	cc.c3b(255, 168, 0),
}

function AincradSelectEnemyScene:createTeam(data, x, y)
	local grid = base.Grid.new()

	grid:addItem(display.newSprite(string.format("aincrad_hero_frame%d.png", data.index)))
	grid:addItem(display.newSprite("aincrad_hero_frame_bottom.png"):pos(0, -186))

	grid:addItems({
			display.newSprite("Banner_Level.png"):zorder(5):pos(-45, 65),
			
			display.newSprite(data.icon):pos(0, 33):zorder(2), 			-- 战队头像
			CommonButton.yellow("挑战", {size=28})
				:scale(0.8)
				:pos(0, -110)				
				:onButtonClicked(function(event)
					CommonSound.click() -- 音效
					
					self:onButtonStart(data)
				end),
			base.Grid.new():pos(0, 33)
			:addItem(display.newSprite(ArenaData:getDefaultBorder()))		
				:onTouch(function(event)					
	       			if event.name == "began" then 
	       				self:showTeam(data, x, y)
	       				
	       			elseif event.name == "ended" then 
	       				self:hideTeam()
	       			end 

	    		end, cc.size(130, 130)),
		})


		-- 等级
		grid:addItemWithKey("lvLabel_", base.Label.new({
			text=tostring(data:getLevel()), 
			size=22,
		})
		:zorder(5)
		:pos(-45, 65)
		:align(display.CENTER)
		:zorder(5))

		-- 名字 
		grid:addItemWithKey("nameLabel_", base.Label.new({
			text=tostring(data.name), 
			size=20, 
			color=cc.c3b(240,200,70),
		})
		:pos(0, -40)
		:align(display.CENTER)
		:zorder(5))

		-- 战斗力
		grid:addItemWithKey("battleLabel_", base.Label.new({
				text=string.format("战斗力:%d", data:getBattle()), 
				size=20,
			})
			:pos(0, -70)
			:zorder(5)
			:align(display.CENTER))

		-- local levelName = teamLevelName[data.index]
		-- if levelName then 
			-- grid:addItem(base.Label.new({text=levelName, size=20}):pos(0, 130):zorder(5):align(display.CENTER))
			local baseScore = AincradData:getBaseScore(data.index, self.floor, self.userLv)
			local starRatio = AincradData:getStarRatio(data.index)

			grid:addItem(base.Label.new({text="基础积分:", size=18, color=cc.c3b(201,195,186)}):pos(-70, -175):zorder(5))
			grid:addItem(base.Label.new({text="得星倍率:", size=18, color=wordColors[data.index]}):pos(-70, -200):zorder(5))
			grid:addItem(base.Label.new({text=tostring(baseScore), size=18, color=cc.c3b(201,195,186)}):pos(30, -175):zorder(5))
			grid:addItem(base.Label.new({text=tostring(starRatio), size=18, color=wordColors[data.index]}):pos(30, -200):zorder(5))
		-- end 

	return grid 
end 

function AincradSelectEnemyScene:showTeam(data, x, y) 
	if not self.teamLayer_ then 
		self.teamView_ = {}
		local node = display.newNode():addTo(self, 10):zorder(11)
		display.newSprite("Defence_Show.png"):addTo(node)
		for i=1,5 do
			local grid = base.Grid.new():addTo(node):pos(i * 95 - 285, 0):scale(0.6)				
			if i == 1 then grid:scale(0.8) end 

			table.insert(self.teamView_, grid)
		end		
		self.teamLayer_ = node 
	end 	
	self.teamLayer_:show():pos(x, y)

	local list = data:getRoleList() 	
	for i,v in ipairs(list) do
		local grid = self.teamView_[i]
		if grid then 
			grid:addItems({
				display.newSprite(v:getIcon()):zorder(2), 	-- 队员头像
				display.newSprite(v:getBorder()), 			-- 头像边框 
				display.newSprite("Banner_Level.png"):pos(-40, 40):zorder(3),
				base.Label.new({text=tostring(v.level), size=18, color=cc.c3b(250,250,250)}):align(display.CENTER):pos(-40, 40):zorder(4),
				createStarIcon(v.starLv):pos(-50, -30):zorder(5), 
			})	
		end 	
	end
end 

function AincradSelectEnemyScene:hideTeam() 
	for i,v in ipairs(self.teamView_) do
		v:removeItems()
	end
	self.teamLayer_:hide()
end 

return AincradSelectEnemyScene

