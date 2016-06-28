local SaveTreeWorldGuankaProcess = class("SaveTreeWorldGuankaProcess")

function SaveTreeWorldGuankaProcess:ctor()
	--请求消息号
	self.order = 20025
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--战斗中的数据
	self.param1 =  ""	
end


function SaveTreeWorldGuankaProcess:serialization()
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

return SaveTreeWorldGuankaProcess