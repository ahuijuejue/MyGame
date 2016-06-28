local GiftExchangeProcess = class("GiftExchangeProcess")

function GiftExchangeProcess:ctor()
	--请求消息号
	self.order = 11002
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--礼包兑换码
	self.param1 =  ""	
end


function GiftExchangeProcess:serialization()
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

return GiftExchangeProcess