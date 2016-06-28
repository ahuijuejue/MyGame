local GetShanDuoLaRewardProcess = class("GetShanDuoLaRewardProcess")

function GetShanDuoLaRewardProcess:ctor()
	--请求消息号
	self.order = 20009
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--碎的钟的id,多人以逗号分开
	self.param1 =  ""
	--挑战的波id
	self.param2 =  ""
	--挑战的敌人类型
	self.param3 =  ""	
end


function GetShanDuoLaRewardProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		
	}
	return data
end

return GetShanDuoLaRewardProcess