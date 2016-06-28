local VipBuyGiftResponse = class("VipBuyGiftResponse")
function VipBuyGiftResponse:VipBuyGiftResponse(data)
    if data.result == 1 then
	    local items = GameConfig["Vip"][data.param1].GiftItemID
	    local itemNum = GameConfig["Vip"][data.param1].GiftItemNum
		local showItems = {}
		local cost = tonumber(GameConfig["Vip"][data.param1].Sale)

        for i=1,#items do
        	local iConfig = GameConfig.item[items[i]]
			if iConfig.Type == 8 then
				UserData:addGold(tonumber(itemNum[i]))
			elseif iConfig.Type == 9 then
				UserData:addDiamond(tonumber(itemNum[i]))
			elseif iConfig.Type == 10 then
				UserData:addPower(tonumber(itemNum[i]))
			elseif iConfig.Type == 11 then
				UserData:addSoul(tonumber(itemNum[i]))
			elseif iConfig.Type == 12 then
				UserData:addArenaValue(tonumber(itemNum[i]))
			elseif iConfig.Type == 13 then
				UserData:addExp(tonumber(itemNum[i]))
			elseif iConfig.Type == 18 then
				UserData:addTreeValue(tonumber(itemNum[i]))
			elseif iConfig.Type == 19 then
				UserData:addCityValue(tonumber(itemNum[i]))
			elseif iConfig.Type == 21 then
				UserData:addCardValue(tonumber(itemNum[i]))
			end

        	ItemData:addMultipleItem(items[i], tonumber(itemNum[i]))
        	local data = ItemData:getItemConfig(items[i])
				table.insert(showItems, {
					itemId 	= items[i],
					count 	= tonumber(itemNum[i]),
					name 	= data.itemName,
				})
        end

	    UserData:setIsBuy(data.param1)
	    UserData:addDiamond(-cost)
	    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

	    return {items=showItems}
    else
    	showToast({text = "VIP礼包未购买成功"})
    end

end
function VipBuyGiftResponse:ctor()
	--响应消息号
	self.order = 20031
	--返回结果,1 :成功,-17:VIP等级不足,或购买的礼包等级和vip等级不一致
	self.result =  ""
	--vip礼包ID，即VIP等级
	self.param1 =  ""
end

return VipBuyGiftResponse