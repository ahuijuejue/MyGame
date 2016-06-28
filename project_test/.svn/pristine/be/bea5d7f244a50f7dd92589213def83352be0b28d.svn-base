local ShowUnionLogResponse = class("ShowUnionLogResponse")
function ShowUnionLogResponse:ShowUnionLogResponse(data)
    if data.result == 1 then
    	UnionListData:reloadLogMsg(data.a_param1)
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function ShowUnionLogResponse:ctor()
	--响应消息号
	self.order = 30017
	--返回结果,1:成功
	self.result =  ""
end

return ShowUnionLogResponse
