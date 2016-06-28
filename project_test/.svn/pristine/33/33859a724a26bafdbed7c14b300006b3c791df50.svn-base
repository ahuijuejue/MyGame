local OpenCardActProcess = class("OpenCardActProcess")

function OpenCardActProcess:ctor()
	--请求消息号
	self.order = 31003
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--卡牌位置
	self.param1 =  ""	
end


function OpenCardActProcess:serialization()
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

return OpenCardActProcess