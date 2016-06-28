local ChatHeartProcess = class("ChatHeartProcess")

function ChatHeartProcess:ctor()
	--响应消息号
	self.order = 11005
	--用户id
	self.userid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""	
end


function ChatHeartProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		uuid = self.uuid,
		token = self.token,
		
	}
	return data
end

return ChatHeartProcess