local SaveJingjiResultProcess = class("SaveJingjiResultProcess")

function SaveJingjiResultProcess:ctor()
	--请求消息号
	self.order = 10059
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--比赛结果，0 输，1 赢
	self.param1 =  ""
	--对方的userid
	self.param2 =  ""
	--对方的teamid
	self.param3 =  ""	
end


function SaveJingjiResultProcess:serialization()
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

return SaveJingjiResultProcess