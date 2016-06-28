--[[
日月追缉 数据
]]

local ArenaLookingForData = class("ArenaLookingForData")

function ArenaLookingForData:ctor()
	
	self.okTimes = 0 	-- 追缉成功总数

	self.haveTimes = 0 	-- 使用了次数
	self.maxTimes = 0 	-- 最大次数

	self.recoverTime 	= 0 -- 开始倒计时时间
	self.everyTime 		= 0 -- 每次的恢复时间
	self.countdown 		= 0 -- 恢复倒计时

	self.buyTimes 		= 0 -- 购买了的次数

	self.enermyTeam 	= nil -- 被挑战者

	self:initConfigData()
end

function ArenaLookingForData:initConfigData()
	local cfg = GameConfig["WantedInfo"]["1"]

	self.everyTime = checknumber(cfg.TimesCD)
	self.maxTimes = checknumber(cfg.TimesLimit)
end

-- 最大次数
function ArenaLookingForData:timesMax()
	return self.maxTimes
end 

-- 剩余次数
function ArenaLookingForData:getHaveTimes()
	return self.haveTimes
end 

function ArenaLookingForData:setHaveTimes(value)
	self.haveTimes = value
end 

function ArenaLookingForData:addHaveTimes(value)
	self:setHaveTimes(self.haveTimes+value)
end 

-- 购买了的次数
function ArenaLookingForData:getBuyTimes()
	return self.buyTimes 
end 

function ArenaLookingForData:setBuyTimes(value)
	self.buyTimes = value
end 

function ArenaLookingForData:addBuyTimes(value)
	self:setBuyTimes(self.buyTimes + value)
end 

-- 购买次数花费
function ArenaLookingForData:getCostForBuyTimes()
	return CostDiamondData:getWanted(self:getBuyTimes() + 1)
end 

-- 被挑战者
function ArenaLookingForData:getEnermyTeam()
	-- return ArenaTeam:new({})
	return self.enermyTeam
end 

function ArenaLookingForData:setEnermyTeam(team)
	self.enermyTeam = team
end 

function ArenaLookingForData:updateTimesData()
	if self:getHaveTimes() >= self:timesMax() then 
		self.recoverTime = UserData:getServerSecond()
		self.countdown = 0
		return 
	end 

	local offsec = UserData:getServerSecond() - self.recoverTime -- 经过秒数 
	local nTimes = math.floor(offsec / self.everyTime) -- 增加次数

	if self:getHaveTimes() + nTimes >= self:timesMax() then 
		self.recoverTime = UserData:getServerSecond()
		self:setHaveTimes(self:timesMax())		
		self.countdown = 0
	else 
		local rtime = nTimes * self.everyTime -- 恢复点数时间
		self.recoverTime = self.recoverTime + rtime 
		self:setHaveTimes(self.haveTimes + nTimes)
		self.countdown = math.floor(self.everyTime - offsec + rtime)
	end 
end 

return ArenaLookingForData
