local OpenRiYueZhuiProcess = class("OpenRiYueZhuiProcess")

function OpenRiYueZhuiProcess:ctor()
	--请求消息号
	self.order = 20026
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""	
end


function OpenRiYueZhuiProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		
	}
	return data
end

return OpenRiYueZhuiProcess