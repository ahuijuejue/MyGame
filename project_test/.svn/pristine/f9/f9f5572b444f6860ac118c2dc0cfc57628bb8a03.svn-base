local TreeWorldSelectHeroProcess = class("TreeWorldSelectHeroProcess")

function TreeWorldSelectHeroProcess:ctor()
	--请求消息号
	self.order = 20023
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--选择的英雄id
	self.param1 =  ""	
end


function TreeWorldSelectHeroProcess:serialization()
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

return TreeWorldSelectHeroProcess