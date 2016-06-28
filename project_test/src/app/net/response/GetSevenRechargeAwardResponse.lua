local GetSevenRechargeAwardResponse = class("GetSevenRechargeAwardResponse")

function GetSevenRechargeAwardResponse:ctor()
	--响应消息号
	self.order = 31004
	--返回结果,1:成功,-1:钱不够
	self.result =  ""
	--宝箱编号:(1,2,3,4,5)
	self.param1 =  ""
	--物品信息
	self.a_param1 =  ""	
end

function GetSevenRechargeAwardResponse:GetSevenRechargeAwardResponse(data)
	if data.result == 1 then
		PlayerData.addItem(data.a_param1)
		FeedbackModel.isFinish = 1
		FeedbackModel.items = data.a_param2 or {}
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return GetSevenRechargeAwardResponse