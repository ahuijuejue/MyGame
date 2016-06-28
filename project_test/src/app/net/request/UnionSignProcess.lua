local UnionSignProcess = class("UnionSignProcess")

function UnionSignProcess:ctor()
	--请求消息号
	self.order = 30010
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--礼拜类型
	self.param1 =  ""	
end


function UnionSignProcess:serialization()
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

return UnionSignProcess