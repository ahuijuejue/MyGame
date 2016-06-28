local ExchangeArenaScoreResponse = class("ExchangeArenaScoreResponse")
function ExchangeArenaScoreResponse:ExchangeArenaScoreResponse(data)
	if data.result == 1 then 
		local rewardId = tostring(data.param1) 	-- 竞技场积分奖励id
		local items = data.a_param1 			-- 奖励的物品


		local reward = ArenaScoreData:getReward(rewardId) 
		if reward then 
			reward.completed = true 
		end 

		-- 增加奖励物品
		UserData:rewardItems(items) 
		local showItems = UserData:parseItems(items) 
		return {items=showItems}

	elseif data.result == -1 then 
		showToast({text="积分不足"})
	elseif data.result == -2 then 
		showToast({text="已经兑换过"})
	end 

end
function ExchangeArenaScoreResponse:ctor()
	--响应消息号
	self.order = 10055
	--返回结果,1 成功;-1 积分不足
	self.result =  ""
	--抽到的物品
	self.a_param1 =  ""	
end

return ExchangeArenaScoreResponse