local SecretChoukaResponse = class("SecretChoukaResponse")
function SecretChoukaResponse:SecretChoukaResponse(data)
	if data.result == 1 then
		SummonData.summonType = SUMMON_TYPE.SECRET_SUMMOM
		SummonData:updateResultData(data.a_param1)
    	UserData:addDiamond(-SummonData.secretPrice)
        for k,v in pairs(data.a_param1) do
        	if tostring(data.a_param1[k].param1) == "1" then
				UserData:addGold(data.a_param1[k].param3)
        	elseif tostring(data.a_param1[k].param1) == "2" then
				UserData:addDiamond(data.a_param1[k].param3)
        	elseif tostring(data.a_param1[k].param1) == "3" then
				UserData:addPower(data.a_param1[k].param3)
    		elseif tostring(data.a_param1[k].param1) == "4" then
				UserData:addSoul(data.a_param1[k].param3)
        	elseif tostring(data.a_param1[k].param1) == "5" then
				UserData:addArenaValue(data.a_param1[k].param3)
    		elseif tostring(data.a_param1[k].param1) == "6" then
				UserData:addExp(data.a_param1[k].param3)
        	elseif tostring(data.a_param1[k].param1) == "7" then
				UserData:addTreeValue(data.a_param1[k].param3)
    		elseif tostring(data.a_param1[k].param1) == "8" then
				UserData:addCityValue(data.a_param1[k].param3)
        	elseif tostring(data.a_param1[k].param1) == "9" then
				UserData:addCardValue(data.a_param1[k].param3)
        	end
        end
		TaskData:addTaskParams("card", 1)
		ActivityUtil.addParams("mysticalDivination", 1)

		UserData:addCardValue(SummonData.secretScore)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function SecretChoukaResponse:ctor()
	--响应消息号
	self.order = 20032
	--返回结果,1 成功;-1  钻石不足    -2 没有抽到物品
	self.result =  ""
	--抽到的物品
	self.a_param1 =  ""
end

return SecretChoukaResponse