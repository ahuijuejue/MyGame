local BuyShopGoodsProcess = class("BuyShopGoodsProcess")

function BuyShopGoodsProcess:ctor()
	--请求消息号
	self.order = 10005
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--商品id
	self.param1 =  ""
	--商品位置,从0开始数
	self.param2 =  ""
	--商店类型：1 普通商店；2 积分商店；3 神树商店；4 竞技场商店,5 购买经验药水,6 艾恩商店,7神秘商店,8打折商店
	self.param3 =  ""
	--数量
	self.param4 =  ""	
end


function BuyShopGoodsProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		param4 = self.param4,
		
	}
	return data
end

return BuyShopGoodsProcess