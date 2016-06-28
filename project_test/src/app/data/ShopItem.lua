
local ShopItem = class("ShopItem")

local sellIcons = {
	"Gold.png", 		-- 金币
	"Diamond.png", 		-- 宝石
	"CardScore.png", 	-- 积分
	"TailsCoin.png", 	-- 神树
	"ArenaCoin.png", 	-- 竞技场
	"CastleCoin.png", 	-- 城建
	"UnionGold.png",    -- 公会
}

local sellFunc = {
	handler(UserData, UserData.addGold),
	handler(UserData, UserData.addDiamond),
	handler(UserData, UserData.addCardValue),
}

function ShopItem:ctor(params)
	self.id = params.id 			-- 商品id
	self.itemId = params.itemId  	-- 商品对应的物品id

	self.count 		= tonumber(params.count) or 0	-- 商品数量
	self.sell 		= params.sell 					-- 出售中
	self.price 		= tonumber(params.price)		-- 出售价格
	self.sellType 	= tonumber(params.sellType) 	-- 出售价格类型 1 金币 2 钻石 3 积分 4 神树 5 竞技 7 公会
	self.have 		= tonumber(params.have) or 0 	-- 拥有数量
	self.sale 		= tonumber(params.sale) or nil 	-- 拥有数量

	local cfg 	= ItemData:getItemConfig(self.itemId)

	self.name 	= cfg.itemName 		-- 物品名
	self.desc 	= cfg.desc 			-- 物品描述
	self.itemCfg 	= cfg

end

function ShopItem:getSellIcon()
	return sellIcons[self.sellType]
end

function ShopItem:isSelling()
	return self.sell
end

function ShopItem:didBuy()
	sellFunc[self.sellType](-self.price)
end

return ShopItem