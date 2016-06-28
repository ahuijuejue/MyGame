local JuexingRongHeBaoshiResponse = class("JuexingRongHeBaoshiResponse")

function JuexingRongHeBaoshiResponse:ctor()
	--响应消息号
	self.order = 10020
	--返回结果,-1，宝石不存在,-2 材料不足；-3 等级不足；1 成功
	self.result =  ""
end

function JuexingRongHeBaoshiResponse:JuexingRongHeBaoshiResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local pos = data.param2
		local hero = HeroListData:getRoleWithId(heroId)
		local awakeInfo = GameConfig.hero_awake[hero.roleId]
		local key = string.format("ItemID%d",hero.awakeLevel+1)
		local targetId = awakeInfo[key][pos]
		HeroAbility.switchHeroStone(hero,targetId,pos)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return JuexingRongHeBaoshiResponse