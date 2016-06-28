local FinishActivityProcess = class("FinishActivityProcess")

function FinishActivityProcess:ctor()
	--请求消息号
	self.order = 30001
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--活动id
	self.param1 =  ""
	--null
	self.param100 =  ""	
end


function FinishActivityProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param100 = self.param100,
		
	}
	return data
end

return FinishActivityProcess