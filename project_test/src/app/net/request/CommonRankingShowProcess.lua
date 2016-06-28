local CommonRankingShowProcess = class("CommonRankingShowProcess")

function CommonRankingShowProcess:ctor()
	--请求消息号
	self.order = 20033
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--排行榜类型：2：艾恩排行榜，3：战力排行榜，4：战队等级，5：关卡得星
	self.param1 =  ""	
end


function CommonRankingShowProcess:serialization()
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

return CommonRankingShowProcess