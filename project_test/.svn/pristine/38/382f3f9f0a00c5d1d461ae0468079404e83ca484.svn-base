local JinjieEquipResponse = class("JinjieEquipResponse")
local GameEquip = import("app.data.GameEquip")

function JinjieEquipResponse:ctor()
	--响应消息号
	self.order = 10026
	--返回结果,1 成功; 2 强化等级不足; 3 材料不足
	self.result =  ""
end

function JinjieEquipResponse:JinjieEquipResponse(data)
	if data.result == 1 then
		local uId = data.param1
		local iId = data.param2
		local heroId = data.param3
		local hero = HeroListData:getRoleWithId(heroId)
		local pos = GamePoint.getEquipPos(hero,uId)
		local equip = hero.equip[pos]

		local param = {itemId = equip.targetItem, id = equip:getLastUid(),level = equip.strLevel}
		local advEquip = GameEquip.new(param)

		local length = #advEquip.needItem
	    for i=1,length do
	        local id = advEquip.needItem[i]
	        local count = advEquip.needCount[i]
	        ItemData:reduceMultipleItem(id,count)
	    end

		HeroAbility.unloadEquip(hero,equip,pos)
		equip = nil

		HeroAbility.loadEquip(hero,advEquip,pos)
		HeroAbility.advAbilityExtra(hero)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return JinjieEquipResponse