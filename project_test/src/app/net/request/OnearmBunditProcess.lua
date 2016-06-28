local OnearmBunditProcess = class("OnearmBunditProcess")

function OnearmBunditProcess:ctor()
	--请求消息号
	self.order = 31002
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--活动类型,1:一次,2:5次
	self.param1 =  ""	
end


function OnearmBunditProcess:serialization()
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

return OnearmBunditProcess