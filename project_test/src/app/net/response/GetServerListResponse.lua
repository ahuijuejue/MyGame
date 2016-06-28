local GetServerListResponse = class("GetServerListResponse")
function GetServerListResponse:GetServerListResponse(data)
	if data.result == 1 then
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end

end
function GetServerListResponse:ctor()
	--响应消息号
	self.order = 10013
	--返回结果,如果成功才会返回下面的参数：1 成功
	self.result =  ""
	--推荐服务器ID
	self.param1 =  ""
	--推荐服务器名称
	self.param2 =  ""
	--推荐服务器状态
	self.param3 =  ""
	--最近登录服务器ID
	self.param4 =  ""
	--最近登录服务器名称
	self.param5 =  ""
	--最近登录服务器状态
	self.param6 =  ""
	--服务器列表json字符串
	self.a_param1 =  ""
end

return GetServerListResponse