local ShowUnionMembersProcess = class("ShowUnionMembersProcess")

function ShowUnionMembersProcess:ctor()
	--请求消息号
	self.order = 30102
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--公会ID
	self.param1 =  ""	
end


function ShowUnionMembersProcess:serialization()
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

return ShowUnionMembersProcess