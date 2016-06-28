--[[
战力活动数据
]]

local SwordActivityData = class("SwordActivityData")

function SwordActivityData:ctor()
	
	self.rankList = self:initRankingAwardConfig()
	self.swordList = self:initBattleAwardConfig()

	self.activityInfo = self:initInfoConfig()
	self:parseInfo()
end

-- 排名奖励
function SwordActivityData:initRankingAwardConfig()
	local cfg = GameConfig["ForceRankAward"]

	local list = {}
	for k,v in pairs(cfg) do
		local items = {}
		for i2,v2 in ipairs(v.AwardItemID or {}) do
			table.insert(items, {
				itemId = v2,
				count = checknumber(v.ItemNumber[i2])
			})
		end
		table.insert(list, {			
			rank = checknumber(v.RankRange), -- 排名
			items = items, -- 奖励
		})
	end

	table.sort(list, function(a, b)
		return a.rank < b.rank
	end)

	return list 
end

-- 战斗力奖励
function SwordActivityData:initBattleAwardConfig()
	local cfg = GameConfig["ForceRankAward2"]

	local list = {}
	for k,v in pairs(cfg) do
		local items = {}
		for i2,v2 in ipairs(v.AwardItemID or {}) do
			table.insert(items, {
				itemId = v2,
				count = checknumber(v.ItemNumber[i2])
			})
		end
		table.insert(list, {
			sort = checknumber(k),
			battle = checknumber(v.ForceMin), -- 战斗力
			items = items, -- 奖励
		})
		-- print("force", v.ForceMin)
	end

	table.sort(list, function(a, b)
		return a.sort < b.sort
	end)

	return list 
end

-- 介绍
function SwordActivityData:initInfoConfig()
	local cfg = GameConfig["ForceRankInfo"]["1"]
	local list = {
		desc = cfg.HeroInfo,
		icon = cfg.CardImage,
		rule = cfg.ForceRule,
		startDay = checknumber(cfg.StartDay), 		-- 开始天
		endDay = checknumber(cfg.EndDay), 			-- 结束天
		accountDay = checknumber(cfg.AccountDay), 	-- 结算天
		accountTime = cfg.AccountTime, 	-- 结算时间
		accountSword = checknumber(cfg.AccountForce), -- 结算需战力下限
		noti1 = cfg.ForceNotice, -- 提示
		noti2 = cfg.ForceNotice2,
	}

	return list 
end 

-- 解析 介绍 数据
function SwordActivityData:parseInfo()
	-- dump(self.activityInfo)
	self.startSec = self.activityInfo.startDay * 86400 + 5 * 3600		-- 开时间点（秒）
	self.endSec = self.activityInfo.endDay * 86400 + 5 * 3600 			-- 结束时间点（秒）
	self.accountSec = self.activityInfo.accountDay * 86400				-- 结算时间点（秒）
	local date = string.time(self.activityInfo.accountTime)
	self.accountSec = self.accountSec + convertDateToSec(date) 		

end 

-- 获取排名奖励
function SwordActivityData:getRankingAwardList()
	return self.rankList
end 

-- 获取战力奖励
function SwordActivityData:getSwordAwardList()
	return self.swordList
end 

-- 获取活动信息
function SwordActivityData:getInfo()
	return self.activityInfo
end 

-- 是否在开启时间
function SwordActivityData:isOpenning()
	if UserData.powerEventEndTime == 0 then
		return false
	end
	return true
end 

-- 剩余时间（秒）
function SwordActivityData:getHaveSecond()
	return UserData.powerEventEndTime - UserData.curServerTime
end 

-- 剩余时间（日期类型）
function SwordActivityData:getHaveDate()
	local sec = self:getHaveSecond()
	return convertSecToDate(sec)
end 

-- 服务器开启时刻（秒）
function SwordActivityData:getStartSecond()
	return self.startSec + UserData:getServerOpenSecond()
end 

-- 服务器结束时刻（秒）
function SwordActivityData:getEndSecond()
	return self.endSec + UserData:getServerOpenSecond()
end 

-- 提示
function SwordActivityData:getNotiString(index)
	index = index or 1
	if index == 1 then 
		return self.activityInfo.noti1 or ""
	elseif index == 2 then 
		return self.activityInfo.noti2 or ""
	end 

	return ""
end 


return SwordActivityData
