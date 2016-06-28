local SummonHeroResponse = class("SummonHeroResponse")

function SummonHeroResponse:ctor()
	--响应消息号
	self.order = 10031
	--返回结果,1 成功;-1 材料不足
	self.result =  ""	
end

function SummonHeroResponse:SummonHeroResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local hero = HeroListData:getRoleWithId(heroId,HeroListData.unActList)
		table.insert(HeroListData.heroList,hero)
		removeObject(HeroListData.unActList,hero)
		ItemData:reduceMultipleItem(hero.stoneId,hero.stoneNum)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return SummonHeroResponse