local FreshOpenCardResponse = class("FreshOpenCardResponse")

function FreshOpenCardResponse:ctor()
	--响应消息号
	self.order = 31006
	--返回结果,1:成功,-1:钱不够
	self.result =  ""	
end

function FreshOpenCardResponse:FreshOpenCardResponse(data)
	dump(data)
	if data.result == 1 then
		FlopModel.getItems = {}
		FlopModel.poses = {}
		UserData:addDiamond(-FlopModel.freshCost)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return FreshOpenCardResponse