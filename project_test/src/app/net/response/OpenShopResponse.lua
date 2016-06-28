local OpenShopResponse = class("OpenShopResponse")
function OpenShopResponse:OpenShopResponse(data)
	if data.result == 1 then
		local ShopData = ShopList:addShopByIndex({
			timeStr = data.reftime, -- 下次刷新时间
			time 	= encodeTime(data.param2), -- 刷新时间点（数值）
			value 	= tonumber(data.diamond), -- 刷新商店需要
		}, tonumber(data.param1))

		if tonumber(data.param1) == 1 then
			ShopList.shopType = 1
		elseif tonumber(data.param1) == 2 then
			ShopList.shopType = 2
		elseif tonumber(data.param1) == 6 then
			ShopList.shopType = 3
		elseif tonumber(data.param1) == 3 then
			ShopList.shopType = 4
		elseif tonumber(data.param1) == 9 then
			ShopList.shopType = 5
		end

    	for i,v in ipairs(data.a_goods) do
			ShopData:addItem({
				id 		= v.id, -- 商店/物品 id
				itemId 	= v.id, -- 商店/物品 id
				count 	= tonumber(v.num), -- 商品数量
				price 	= tonumber(v.price), -- 商品售价
				sellType = tonumber(v.type), --货币类型 1 金币 2 钻石 3 积分 4 神树 5 竞技 6 城建 7 公会
				sell 	= v.sell=="0" and true or false, -- 出售中
				have 	= v.has, -- 拥有数量
				sale    = v.sale, -- 折扣
			})
		end

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

    elseif data.result == -1 then
    	showToast({text = "神秘商店未开启"})
	end

end
function OpenShopResponse:ctor()
	--响应消息号
	self.order = 10004
	--返回结果,如果成功才会返回下面的参数：1 成功， -1 神秘商店未开启
	self.result =  ""
	--商店中的商品信息
	self.a_goods =  ""
	--下次刷新时间
	self.reftime =  ""
	--下次刷新的钻石
	self.diamond =  ""
	--商店类型：1 普通商店；2 积分商店；3 神树商店；4 竞技场商店，7 神秘商店，6 艾恩商店
	self.param1 =  ""
	--刷新时间
	self.param2 =  ""
end

return OpenShopResponse
