local FinishGeneralActivityProcess = class("FinishGeneralActivityProcess")

function FinishGeneralActivityProcess:ctor()
	--请求消息号
	self.order = 30003
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--活动ID
	self.param1 =  ""	
end


function FinishGeneralActivityProcess:serialization()
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

return FinishGeneralActivityProcess