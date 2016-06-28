local SystemNoticeResponse = class("SystemNoticeResponse")

function SystemNoticeResponse:ctor()
	--响应消息号
	self.order = 11001
	--返回结果,1 成功;
	self.result =  ""
	--公告标题
	self.param1 =  ""
	--公告内容
	self.param2 =  ""
	--发送者
	self.param3 =  ""	
end

function SystemNoticeResponse:SystemNoticeResponse(data)
	if data.result == 1 then
		NoticeData = data
	end
end

return SystemNoticeResponse