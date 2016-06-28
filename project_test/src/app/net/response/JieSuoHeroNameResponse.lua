local JieSuoHeroNameResponse = class("JieSuoHeroNameResponse")

function JieSuoHeroNameResponse:ctor()
	--响应消息号
	self.order = 10019
	--返回结果,-1，条件不足，失败,-2 已达最大等级；1 成功
	self.result =  ""	
end

function JieSuoHeroNameResponse:JieSuoHeroNameResponse(data)
	hideLoading()
	if data.result == 1 then
		local heroId = data.param1
		local hero = HeroListData:getRoleWithId(heroId)
		hero:setStarLevel(hero.starLv + 1)
		if hero.starLv < NAME_MAX_LEVEL then
			hero.coinNums = {0,0,0,0,0,0}
		end
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return JieSuoHeroNameResponse