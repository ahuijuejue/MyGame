local SellGoodsResponse = class("SellGoodsResponse")

function SellGoodsResponse:ctor()
	--响应消息号
	self.order = 10032
	--返回结果,1 成功;
	self.result =  ""
	--出售获取的金币
	self.param1 =  ""	
end

function SellGoodsResponse:SellGoodsResponse(data)
	if data.result == 1 then
		local itemId = data.param1
		local uId = data.param2
		local count = data.param3
		local config = GameConfig.item[itemId]
		if config.Type == 2 then
			for i,v in ipairs(uId) do
				data.param2 = ItemData:removeSuperimposeEquip(v)
			end
		else
			ItemData:reduceMultipleItem(itemId,count)
		end

		local gold = config.Gold * count
		UserData:addGold(gold)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return SellGoodsResponse