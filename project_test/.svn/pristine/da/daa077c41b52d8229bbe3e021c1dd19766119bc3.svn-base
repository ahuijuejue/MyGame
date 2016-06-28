local ModifyUnionSetUpProcess = class("ModifyUnionSetUpProcess")

function ModifyUnionSetUpProcess:ctor()
	--请求消息号
	self.order = 30019
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--申请人等级限制
	self.param1 =  ""
	--是否需要审批（1：需要，2：不需要）
	self.param2 =  ""	
end


function ModifyUnionSetUpProcess:serialization()
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

return ModifyUnionSetUpProcess