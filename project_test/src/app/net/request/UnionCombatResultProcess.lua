local UnionCombatResultProcess = class("UnionCombatResultProcess")

function UnionCombatResultProcess:ctor()
	--请求消息号
	self.order = 30103
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--挑战对手的userid
	self.param1 =  ""
	--战斗结果,1:胜利,0:失败
	self.param2 =  ""	
end


function UnionCombatResultProcess:serialization()
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

return UnionCombatResultProcess