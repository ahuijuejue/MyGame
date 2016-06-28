local JiahuEquipProcess = class("JiahuEquipProcess")

function JiahuEquipProcess:ctor()
	--请求消息号
	self.order = 20040
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--英雄id
	self.param1 =  ""
	--装备的唯一id
	self.param2 =  ""	
end


function JiahuEquipProcess:serialization()
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

return JiahuEquipProcess