local FirstRechargeProcess = class("FirstRechargeProcess")

function FirstRechargeProcess:ctor()
	--请求消息号
	self.order = 20034
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--1:首冲奖励，2:首冲10元奖励
	self.param1 =  ""	
end


function FirstRechargeProcess:serialization()
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

return FirstRechargeProcess