local SaveTailsFormationProcess = class("SaveTailsFormationProcess")

function SaveTailsFormationProcess:ctor()
	--请求消息号
	self.order = 10062
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--选择的尾兽id,多个以逗号隔开
	self.param1 =  ""	
end


function SaveTailsFormationProcess:serialization()
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

return SaveTailsFormationProcess