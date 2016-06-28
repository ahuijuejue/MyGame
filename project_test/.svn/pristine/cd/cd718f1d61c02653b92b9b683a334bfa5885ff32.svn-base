local TeamRechargeProcess = class("TeamRechargeProcess")

function TeamRechargeProcess:ctor()
	--请求消息号
	self.order = 50000
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--订单ID
	self.param1 =  ""
	--服务器生成的订单号
	self.param2 =  ""	
end


function TeamRechargeProcess:serialization()
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

return TeamRechargeProcess