local TeamRechargeResponse = class("TeamRechargeResponse")
function TeamRechargeResponse:TeamRechargeResponse(data)
end
function TeamRechargeResponse:ctor()
	--响应消息号
	self.order = 50000
	--返回结果,如果成功才会返回下面的参数：1 成功，
	self.result =  ""
	--订单ID
	self.param1 =  ""
	--服务器生成的订单号
	self.param2 =  ""
end

return TeamRechargeResponse