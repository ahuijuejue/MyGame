local DecomposeProcess = class("DecomposeProcess")

function DecomposeProcess:ctor()
	--请求消息号
	self.order = 20038
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--分解的物品,itemid_itemnum,itemid_itemnum
	self.param1 =  ""	
end


function DecomposeProcess:serialization()
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

return DecomposeProcess