local BuyJingjiTimesProcess = class("BuyJingjiTimesProcess")

function BuyJingjiTimesProcess:ctor()
	--请求消息号
	self.order = 10057
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""	
end


function BuyJingjiTimesProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		
	}
	return data
end

return BuyJingjiTimesProcess