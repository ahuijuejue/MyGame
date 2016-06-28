local EveryDaySignProcess = class("EveryDaySignProcess")

function EveryDaySignProcess:ctor()
	--请求消息号
	self.order = 10041
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--请求签到的id
	self.param1 =  ""
	--1:普通签到 2：至尊签到
	self.param2 =  ""	
end


function EveryDaySignProcess:serialization()
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

return EveryDaySignProcess