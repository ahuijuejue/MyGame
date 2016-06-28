local ShowExchangeItemsResponse = class("ShowExchangeItemsResponse")
function ShowExchangeItemsResponse:ShowExchangeItemsResponse(data)
	if data.result == 1 then
		CoinData.exchangeItems = {}
		for i,v in ipairs(data.a_goods) do
			CoinData:addExchangeItems(v)
		end
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function ShowExchangeItemsResponse:ctor()
	--响应消息号
	self.order = 20039
	--返回结果,1:成功
	self.result =  ""
	--商店中的商品信息
	self.a_goods =  ""
end

return ShowExchangeItemsResponse
