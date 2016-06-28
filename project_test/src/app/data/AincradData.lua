
local AincradData = class("AincradData")

function AincradData:ctor()
	self.floor 				= 1 	-- 当前第几层
	self.useRestarTimes 	= 0 	-- 使用刷新次数
	self.isBattleOk 		= false -- 是否挑战成功
	self.isGetReward 		= false -- 是否已经领取奖励

	self.selectedTeam 		= nil 	-- 已经选中的敌人队伍
	self.teams 				= {} 	-- 预选敌人队伍数组
	self.oldRoles 			= {} 	-- 自己上过场的人

	self.willBuff 			= {}
	self.willReward 		= {}

	self.awardTimes 		= 0 	-- 茅场晶彦 抽奖次数

	self.oldFloor = 1 		-- 历史最高
	self.totalFloor = 0 	-- 通关总数

	self.currentScore = 0 	-- 当前积分
	self.currentStar = 0 	-- 当前星星数

	self.maxScore = 0 		-- 当天最高积分

	self.scoreRatios = {}
	self.starRatios = {}

	self.scoreBase = {}

	self.awards = {}

	self:initScoreConfig()
	self:initInfoConfig()
	self:initRankAwardConfig()
end

function AincradData:initScoreConfig()
	local cfg = GameConfig["AincradScore"]

	for k,v in pairs(cfg) do
		table.insert(self.scoreBase, {
			level = checknumber(k),
			score1 = checknumber(v.Score1),
			score2 = checknumber(v.Score2),
			score3 = checknumber(v.Score3),
		})
	end

	table.sort(self.scoreBase, function(a, b)
		return a.level < b.level
	end)
end

function AincradData:initInfoConfig()
	local cfg = GameConfig["AincradInfo"]["1"]
	table.insert(self.scoreRatios, checknumber(cfg.OneStarScore))
	table.insert(self.scoreRatios, checknumber(cfg.TwoStarScore))
	table.insert(self.scoreRatios, checknumber(cfg.ThreeStarScore))

	table.insert(self.starRatios, checknumber(cfg.OneEnemyStar))
	table.insert(self.starRatios, checknumber(cfg.TwoEnemyStar))
	table.insert(self.starRatios, checknumber(cfg.ThreeEnemyStar))

	self.ruleDesc = cfg.Info or ""  -- 规则描述
end

local function parseAwardConfig(data)
	local items = {}
	for i,v in ipairs(data.AwardItemID or {}) do
		if string.len(v) > 0 then
			table.insert(items, {
				itemId = v,
				count = checknumber(data.ItemNumber[i])
			})
		end
	end
	local lvs = {}
	if type(data.RankRange) == "table" then
		for i,v in ipairs(data.RankRange) do
			table.insert(lvs, checknumber(v))
		end
	else
		table.insert(lvs, checknumber(data.RankRange))
	end

	local info = {
		lv = lvs,
		items = items,
	}

	return info
end

function AincradData:initRankAwardConfig()
	for k,v in pairs(GameConfig["AnicradRankAward"] or {}) do
		table.insert(self.awards, parseAwardConfig(v))
	end

	for k,v in pairs(GameConfig["AnicradRankAward2"] or {}) do
		table.insert(self.awards, parseAwardConfig(v))
	end

	table.sort(self.awards, function(a, b)
		return a.lv[1] < b.lv[1]
	end)
end

function AincradData:restartData()
	self.floor = 1
	self.useRestarTimes = self.useRestarTimes + 1
	self.isBattleOk = false
	self.isGetReward = false
	self.selectedTeam = nil
	self.currentScore = 0 	-- 当前积分
	self.currentStar = 0 	-- 当前星星数
	self:resetTeams()
	AincradBuffData:resetBuffProcess()

	self:resetHeros()
end

function AincradData:resetDayData()
	self.useRestarTimes = 0
end

-- 服务器交互层数
function AincradData:getFloor()
	return self.floor
end

function AincradData:setFloor(value)
	if self.oldFloor < self.floor then
		self.oldFloor = self.floor
	end
	self.floor = value
end

-- 计算当前层数
function AincradData:getCurrentFloor()
	if AincradData.isBattleOk and AincradData.isGetReward then
		return self:getFloor() + 1
	end

	return self:getFloor()
end

function AincradData:addFloor(value)
	 self:setFloor(self.floor + value)
end

-- 历史最高层数
function AincradData:getOldFloor()
	return self.oldFloor
end

function AincradData:setOldFloor(value)
	self.oldFloor = value
end

function AincradData:setOldFloorIf(value)
	if self.oldFloor < value then
		self:setOldFloor(value)
	end
end

-- 总层数
function AincradData:getTotalFloor()
	return self.totalFloor
end

function AincradData:setTotalFloor(value)
	self.totalFloor = value
end

function AincradData:addTotalFloor(value)
	 self:setTotalFloor(self.totalFloor + value)
end

-- 最大层数
function AincradData:getFloorMax()
	return 20
end

-- 剩余刷新次数
function AincradData:haveRestarTimes()
	return self:getRestartMax() - self.useRestarTimes
end

-- 可刷新最大次数
function AincradData:getRestartMax()
	return VipData:getAincradResetMax()
end

-- 重置预选队伍数组
function AincradData:resetTeams()
	self.teams = {}
end

-- 获取预选队伍数组
function AincradData:getTeams()
	return self.teams
end

-- 获取已选队伍
function AincradData:getSelectedTeam()
	return self.selectedTeam
end

-- 增加预选队伍
function AincradData:addTeam(team)
	table.insert(self.teams, team)
end

-- 排序队伍
function AincradData:sortTeams()
	table.sort(self.teams, function(a, b)
		return a.index < b.index
	end)
end

-- 重新开始
function AincradData:restart(callback, target)
	NetHandler.request("ResetAincrad", {
		onsuccess = function(params)
			callback(params)
		end
	}, target)
end

----------------------------------------
-- 拥有的buff
function AincradData:getHaveBuff()
	return AincradBuffData:getHaveBuff()
end
----------------------------------------
-- 设置英雄状态 (己方)
function AincradData:resetHero(hero)
	hero.hp = hero.maxHp
	hero.anger = 0
end

function AincradData:resetHeros()
	self.oldRoles = {}
end

----------------------------------------
-- 设置已选人的状态
function AincradData:setOldHero(heroId, hp, anger)
	if not self.oldRoles[heroId] then
		self.oldRoles[heroId] = {}
	end
	self.oldRoles[heroId].roleId = heroId
	self.oldRoles[heroId].hp = hp
	self.oldRoles[heroId].anger = anger

	return self
end

function AincradData:getOldHeros()
	return self.oldRoles
end

function AincradData:getOldHero(heroId)
	return self.oldRoles[heroId]
end
------------------------------------------
-- 欲奖励buff
function AincradData:resetWillBuff()
	self.willBuff = {}
end

function AincradData:addWillBuff(buffId, value)
	local buffdata = AincradBuffData:createBuff(buffId, value)
	table.insert(self.willBuff, buffdata)

	return buffdata
end

function AincradData:getWillBuff()
	return self.willBuff
end
------------------------------------------
-- 欲奖励 物品
function AincradData:resetWillReward()
	self.willReward = {}
end

function AincradData:addWillReward(reward)
	table.insert(self.willReward, reward)
end

function AincradData:setWillReward(arr)
	self.willReward = arr
end

function AincradData:getWillReward()
	return self.willReward
end

------------------------------------------
---- 茅场晶彦
-- 抽奖 花费宝石
 function AincradData:getAwardCost()
	return CostDiamondData:getAincradAward(self.awardTimes + 1)
end

-- 增加抽奖次数
function AincradData:addAwardTimes()
	self.awardTimes = self.awardTimes + 1
end

------------------------------------------

function AincradData:isAincradOpen()
	return UserData:getUserLevel() >= OpenLvData.aincrad.openLv
end

-------------------------------------------
--******************* 积分和星级 ********************--

--[[
-- 获得 基础积分
基础积分 = 配置基础积分 * 玩家等级

@param index 难度 1简单 2普通 3困难
@param floor 层级
@param userLv 玩家等级
]]
function AincradData:getBaseScore(index, floor, userLv)
	local data = self.scoreBase[floor]
	local value = data[string.format("score%d", index)]
	return value * 10 * math.floor((userLv+5)*0.1)
end

--[[
-- 获得 计算后最终积分
= 基础积分 * 积分倍数

@param index 难度 1简单 2普通 3困难
@param floor 层级
@param userLv 玩家等级
@param star 关卡星级
]]
function AincradData:getResultScore(index, floor, userLv, star)
	local baseScore = self:getBaseScore(index, floor, userLv)
	return baseScore * self.scoreRatios[star]
end

-- 获得 得星倍率
-- @param index 难度 1简单 2普通 3困难
function AincradData:getStarRatio(index)
	return self.starRatios[index] or 0
end

-- 计算获得星星数 (通关计算)
-- @param index 难度 1简单 2普通 3困难
-- @param overStar 通关星级
function AincradData:getResultStar(index, overStar)
	local starRatio = self:getStarRatio(index)
	return starRatio * overStar
end

-------------------
-------------------
-- 积分
function AincradData:getCurrentScore()
	return self.currentScore
end

function AincradData:setCurrentScore(value)
	self.currentScore = value
end

function AincradData:addCurrentScore(value)
	self:setCurrentScore(self.currentScore + value)
end

function AincradData:setMaxScoreIf(value)
	if self.maxScore < value then
		self.maxScore = value
	end
end

-- 星级
function AincradData:getCurrentStar()
	return self.currentStar
end

function AincradData:setCurrentStar(value)
	self.currentStar = value
end

function AincradData:addCurrentStar(value)
	self:setCurrentStar(self.currentStar + value)
end

-- 排名奖励
--@param lv 排名等级
function AincradData:getAwardData(lv)
	for i,v in ipairs(self.awards) do
		if #v.lv == 1 then
			if v.lv[1] == lv then
				return v
			end
		else
			if v.lv[1] <= lv and v.lv[2] >= lv then
				return v
			end
		end
	end
	return nil
end

-- 所有排名奖励
function AincradData:getAwardDatas()
	return self.awards
end

return AincradData



