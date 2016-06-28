local OpenCardActResponse = class("OpenCardActResponse")

function OpenCardActResponse:ctor()
	--响应消息号
	self.order = 31003
	--返回结果,1:成功,-1:没有翻卡机会
	self.result =  ""
	--物品信息
	self.a_param1 =  ""	
end

function OpenCardActResponse:OpenCardActResponse(data)
	dump(data)
	if data.result == 1 then
		PlayerData.addItem(data.a_param1)
		local poses = {}
		if data.param1 ~= -1 then
			poses = string.split(data.param1,",")
		else
			poses = FlopModel:getLeftPos()
			FlopModel:setLeftPos(poses)
		end
		for i,v in ipairs(data.a_param1) do
			FlopModel:insertPos(poses[i])
			FlopModel:insertGetItem(poses[i],data.a_param1[i])
			FlopModel:setUseTimes(FlopModel.useTimes+1)
		end
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return OpenCardActResponse