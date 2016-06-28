local NavigateResponse = class("NavigateResponse")
function NavigateResponse:NavigateResponse(data)
	if data.result == 1 then
		if data.param1 == 1 then       -- 航行一次
			CoinData.coinType = COIN_TYPE.COIN_TRIP

            local diamondLeftTime = CoinData.nextCoinTimeStamp - UserData.curServerTime
			if diamondLeftTime <= 0 then
				CoinData.nextCoinTimeStamp = UserData.curServerTime + CoinData.freeCoinTime
			elseif CoinData:getRecordCount() > 0 then  -- 永久指针
				ItemData:reduceMultipleItem("12103",1)
			else
		    	UserData:addDiamond(-CoinData.coinPrice)
			end

			UserData:addCoinValue(CoinData.coinValue)
			CoinData:updateResultData(data.a_param1)

            CoinData.coinAllCounts = CoinData.coinAllCounts + 1
			ActivityUtil.addParams("coinFindTimes", 1) -- 寻宝%s次
		elseif data.param1 == 10 then  -- 航行十次
			CoinData.coinType = COIN_TYPE.COIN_TRIPEX
			CoinData:updateResultData(data.a_param1)
			UserData:addDiamond(-CoinData.coinPriceEx)
			UserData:addCoinValue(CoinData.coinValueEx)

			CoinData.coinAllCounts = CoinData.coinAllCounts + 10
			ActivityUtil.addParams("coinFindTimes", 10) -- 寻宝%s次
		end

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function NavigateResponse:ctor()
	--响应消息号
	self.order = 20037
	--返回结果,1:成功
	self.result =  ""
	--类型，1:航行1次，2航行10次
	self.param1 =  ""
	--购买结果信息
	self.a_param1 =  ""
end

return NavigateResponse
