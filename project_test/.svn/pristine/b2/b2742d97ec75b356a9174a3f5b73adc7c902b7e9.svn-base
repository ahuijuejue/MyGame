local FinishTaskProcess = class("FinishTaskProcess")

function FinishTaskProcess:ctor()
	--请求消息号
	self.order = 10039
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--任务id
	self.param1 =  ""	
end


function FinishTaskProcess:serialization()
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

return FinishTaskProcess