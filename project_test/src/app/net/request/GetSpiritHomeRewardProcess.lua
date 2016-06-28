local GetSpiritHomeRewardProcess = class("GetSpiritHomeRewardProcess")

function GetSpiritHomeRewardProcess:ctor()
	--请求消息号
	self.order = 20010
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--存活的人数
	self.param1 =  ""
	--关卡的难度id
	self.param2 =  ""	
end


function GetSpiritHomeRewardProcess:serialization()
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

return GetSpiritHomeRewardProcess