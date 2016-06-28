local GodOfFortuneResponse = class("GodOfFortuneResponse")

function GodOfFortuneResponse:ctor()
	--响应消息号
	self.order = 31007
	--返回结果,1:成功,-1:活动不在有效期，-2：次数耗尽，-3：钱不够
	self.result =  ""	
end

function GodOfFortuneResponse:GodOfFortuneResponse(data)
	if data.result == 1 then
		UserData:addDiamond(-GamblingModel.cost)
		UserData:addDiamond(data.param1)
		
		GamblingModel.bonus = data.param1
		GamblingModel.cost = data.param2
		GamblingModel.maxBonus = data.param3
		GamblingModel.times = GamblingModel.times + 1

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return GodOfFortuneResponse