local SaveAincradBattleResultProcess = class("SaveAincradBattleResultProcess")

function SaveAincradBattleResultProcess:ctor()
	--请求消息号
	self.order = 20019
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--胜负：1 胜，0 负
	self.param1 =  ""
	--战场信息
	self.param2 =  ""
	--通关星数
	self.param3 = ""	
end

function SaveAincradBattleResultProcess:serialization()
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

return SaveAincradBattleResultProcess