local UseYaoShuiProcess = class("UseYaoShuiProcess")

function UseYaoShuiProcess:ctor()
	--请求消息号
	self.order = 10023
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
	--物品id
	self.param2 =  ""	
end


function UseYaoShuiProcess:serialization()
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

return UseYaoShuiProcess