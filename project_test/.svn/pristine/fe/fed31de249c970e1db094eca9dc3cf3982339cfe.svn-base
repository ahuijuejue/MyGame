
local ArenaTeam = import(".ArenaTeam")
local ArenaData = class("ArenaData")
local scheduler = require("framework.scheduler")

function ArenaData:ctor() 
	self.rank 			= 0 		-- 排名 
	self.rankMax 		= 0 		-- 历史最高排名 
	self.coolTime 		= 0 		-- 冷却时间，到达的时间点
	self.battleNumMax 	= 5 		-- 最大 挑战次数
	self.times 			= 0 		-- 挑战剩余次数 
	self.refreshCost 	= 0 		-- 刷新冷却时间花费宝石 
	self.timesCost 		= 0 		-- 购买剩余挑战次数花费

	self.battle = 0 -- 自己的战斗力

	self.arenaList_ = {} 			-- 竞技场挑战列表

	self.schedule_ = nil 			-- 计算冷却时间 

	self.arenaInfo = {}
	for k,v in pairs(GameConfig["ArenaInfo"] or {}) do
		self.arenaInfo[k] = {
			id = k,
			name = v.Name or "",
			desc = v.Info or "",
		}
	end

end

-- 当前排名
function ArenaData:getRank()	
	return self.rank 
end 

function ArenaData:setRank(value)
	self.rank = value
end 

-------------------------
-- 挑战列表
function ArenaData:resetTeamList()
	self.arenaList_ = {}
	return self 
end 

function ArenaData:setTeamList(list)
	assert(type(list) == "table", "list should be table")
	self.arenaList_ = list

	return self 
end

function ArenaData:addTeam(team)
	table.insert(self.arenaList_, team)

	return self 
end

function ArenaData:sortTeamList()
	table.sort(self.arenaList_, function(a, b)
		return a.rank < b.rank 
	end)
end

function ArenaData:getTeamList()
	return self.arenaList_ 
end

----------------------------------------

--@return 解锁变身为数量，解锁下一变身位需要等级
function ArenaData:getSuperOpen(teamLevel) 
	local openLv
	local count = 0 
	local arenaOpen = OpenLvData.arenaPos.openLv 

	for i,v in ipairs(arenaOpen) do
		if v.level > teamLevel then 
			openLv = v.level 	
			break 
		else 
			count = i 
		end 		
	end 
	return count, openLv 
end
-----------------------------------------
-- 剩余挑战次数 
function ArenaData:haveBattleNum() 
	return self.times
end 

-- 增加剩余挑战次数 
function ArenaData:addBattleNum() 
	self.times = self.times + 1
end 

-- 减少剩余挑战次数 
function ArenaData:reduceBattleNum() 
	self.times = self.times - 1
end 

--------------------------------------
-- 刷新的 冷却时间  
function ArenaData:getCoolTime() 
	return self.coolTime 
end 

function ArenaData:setCoolTime(value) 
	self.coolTime = value 
	if value > 0 then 
		self:scheduleTime()
	end 
end 

function ArenaData:scheduleTime() 
	if not self.schedule_ then 
		self.schedule_ = scheduler.scheduleGlobal(handler(self,self.updateTime), 0.5)
	end 
end 

function ArenaData:unscheduleTime() 
	if self.schedule_ then 
		scheduler.unscheduleGlobal(self.schedule_)
		self.schedule_ = nil 
	end
end 

function ArenaData:updateTime(dt) 
	if self.coolTime <= 0 then 
		self:unscheduleTime() 
		self.coolTime = 0 
	else 
		self.coolTime = self.coolTime - dt 
	end 
end 

---------------------------------------
-- 自己的战斗力 
function ArenaData:getBattle()
	return self.battle
end 
---------------------------------------
---- 关于图片
function ArenaData:getDefaultBorder() 
	return "Mail_Circle.png"
end 

---------------------------------------
---- 关于积分 
-- 有没有领取的奖励
function ArenaData:haveAward() 
	local items = ArenaScoreData:getScoreList() 
	for i,v in ipairs(items) do
		if not v:isCompleted() and ArenaScoreData:isOk(v.id) then 
			return true 
		end 
	end
	return false 
end 
---------------------------------------

return ArenaData

