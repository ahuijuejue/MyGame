local SendChatMsgProcess = class("SendChatMsgProcess")

function SendChatMsgProcess:ctor()
	--请求消息号
	self.order = 20036
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--聊天类型，类型，1：系统公告、2：世界聊天、3：公会聊天
	self.param1 =  ""
	--聊天内容
	self.param2 =  ""	
end


function SendChatMsgProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		
	}
	return data
end

return SendChatMsgProcess