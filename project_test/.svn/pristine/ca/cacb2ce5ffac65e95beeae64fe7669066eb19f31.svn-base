module("GamePoint", package.seeall)

--检测英雄是否可以进阶
function heroCanAwake(hero)
    if hero.awakeLevel >= AWAKE_MAX_LEVEL - 1 then
        return false
    end
	local awakeInfo = GameConfig.hero_awake[hero.roleId]
	local key = string.format("ItemID%d",hero.awakeLevel+1) 
	local itemIds = awakeInfo[key]

	for i=1,#itemIds do
		if hero.stones[i] ~= itemIds[i] then
			return false
		end
	end
	return true
end

--检测材料是否足够
function stoneEnough(targetItem)
    local needCount = targetItem.content.NeedItemNum
    local needItemId = targetItem.content.NeedItemID
    for i,v in ipairs(needCount) do
        local count = ItemData:getItemCountWithId(needItemId[i])
        if count < v then
            return false
        end
    end
    return true
end

--检测是否满足融合等级
function mergeLevel(hero,targetItem)
    if hero.level < targetItem.content.NeedLevel then
        return false
    end
    return true
end

--是否满足品质
function mergeQuality(hero,targetItem)
	if hero.awakeLevel < targetItem.content.NeedHeroQuality then
		return false
	end
	return true
end

--宝石是否可以融合
function stoneMerge(hero,targetItem)
    if stoneEnough(targetItem) and mergeLevel(hero,targetItem) and mergeQuality(hero,targetItem) then
        return true
    end
    return false
end

--检测是否提示融合宝石
function holeCanTip(hero,index)
    local awakeInfo = GameConfig.hero_awake[hero.roleId]
    local currentId = hero.stones[index]
    if currentId == 0 then
        local key = string.format("ItemID%d",hero.awakeLevel+1)
        local targetId = awakeInfo[key][index]
        local targetItem = ItemData:getItemConfig(targetId)
        if not stoneEnough(targetItem) or not mergeLevel(hero,targetItem) then
            return true
        end
    end
    return false
end

--检测英雄宝石孔是否可以融合宝石
function holeCanMerge(hero,index)
    local awakeInfo = GameConfig.hero_awake[hero.roleId]
    local currentId = hero.stones[index]
    if currentId == 0 then
        local key = string.format("ItemID%d",hero.awakeLevel+1)
        local targetId = awakeInfo[key][index]
        local targetItem = ItemData:getItemConfig(targetId)
        return stoneMerge(hero,targetItem)
    else
        return false
    end
end

--检测英雄是否有可融合宝石
function heroCanMerge(hero)
    if hero.awakeLevel == AWAKE_MAX_LEVEL - 1 then
        return false
    end
    for i=1,STONE_INSERT_COUNT do
        if holeCanMerge(hero,i) then
            return true
        end
    end
    return false
end

--英雄是否有可更新状态
function heroCanUpdate(hero)
    if heroCanAwake(hero) or heroCanMerge(hero) then
        return true
    end
    return false
end

--检测孔是否可镶嵌硬币
function holeCanInsert(hero,index)
    if hero.starLv < NAME_MAX_LEVEL then
        local data = GameConfig.skill_awake[hero.roleId]
        local key1 = string.format("SkillNameItemID%d",hero.starLv+1)
        local coinId = data[key1][index]
        local coinCount = ItemData:getItemCountWithId(coinId)

        local key2 = string.format("SkillNameNum%d",hero.starLv+1)
        local needCount = data[key2][index]
        if coinCount > 0 and hero.coinNums[index] < needCount then
            return true
        end
    end
    
    return false
end

--检测英雄是否有可镶嵌硬币
function heroCanInsert(hero)
    for i=1,6 do
        if holeCanInsert(hero,i) then
            return true
        end
    end
    return false
end

--镶嵌硬币进度
function heroInsertPercent(hero)
    if hero.starLv >= NAME_MAX_LEVEL then
        return 0
    end

    local data = GameConfig.skill_awake[hero.roleId]
    local key = string.format("SkillNameNum%d",hero.starLv+1)
    --所需材料数量
    local count = data[key]
    local totalCount = 0
    for i=1,#count do
        totalCount = totalCount + count[i]
    end
    --已镶嵌硬币数量
    local insertCount = 0
    for i=1,6 do
        insertCount = insertCount + hero.coinNums[i]
    end

    return insertCount/totalCount
end

--检测英雄技能是否可更新
function heroSkillCanUpdate(hero)
    if UserData:getUserLevel() < OpenLvData.starUp.openLv then
        return false
    end
    if heroInsertPercent(hero) >= 1 or heroCanInsert(hero) then
        if hero.starLv < NAME_MAX_LEVEL then
            return true
        end
    end
    return false
end

--检测英雄装备栏是否有可装备物品
function heroCanEquip(index,hero)
    local equipInfo = GameConfig.hero_equip[hero.roleId]
    local key = string.format("GearItemID%d",index)
    local equipIds = equipInfo[key]
    for i=1,#equipIds do
        if ItemData:getItemWithId(equipIds[i]) then
            return true
        end
    end
    return false
end

--检测英雄装备栏是否有可替换装备物品
function heroCanReplaceEquip(index,hero)
    assert(hero.equip[index] ~= 0,"no equip")
    local equipInfo = GameConfig.hero_equip[hero.roleId]
    local key = string.format("GearItemID%d",index)
    local equipIds = equipInfo[key]
    local equips = ItemData:getEquipList(equipIds)
    
    local powers = {}
    for i=1,#equips do
        table.insert(powers,equips[i].power)
    end

    if #powers > 0 then
        local maxPower = math.max(unpack(powers))
        if maxPower > hero.equip[index].power then
            return true
        end
    end
    
    return false
end

--装备进阶材料是否满足
function matEnough(itemId)
    local needCount = GameConfig.item[itemId].Content.NeedItemNum
    local needItemId = GameConfig.item[itemId].Content.NeedItemID
    for i,v in ipairs(needCount) do
        local count = ItemData:getItemCountWithId(needItemId[i])
        if count < v then
            return false
        end
    end
    return true
end

--检测装备是否能够进阶
function equipCanAdv(equip)
    if equip.targetItem then
        if matEnough(equip.targetItem) and equip:isLimit() then
            return true
        end
    end
    return false
end

--检测是装备否能够加护
function equipCanPlus(hero,equip)
    if equip.star < EQUIP_STAR_MAX then
        local equipPos = getEquipPos(hero,equip:getLastUid())
        local config = GameConfig.Hero_equip_up[tostring(equip.star+1)]
        local ids = config[string.format("GearItemID%d",equipPos)]
        local nums = config[string.format("GearItemNum%d",equipPos)]
        local cost = config["Cost"][equipPos]
        if cost > UserData.gold then
            return false
        end
        for i,v in ipairs(nums) do
            local count = ItemData:getItemCountWithId(ids[i])
            if count < v then
                return false
            end
        end
        return true
    end
    return false
end

--检测英雄装备是否有更新
function heroEquipCanUpdate(hero)
    for i=1,#hero.equip do
        if hero.equip[i] == 0 then
            if heroCanEquip(i,hero) then
                return true
            end
            if i == 1 then
                local equipInfo = GameConfig.hero_equip[hero.roleId]
                local key = string.format("GearItemID%d",1)
                local equipIds = equipInfo[key]
                if matEnough(equipIds[1]) then
                    return true
                end
            end
        else
            if heroCanReplaceEquip(i,hero) then
                return true
            end
            if equipCanAdv(hero.equip[i]) then
                return true
            end
            if equipCanPlus(hero,hero.equip[i]) then
                return true
            end
        end
    end
    return false
end

--英雄 技能 装备是否有更新状态
function heroSystemCanUpdate(hero)
    if heroCanUpdate(hero) or heroSkillCanUpdate(hero) or heroEquipCanUpdate(hero) then
        return true
    end
    return false
end

--列表中 觉醒 技能 装备是否有更新状态
function hasHeroSystemCanUpdate()
    for i,v in ipairs(HeroListData.heroList) do
        if heroSystemCanUpdate(v) then
            return true
        end
    end
    for i,v in ipairs(HeroListData.unActList) do
        if heroCanActive(v) then
            return true
        end
    end
    return false
end

--英雄装备强化费用
function heroAllStrenCost(hero,type_)
    local cost = 0
    local heroLv = hero.level
    for i=1,#hero.equip do
        if hero.equip[i] ~= 0 then
            if type_ == 1 then
                cost = cost + hero.equip[i]:oneCost(heroLv)
            elseif type_ == 2 then
                cost = cost + hero.equip[i]:moreCost(heroLv)
            end
        end
    end
    return cost
end

--英雄装备位置
function getEquipPos(hero,uId)
    for i=1,#hero.equip do
        if hero.equip[i] ~= 0 then
            if hero.equip[i]:getLastUid() == uId then
                return i
            end
        end
    end
    return nil
end

--是否有英雄能激活
function heroCanActive(hero)
    local needNum = hero.stoneNum
    local stoneNum = ItemData:getItemCountWithId(hero.stoneId)
    if stoneNum >= needNum then
        return true
    end
    return false
end

--是否存在经验药水
function haveExpItem()
    for i=1,#EXP_ITEM do
        local count = ItemData:getItemCountWithId(EXP_ITEM[i])
        if count > 0 then
            return true
        end
    end
    return false
end