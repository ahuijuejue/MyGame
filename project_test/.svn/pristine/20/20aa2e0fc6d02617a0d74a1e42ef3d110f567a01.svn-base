local XiangQianHeroNameChipProcess = class("XiangQianHeroNameChipProcess")

function XiangQianHeroNameChipProcess:ctor()
	--请求消息号
	self.order = 10018
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
	--镶嵌的位置，以1开始
	self.param2 =  ""
	--镶嵌的次数
	self.param3 =  ""	
end


function XiangQianHeroNameChipProcess:serialization()
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

return XiangQianHeroNameChipProcess