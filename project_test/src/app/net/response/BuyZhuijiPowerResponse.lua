local BuyZhuijiPowerResponse = class("BuyZhuijiPowerResponse")
function BuyZhuijiPowerResponse:BuyZhuijiPowerResponse(data)
	if data.result == 1 then 
		local diamond = ArenaLookingForData:getCostForBuyTimes()
		UserData:addDiamond(-diamond)
		ArenaLookingForData:addBuyTimes(1)
		ArenaLookingForData:addHaveTimes(1)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == -14 then -- 钻石不足
		ResponseEvent.lackGems()
	end 

end
function BuyZhuijiPowerResponse:ctor()
	--响应消息号
	self.order = 20029
	--返回结果,1 成功;-14 钻石不足
	self.result =  ""	
end

return BuyZhuijiPowerResponse