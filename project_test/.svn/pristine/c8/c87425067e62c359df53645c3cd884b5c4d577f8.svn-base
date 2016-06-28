local RecieveChatMsgProcess = class("RecieveChatMsgProcess")

function RecieveChatMsgProcess:ctor()
	--响应消息号
	self.order = 11009
	--用户id
	self.userid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""	
end


function RecieveChatMsgProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		uuid = self.uuid,
		token = self.token,
		
	}
	return data
end

return RecieveChatMsgProcess