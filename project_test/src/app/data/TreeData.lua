--[[
世界树 数据
]]
local TreeData = class("TreeData")

local CharacterModel = require("app.battle.model.CharacterModel")

function TreeData:ctor()
	-- 奖励列表
	self.awardDict = {}
	-- 刷新花费列表
	self.costList = {}
	self:initConfig()
	
	self.heroBattleList = {} 	-- 已选择英雄列表
	self.heroCacheList = {} 	-- 待选择英雄列表

	self.refreshTimes = 0 	-- 刷新次数 
	self.useTimes = 0 		-- 使用次数
	self.winTimes = 0 		-- 胜利场次
	self.battling = false 	-- 是否战斗进行中

	self.isTips = true 		-- 是否显示 刷新弹出窗

	self.isRequestingHero = false 	-- 是否正在向服务器申请 预选队员列表 
	self.tree_we = "" -- tree_we的id

	self.battleData = "" 	-- 上一场战斗保存数据
	self.oldHeroData = {} 	-- 上一场战斗英雄血量

	self.totalWin = 0 	-- 通关总层数
	self.oldWin = 0 	-- 历史最高
end

function TreeData:initConfig()
	local awardCfg = GameConfig["TreeAward"]
	self.awardDict = {}
	for k,v in pairs(awardCfg) do		
		local key = tostring(v.Level)
		if not self.awardDict[key] then 
			self.awardDict[key] = {}
		end 
		local count = #v.AwardItemID 
		local items = {}
		for i=1,count do
			table.insert(items, {
				id = v.AwardItemID[i],
				count = checknumber(v.ItemNumber[i]),
			})			
		end
		table.insert(self.awardDict[key], {
			we = key,
			win = checknumber(v.Win),
			items = items,
		})
		
	end
	for k,v in pairs(self.awardDict) do
		table.sort(v, function(a, b)
			return a.win < b.win 
		end)
	end
	-- 刷新花费列表
	self.costList = {}
	for k,v in pairs(GameConfig["TimesDiamond"]) do
		table.insert(self.costList, checknumber(v.TreeRefresh))
	end
	table.sort(self.costList, function(a, b)
		return a < b 
	end)
end 

function TreeData:resetData()
	self.heroBattleList = {} 	-- 已选择英雄列表
	self.heroCacheList = {} 	-- 待选择英雄列表

	self.refreshTimes = 0 	-- 刷新次数 
	self.useTimes = 0 		-- 使用次数
	self.winTimes = 0 		-- 胜利场次

	self.tree_we = "" -- tree_we的id
	self.battleData = ""
	self.oldHeroData = {}
	self.battling = false

end 

-- 历史最高层数
function TreeData:getOldWin()
	return self.oldWin
end 

function TreeData:setOldWin(value)
	self.oldWin = value	
end 

-- 总层数
function TreeData:getTotalWin()
	return self.totalWin
end 

function TreeData:setTotalWin(value)
	self.totalWin = value	
end 

function TreeData:addTotalWin(value)
	 self:setTotalWin(self.totalWin + value)
end 

-- 当前层数
function TreeData:getWinTimes()
	return self.winTimes
end 

function TreeData:setWinTimes(value)
	self.winTimes = value	
end 

function TreeData:addWinTimes(value)
	 self:setWinTimes(self.winTimes + value)

	 if self.oldWin < value then 
	 	self:setOldWin(value)
	 end 
end 

-- 最大胜利次数
function TreeData:getWinMax()
	return 20 
end 

function TreeData:isBattling()
	return self.battling
end

---------------
-- 已选择英雄列表  *（数据模型）
function TreeData:setBattleList(list)	
	self.heroBattleList = list
end

function TreeData:getBattleList()	
	return self.heroBattleList
end

function TreeData:addBattleHero(heroId)	
	if heroId and string.len(heroId) > 0 then
		local hero = self:createHero(heroId, self.tree_we)
		table.insert(self.heroBattleList, hero)

		return hero
	end
end

function TreeData:resetBattleHeroList()	
	self.heroBattleList = {}
end

------------------------
-- 待选择英雄列表  *（数据模型）
function TreeData:setHeroCacheList(list)	
	self.heroCacheList = list
end

function TreeData:addCacheHero(heroId)	
	if heroId and string.len(heroId) > 0 then 
		local hero = self:createHero(heroId, self.tree_we)
		table.insert(self.heroCacheList, hero)
	end 
end

function TreeData:getHeroCacheList()	
	return self.heroCacheList	
end

function TreeData:resetHeroCacheList()	
	self.heroCacheList = {}
end

------------------------
-- 剩余次数
function TreeData:getHaveTimes()	
	return self:getTimesMax() - self.useTimes
end

-- 次数上限
function TreeData:getTimesMax()	
	return VipData:getTreeResetMax()
end
------------------------
-- 奖励列表
function TreeData:getAwardList()
	return self.awardDict[self.tree_we] or {}
end

------------------------
-- 刷新花费
function TreeData:getRefreshCost()	
	local levelMax = #self.costList
	if self.refreshTimes < levelMax then 
		return self.costList[self.refreshTimes + 1]
	end 
	
	return self.costList[levelMax]
end

-- 设置刷新次数
function TreeData:setRefreshTimes(times)	
	self.refreshTimes = times
end

-- 增加刷新次数
function TreeData:addRefreshTimes(times)	
	self.refreshTimes = self.refreshTimes + times
end

-- 设置战斗保存数据
function TreeData:setBattleData(data)		
	self.battleData = data

	local bdata = json.decode(data or "") or {}
	self.oldHeroData = bdata.team or {}	
end

function TreeData:getBattleHero(heroId)
	return self.oldHeroData[heroId]
end 

----------------------------------
-- 创建一个机器人英雄
function TreeData:createHero(heroId, teamId)	
	local cfgR = GameConfig["TreeHero"][heroId] -- 人物加成 
	local cfgT = GameConfig["tree_we"][teamId] -- 战队加成

	local function getCfgValue(key)
		return checknumber(cfgR[key]) * checknumber(cfgT[key])
	end
	local keys = {
		"hp", "atk", "m_atk", "defense", "m_defense",
		"acp", "m_acp", "rate", "dodge", "crit",
		"blood", "breaks", "tumble",
	}
	local propertys = {}
	for i,v in ipairs(keys) do
		propertys[v] = getCfgValue(v)
	end


	local param = {
		roleId 	= heroId,
		starLv 	= checknumber(cfgT.star),
		level 	= checknumber(cfgT.lv),
		strongLv = checknumber(cfgT.pz),
		skillLvList = {
			checknumber(cfgT.skill1),
			checknumber(cfgT.skill2),
			checknumber(cfgT.skill3),
			checknumber(cfgT.skill4),
		},
		propertyScale = propertys,
	}
	
	local hero = CharacterModel.new(param)
	hero.battleImage = GameConfig.Hero[hero.roleId].HeroMorph
	return hero 
end

----------------------------------
function TreeData:isTreeOpen()
	return UserData:getUserLevel() >= OpenLvData.tree.openLv
end


return TreeData 
