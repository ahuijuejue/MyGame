local GetSevenRechargeAwardProcess = class("GetSevenRechargeAwardProcess")

function GetSevenRechargeAwardProcess:ctor()
	--请求消息号
	self.order = 31004
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--宝箱编号:(1,2,3,4,5)
	self.param1 =  ""	
end


function GetSevenRechargeAwardProcess:serialization()
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

return GetSevenRechargeAwardProcess