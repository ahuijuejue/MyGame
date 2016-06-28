local EveryDaySignResponse = class("EveryDaySignResponse")
function EveryDaySignResponse:EveryDaySignResponse(data)
	if data.result == 1 then

		local items = data.a_param1 -- 获得物品
		local info = data.param1 	-- 签到信息

		if data.param2 == 1 then     -- 每日签到
			SignInData.totalSignIn 		= checknumber(info.signTotal) 	 -- 总的签到次数
			SignInData.latestId 		= tostring(info.signId) 		 -- 最近的签到id
			SignInData.latestDate 		= checknumber(info.lastSignDay)  -- 最后一次签到的时间
			SignInData.signVip 			= checknumber(info.vipSign) == 1 -- 是否进行了vip签到
			SignInData.latestReward 	= tostring(info.lastreward) 	 -- 最后一次领取的累积奖励id
		elseif data.param2 == 2 then -- 至尊签到
			SignInData.totalSignIn 		= checknumber(info.signTotal) 	  -- 总的签到次数
			SignInData.latestReward 	= tostring(info.lastreward) 	  -- 最后一次领取的累积奖励id
			SignInData.viplatestId      = tostring(info.lastRechargeSign) -- 最近的签到id
		    SignInData.vipIsReward      = info.canGetReward               -- 是否可以领取礼包 0充值 1领取 2领过
		end

		-- 增加奖励物品
		UserData:rewardItems(items)
		local showItems = UserData:parseItems(items)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

		return {items=showItems}

	elseif data.result == -1 then 	-- 已签到
		showToast({text="已签到"})
	elseif data.result == -2 then 	-- 签到已过期
		showToast({text="签到已过期"})
	end

end
function EveryDaySignResponse:ctor()
	--响应消息号
	self.order = 10041
	--返回结果,1 成功; -2 签到已过期；-1 已签到
	self.result =  ""
	--抽到的物品
	self.a_param1 =  ""
end

return EveryDaySignResponse
