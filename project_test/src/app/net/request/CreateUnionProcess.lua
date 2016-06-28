local CreateUnionProcess = class("CreateUnionProcess")

function CreateUnionProcess:ctor()
	--请求消息号
	self.order = 30004
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--公会名称
	self.param1 =  ""
	--公会图标
	self.param2 =  ""	
end


function CreateUnionProcess:serialization()
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

return CreateUnionProcess