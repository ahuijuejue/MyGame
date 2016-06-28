local TenGoldChoukaResponse = class("TenGoldChoukaResponse")

function TenGoldChoukaResponse:ctor()
	--响应消息号
	self.order = 10034
	--返回结果,1 成功;-1 金币不足
	self.result =  ""
	--抽到的物品id，多个以逗号分开
	self.param1 =  ""
end

function TenGoldChoukaResponse:TenGoldChoukaResponse(data)
	if data.result == 1 then
		SummonData.summonType = SUMMON_TYPE.CASH_SUMMON_TEN
    	SummonData:updateResultData(data.a_param1)

		TaskData:addTaskParams("card", 10)
		ActivityUtil.addParams("golgCoinTimes", 10) -- 黄金推币%s次
		
		UserData:addCardValue(SummonData.cashScoreEx)
		UserData:addGold(-SummonData.cashPriceEx)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return TenGoldChoukaResponse