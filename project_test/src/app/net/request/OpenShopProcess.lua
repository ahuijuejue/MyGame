local OpenShopProcess = class("OpenShopProcess")

function OpenShopProcess:ctor()
	--请求消息号
	self.order = 10004
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--商店类型：1 普通商店；2 积分商店；3 神树商店；4 竞技场商店，6 艾恩商店 
	self.param1 =  ""	
end


function OpenShopProcess:serialization()
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

return OpenShopProcess