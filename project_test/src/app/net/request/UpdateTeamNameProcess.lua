local UpdateTeamNameProcess = class("UpdateTeamNameProcess")

function UpdateTeamNameProcess:ctor()
	--请求消息号
	self.order = 10065
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--类型： 1 起名，2 更新名字
	self.param1 =  ""
	--名字
	self.param2 =  ""
	--新手引导字段
	self.param100 =  ""	
end


function UpdateTeamNameProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param100 = self.param100,
		
	}
	return data
end

return UpdateTeamNameProcess