local HandRefreshShopResponse = class("HandRefreshShopResponse")
function HandRefreshShopResponse:HandRefreshShopResponse(data)
	if data.result == 1 then

		local param1 = tonumber(data.param1)
		local shopData = ShopList:getShopByIndex(param1)
		:resetItems()

		for i,v in ipairs(data.a_goods) do
			shopData:addItem({
				id 		= v.id, 				-- 商店id
				itemId 	= v.id, 				-- 物品 id
				count 	= tonumber(v.num), 		-- 商品数量
				price 	= tonumber(v.price), 	-- 商品售价
				sellType = tonumber(v.type), 	--货币类型 1 金币 2 钻石
				sell 	= v.sell=="0" and true or false, -- 出售中
				have 	= tonumber(v.has), -- 拥有数量
				sale    = v.sale, -- 折扣
			})
		end

		UserData:addDiamond(-shopData.value)
		shopData.value = tonumber(data.diamond)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == 2 then
		-- 钻石不足
		ResponseEvent.lackGems()
	end

end
function HandRefreshShopResponse:ctor()
	--响应消息号
	self.order = 10006
	--返回结果,如果成功才会返回下面的参数：1 成功,2 钻石不足
	self.result =  ""
	--商店中的商品信息
	self.a_goods =  ""
	--下次刷新费用
	self.diamond =  ""
end

return HandRefreshShopResponse