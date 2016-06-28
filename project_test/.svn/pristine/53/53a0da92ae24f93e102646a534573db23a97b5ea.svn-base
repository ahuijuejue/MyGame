local OneDiamondChoukaProcess = class("OneDiamondChoukaProcess")

function OneDiamondChoukaProcess:ctor()
	--请求消息号
	self.order = 10035
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""	
end


function OneDiamondChoukaProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		
	}
	return data
end

return OneDiamondChoukaProcess