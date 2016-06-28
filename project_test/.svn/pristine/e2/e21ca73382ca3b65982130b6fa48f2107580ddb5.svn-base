local VipBuyGiftProcess = class("VipBuyGiftProcess")

function VipBuyGiftProcess:ctor()
	--请求消息号
	self.order = 20031
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--vip礼包ID，即VIP等级
	self.param1 =  ""	
end


function VipBuyGiftProcess:serialization()
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

return VipBuyGiftProcess