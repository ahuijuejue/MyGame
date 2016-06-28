local ChatHeartResponse = class("ChatHeartResponse")

function ChatHeartResponse:ctor()
	--响应消息号
	self.order = 11005
	--返回结果,1 成功
	self.result =  ""	
end

function ChatHeartResponse:ChatHeartResponse(data)
	if data.result == 1 then
		ChatManage.isSending = false
	end
end

return ChatHeartResponse