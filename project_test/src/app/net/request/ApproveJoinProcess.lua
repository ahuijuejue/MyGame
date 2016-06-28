local ApproveJoinProcess = class("ApproveJoinProcess")

function ApproveJoinProcess:ctor()
	--请求消息号
	self.order = 30012
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--是否同意加入
	self.param1 =  ""
	--被审批人userid
	self.param2 =  ""	
end


function ApproveJoinProcess:serialization()
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

return ApproveJoinProcess