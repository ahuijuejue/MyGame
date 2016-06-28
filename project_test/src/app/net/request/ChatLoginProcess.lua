local ChatLoginProcess = class("ChatLoginProcess")

function ChatLoginProcess:ctor()
	--响应消息号
	self.order = 11006
	--用户id
	self.userid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""	
end


function ChatLoginProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		uuid = self.uuid,
		token = self.token,
		
	}
	return data
end

return ChatLoginProcess