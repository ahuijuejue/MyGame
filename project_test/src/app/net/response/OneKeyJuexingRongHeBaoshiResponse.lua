local OneKeyJuexingRongHeBaoshiResponse = class("OneKeyJuexingRongHeBaoshiResponse")

function OneKeyJuexingRongHeBaoshiResponse:ctor()
	--响应消息号
	self.order = 10067
	--返回结果,-1，宝石不存在,-2 材料不足；-3 等级不足；1 成功
	self.result =  ""
	--英雄id
	self.param2 =  ""
	--宝石战斗力
	self.param3 =  ""
	--新手引导步骤
	self.param100 =  ""	
end

function OneKeyJuexingRongHeBaoshiResponse:OneKeyJuexingRongHeBaoshiResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local hero = HeroListData:getRoleWithId(heroId)
	
		HeroAbility.insertAllStone(hero)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return OneKeyJuexingRongHeBaoshiResponse