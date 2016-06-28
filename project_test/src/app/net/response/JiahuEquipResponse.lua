local JiahuEquipResponse = class("JiahuEquipResponse")

function JiahuEquipResponse:ctor()
	--响应消息号
	self.order = 20040
	--返回结果,1:成功
	self.result =  ""
	--返回结果,1 成功; 2 强化等级不足; 3 材料不足
	self.result =  ""
	--英雄id
	self.param1 =  ""
	--装备的唯一id
	self.param2 =  ""	
end

function JiahuEquipResponse:JiahuEquipResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local uId = data.param2
		local hero = HeroListData:getRoleWithId(heroId)
		local pos = GamePoint.getEquipPos(hero,uId)
		local equip = hero.equip[pos]

		local config = GameConfig.Hero_equip_up[tostring(equip.star+1)]
        local ids = config[string.format("GearItemID%d",pos)]
        local nums = config[string.format("GearItemNum%d",pos)]
	    local cost = config["Cost"][pos]
	    for i,v in ipairs(ids) do
	    	ItemData:reduceMultipleItem(v,nums[i])
	    end
	    UserData:addGold(-cost)

		HeroAbility.unloadEquip(hero,equip,pos)
		equip:upEquipStar(1)
		HeroAbility.loadEquip(hero,equip,pos)
		HeroAbility.plusAbilityExtra(hero)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return JiahuEquipResponse