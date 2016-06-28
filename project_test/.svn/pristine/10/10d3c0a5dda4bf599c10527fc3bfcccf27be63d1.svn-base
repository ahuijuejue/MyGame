local BuySkillPowerStartResponse = class("BuySkillPowerStartResponse")

function BuySkillPowerStartResponse:ctor()
	--响应消息号
	self.order = 10068
	--返回结果,如果成功才会返回下面的参数：1 成功,-1 今日次数已用完  ,-2 钻石不足
	self.result =  ""	
end

function BuySkillPowerStartResponse:BuySkillPowerStartResponse(data)
	if data.result == 1 then
	    local limitPoint = tonumber(GameConfig.Global["1"].SkillPointLimit)
        local point = GameConfig.Global["1"].BuySkillPoint
        UserData:addSkillPoint(point)
        UserData:addSkillBuyTimes(1)

    	local times = math.min(UserData.skillBuyTimes,table.nums(GameConfig.TimesDiamond))
        local price = GameConfig.TimesDiamond[tostring(times)].BuySkillPoint
    	UserData:addDiamond(-price)

    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	end
end

return BuySkillPowerStartResponse