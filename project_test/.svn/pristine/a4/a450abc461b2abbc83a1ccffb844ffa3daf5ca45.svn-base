local UpTailsStarProcess = class("UpTailsStarProcess")

function UpTailsStarProcess:ctor()
	--请求消息号
	self.order = 10051
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--尾兽id
	self.param1 =  ""	
end


function UpTailsStarProcess:serialization()
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

return UpTailsStarProcess