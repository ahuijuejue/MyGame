local JuexingRongHeBaoshiProcess = class("JuexingRongHeBaoshiProcess")

function JuexingRongHeBaoshiProcess:ctor()
	--请求消息号
	self.order = 10020
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
	--融合的宝石位置，从1开始计算
	self.param2 =  ""	
end


function JuexingRongHeBaoshiProcess:serialization()
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

return JuexingRongHeBaoshiProcess