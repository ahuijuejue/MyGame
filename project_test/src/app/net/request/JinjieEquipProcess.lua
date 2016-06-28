local JinjieEquipProcess = class("JinjieEquipProcess")

function JinjieEquipProcess:ctor()
	--请求消息号
	self.order = 10026
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--装备的唯一id
	self.param1 =  ""
	--装备所属的物品id
	self.param2 =  ""
	--英雄id
	self.param3 = ""
end


function JinjieEquipProcess:serialization()
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

return JinjieEquipProcess