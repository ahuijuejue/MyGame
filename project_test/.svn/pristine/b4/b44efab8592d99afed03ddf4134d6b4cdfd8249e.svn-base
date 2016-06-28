local TenDiamondChoukaResponse = class("TenDiamondChoukaResponse")

function TenDiamondChoukaResponse:ctor()
	--响应消息号
	self.order = 10036
	--返回结果,1 成功;-1 金币不足
	self.result =  ""
	--抽到的物品id，多个以逗号分开
	self.param1 =  ""
end

function TenDiamondChoukaResponse:TenDiamondChoukaResponse(data)
	if data.result == 1 then
    	SummonData.summonType = SUMMON_TYPE.DIAMOND_SUMMON_TEN
		SummonData:updateResultData(data.a_param1)
		TaskData:addTaskParams("card", 10)
		ActivityUtil.addParams("diamondCoinTimes", 10) -- 钻石推币%s次

   		UserData:addDiamond(-SummonData.diamondPriceEx)
   		
    	--更新用户抽卡积分
    	UserData:addCardValue(SummonData.diamondScoreEx)

   		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return TenDiamondChoukaResponse