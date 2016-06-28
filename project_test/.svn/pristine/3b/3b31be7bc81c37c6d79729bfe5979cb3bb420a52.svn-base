local UnloadEquipResponse = class("UnloadEquipResponse")

function UnloadEquipResponse:ctor()
	--响应消息号
	self.order = 10030
	--返回结果,1 成功;-1 材料不足
	self.result =  ""	
end

function UnloadEquipResponse:UnloadEquipResponse(data)	
	if data.result == 1 then
		local pos = data.param2
		local heroId = data.param3
		local hero = HeroListData:getRoleWithId(heroId)
		local equip = hero.equip[pos]

		local param = {itemId = equip.itemId, id = equip:getLastUid(), level = equip.strLevel}
		ItemData:superimposeEquip(param)

		HeroAbility.unloadEquip(hero,equip,pos)
		HeroAbility.strAbilityExtra(hero)
		HeroAbility.advAbilityExtra(hero)
		HeroAbility.plusAbilityExtra(hero)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

		equip = nil
	end
end

return UnloadEquipResponse