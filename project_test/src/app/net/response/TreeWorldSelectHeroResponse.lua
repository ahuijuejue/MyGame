local TreeWorldSelectHeroResponse = class("TreeWorldSelectHeroResponse")
function TreeWorldSelectHeroResponse:TreeWorldSelectHeroResponse(data)
	if data.result == 1 then 
		local heroId = data.param1 
		local hero = TreeData:addBattleHero(heroId)

		-- 加入待选列表
		TreeData:resetHeroCacheList()
		for i,v in ipairs(string.split(data.param2 or "", ",")) do
			TreeData:addCacheHero(v)
		end

		TreeData:setRefreshTimes(0)

		return {hero=hero}

	elseif data.result == -1 then 
		showToast({text="不能重复选择"})
	elseif data.result == -2 then 
		showToast({text="最多只能七个英雄"})
	elseif data.result == -3 then 
		showToast({text="没有挑战次数"})
	end

end
function TreeWorldSelectHeroResponse:ctor()
	--响应消息号
	self.order = 20023
	--返回结果,1 成功;-1 不能重复选择；-2 最多只能七个英雄
	self.result =  ""
	--新的英雄列表
	self.param2 =  ""
	--选择的英雄id
	self.param1 =  ""	
end

return TreeWorldSelectHeroResponse