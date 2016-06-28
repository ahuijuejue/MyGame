--[[
任务场景
]]
local TaskScene = class("TaskScene", base.Scene)

function TaskScene:initView()
	--self:loadImage("texture_account.plist", "texture_account.pvr.ccz")
	self:autoCleanImage()

	-----------------------------------------------------
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	--------------------------------------------------------
	-- /////////////////////////按钮层///////////////////////////////
	self.menuLayer = app:createView("widget.MenuLayer")
	:addTo(self)
	:zorder(10)
	:onBack(function(layer)
		app:popScene()
		-- app:pushScene("MainScene")
	end)

	----------------------------------------------------------
	-- 背景框
	CommonView.backgroundFrame1()
	:pos(435, 285)
	:addTo(self.layer_)
	:zorder(2)

	CommonView.titleLinesFrame2()
	:pos(450, 537)
	:zorder(2)
	:addTo(self.layer_)

	display.newSprite("Word_Quest.png")
	:pos(450, 537)
	:zorder(2)
	:addTo(self.layer_)

	----------------------------------------------------
	self.btnGroup_ = base.ButtonGroup.new({
		zorder1 = 1,
		zorder2 = 5,
	})
	:addButton(self:createButton("成就"))
	:walk(function(index, button)
		button:pos(885, 430 - (index-1) * 80):addTo(self.layer_)
	end)
	:onEvent(function(event)
		if self.btnGroup_ then
			CommonSound.click() -- 音效
		end

		self:updateTaskList()
	end)
	:selectedButtonAtIndex(1)



	self.listView_ = base.TableView.new({
		viewRect = cc.rect(0, 0, 770, 415),
		itemSize = cc.size(770, 130),
		page = true,
	}):addTo(self.layer_)
	:pos(50, 70)
	:zorder(2)
	:onTouch(function(event)
		if event.name == "selected" then
			print("index:", event.index)
		end
	end)

	local flagnames = {
		"okflag",
		"okflag",
		"okflag",
		"toflag",
		"toflag",
		"toflag",
		"timeflag",
		"timeflag",
	}

	for i,v in ipairs(flagnames) do
		self.listView_:addFreeItem(self:createTaskGrid(v))
	end

end

function TaskScene:createButton(txt)
	local btn = CommonButton.sidebar(txt,{size = 28})
	local dot = display.newSprite("Point_Red.png") -- 红点
	btn:setData("dot", dot)

	dot:addTo(btn, 6)
	:pos(58, 33)

	return btn
end

function TaskScene:getCurrentData()
	if not self.btnGroup_ then return nil end
	print("idx:", self.btnGroup_:getSelectedIndex())
	return self.data[self.btnGroup_:getSelectedIndex()]
end


-- 重新显示任务
-- @param isNewData bool 是否变换了任务数量
function TaskScene:updateTasks(isNewData)
	self.viewOffset_ = {self.listView_:getScrollNode():getPosition()}
	if isNewData then
		self:updateData()
		self.menuLayer:updateDot()
	end
	self:updateView()
	self:updateDailyButton()
	self:updateDot()

end

function TaskScene:updateData()
	local achievementTasks = TaskData:getAchievementTasks()
	self:sortTasks(achievementTasks)
	self.data = {achievementTasks}

	if TaskData:isDailyTaskOpen() then
		local dailyTasks = TaskData:getDailyTasks()
		self:sortTasks(dailyTasks)
		table.insert(self.data, 1, dailyTasks)
	end
end

function TaskScene:sortTasks(tasks)
	table.sort(tasks, function(a, b)
		if a and b then
			local aInfo = TaskData:getAchieveInfo(a.id)
			local bInfo = TaskData:getAchieveInfo(b.id)
			if aInfo.isOk and not bInfo.isOk then
				return true
			elseif not aInfo.isOk and bInfo.isOk then
				return false
			elseif aInfo.isDailyTime and not bInfo.isDailyTime then
				return true
			end
		end
		return a:compare(b) == -1
	end)
end

function TaskScene:updateView()
	self:updateTaskList()
	if self.viewOffset_ then
        self.listView_:scrollOffset(cc.p(self.viewOffset_[1], self.viewOffset_[2]), false, true)
        self.listView_:elasticScroll()
    end
    self:updateDailyButton()
    self:updateDot()

end

local function parseRewardItems(data)
	local rewards = {}
	for i,v in ipairs(data.items) do
		local itemIcon = UserData:createItemView(v.itemId, {scale=0.4})
		table.insert(rewards, {
			icon = itemIcon,
			count = v.count
		})
	end
	for k,v in pairs(data.heros) do
		local hero = HeroListData:getRole(k)
		if hero then
			local node = UserData:createHeroView(k, {scale=0.4})
			table.insert(rewards, {
				icon = node,
				count = v
			})
		end
	end
	return rewards
end

function TaskScene:createTaskGrid(flag)
	local grid = app:createView("task.TaskGrid", {
		flag = flag
	})

	if flag == "okflag" then
		grid:setBackground("DialyQuest_List.png")
		grid:initOkButton(function(event)
			self:completeTask(event.target:getData("task"), event.target)
		end)
	elseif flag == "toflag" then
		grid:setBackground("AchievementQuest_List.png")
		grid:initGotoButton(function(event)
			self:gotoScene(event.target:getData("task"))
		end)
	elseif flag == "timeflag" then
		grid:setBackground("AchievementQuest_List.png")
		grid:initTimeButton()
	end

	return grid
end

function TaskScene:updateTaskList()
	local datas = self:getCurrentData()
	if not datas then
		print "data is nil"
		return
	end

	self.listView_
	:resetData()
	:addItems(#datas, function(event)
		local index = event.index
		local data = datas[index]

		local flag = nil
		local info = TaskData:getAchieveInfo(data.id)
		if info then
			if info.isOk then
				flag = "okflag"
			else
				if info.isDailyTime then
					flag = "timeflag"
				else
					flag = "toflag"
				end
			end
		end

		local grid = event.target:getFreeItem(flag)
		if not grid then
			grid = self:createTaskGrid(flag)
		else
			grid:removeRewards()
		end

		grid:setTaskName(data.name)
		grid:setTaskDesc(data.desc)

		grid:setData("task", data)

		grid:setIconBorder(data.border)
		grid:setIcon(data.icon)

		local items = parseRewardItems(data)
		grid:addRewards(items)

		if info then
			local descStr = info.desc or ""
			grid:setAchieve(descStr)
		end

		return grid

	end)
	:reload()

end

function TaskScene:updateDailyButton()
	if self.btnGroup_:getButtonsCount() < 2 and TaskData:isDailyTaskOpen() then
		local addbtn = self:createButton("每日")
		:addTo(self.layer_)

		self.btnGroup_:addButton(addbtn, 1)
		:walk(function(index, button)
			button:pos(885, 430 - (index-1) * 80)
		end)
		:selectedButtonAtIndex(1)
	end
end

function TaskScene:updateDot()
	local okAchievement = TaskData:haveOkAchievement()
	if TaskData:isDailyTaskOpen() then
		local okDaily = TaskData:haveOkDaily()

		self.btnGroup_:getButtonAtIndex(1):getData("dot"):setVisible(okDaily)
		self.btnGroup_:getButtonAtIndex(2):getData("dot"):setVisible(okAchievement)
	else
		self.btnGroup_:getButtonAtIndex(1):getData("dot"):setVisible(okAchievement)
	end

end

function TaskScene:completeTask(data, button)
	print("完成任务:", data.id)

	NetHandler.request("FinishTask", {
		data = {param1=data.id},
		onsuccess = function(params)
			showToast({text="领取成功"})
			self:updateTasks(true)
			UserData:showReward(params.items, function()
				UserData:showTeamLevelUp(params.levelUp, function()
					self:onGuide()
				end)
			end)
			if button and button.setButtonEnabled then
				button:setButtonEnabled(true)
			end
		end,
		onerror = function()
			if button and button.setButtonEnabled then
				button:setButtonEnabled(true)
			end
		end
	}, self)
end

function TaskScene:gotoScene(data)
	TaskData:JumpUI(data.id, self)
end

----------------------------------------------------------------
function TaskScene:onGuide()
	if GuideManager:makeGuide(self) then
		self.menuLayer:openMenuNode()
	end

	-- local keys = GuideData.key
	-- if GuideData:isNotCompleted(keys.task) then 	-- 任务
	-- 	self:showStartGuide({name=keys.task})
	-- elseif GuideData:isNotCompleted(keys.taskDaily) and TaskData:isDailyTaskOpen() then 	-- 每日任务
	-- 	self:showStartGuide({name=keys.taskDaily})
 --    elseif GuideManager:makeGuide() then
 --    	self.menuLayer:openMenuNode()
	-- end

end

-- function TaskScene:showStartGuide(params)
-- 	if GuideData:isNotCompleted(params.name) then
-- 		local posX = display.cx + 220
--     	local posY = display.cy + 90

--     	showTutorial2({
--             rect = cc.rect(posX, posY, 150, 100),
--             callback = function(target)
-- 	            self:onStartGuide(params)
-- 	        	target:removeSelf()
--             end,
--         })

--         return true
-- 	end
-- 	return false
-- end

-- function TaskScene:onStartGuide(params)
-- 	GuideData:setCompleted(params.name, function()
-- 		local datas = self:getCurrentData()
-- 		local data = datas[1]
-- 		local info = TaskData:getAchieveInfo(data.id)
-- 		if info then
-- 			if info.isOk then
-- 				self:completeTask(data)
-- 			else
-- 				self:gotoScene(data)
-- 			end
-- 		end
-- 	end,
-- 	function()

-- 	end)
-- end
--------------------------------------

function TaskScene:netCallback(event)
	local data = event.data
	local order = data.order
	if order == OperationCode.ShowUnionInfoProcess then
        if data.param1 == 1 then
            app:pushToScene("UnionScene")
        elseif data.param1 == 2 then
            app:pushToScene("JoinUnionScene")
        end
	end
end

function TaskScene:onEnter()
	TaskScene.super.onEnter(self)

	self.buyGoldOkEvent = UserData:addEvent(EVENT_CONSTANT.BUY_GOLD_SUCCESS, function()
		self:updateTasks(true)
	end)

	self.buyPowerOkEvent = UserData:addEvent(EVENT_CONSTANT.BUY_POWER_SUCCESS, function()
		self:updateActivity()
		self:updateDot()
	end)

	--注册监听事件
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))

end

function TaskScene:onExit()
	print("TaskScene:onExit")
	self.viewOffset_ = {self.listView_:getScrollNode():getPosition()}
	UserData:removeEvent(self.buyGoldOkEvent)
	UserData:removeEvent(self.buyPowerOkEvent)

	--移除监听事件
    GameDispatcher:removeEventListener(self.netEvent)

	TaskScene.super.onExit(self)
end

return TaskScene
