--[[
商店信息
]]
local ShopData = class("ShopData")

local ShopItem = import(".ShopItem")

function ShopData:ctor(params)
	self.time 	= params.time or 0					-- 刷新时间（数值）
	self.timeStr 	= params.timeStr or "" 				-- 下次刷新时间
	self.value 	= tonumber(params.value) or 0 		-- 刷新商店需要
	self.items 	= params or {} 						-- 商品列表
	self.shopIndex = 0 
end

-- 创建一个商品
function ShopData:getRefreshIcon()
	return "Diamond.png"
end

-- 创建一个商品
function ShopData:createItem(params)
	return ShopItem.new(params)
end

-- 重置商品列表
function ShopData:resetItems()	
	self.items = {}

	return self 
end

-- 获取商品列表
function ShopData:getItems()	
	return self.items
end

-- 增加商店物品
function ShopData:addItem(item)
	if type(item) == "table" then 
		item = self:createItem(item)
	end 
	table.insert(self.items, item)

	return item 
end

-- 增加商店物品
function ShopData:getItem(id)
	for k,v in pairs(self.items) do
		if id == v.id then 
			return v
		end 
	end

	return nil  
end

function ShopData:getShopIndex()	
	return self.shopIndex
end

return ShopData 
