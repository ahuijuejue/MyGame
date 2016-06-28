local JueXingHeroResponse = class("JueXingHeroResponse")

function JueXingHeroResponse:ctor()
	--响应消息号
	self.order = 10021
	--返回结果,-1 条件不足，失败；1 成功
	self.result =  ""	
end

function JueXingHeroResponse:JueXingHeroResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local hero = HeroListData:getRoleWithId(heroId)
		local level = hero.awakeLevel+1
		hero:setHeroAwakeLevel(level)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return JueXingHeroResponse