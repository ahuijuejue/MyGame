

local ArenaScoreData = class("ArenaScoreData") 
local ArenaRewardData = import(".ArenaRewardData")

function ArenaScoreData:ctor()
	local cfg = GameConfig["ArenaScore"] 
	self.dict = {} 
	self.arr = {} 
	for k,v in pairs(cfg) do
		local rewardData = ArenaRewardData.new({id=k, cfg=v})
		self.dict[k] = rewardData 
		table.insert(self.arr, rewardData)
	end
	table.sort(self.arr, function(a, b)
		return a.score < b.score 
	end)
end 

--------------------------------------------
--------------------------------------------
-- 重置所有关卡数据 
function ArenaScoreData:resetAllDatas()
	for k,v in pairs(self.dict) do
		v.completed = false
	end
end 
--------------------------------------------
--------------------------------------------

-- 获取积分奖励数据
function ArenaScoreData:getReward(rewardId)
	return self.dict[rewardId] 
end 

-- 获取积分奖励数据队列
function ArenaScoreData:getScoreList() 
	return self.arr  
end 

function ArenaScoreData:isOk(rewardId) 
	local reward = self:getReward(rewardId) 
	local score = UserData.arenaScore 
	return score >= reward.score 
end


return ArenaScoreData 
