local BuyJingjiTimesResponse = class("BuyJingjiTimesResponse")
function BuyJingjiTimesResponse:BuyJingjiTimesResponse(data)
	if data.result == 1 then 
		local cost = ArenaData.timesCost  -- 购买挑战次数的花费的宝石
		UserData:addDiamond(-cost)			
			
		ArenaData.timesCost = checknumber(data.param1)  -- 下一次购买挑战次数的花费 
		ArenaData.times = checknumber(data.param2) 		-- 当前剩余的挑战次数 

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == -1 then -- 钻石不足
		ResponseEvent.lackGems()
	end 
end
function BuyJingjiTimesResponse:ctor()
	--响应消息号
	self.order = 10057
	--返回结果,1 成功;-1，钻石不足
	self.result =  ""
	--一次购买挑战次数的花费
	self.param1 =  ""	
end

return BuyJingjiTimesResponse