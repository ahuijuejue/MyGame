local PurchaseFundResponse = class("PurchaseFundResponse")

function PurchaseFundResponse:ctor()
	--响应消息号
	self.order = 31005
	--返回结果,1:成功,-1:活动不在有效期,-2:已经购买，-3:vip等级不足，-4:钱不够
	self.result =  ""	
end

function PurchaseFundResponse:PurchaseFundResponse(data)
	if data.result == 1 then
		UserData.buyGrowGift = 1
		local price = GameConfig.Global["1"].FundDiamond
		UserData:addDiamond(-price)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return PurchaseFundResponse