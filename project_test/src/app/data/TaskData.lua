--[[
任务区
]]
local TaskData = class("TaskData")
local GameTask = import(".GameTask")

function TaskData:ctor(params)
	params = params or {}
	self.list 		= 	params.list or {}
	self.type 		= 	params.type or "" -- 分区名


	------------------------------------------
	-- 所有任务
	self.tasks = {}

	function addTasks(dict, taskType)
		for k,v in pairs(dict) do
			local task = GameTask.new({
				id 			= k,
				taskType 	= taskType,
				cfg 		= v,
			})
			self.tasks[k] = task
		end
	end
	--@ daily, dailyTime, achievement 为taskType任务类型
	addTasks(GameConfig["DailyQuest"] or {}, 		"daily")
	addTasks(GameConfig["DailyTimingQuest"] or {}, 	"dailyTime")
	addTasks(GameConfig["AchievementQuest"] or {}, 	"achievement")

	----------------------------------------------
	-- 任务种类参数
	self.dailyParams = {} -- 日常任务 完成度参数
	self.achievementParams = {} -- 成就任务 完成度参数（需要服务器数据的部分）

end

--------------------------------------------
--------------------------------------------
-- 重置所有数据
function TaskData:resetAllDatas()
	for k,v in pairs(self.tasks) do
		v.completed = false
	end

	self.dailyParams = {} -- 日常任务 完成度参数
	self.achievementParams = {} -- 成就任务 完成度参数（需要服务器数据的部分）
end
--------------------------------------------
--------------------------------------------

-- 获取单个任务数据，根据任务taskId
function TaskData:getTask(taskId)
	return self.tasks[taskId]
end

-- 获取任务类型，根据任务taskId
function TaskData:getTaskType(taskId)
	return self.tasks[taskId].taskType
end

-- 获取任务 tasks 中 所有的任务种类
function TaskData:getTaskKinds(tasks)
	local types = {}
	for k,v in pairs(tasks) do
		if v.taskType == taskType then
			types[v.okCode] = true
		end
	end
	return table.keys(types)
end

-- 获取任务 taskType 任务类型中 所有的任务
function TaskData:getTasks(taskType)
	local tasks = {}
	for k,v in pairs(self.tasks) do
		if v.taskType == taskType then
			tasks[k] = v
		end
	end
	return tasks
end

-- 完成了一件任务 -*- 把成就任务里的购买商品的物品记录清空 -*-
function TaskData:achieveTask(taskId)
	local task = self:getTask(taskId)
	if task.taskType == "achievement" then
		if task.okCode == "12" then -- 在竞技场商店购买一个%s（物品ID
			self:resetShopBuyParams("shopArena")

		elseif task.okCode == "13" then -- 在积分商店购买一个%s（物品ID）
			self:resetShopBuyParams("shopScore")

		elseif task.okCode == "14" then -- 在神树商店购买一个%s（物品ID）
			self:resetShopBuyParams("shopTree")

		end
	end
end

----------------------------------------------
------ 任务缓存

-- 日常任务
local taskNames = {
	stageNormal 	= "1", 		-- 通关普通关卡次数
	stageElit 		= "2", 		-- 通关精英关卡次数
	useExpWater 	= "3", 		-- 使用经验药水次数
	upHeroLevel 	= "4", 		-- 提升英雄等级次数
	upHeroSkill 	= "5", 		-- 升级英雄技能次数
	upHeroEquip 	= "6", 		-- 强化英雄装备次数
	gold 			= "7", 		-- 点金次数
	card 			= "8", 		-- 抽卡次数
	holyLand 		= "9", 		-- 修炼圣地次数
	arena 			= "10", 	-- 竞技场挑战次数
	tree 			= "11", 	-- 保卫世界树次数
	aincrad 		= "12", 	-- 艾恩葛朗特次数
	seal 			= "13", 	-- 封印魔像次数
	city 			= "14", 	-- 城建次数
	wanted 			= "15", 	-- 日月追缉
}

-- 增加日常任务进度数值
function TaskData:addTaskParams(taskName, value)
	local taskKind = taskNames[taskName]
	if taskKind then
		local params = self:getDailyParams_(taskKind)
		self:setDailyParams_(taskKind, params + value)
	end
end

-- 设置日常任务进度数值
function TaskData:setTaskParams(taskName, value)
	local taskKind = taskNames[taskName]
	if taskKind then
		self:setDailyParams_(taskKind, value)
	end
end

----------------------------------------------
-- 成就任务
local achievementTaskNames = {
	shopArena 	= "12", 	-- 竞技场商店购买一个物品
	shopScore 	= "13", 	-- 积分商店购买一个物品
	shopTree 	= "14",  	-- 神树商店购买一个物品
}
-- 设置成就任务进度 (商店购买物品)
function TaskData:addShopBuyParams(taskName, itemId, value)
	local taskKind = achievementTaskNames[taskName]
	if taskKind then
		local tasks = self:getAchievementTasks()
		local task = nil
		for k,v in pairs(tasks) do
			if v.okCode == taskKind and v.okParams1 == itemId then
				task = v
				break
			end
		end
		if task then -- 匹配任务对应的物品id
			local params = self.achievementParams[taskKind] or {} -- 对应商店, 即商品列表
			local nHave = params[itemId] or 0
			params[itemId] = nHave + value
			self:setAchievementParams_(taskKind, params)
		end
	end
end

-- 增加成就任务进度
function TaskData:setShopBuyParams(taskName, itemId, value)
	local taskKind = achievementTaskNames[taskName]
	if taskKind then
		local params = self.achievementParams[taskKind] or {} -- 对应商店
		params[itemId] = value
		self:setAchievementParams_(taskKind, params)
	end
end
-----------------------------------------------------
-- 重置日常任务进度数值
function TaskData:resetDailyParams()
	self.dailyParams = {}
end

-- 重置商店任务进度数值
function TaskData:resetShopBuyParams(taskName)
	local taskKind = achievementTaskNames[taskName]
	if taskKind then
		self:setAchievementParams_(taskKind, nil)
	end
end

-----------------------------------------------
-- 日常任务参数
--@param taskKind 任务种类
function TaskData:setDailyParams_(taskKind, params)
	self.dailyParams[taskKind] = params
end

function TaskData:getDailyParams_(taskKind)
	return self.dailyParams[taskKind] or 0
end

-- 成就任务参数
--@param taskKind 任务种类
function TaskData:setAchievementParams_(taskKind, params)
	self.achievementParams[taskKind] = params
end

----------------------------------------------
-- 获取成就任务
--[[
开启条件类型
1等级
2前置任务
3购买月卡
]]
function TaskData:getAchievementTasks()
	local taskPool = self:getTasks("achievement")
	local level = UserData:getUserLevel()
	local tasks = {}
	for k,v in pairs(taskPool) do
		if not v:isCompleted() then
			if v.openCode == "1" then
				if level >= tonumber(v.openParams) then
					table.insert(tasks, v)
				end
			elseif v.openCode == "2" then
				local preTask = self:getTask(v.openParams)
				if preTask:isCompleted() then
					table.insert(tasks, v)
				end
			end
		end
	end
	table.sort(tasks, function(a, b)
		return a:compare(b) == -1
	end)

	return tasks
end

-- 获取每日任务
--[[
开启条件类型
1等级
2前置任务
3购买月卡
4开启时间
]]
function TaskData:getDailyTasks()
	local level = UserData:getUserLevel()
	local date  = UserData:getServerTime()
	local serverMinute = date.hour * 60 + date.min
	local tasks = {}

	function getOpenTasks(tasksData)
		for k,v in pairs(tasksData) do
			if not v:isCompleted() then
				if v.openCode == "1" then
					if level >= tonumber(v.openParams) then
						table.insert(tasks, v)
					end
				elseif v.openCode == "2" then
					local preTask = self:getTask(v.openParams)
					if preTask:isCompleted() then
						table.insert(tasks, v)
					end
				elseif v.openCode == "3" then -- 月卡
					local days = UserData:getCardDay(1)
					v.desc = string.format(v.cfgDes,days)
					table.insert(tasks, v)
				elseif v.openCode == "4" then
					local endTime = self:convertTimeToNum(v.okParams2)
					if serverMinute < endTime then
						table.insert(tasks, v)
					end
				elseif v.openCode == "5" then
					local days = UserData:getCardDay(2)
					v.desc = string.format(v.cfgDes,days)
					table.insert(tasks, v)
				end
			end
		end
	end

	local taskPool1 = self:getTasks("daily")
	local taskPool2 = self:getTasks("dailyTime")
	getOpenTasks(taskPool1)
	getOpenTasks(taskPool2)

	table.sort(tasks, function(a, b)
		return a:compare(b) == -1
	end)

	return tasks
end

function TaskData:convertTimeToNum(timeStr) -- 转换成数值，单位分钟
	local arrStr = string.split(timeStr, ":")
	return tonumber(arrStr[1]) * 60 + tonumber(arrStr[2])
end

--------------------------------------------------------
--------------------------------------------------------
-- 跳转至UI
function TaskData:JumpUI(taskId, target, callback)
	local task = self:getTask(taskId)
	self:JumpUI_(task.jumpCode, task.params, target, callback)
end

--@param type jump ui 的编号
function TaskData:JumpUI_(type, params, target, callback)
	local index = checknumber(type)
	if index == 22 then
		NetHandler.gameRequest("ShowUnionInfo")
	elseif index == 23 then
		app:pushScene("CoinScene")
	else
		if index == 19 then
			params = {stageId = params[1]}
		end
		SceneData:JumpUI(index, params, target, callback)
	end
end

------------------------------------------------
------------------------------------------------
-- 获取任务完成情况
--@return table
--isOk			是否完成
--desc 			完成进度
function TaskData:getAchieveInfo(id)
	local task = self:getTask(id)
	local data
	if task.taskType == "dailyTime" then 		-- 每日时间任务
		data = self:getDailyTimingInfo(task)
	elseif task.taskType == "daily" then 	-- 每日任务
		data = self:getDailyInfo(task)
	elseif task.taskType == "achievement" then 	-- 成就任务
		data = self:getAchievementInfo(task)
	end

	return data or {}
end

-- 每日时间任务完成情况
function TaskData:getDailyTimingInfo(task)
	local date  = UserData:getServerTime()
	local serverMinute = date.hour * 60 + date.min

	local data = {}
	if task.okCode == "1" then 		-- 1每天到达几点自动完成
		data.isDailyTime = true
		local startTime = self:convertTimeToNum(task.openParams)
		local endTime = self:convertTimeToNum(task.okParams2)
		if startTime <= serverMinute and endTime >= serverMinute then
			data.isOk = true
		end
	elseif task.okCode == "2" then 	-- 2领取多少天 （月卡）
		local days = UserData:getCardDay(1)
		if days > 0 then
			data.name = string.format(task.cfgDes,days)
			data.isOk = true
		end
	elseif task.okCode == "3" then
		local days = UserData:getCardDay(2)
		if days > 0 then
			data.name = string.format(task.cfgDes,days)
			data.isOk = true
		end
	end
	return data
end

-- 每日任务完成情况
function TaskData:getDailyInfo(task)
	local data = {}
	local params = self:getDailyParams_(task.okCode) -- 完成数值
	if task.okCode == "1" then  	-- 1通关普通关卡%d 次（10）(包括扫荡）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "2" then 	-- 2通关精英关卡%d次（5）(包括扫荡）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "3" then 	-- 3使用经验药水%d次（1）（查ExpDrug表）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "4" then 	-- 4提升%d次英雄等级（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "5" then 	-- 5升级%d次英雄技能（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "6" then 	-- 6强化%d次英雄装备（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "7" then 	-- 7点金%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "8" then 	-- 8抽卡%d次（3）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "9" then 	-- 9进行修炼圣地%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "10" then -- 10竞技场挑战%d次（3）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "11" then -- 11进行保卫世界树%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "12" then -- 12进行艾恩葛朗特%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "13" then -- 13封印魔像%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "14" then -- 14城建%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end

	elseif task.okCode == "15" then -- 14日月追缉%d次（1）
		if params >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", params, tonumber(task.okParams1))
		end
	end
	return data
end

-- 成就任务完成情况
function TaskData:getAchievementInfo(task)
	local data = {}
	local params = self.achievementParams[task.okCode] -- 完成数值
	if task.okCode == "1" then  	-- 战队等级达到%d级
		local teamLevel = UserData:getUserLevel()
		data.isOk = teamLevel >= tonumber(task.okParams1)
		if not data.isOk then
			data.desc = string.format("%d/%d", teamLevel, tonumber(task.okParams1))
		end

	elseif task.okCode == "2" then 	-- VIP等级达到%d级
		local vipLevel = UserData:getVip()
		data.isOk = vipLevel >= tonumber(task.okParams1)
		if not data.isOk then
			data.desc = string.format("%d/%d", vipLevel, tonumber(task.okParams1))
		end

	elseif task.okCode == "3" then 	-- 拥有%d名英雄
		local heros = HeroListData.heroList
		local heroCount = table.nums(heros)
		data.isOk = heroCount >= tonumber(task.okParams1)
		if not data.isOk then
			data.desc = string.format("%d/%d", heroCount, tonumber(task.okParams1))
		end

	elseif task.okCode == "4" then 	-- %d名英雄进阶为%s品质（1白2绿3蓝4紫5橙）
		local heros = HeroListData.heroList
		local count = 0
		for i,v in ipairs(heros) do
			if v.strongLv >= tonumber(task.okParams2) then
				count = count + 1
			end
		end
		data.isOk = count >= tonumber(task.okParams1)
		if not data.isOk then
			data.desc = string.format("%d/%d", count, tonumber(task.okParams1))
		end

	elseif task.okCode == "5" then 	-- %d名英雄获得英雄名%s（1临2兵3斗4者5皆6阵7列8在9前）
		local heros = HeroListData.heroList
		local count = 0
		for i,v in ipairs(heros) do
			if v.starLv >= tonumber(task.okParams2) then
				count = count + 1
			end
		end
		data.isOk = count >= tonumber(task.okParams1)
		if not data.isOk then
			data.desc = string.format("%d/%d", count, tonumber(task.okParams1))
		end

	elseif task.okCode == "6" then 	-- 拥有%d只尾兽
		local list = TailsData:getOpenTails()
		-- dump(list, "list")
		local count = table.nums(list)
		if count >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", count, tonumber(task.okParams1))
		end

	elseif task.okCode == "7" then 	-- %d只尾兽达成%D星
		local list = TailsData:getOpenTails()
		local toLevel = tonumber(task.okParams2)
		local count = 0
		for k,v in pairs(list) do
			if v:getLevel() >= toLevel then
				count = count + 1
			end
		end
		if count >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", count, tonumber(task.okParams1))
		end

	elseif task.okCode == "8" then 	-- 完成普通关卡：%s-%s（关卡ID）
		local stage = ChapterData:getStage(task.okParams1)
		data.isOk = stage:isOver()

	elseif task.okCode == "9" then 	-- 完成精英关卡：%s-%s（关卡ID）（和上边是一样的）
		local stage = ChapterData:getStage(task.okParams1)
		data.isOk = stage:isOver()

	elseif task.okCode == "10" then -- 封印魔像至%d层
		local level = SealData:getSealLevel()
		if level >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", level, tonumber(task.okParams1))
		end

	elseif task.okCode == "11" then -- 城建到%d级
		local level = 0
		for k,v in pairs(CityData.cityData) do
			if level < v.level then
				level = v.level
			end
		end
		if level >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", level, tonumber(task.okParams1))
		end
	elseif task.okCode == "12" then -- 在竞技场商店购买一个%s（物品ID
		if params then
			local nCount = params[task.okParams1] or 0 -- 物品数量
			if nCount >= 1 then
				data.isOk = true
			end
		end

	elseif task.okCode == "13" then -- 在积分商店购买一个%s（物品ID）
		if params then
			local nCount = params[task.okParams1] or 0 -- 物品数量
			if nCount >= 1 then
				data.isOk = true
			end
		end

	elseif task.okCode == "14" then -- 在神树商店购买一个%s（物品ID）
		if params then
			local nCount = params[task.okParams1] or 0 -- 物品数量
			if nCount >= 1 then
				data.isOk = true
			end
		end

	elseif task.okCode == "66" then -- 寻宝%d次
		local counts = CoinData.coinAllCounts or 0 -- 寻宝次数
		if counts >= tonumber(task.okParams1) then
			data.isOk = true
		else
			data.desc = string.format("%d/%d", counts, tonumber(task.okParams1))
		end

	elseif task.okCode == "67" then -- 公会等级达到%d级
		data.isOk = UserData.unionLevel >= tonumber(task.okParams1)
		if not data.isOk then
			data.desc = string.format("%d/%d", UserData.unionLevel, tonumber(task.okParams1))
		end

	elseif task.okCode == "54" then -- 日月追缉胜利多少次
		if params then
			local nCount = params[task.okParams1] or 0 -- 物品数量
			if nCount >= 1 then
				data.isOk = true
			end
		end

	end

	return data
end

----------------------------------------------------------------
-- 是否有成就任务达成
function TaskData:haveOkAchievement()
	local tasks = self:getAchievementTasks()
	for i,v in ipairs(tasks) do
		local info = self:getAchieveInfo(v.id)
		if info and info.isOk then
			return true
		end
	end
	return false
end

-- 是否有成就任务达成
function TaskData:haveOkDaily()
	local tasks = self:getDailyTasks()
	for i,v in ipairs(tasks) do
		local info = self:getAchieveInfo(v.id)
		if info and info.isOk then
			return true
		end
	end
	return false
end

-- 是否有任务达成
function TaskData:haveOkTask()
	if self:haveOkAchievement() then
		return true
	elseif self:isDailyTaskOpen() and self:haveOkDaily() then
		return true
	end
	return false
end

----------------------------------------------------------------
-- 每日任务是否解锁
function TaskData:isDailyTaskOpen()
	return UserData:getUserLevel() >= OpenLvData.dailyTask.openLv
end
----------------------------------------------------------------

return TaskData
