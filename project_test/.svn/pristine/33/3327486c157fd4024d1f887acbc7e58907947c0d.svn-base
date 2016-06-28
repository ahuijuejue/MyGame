local GetNDayEndRewardResponse = class("GetNDayEndRewardResponse")
function GetNDayEndRewardResponse:GetNDayEndRewardResponse(data)
	if data.result == 1 then 
		ActivityOpenData.received = true

		local items = data.a_param1 	-- 奖励的物品

		-- 增加奖励物品
		UserData:rewardItems(items) 

		local showItems = UserData:parseItems(items)
		return {items=showItems}

	elseif data.result == -10 then 
		showToast({text="完成条件不足", time=3})
	end 

end
function GetNDayEndRewardResponse:ctor()
	--响应消息号
	self.order = 30002
	--返回结果,1 成功; -1 任务完成条件不足
	self.result =  ""
	--奖励 的物品id
	self.a_param1 =  ""	
end

return GetNDayEndRewardResponse