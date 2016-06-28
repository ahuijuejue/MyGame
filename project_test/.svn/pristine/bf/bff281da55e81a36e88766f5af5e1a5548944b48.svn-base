local AssemblyEquipResponse = class("AssemblyEquipResponse")
local GameEquip = import("app.data.GameEquip")

function AssemblyEquipResponse:ctor()
	--响应消息号
	self.order = 10029
	--返回结果,1 成功;-1 材料不足
	self.result =  ""
	--装备唯一id
	self.param1 =  ""	
end

function AssemblyEquipResponse:AssemblyEquipResponse(data)
	if data.result == 1 then
		local uId = data.param1
		local heroId = data.param2
		local hero = HeroListData:getRoleWithId(heroId)

		local equipInfo = GameConfig.hero_equip[hero.roleId]
		local key = string.format("GearItemID%d",1)
		local equipIds = equipInfo[key]
		local equip = GameEquip.new({itemId = equipIds[1],id = uId})
		local length = #equip.needItem
		for i=1,length do
			local id = equip.needItem[i]
	        local count = equip.needCount[i]
	        ItemData:reduceMultipleItem(id,count)
		end
		HeroAbility.loadEquip(hero,equip,1)
	    HeroAbility.advAbilityExtra(hero)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return AssemblyEquipResponse