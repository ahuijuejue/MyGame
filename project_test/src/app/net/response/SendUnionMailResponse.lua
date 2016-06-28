local SendUnionMailResponse = class("SendUnionMailResponse")
function SendUnionMailResponse:SendUnionMailResponse(data)
    if data.result == 1 then
    	UnionListData.mailCounts = UnionListData.mailCounts + 1
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function SendUnionMailResponse:ctor()
	--响应消息号
	self.order = 30020
	--返回结果,1:成功,2:内容超长，-1：不是会长
	self.result =  ""
	--邮件内容
	self.param1 =  ""
end

return SendUnionMailResponse
