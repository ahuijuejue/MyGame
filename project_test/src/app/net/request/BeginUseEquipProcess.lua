local BeginUseEquipProcess = class("BeginUseEquipProcess")

function BeginUseEquipProcess:ctor()
	--请求消息号
	self.order = 10027
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
	--装备唯一id
	self.param2 =  ""
	--装备的位置
	self.param3 =  ""	
end


function BeginUseEquipProcess:serialization()
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

return BeginUseEquipProcess