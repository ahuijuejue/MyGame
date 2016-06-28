local BuyBattleTimesProcess = class("BuyBattleTimesProcess")

function BuyBattleTimesProcess:ctor()
	--请求消息号
	self.order = 20006
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
end


function BuyBattleTimesProcess:serialization()
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

return BuyBattleTimesProcess