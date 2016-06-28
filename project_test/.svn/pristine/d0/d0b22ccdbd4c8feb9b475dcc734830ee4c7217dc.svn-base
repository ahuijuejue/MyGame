local AppointUnionProcess = class("AppointUnionProcess")

function AppointUnionProcess:ctor()
	--请求消息号
	self.order = 30016
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--被任命成员的userid
	self.param1 =  ""
	--职位，1:会长，2:副会长，3:管理员
	self.param2 =  ""	
end


function AppointUnionProcess:serialization()
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

return AppointUnionProcess