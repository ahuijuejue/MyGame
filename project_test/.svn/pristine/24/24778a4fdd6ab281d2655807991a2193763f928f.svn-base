local NewComerGuideProcess = class("NewComerGuideProcess")

function NewComerGuideProcess:ctor()
	--请求消息号
	self.order = 10064
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--当前达到的新手引导的字段
	self.param1 =  ""	
end


function NewComerGuideProcess:serialization()
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

return NewComerGuideProcess