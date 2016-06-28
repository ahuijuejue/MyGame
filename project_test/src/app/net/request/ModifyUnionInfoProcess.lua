local ModifyUnionInfoProcess = class("ModifyUnionInfoProcess")

function ModifyUnionInfoProcess:ctor()
	--请求消息号
	self.order = 30015
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--1:签名，2:公告，3:图标
	self.param1 =  ""
	--内容
	self.param2 =  ""	
end


function ModifyUnionInfoProcess:serialization()
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

return ModifyUnionInfoProcess