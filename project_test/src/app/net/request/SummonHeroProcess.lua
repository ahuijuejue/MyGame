local SummonHeroProcess = class("SummonHeroProcess")

function SummonHeroProcess:ctor()
	--请求消息号
	self.order = 10031
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--英雄id
	self.param1 =  ""	
end


function SummonHeroProcess:serialization()
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

return SummonHeroProcess