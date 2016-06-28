local RefreshTreeWorldHeroListResponse = class("RefreshTreeWorldHeroListResponse")
function RefreshTreeWorldHeroListResponse:RefreshTreeWorldHeroListResponse(data)
	if data.result == 1 then 
		local cost = TreeData:getRefreshCost()

		UserData:addDiamond(-cost)
		TreeData:addRefreshTimes(1)

		-- 加入待选列表
		TreeData:resetHeroCacheList()
		for i,v in ipairs(string.split(data.param1 or "", ",")) do
			TreeData:addCacheHero(v)
		end
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == -1 then 
		ResponseEvent.lackGems()
	elseif data.result == -2 then 
		showToast({text="保卫世界数次数已用完"})
	end 
end

function RefreshTreeWorldHeroListResponse:ctor()
	--响应消息号
	self.order = 20022
	--返回结果,1 成功; -1 钻石不足；-2 保卫世界数次数已用完
	self.result =  ""
	--英雄列表，三个以逗号隔开
	self.param1 =  ""	
end

return RefreshTreeWorldHeroListResponse