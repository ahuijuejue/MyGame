local GetWuLaoFengRewardProcess = class("GetWuLaoFengRewardProcess")

function GetWuLaoFengRewardProcess:ctor()
	--请求消息号
	self.order = 20011
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--杀死的人数
	self.param1 =  ""
	--难度id
	self.param2 =  ""	
end


function GetWuLaoFengRewardProcess:serialization()
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

return GetWuLaoFengRewardProcess