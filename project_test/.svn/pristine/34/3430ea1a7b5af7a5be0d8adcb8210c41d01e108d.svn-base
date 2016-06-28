local GenerateOrderIdProcess = class("GenerateOrderIdProcess")

function GenerateOrderIdProcess:ctor()
	--请求消息号
	self.order = 20030
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--订单ID
	self.param1 =  ""
end


function GenerateOrderIdProcess:serialization()
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

return GenerateOrderIdProcess