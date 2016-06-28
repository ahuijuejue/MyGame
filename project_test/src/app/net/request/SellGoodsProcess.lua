local SellGoodsProcess = class("SellGoodsProcess")

function SellGoodsProcess:ctor()
	--请求消息号
	self.order = 10032
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--出售物品的配置id
	self.param1 =  ""
	--如果物品不可叠加，此处是物品的唯一id，
	self.param2 =  ""
	--出售数量
	self.param3 =  ""	
end

function SellGoodsProcess:serialization()
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

return SellGoodsProcess