local ClearArenaCoolResponse = class("ClearArenaCoolResponse")
function ClearArenaCoolResponse:ClearArenaCoolResponse(data)
	if data.result == 1 then 
		local cost = ArenaData.refreshCost  -- 刷新时间花费的宝石
		UserData:addDiamond(-cost)
		ArenaData.coolTime = 0 				-- 冷却时间清零
		ArenaData.refreshCost = checknumber(data.param1) 	-- 下一次清除的价格 
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == -1 then -- 钻石不足
		ResponseEvent.lackGems()
	end 
end
function ClearArenaCoolResponse:ctor()
	--响应消息号
	self.order = 10054
	--返回结果,1 成功;-1 钻石不足
	self.result =  ""
	--下一次清除的价格
	self.param1 =  ""	
end

return ClearArenaCoolResponse