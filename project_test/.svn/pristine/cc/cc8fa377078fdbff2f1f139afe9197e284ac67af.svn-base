local SendUnionMailProcess = class("SendUnionMailProcess")

function SendUnionMailProcess:ctor()
	--请求消息号
	self.order = 30020
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--邮件内容
	self.param1 =  ""	
end


function SendUnionMailProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		
	}
	return data
end

return SendUnionMailProcess