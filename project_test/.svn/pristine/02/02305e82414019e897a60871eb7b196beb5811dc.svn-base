local UpdateTeamSrcProcess = class("UpdateTeamSrcProcess")

function UpdateTeamSrcProcess:ctor()
	--请求消息号
	self.order = 10066
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--图片名
	self.param1 =  ""	
end


function UpdateTeamSrcProcess:serialization()
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

return UpdateTeamSrcProcess