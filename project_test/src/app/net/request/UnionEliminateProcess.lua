local UnionEliminateProcess = class("UnionEliminateProcess")

function UnionEliminateProcess:ctor()
	--请求消息号
	self.order = 30013
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--被踢出人的userid
	self.param1 =  ""	
end


function UnionEliminateProcess:serialization()
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

return UnionEliminateProcess