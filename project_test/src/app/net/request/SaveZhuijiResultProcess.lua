local SaveZhuijiResultProcess = class("SaveZhuijiResultProcess")

function SaveZhuijiResultProcess:ctor()
	--请求消息号
	self.order = 20028
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--上传的英雄，字符串逗号分开
	self.param1 =  ""
	--战斗类型，1 日追击；2 月追击
	self.param2 =  ""	
end


function SaveZhuijiResultProcess:serialization()
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

return SaveZhuijiResultProcess