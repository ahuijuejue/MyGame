local ExchangeArenaScoreProcess = class("ExchangeArenaScoreProcess")

function ExchangeArenaScoreProcess:ctor()
	--请求消息号
	self.order = 10055
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--要领取的积分奖励的积分
	self.param1 =  ""	
end


function ExchangeArenaScoreProcess:serialization()
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

return ExchangeArenaScoreProcess