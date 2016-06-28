--
-- Author: zsp
-- Date: 2014-11-20 22:40:20
--
local RoleModel      = import(".RoleModel")
local CharacterModel = class("CharacterModel",RoleModel)
--[[
	角色的数据模型
--]]
function CharacterModel:ctor(params)
	self.roleId      = params.roleId or "1"
	--英雄星级
	self.starLv      = params.starLv or 0
	--英雄觉醒等级
	self:setHeroAwakeLevel(params.strongLv or 0)
	--超神水到期时间
	self.leaderWater = params.leaderWater or 0
	--超圣水到期时间
	self.memberWater = params.memberWater or 0
	--英雄总经验
	self.exp         = params.exp or 0
	--英雄角色等级
	self.level       = params.level or GameExp.getLevel(self.exp)
	--所属用户id
	self.userId = nil
	--所属战队id
	self.teamId = nil
	--所属战队名
	self.teamName = nil
	--派出时间
	self.sendTime = nil
	--雇佣次数
	self.useTimes = nil

	if checkint(self.roleId) % 2 ~= 0 then
		--是否能变身 外部传入参数优先
		self.evolve = params.evolve
	end

	--英雄镶嵌的宝石
	self.stones      = params.stone or {0,0,0,0,0}
	local stoneData = params.stones or {}
	for i=1,#stoneData do
		local pos = tonumber(stoneData[i].param2)
		self.stones[pos] = stoneData[i].param1
	end

	--英雄镶嵌的英雄硬币数量
	self.coinNums = {0,0,0,0,0,0}
	local coinData = params.coins or {}
	for i=1,#coinData do
		local pos = coinData[i].param2
		self.coinNums[pos] = tonumber(coinData[i].param3)
	end
	--英雄装备
	self.equip = params.equip or {0,0,0,0,0,0}

	--英雄装备强化加成等级
	self.equipStrLv = 0
	--英雄装备进阶加成等级
	self.equipAdvLv = 0
	--英雄装备加护加成等级
	self.equipPlusLv = 0

	local config = GameConfig.character[self.roleId]
	CharacterModel.super.ctor(self,config)

	--英雄技能ID
	self.skills = {}
	--英雄技能等级，变身后角色会通过参数传入
	self.skillLevel = params.skillLevel or {}

	if not params.skillLevel then
		local skillLevels = params.skillLvList or {}
		--初始化角色技能等级
		for i=1,4 do
			local sId = config[string.format("skill%d",i)]
			self.skills[i] = sId
			self.skillLevel[sId] = skillLevels[i] or 1
		end
	end

	--变身前角色会通过服务器数据初始化参数传入，设置角色的技能等级
	local skillData = params.skills or {}
	for i=1,#skillData do
		local key = skillData[i].param2
		local value = skillData[i].param1
		self.skillLevel[key] = tonumber(value)
	end

	--英雄战斗力
	self.power       = self:getHeroTotalPower()

	HeroAbility.loadAllEquip(self)
	HeroAbility.loadAllStone(self)
	HeroAbility.strAbilityExtra(self)
	HeroAbility.advAbilityExtra(self)
	HeroAbility.plusAbilityExtra(self)

	--被动技能加层
	self:skillExtra()
	--封印加成
	self:sealExtra()

	self:setCharacterProperty()

   --变身后角色总体属性放大 todo 提供基础属性放大接口
	if checkint(self.roleId) % 2 == 0 then
		self.property.maxHp        = math.ceil(self.property.maxHp * tonumber(self.data["hp"])) 					--血上限
		self.property.atk          = math.ceil(self.property.atk * tonumber(self.data["atk"]))					--物理攻击
		self.property.magicAtk     = math.ceil(self.property.magicAtk * tonumber(self.data["m_atk"]))			--魔法攻击
		self.property.defense      = math.ceil(self.property.defense * tonumber(self.data["defense"]))			--物理防御
		self.property.magicDefense = math.ceil(self.property.magicDefense * tonumber(self.data["m_defense"]))	--魔法防御
		self.property.acp          = math.ceil(self.property.acp * tonumber(self.data["acp"]))					--物理破防
		self.property.magicAcp     = math.ceil(self.property.magicAcp * tonumber(self.data["m_acp"]))			--能量破防
		self.property.rate         = math.ceil(self.property.rate * tonumber(self.data["rate"]))					--命中
		self.property.dodge        = math.ceil(self.property.dodge * tonumber(self.data["dodge"]))				--闪避
		self.property.crit         = math.ceil(self.property.crit * tonumber(self.data["crit"]))					--暴击
		self.property.blood        = math.ceil(self.property.blood * tonumber(self.data["blood"]))				--吸血
		self.property.breakValue   = math.ceil(self.property.breakValue * tonumber(self.data["breaks"]))			--打断
		self.property.tumble       = math.ceil(self.property.tumble * tonumber(self.data["tumble"]))				--击退
	end

	--创建角色可传入放大属性参数
	if params.propertyScale then
		self.propertyScale = params.propertyScale
		self.property.maxHp        = math.ceil(self.property.maxHp * params.propertyScale.hp )
		self.property.atk          = math.ceil(self.property.atk * params.propertyScale.atk)
		self.property.magicAtk     = math.ceil(self.property.magicAtk * params.propertyScale.m_atk)
		self.property.defense      = math.ceil(self.property.defense * params.propertyScale.defense)
		self.property.magicDefense = math.ceil(self.property.magicDefense * params.propertyScale.m_defense)
		self.property.acp          = math.ceil(self.property.acp * params.propertyScale.acp)
		self.property.magicAcp     = math.ceil(self.property.magicAcp * params.propertyScale.m_acp)
		self.property.rate         = math.ceil(self.property.rate * params.propertyScale.rate)
		self.property.dodge        = math.ceil(self.property.dodge * params.propertyScale.dodge)
		self.property.crit         = math.ceil(self.property.crit * params.propertyScale.crit)
		self.property.blood        = math.ceil(self.property.blood * params.propertyScale.blood)
		self.property.breakValue   = math.ceil(self.property.breakValue * params.propertyScale.breaks)
		self.property.tumble       = math.ceil(self.property.tumble * params.propertyScale.tumble)
	end

	self:setProperty()
end

function CharacterModel:setHeroConfig(need)
	local heroData 	 = GameConfig.Hero[self.roleId]
	--战斗插画
	self.battleImage = heroData.HeroMorph
	--抽卡插画
	self.summonImage = heroData.HeroImage
	--英雄名
	self.name = heroData.Name
	--英雄灵魂石对应物品ID
	self.stoneId     = heroData.SummonItemID
	--召唤英雄所需灵魂石个数
	self.stoneNum    = tonumber(heroData.SummonItemNum)
	--英雄头像文件
	self.avatarImage = heroData.Icon
	--英雄类型 1肉盾2输出3辅助
	self.roleType    = tonumber(heroData.HeroType)
	--英雄类型图片
	self.jobImage = heroData.HeroJob
	--英雄位置 1前排2中排3后排
	self.rangeType = tonumber(heroData.HeroRange)
	--英雄兑换灵魂石个数
	self.exchangeStoneNum = tonumber(heroData.ReexchangeItemNum)
	--英雄性别
	self.sex = tonumber(heroData.Sex)
	--初始星级
	self.initStarLv = tonumber(heroData.InitialSkillName)
end

function CharacterModel:setHeroAwakeLevel(level)
	self.stones = {0,0,0,0,0}
	self.awakeLevel = level
	self.strongLv = getAwakeLevel(level)[1]
end

function CharacterModel:getHeroName(awakeLevel)
	local num
	if awakeLevel then
		num = getAwakeLevel(awakeLevel)[2]
	else
		num = getAwakeLevel(self.awakeLevel)[2]
	end
	local name = self.name
	if num > 0 then
		name = self.name.."+"..num
	end
	return name
end

--获取英雄战斗力
function CharacterModel:getHeroPower(level,starLv,awakeLevel)
	if level or starLv or awakeLevel then
		local power =(500+(level-1)*50)*(1+(starLv-1)*0.15)*(1+(awakeLevel-1)*0.05)
		return power
	else
		local power =(500+(self.level-1)*50)*(1+(self.starLv-1)*0.15)*(1+(self.awakeLevel-1)*0.05)
		return power
	end
end


--获取技能战斗力
function CharacterModel:getSkillPower()
	local power = 0
	for i,v in ipairs(self.skills) do
		local lv = self.skillLevel[v]
		if lv then
			power = power + (15+(lv-1)*15*i)
		end
	end
	return power
end

--获取装备战斗力
function CharacterModel:getEquipPower()
	local power = 0
	for i,v in ipairs(self.equip) do
		if v ~= 0 then
			power = power + v:getPower()
		end
	end
	return math.floor(power)
end

--获取宝石战斗力
function CharacterModel:getStonePower()
	local power = 0
	for i,v in ipairs(self.stones) do
		if v ~= 0 then
			local item = GameConfig.item[v]
		    power = power + (40+10*item.Quality)
		end
	end

	--计算镶嵌过的宝石战斗力
	if self.awakeLevel > 0 then
		local awakeInfo = GameConfig.hero_awake[self.roleId]
		if awakeInfo then
			for i=1,self.awakeLevel do
				local key = string.format("ItemID%d", i)
				local itemIds = awakeInfo[key]
				for i=1,#itemIds do
					local item = GameConfig.item[itemIds[i]]
					power = power + (40+10*item.Quality)
				end
			end
		end
	end

	return power
end

--获取英雄总战斗力
function CharacterModel:getHeroTotalPower(level,starLv,awakeLevel)
	if level or starLv or awakeLevel then
		local power = self:getHeroPower(level,starLv,awakeLevel) + self:getSkillPower() + self:getEquipPower() + self:getStonePower()
		return math.floor(power)
	else
		local power = self:getHeroPower() + self:getSkillPower() + self:getEquipPower() + self:getStonePower()
		return math.floor(power)
	end
end

--超神水剩余时间
function CharacterModel:lWaterTime()
	local left = self.leaderWater - UserData.curServerTime
	return left
end

--超圣水剩余时间
function CharacterModel:mWaterTime()
	local left = self.memberWater - UserData.curServerTime
	return left
end

--[[
	设置角色等级，重新重新按等级计算角色属性
--]]
function CharacterModel:setLevel(level)
	self.level = level
	self:updateProperty()
end

--[[
	设置星级
--]]
function CharacterModel:setStarLevel(starLv)
	self.starLv = starLv
	self:updateProperty()
	self:setSkillsId()
end

--[[
	更新属性属性
--]]
function CharacterModel:updateProperty()
	self:setUpgradeProperty()

	HeroAbility.loadAllEquip(self)
	HeroAbility.loadAllStone(self)
	HeroAbility.strAbility(self,self.equipStrLv,1)
	HeroAbility.advAbility(self,self.equipAdvLv,1)
	HeroAbility.plusAbility(self,self.equipPlusLv,1)

	self:skillExtra()
	self:sealExtra()

	self:setProperty()
end

--[[
	角色被动技能属性加层
--]]
function CharacterModel:skillExtra()

	local sid   = self.data[string.format("skill%d",4)]
	local skill = GameConfig.skill_4[sid]
	local lv    = self.skillLevel[sid]
	local lvUp  = tonumber(skill["level_up"])
	local value = tonumber(skill["value"])
	local key   = skill["key"]

	local v = Formula[17](value,lv,lvUp)
	self.property[key] = self.property[key] + v
end

--[[
	角色封印属性加层
--]]
function CharacterModel:sealExtra()
	local sealAttr =  SealData:getAttributeForBattle()
	for k,v in pairs(sealAttr) do
		self.property[k] = self.property[k] + v
	end
end

--[[
	初始英雄基础属性值
--]]
function CharacterModel:initBaseProperty()

	self.baseProperty.maxHp        = checknumber(self.data["hp"])
	self.baseProperty.atk          = checknumber(self.data["atk"])
	self.baseProperty.magicAtk     = checknumber(self.data["m_atk"])
	self.baseProperty.defense      = checknumber(self.data["defense"])
	self.baseProperty.magicDefense = checknumber(self.data["m_defense"])
	self.baseProperty.acp          = checknumber(self.data["acp"])
	self.baseProperty.magicAcp     = checknumber(self.data["m_acp"])
	self.baseProperty.rate         = checknumber(self.data["rate"])
	self.baseProperty.dodge        = checknumber(self.data["dodge"])
	self.baseProperty.crit         = checknumber(self.data["crit"])
	self.baseProperty.blood        = checknumber(self.data["blood"])
	self.baseProperty.breakValue   = checknumber(self.data["breaks"])
	self.baseProperty.tumble       = checknumber(self.data["tumble"])

	self.baseProperty.powerGet     = checknumber(self.data["power_get"])
	self.baseProperty.powerConsum  = checknumber(self.data["power_consum"])
	self.baseProperty.animSpeed    = 1 --动画播放速度系数
	self.baseProperty.walkSpeed    = checkint(self.data["speed"])

	--变身后的角色的基础属性按变身前的倍率计算
	if checkint(self.roleId) % 2 == 0 then
		-- 获取变身前的角色基础属性----------------------------------------------------------------
		local normalData = GameConfig.character[string.format("%d", checkint(self.roleId)-1)]

		self.baseProperty.maxHp        = checknumber(normalData["hp"])
		self.baseProperty.atk          = checknumber(normalData["atk"])
		self.baseProperty.magicAtk     = checknumber(normalData["m_atk"])
		self.baseProperty.defense      = checknumber(normalData["defense"])
		self.baseProperty.magicDefense = checknumber(normalData["m_defense"])
		self.baseProperty.acp          = checknumber(normalData["acp"])
		self.baseProperty.magicAcp     = checknumber(normalData["m_acp"])
		self.baseProperty.rate         = checknumber(normalData["rate"])
		self.baseProperty.dodge        = checknumber(normalData["dodge"])
		self.baseProperty.crit         = checknumber(normalData["crit"])
		self.baseProperty.blood        = checknumber(normalData["blood"])
		self.baseProperty.breakValue   = checknumber(normalData["breaks"])
		self.baseProperty.tumble       = checknumber(normalData["tumble"])

	end
end

--[[
	初始英雄成长数据
--]]
function CharacterModel:initUpgradeProperty()

	-- 基础属性成长值-----------------------------------------------------------
	self.upgradeProperty.maxHp        = checknumber(self.data["hp_upgrade"])
	self.upgradeProperty.atk          = checknumber(self.data["atk_upgrade"])
	self.upgradeProperty.magicAtk     = checknumber(self.data["m_atk_upgrade"])
	self.upgradeProperty.defense      = checknumber(self.data["defense_upgrade"])
	self.upgradeProperty.magicDefense = checknumber(self.data["m_defense_upgrade"])
	self.upgradeProperty.acp          = checknumber(self.data["acp_upgrade"])
	self.upgradeProperty.magicAcp     = checknumber(self.data["m_acp_upgrade"])
	self.upgradeProperty.rate         = checknumber(self.data["rate_upgrade"])
	self.upgradeProperty.dodge        = checknumber(self.data["dodge_upgrade"])
	self.upgradeProperty.crit         = checknumber(self.data["crit_upgrade"])
	self.upgradeProperty.blood        = checknumber(self.data["blood_upgrade"])
	self.upgradeProperty.breakValue   = checknumber(self.data["break_upgrade"])
	self.upgradeProperty.tumble       = checknumber(self.data["tumble_upgrade"])
	-- 基础属性成长值-----------------------------------------------------------

	if checkint(self.roleId) % 2 == 0 then
		-- 获取变身前的角色基础属性----------------------------------------------------------------
		local normalData = GameConfig.character[string.format("%d", checkint(self.roleId)-1)]
		-- 基础属性成长值-----------------------------------------------------------
		self.upgradeProperty.maxHp        = checknumber(normalData["hp_upgrade"])
		self.upgradeProperty.atk          = checknumber(normalData["atk_upgrade"])
		self.upgradeProperty.magicAtk     = checknumber(normalData["m_atk_upgrade"])
		self.upgradeProperty.defense      = checknumber(normalData["defense_upgrade"])
		self.upgradeProperty.magicDefense = checknumber(normalData["m_defense_upgrade"])
		self.upgradeProperty.acp          = checknumber(normalData["acp_upgrade"])
		self.upgradeProperty.magicAcp     = checknumber(normalData["m_acp_upgrade"])
		self.upgradeProperty.rate         = checknumber(normalData["rate_upgrade"])
		self.upgradeProperty.dodge        = checknumber(normalData["dodge_upgrade"])
		self.upgradeProperty.crit         = checknumber(normalData["crit_upgrade"])
		self.upgradeProperty.blood        = checknumber(normalData["blood_upgrade"])
		self.upgradeProperty.breakValue   = checknumber(normalData["break_upgrade"])
		self.upgradeProperty.tumble       = checknumber(normalData["tumble_upgrade"])
		-- 基础属性成长值-----------------------------------------------------------
	end

end

--[[
	设置英雄特有属性
--]]
function CharacterModel:setCharacterProperty()

	self.expRatio    = self.data["exp_ratio"]
	local cfgEnterCd = self.data["enter_cd"]
	local cfgHpCd    = self.data["hp_cd"]
	local cfgSkill   = self.data["enter_skill"]

	--按角色品质的替补登场cd时间
	self.enterCd      = checkint(cfgEnterCd[self.strongLv + 1])
	self.hpCd         = checkint(cfgHpCd[self.strongLv + 1])
	self.enterSkillId = cfgSkill[self.strongLv + 1]
	self.head 		  = self.data["hero_icon"] or string.format("head_%s", self.roleId)
end

--[[
	检查是否能变身 如果能变身应该设置 evolve = true
	这个方法只针对变身前的英雄
--]]
function CharacterModel:checkEvolve()
	if checkint(self.roleId) % 2 ~= 0 then
		if  self.leaderWater > 0 or self.strongLv > 0  then
			return true
		end
	end

	return false
end

-- 设置英雄所有技能的等级
function CharacterModel:setSkillsLevel(level)
	local keys = table.keys(self.skillLevel)
	for i,v in ipairs(keys) do
		self.skillLevel[v] = level
	end
end

function CharacterModel:setTeamId(tId)
	self.teamId = tId
end

function CharacterModel:setTeamName(name)
	self.teamName = name
end

function CharacterModel:setSendTime(time)
	self.sendTime = time
end

function CharacterModel:setUseTimes(times)
	self.useTimes = times
end

function CharacterModel:setUserId(uId)
	self.userId = uId
end

return CharacterModel