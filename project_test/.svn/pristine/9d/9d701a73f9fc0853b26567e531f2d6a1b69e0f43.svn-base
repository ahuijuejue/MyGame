local DecomposeResponse = class("DecomposeResponse")
function DecomposeResponse:DecomposeResponse(data)
	if data.result == 1 then
		local param1 = data.param1
		local id_str = string.split(param1, ",")

		-- 物品数据中除去分解消耗的物品
		local addCoin = 0 			-- 增加的黄金碎片
		for i,v in ipairs(id_str) do
			local itemInfo = string.split(v, "_")
			if table.nums(itemInfo) == 2 then
				local itemId = itemInfo[1]
				local nItem = checknumber(itemInfo[2])

				local item = ItemData:getItem(itemId)
				if item then
					addCoin = addCoin + item.seal * nItem
					ItemData:reduceItem(itemId, nItem)
				end
			end
		end

		-- 增加黄金碎片
	    UserData:addCoinValue(addCoin)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function DecomposeResponse:ctor()
	--响应消息号
	self.order = 20038
	--返回结果,1:成功
	self.result =  ""
	--分解的物品,itemid_itemnum,itemid_itemnum
	self.param1 =  ""
end

return DecomposeResponse
