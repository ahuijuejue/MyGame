local GetTotalSignRewardResponse = class("GetTotalSignRewardResponse")
function GetTotalSignRewardResponse:GetTotalSignRewardResponse(data)
	if data.result == 1 then
		local totalId = tostring(data.param1) -- 累计签到id
		local items = data.a_param1 -- 获得物品

		-- SignInData.totalSignIn = SignInData.totalSignIn + 1
		SignInData.latestReward = totalId

		-- 增加奖励物品
		UserData:rewardItems(items)

		local showItems = UserData:parseItems(items)

		return {items=showItems}

	elseif data.result == -1 then
		showToast({text="条件不足"})
	end

end
function GetTotalSignRewardResponse:ctor()
	--响应消息号
	self.order = 10042
	--返回结果,1 成功; -1 条件不足
	self.result =  ""
end

return GetTotalSignRewardResponse