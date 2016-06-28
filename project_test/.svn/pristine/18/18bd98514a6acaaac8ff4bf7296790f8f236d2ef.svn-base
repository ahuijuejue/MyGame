local DiscountShopModel = class("DiscountShopModel")

function DiscountShopModel:ctor()
	self.data = {}
	self.closeTime = 0
	self:createShopData()
end

function DiscountShopModel:createShopData()
	local num = table.nums(GameConfig.Discounteditems)
	for i=1,num do
		local shopItem = self:createItem(i)
		table.insert(self.data,shopItem)
	end
end

function DiscountShopModel:createItem(index)
	local cfg = GameConfig.Discounteditems[tostring(index)]
	local shopItem = {
		GiftItemID = cfg.GiftItemID,	--包含的物品id
		GiftItemNum = cfg.GiftItemNum,	--物品数量
		name = cfg.Name,				--商品名称
		price =cfg.Price,				--商品原价
		sale = cfg.Sale,				--商品售价
		isBuy = false, 					--是否已购买该商品
	}
	return shopItem
end

function DiscountShopModel:update(data)
	if data.param1 then
		local buyIds = string.split(data.param1,",")
		for i,v in ipairs(buyIds) do
			self:updateBuyStatus(tonumber(v),true)
		end
	end
	self.closeTime = data.param5
end

--更新商品购买状态
function DiscountShopModel:updateBuyStatus(index,isBuy)
	self.data[index].isBuy = isBuy or false
end

function DiscountShopModel:getItem(index)
	return self.data[index]
end

function DiscountShopModel:getDays()
	local leftTime = self.closeTime - UserData.serverTime
	local days = math.floor(leftTime / 86400)
	return math.min(math.max(1,7-days),7) 
end

function DiscountShopModel:isCanBuy()
	for i,v in ipairs(self.data) do
		if i <= self:getDays() and not v.isBuy then
			return true
		end
	end
	return false
end

function DiscountShopModel:isOpen()
	if UserData.curServerTime < self.closeTime then
		return true
	end
	return false
end

function DiscountShopModel:clean()
	for i,v in ipairs(self.data) do
		v = nil
	end
	self.data = {}
	self.closeTime = 0
	self:createShopData()
end

return DiscountShopModel