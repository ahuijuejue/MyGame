local BeginBattleProcess = class("BeginBattleProcess")

function BeginBattleProcess:ctor()
	--请求消息号
	self.order = 20003
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--关卡id
	self.param1 =  ""
	--上阵英雄
	self.param2 =  ""	
end


function BeginBattleProcess:serialization()
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

return BeginBattleProcess