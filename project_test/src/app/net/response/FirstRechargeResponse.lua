local FirstRechargeResponse = class("FirstRechargeResponse")
function FirstRechargeResponse:FirstRechargeResponse(data)
    if data.result == 1 then

		UserData:setFirstRecharge(tostring(data.param1))

		local items = GameConfig["FirstRechargeInfo"][tostring(data.param1)].RAwardID
	    local itemNum = GameConfig["FirstRechargeInfo"][tostring(data.param1)].RAwardNum
		local showItems = {}

		for i=1,#items do
        	ItemData:addMultipleItem(items[i], tonumber(itemNum[i]))
        	local data = ItemData:getItemConfig(items[i])
			table.insert(showItems, {
				itemId 	= items[i],
				count 	= tonumber(itemNum[i]),
				name 	= data.itemName,
			})
        end

        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

		return {items=showItems}

    else
    	showToast({text = "不能领取奖励"})
    end

end
function FirstRechargeResponse:ctor()
	--响应消息号
	self.order = 20034
	--返回结果,1 成功,-1:不能领取奖励
	self.result =  ""
	--1:首冲奖励，2:首冲10元奖励
	self.param1 =  ""
end

return FirstRechargeResponse