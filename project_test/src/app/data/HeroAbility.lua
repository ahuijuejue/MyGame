--英雄属性相关
module("HeroAbility", package.seeall)

--穿上英雄身上所有装备
function loadAllEquip(hero)
	local equips = hero.equip
	for i=1,#equips do
		if equips[i] ~= 0 then
			equipAbilityChange(hero,equips[i],1)
		end
	end
end

--英雄装备属性变更
function equipAbilityChange(hero,equip,dir)
	for i=1,#equip.types do
		abilityChange(hero,equip.types[i],equip.abilitys[i],dir)
	end
end

--英雄属性变更
function abilityChange(hero,_type,ability,dir)
	if _type == 1 then
		hero.property.maxHp = hero.property.maxHp + ability * dir
	elseif _type == 2 then
		hero.property.atk = hero.property.atk + ability * dir
	elseif _type == 3 then
		hero.property.magicAtk = hero.property.magicAtk + ability * dir
	elseif _type == 4 then
		hero.property.defense = hero.property.defense + ability * dir
	elseif _type == 5 then
		hero.property.magicDefense = hero.property.magicDefense + ability * dir
	elseif _type == 6 then
		hero.property.acp = hero.property.acp + ability * dir
	elseif _type == 7 then
		hero.property.magicAcp = hero.property.magicAcp + ability * dir
	elseif _type == 8 then
		hero.property.rate = hero.property.rate + ability * dir
	elseif _type == 9 then
		hero.property.dodge = hero.property.dodge + ability * dir
	elseif _type == 10 then
		hero.property.crit = hero.property.crit + ability * dir
	elseif _type == 11 then
		hero.property.blood = hero.property.blood + ability * dir
	elseif _type == 12 then
		hero.property.breakValue = hero.property.breakValue + ability * dir
	elseif _type == 13 then
		hero.property.tumble = hero.property.tumble + ability * dir
	end
	hero:setProperty()
end

--英雄穿上装备 属性变更
function loadEquip(hero,equip,index)
	equipAbilityChange(hero,equip,1)
	hero.equip[index] = equip
end

--英雄卸下装备
function unloadEquip(hero,equip,index)
	equipAbilityChange(hero,equip,-1)
	hero.equip[index] = 0
end

--英雄强化综合等级
function getStrenLv(hero)
	local equipLvs = {}
	for i=1,#hero.equip do
		if hero.equip[i] == 0 then
			table.insert(equipLvs,0)
		else
			table.insert(equipLvs,hero.equip[i].strLevel)
		end
	end
	local minLv = math.min(unpack(equipLvs))
	return math.floor(minLv/10)
end

--英雄进阶等级
function getAdvLv(hero)
	local advLvs = {}
	for i=1,#hero.equip do
		if hero.equip[i] == 0 then
			table.insert(advLvs,0)
		else
			table.insert(advLvs,hero.equip[i].configQuality)
		end
	end
	local minLv = math.min(unpack(advLvs))
	return minLv
end

--装备套装属性加成
function strAbility(hero,level,dir)
	local equipInfo = GameConfig.hero_equip[hero.roleId]
	if not equipInfo then
		return
	end
	local types = equipInfo.Strengthen_type
	local values = equipInfo.Strengthen_value
	if level > 0 then
		for i=1,#types do
			local value = values[i]*level
			abilityChange(hero,types[i],value,dir)
		end
	end
end

--英雄强化属性加成
function strAbilityExtra(hero)
	local strLv = getStrenLv(hero)
	if strLv == hero.equipStrLv then
		return
	end
	strAbility(hero,hero.equipStrLv,-1)
	strAbility(hero,strLv,1)
	hero.equipStrLv = strLv
end

--装备进阶属性加成
function advAbility(hero,level,dir)
	local key = ""
	local types = {}
	local values = {}
	local equipInfo = GameConfig.hero_equip[hero.roleId]
	if not equipInfo then
		return
	end
	if level > 0 then
		types = string.split(equipInfo["Quality_type"][level],":")
		values = string.split(equipInfo["Quality_value"][level],":")
		for i=1,#types do
			abilityChange(hero,types[i],values[i],dir)
		end
	end
end

--英雄进阶属性加成
function advAbilityExtra(hero)
	local advLv = getAdvLv(hero)
	if advLv == hero.equipAdvLv then
		return
	end
	advAbility(hero,hero.equipAdvLv,-1)
	advAbility(hero,advLv,1)
	hero.equipAdvLv = advLv
end

--加护综合等级
function getPlusLv(hero)
	local tLevel = 0
	for i,v in ipairs(hero.equip) do
		if v ~= 0 then
			tLevel = tLevel + v.star
		end
	end
	return math.floor(tLevel/5)
end

--加护属性加成
function plusAbility(hero,level,dir)
	local equipInfo = GameConfig.hero_equip[hero.roleId]
	if not equipInfo then
		return
	end
	if level > 0 then
		local types = equipInfo["Equip_up_type"]
		local values = equipInfo["Equip_up_value"]
		for i=1,#types do
			abilityChange(hero,types[i],values[i]*level,dir)
		end
	end
end

function plusAbilityExtra(hero)
	local lv = getPlusLv(hero)
	if lv == hero.equipPlusLv then
		return
	end
	advAbility(hero,hero.equipPlusLv,-1)
	advAbility(hero,lv,1)
	hero.equipPlusLv = lv
end

--英雄宝石属性加成
function loadAllStone(hero)
	local stones = hero.stones
	for i=1,#stones do
		if stones[i] ~= 0 then
			local stone = ItemData:getItemConfig(stones[i])
			local _type = stone.content.Type
			local ability = stone.content.Value
			abilityChange(hero,_type,ability,1)
		end
	end
end

--英雄镶嵌宝石
function switchHeroStone(hero,nId,index)
	if hero.stones[index] == 0 then
		local length = #GameConfig.item[nId].Content.NeedItemNum
	    for i=1,length do
	        local id = GameConfig.item[nId].Content.NeedItemID[i]
	        local count = GameConfig.item[nId].Content.NeedItemNum[i]
	        ItemData:reduceMultipleItem(id,count)
	    end
		local nStone = ItemData:getItemConfig(nId)
		local _type = nStone.content.Type
		local ability = nStone.content.Value
		abilityChange(hero,_type,ability,1)
		hero.stones[index] = nId

		--通知显示特效
		local args = {pos = index,type_ = 3}
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.EQUIP_STR_EFFECT,data = args})
	end
end

--镶嵌英雄所有宝石孔
function insertAllStone(hero)
	for i=1,STONE_INSERT_COUNT do
		if GamePoint.holeCanMerge(hero,i) then
			local key = string.format("ItemID%d",hero.awakeLevel+1)
			local awakeInfo = GameConfig.hero_awake[hero.roleId]
	        local targetId = awakeInfo[key][i]
			switchHeroStone(hero,targetId,i)
		end
	end
end

function getStoneValue(hero,type_)
	local value = 0
	for i=1,#hero.stones do
		if hero.stones[i] ~= 0 then
			local stone = ItemData:getItemConfig(hero.stones[i])
			local _type = stone.content.Type
			if type_ == _type then
				value = stone.content.Value + value
			end
		end
	end
	return value
end

function getEquipValue(hero,type_)
	local value = 0
	for i=1,#hero.equip do
		if hero.equip[i] ~= 0 then
			local equip = hero.equip[i]
			for i=1,#equip.types do
				if equip.types[i] == type_ then
					value = equip.abilitys[i] + value
				end
			end
		end
	end
	return value
end

function getStrenValue(hero,type_)
	local value = 0
	local equipInfo = GameConfig.hero_equip[hero.roleId]
	local strLv = getStrenLv(hero)
	local types = equipInfo.Strengthen_type
	for i=1,#types do
		if types[i] == type_ then
			value = equipInfo.Strengthen_value[i] * strLv + value
		end
	end
	return value
end

function getAdvanceValue(hero,type_)
	local value = 0
	local equipInfo = GameConfig.hero_equip[hero.roleId]
	local advLv = getAdvLv(hero)
	if advLv > 0 then
		local types = string.split(equipInfo["Quality_type"][advLv],":")
		local values = string.split(equipInfo["Quality_value"][advLv],":")
		for i=1,#types do
			if types[i] == type_ then
				value = values[i] + value
			end
		end
	end
	return value
end

function getPlusValue(hero,type_)
	local value = 0
	local equipInfo = GameConfig.hero_equip[hero.roleId]
	local plusLv = getPlusLv(hero)
	if plusLv > 0 then
		local types = equipInfo["Equip_up_type"]
		local values = equipInfo["Equip_up_value"]
		for i=1,#types do
			if types[i] == type_ then
				value = values[i] * plusLv + value
			end
		end
	end
	return value
end

