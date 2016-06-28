local GenerateOrderIdResponse = class("GenerateOrderIdResponse")

function GenerateOrderIdResponse:GenerateOrderIdResponse(data)
	NetHandler.gameRequest("TeamRecharge",{param1 = data.param1, param2 = data.param2})
end

function GenerateOrderIdResponse:ctor()
	--响应消息号
	self.order = 20030
	--返回结果,1 成功
	self.result =  ""
	--系统生成的订单号
	self.param1 =  ""
end

return GenerateOrderIdResponse