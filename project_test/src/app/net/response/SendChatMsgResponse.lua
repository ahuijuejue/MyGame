local SendChatMsgResponse = class("SendChatMsgResponse")
function SendChatMsgResponse:SendChatMsgResponse(data)
    if data.result == 1 then
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function SendChatMsgResponse:ctor()
	--响应消息号
	self.order = 20036
	--返回结果,-1:异常，等级不足，1 ：成功，2:禁言
	self.result =  ""
	--聊天类型，类型，1：系统公告、2：世界聊天、3：公会聊天
	self.param1 =  ""
	--聊天内容
	self.param2 =  ""
	--禁言解除剩余时间（秒），null代表正常，没有禁言，-1代表永久禁言，需要通过用户中心手动解除，其他标识禁言解除剩余时间
	self.param3 =  ""
end

return SendChatMsgResponse