local RecieveChatMsgResponse = class("RecieveChatMsgResponse")
local ChatModel = import("app.data.ChatModel")

function RecieveChatMsgResponse:RecieveChatMsgResponse(data)
    if data.result == 1 then
        if data.param1 == "2" then
        	NoticeData:insertNotice(data.param6)
			showNotice()
		elseif data.param1 == "5" then
			GamblingModel:insertInfo(data.param6)
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
			return
        end

    	local chatModel = ChatModel.new({
				channelType = data.param1,
				sender = data.param7,
				name = data.param2 ,
				headIcon = data.param3 ,
				vipLevel = data.param4,
				msg = data.param6 ,
				sendTime = data.param5,
			})
    	ChatData:insertData(data.param1, chatModel)
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == 2 then
    	showToast({text = "禁言中"})
    end
end

function RecieveChatMsgResponse:ctor()
	--响应消息号
	self.order = 11009
	--返回结果,1 成功
	self.result =  ""
	--类型，2：系统公告、3：世界聊天、4：公会聊天
	self.param1 =  ""
	--消息信息：发送人teamid+战队昵称+头像+时间+消息内容
	self.param2 =  ""
end

return RecieveChatMsgResponse
