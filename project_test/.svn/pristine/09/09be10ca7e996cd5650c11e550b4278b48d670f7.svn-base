local OneDiamondChoukaReponse = class("OneDiamondChoukaReponse")

function OneDiamondChoukaReponse:ctor()
	--响应消息号
	self.order = 10035
	--返回结果,1 成功;-1 cd中；-2 金币不足
	self.result =  ""
	--抽到的物品id
	self.param1 =  ""
end

function OneDiamondChoukaReponse:OneDiamondChoukaReponse(data)
	if data.result == 1 then
		if not GuideData:isCompleted("FirstCard") then
        	NetHandler.gameRequest("NewComerGuide",{param1 = "FirstCard"})
        end

		SummonData.summonType = SUMMON_TYPE.DIAMOND_SUMMON
		SummonData.diamondBonus = SummonData.diamondBonus - 1
		if SummonData.diamondBonus == 0 then
            SummonData.diamondBonus = 10
        end
		SummonData:updateResultData(data.a_param1)
		local diamondLeftTime = SummonData.nextDiamondStamp - UserData.curServerTime
		if diamondLeftTime <= 0 then
			SummonData.nextDiamondStamp = UserData.curServerTime + SummonData.freeDiamondTime
		else
	    	UserData:addDiamond(-SummonData.diamondPrice)
		end

		TaskData:addTaskParams("card", 1)
		ActivityUtil.addParams("diamondCoinTimes", 1) -- 钻石推币%s次

		UserData:addCardValue(SummonData.diamondScore)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return OneDiamondChoukaReponse