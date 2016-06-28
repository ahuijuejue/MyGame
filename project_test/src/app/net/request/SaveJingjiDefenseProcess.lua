local SaveJingjiDefenseProcess = class("SaveJingjiDefenseProcess")

function SaveJingjiDefenseProcess:ctor()
	--请求消息号
	self.order = 10060
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--保存的阵形英雄id,多个以逗号分开
	self.param1 =  ""
	--新手引导字段
	self.param100 =  ""	
end


function SaveJingjiDefenseProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param100 = self.param100,
		
	}
	return data
end

return SaveJingjiDefenseProcess