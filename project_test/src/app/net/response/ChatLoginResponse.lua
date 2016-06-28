local ChatLoginResponse = class("ChatLoginResponse")
function ChatLoginResponse:ChatLoginResponse(data)


end
function ChatLoginResponse:ctor()
	--响应消息号
	self.order = 11006
	--返回结果,1 成功
	self.result =  ""	
end

return ChatLoginResponse