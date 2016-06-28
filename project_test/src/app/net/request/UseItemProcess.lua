local UseItemProcess = class("UseItemProcess")

function UseItemProcess:ctor()
	--请求消息号
	self.order = 10050
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--heroid
	self.param1 =  ""
	--物品id
	self.param2 =  ""
	--物品数量
	self.param3 =  ""	
end


function UseItemProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		
	}
	return data
end

return UseItemProcess