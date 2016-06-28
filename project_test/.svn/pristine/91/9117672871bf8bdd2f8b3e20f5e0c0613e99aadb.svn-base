local BuyPowerStartResponse = class("BuyPowerStartResponse")
function BuyPowerStartResponse:BuyPowerStartResponse(data)
	if data.result == 1 then 		
		local data2 	= PowerAlert 
		local diamond 	= data2.gems -- 花费的钻石
		local power 	= data2.power -- 获得的体力
		
		UserData:addDiamond(-diamond)
		UserData:addPower(power)

		UserData.powerData.buyTimes = UserData.powerData.buyTimes + 1

		-- 活动数据
		ActivityUtil.addParams("buyPower", 1)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == 2 then 
		-- 今日次数已经用完
		local data2 = PowerAlert
		data2.times = data2:getTimesMax()
		data2:check()
	elseif data.result == 3 then 
		-- 钻石不足
		ResponseEvent.lackGems()
	end 

end
function BuyPowerStartResponse:ctor()
	--响应消息号
	self.order = 10010
	--返回结果,如果成功才会返回下面的参数：1 成功,2 今日次数已用完  3 钻石不足
	self.result =  ""
	--花费的钻石
	self.diamond =  ""
	--获得的金币
	self.gold =  ""	
end

return BuyPowerStartResponse