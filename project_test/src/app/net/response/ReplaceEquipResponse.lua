local ReplaceEquipResponse = class("ReplaceEquipResponse")

function ReplaceEquipResponse:ctor()
	--响应消息号
	self.order = 10028
	--返回结果,1 成功;
	self.result =  ""	
end

function ReplaceEquipResponse:ReplaceEquipResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local equipId = data.param3
		local pos = data.param4
		local hero = HeroListData:getRoleWithId(heroId)
		
		local equip1 = hero.equip[pos]
		local param = {itemId = equip1.itemId, id = equip1:getLastUid(), level = equip1.strLevel}
		ItemData:superimposeEquip(param)

		HeroAbility.unloadEquip(hero,equip1,pos)
		equip1 = nil

		--创建新装备
		local equip2 = clone(ItemData:getEquipWithUid(equipId))
		equip2.uniqueId = {}
		equip2:addSameEquip(equipId)

		HeroAbility.loadEquip(hero,equip2,pos)
		HeroAbility.strAbilityExtra(hero)
		HeroAbility.advAbilityExtra(hero)
		HeroAbility.plusAbilityExtra(hero)

		ItemData:removeSuperimposeEquip(equipId)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return ReplaceEquipResponse