local OneGoldChoukaResponse = class("OneGoldChoukaResponse")

function OneGoldChoukaResponse:ctor()
	--响应消息号
	self.order = 10033
	--返回结果,1 成功;-1 cd中；-2 金币不足
	self.result =  ""
	--抽到的物品id
	self.param1 =  ""
end

function OneGoldChoukaResponse:OneGoldChoukaResponse(data)
	if data.result == 1 then
		SummonData.summonType = SUMMON_TYPE.CASH_SUMMON
    	SummonData.cashBonus = SummonData.cashBonus - 1
        if SummonData.cashBonus == 0 then
            SummonData.cashBonus = 10
        end
    	SummonData:updateResultData(data.a_param1)
        local cashLeftTime = SummonData.nextCashTimeStamp - UserData.curServerTime
    	if SummonData.freeCashTimes > 0 and cashLeftTime <= 0 then
    		SummonData.freeCashTimes = SummonData.freeCashTimes - 1
            SummonData.nextCashTimeStamp = UserData.curServerTime + SummonData.freeCashTime
    	else
            UserData:addGold(-SummonData.cashPrice)
    	end
        TaskData:addTaskParams("card", 1)
        ActivityUtil.addParams("golgCoinTimes", 1) -- 黄金推币%s次
    	--更新抽卡积分
        UserData:addCardValue(SummonData.cashScore)

        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return OneGoldChoukaResponse