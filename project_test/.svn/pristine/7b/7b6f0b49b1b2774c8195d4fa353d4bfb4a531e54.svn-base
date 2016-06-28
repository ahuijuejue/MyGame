local SaoDangProcess = class("SaoDangProcess")

function SaoDangProcess:ctor()
	--请求消息号
	self.order = 20005
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
	--扫荡次数
	self.param2 =  ""
	--关卡类型：1 普通；2 精英
	self.param3 =  ""	
end


function SaoDangProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		
	}
	return data
end

return SaoDangProcess