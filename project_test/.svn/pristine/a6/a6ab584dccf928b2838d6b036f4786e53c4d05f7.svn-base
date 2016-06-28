local QiangHuaEquipResponse = class("QiangHuaEquipResponse")

function QiangHuaEquipResponse:ctor()
	--响应消息号
	self.order = 10025
	--返回结果,1 成功; 2 不能大于英雄等级; 3 不能大于当前品阶的最大等级; 4 资金不足
	self.result =  ""	
end

function QiangHuaEquipResponse:QiangHuaEquipResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local uId = data.param2
		local times = data.param3

		local hero = HeroListData:getRoleWithId(heroId)
		local heroLv = hero.level

		local upLv = 0
		local cost = 0

		if uId ~= "" then
			local pos = GamePoint.getEquipPos(hero,uId)
			local equip = hero.equip[pos]
			if times == 1 then
				upLv = 1
				cost = equip:oneCost(heroLv)
			else
				upLv = equip:getUpTimes(heroLv)
				cost = equip:moreCost(heroLv)
			end
			HeroAbility.unloadEquip(hero,equip,pos)
			equip:upEquipLevel(upLv)
			HeroAbility.loadEquip(hero,equip,pos)
			HeroAbility.strAbilityExtra(hero)
		else
			for i=1,#hero.equip do
				local equip = hero.equip[i]
				if equip ~= 0 then
					local equipLv = equip.strLevel
					if equipLv < heroLv then
						if times == 1 then
							upLv = 1
							cost = cost + equip:oneCost(heroLv)
						else
							upLv = equip:getUpTimes(heroLv)
							cost = cost + equip:moreCost(heroLv)
						end
						HeroAbility.unloadEquip(hero,equip,i)
						equip:upEquipLevel(upLv)
						HeroAbility.loadEquip(hero,equip,i)
						if equip.strLevel > equipLv then
							--强化装备特效
							local args = {pos = i, type_ = 1 }
							GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.EQUIP_STR_EFFECT,data = args})
						end
					end
				end
			end
			HeroAbility.strAbilityExtra(hero)
		end
	    UserData:addGold(-cost)
	    
	    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

		TaskData:addTaskParams("upHeroEquip", times)
	end
end

return QiangHuaEquipResponse