local BeginUseEquipResponse = class("BeginUseEquipResponse")

function BeginUseEquipResponse:ctor()
	--响应消息号
	self.order = 10027
	--返回结果,1 成功; 2 装备不存在; 3 装备位置不对
	self.result =  ""	
end

function BeginUseEquipResponse:BeginUseEquipResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local uniqueId = data.param2
		local pos = data.param3
		local hero = HeroListData:getRoleWithId(heroId)

		--创建新装备
		local equip = clone(ItemData:getEquipWithUid(uniqueId))
		equip.uniqueId = {}
		equip:addSameEquip(uniqueId)

		HeroAbility.loadEquip(hero,equip,pos)
		HeroAbility.strAbilityExtra(hero)
		HeroAbility.advAbilityExtra(hero)
		HeroAbility.plusAbilityExtra(hero)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
		ItemData:removeSuperimposeEquip(uniqueId)
	end
end

return BeginUseEquipResponse