local ApplyUnionProcess = class("ApplyUnionProcess")

function ApplyUnionProcess:ctor()
	--请求消息号
	self.order = 30008
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--公会Id
	self.param1 =  ""	
end


function ApplyUnionProcess:serialization()
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

return ApplyUnionProcess