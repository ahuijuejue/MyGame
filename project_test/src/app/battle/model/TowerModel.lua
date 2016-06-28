--
-- Author: zsp
-- Date: 2015-02-07 11:08:20
--

local TowerModel = class("TowerModel")

--[[
	塔 数据模型
--]]
function TowerModel:ctor(level,data)
	
	self.level = level
	self.data  = data

	--角色配置表里读取原始属性
	self.baseProperty = {}
	--角色属性成长配置
	self.upgradeProperty = {}
	--角色计算加成后的属性 包括(属性成长 道具加成 技能加成)
	self.property = {}

	self:initBaseProperty()
	self:initUpgradeProperty()
	self:initProperty()
	
	self:setUpgradeProperty()
	self:setProperty()
end

--[[
	加载配置表基础数值属性赋值
--]]
function TowerModel:initBaseProperty()
	
	-- 基础数值属性----------------------------------------------------------------
	self.baseProperty.maxHp        = checknumber(self.data["hp"]) 			--血上限
	self.baseProperty.atk          = checknumber(self.data["atk"]) 			--物理攻击
	self.baseProperty.magicAtk     = checknumber(self.data["m_atk"])		--魔法攻击
	self.baseProperty.defense      = checknumber(self.data["defense"])		--物理防御
	self.baseProperty.magicDefense = checknumber(self.data["m_defense"])	--魔法防御
	self.baseProperty.acp          = checknumber(self.data["acp"])			--物理破防
	self.baseProperty.magicAcp     = checknumber(self.data["m_acp"])		--魔法破防
	self.baseProperty.rate         = checknumber(self.data["rate"])         --命中
	self.baseProperty.dodge        = checknumber(self.data["dodge"])        --闪避
	self.baseProperty.crit         = checknumber(self.data["crit"])         --暴击
	self.baseProperty.blood        = checknumber(self.data["blood"])		--吸血
	self.baseProperty.breakValue   = checknumber(self.data["breaks"])		--击退
	self.baseProperty.tumble       = checknumber(self.data["tumble"])       --后仰
	self.baseProperty.powerGet     = checknumber(self.data["power_get"])    
	-- 基础数值属性----------------------------------------------------------------
end

--[[
	加载配置表成长数值属性赋值
--]]
function TowerModel:initUpgradeProperty()
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
end

--[[
	加载角色公共属性赋值
--]]
function TowerModel:initProperty()
	self.name           = self.data["name"]
	self.info           = self.data["info"]
	self.type           = checkint(self.data["type"])
	self.atkInterval 	= checknumber(self.data["atk_interval"])
	
	--self.baseWalkSpeed  = checkint(self.data["speed"])
	self.missileId      = self.data["fly_id"] or ""
	self.image          = self.data["image"]
	self.damageType     = checkint(self.data["damage_type"])
	self.atkEffect      = self.data["atk_effect"]
	--self.atkEffectNum = checkint(self.data["atk_effect_num"])
	
	self.nodeOffset     = cc.p(checkint(self.data["body_box"][1]),checkint(self.data["body_box"][2]))
	self.nodeSize       = cc.size(checkint(self.data["body_box"][3]),checkint(self.data["body_box"][4]))
	self.attackOffset   = cc.p(checkint(self.data["attack_box"][1]),checkint(self.data["attack_box"][2]))
	self.attackSize     = cc.size(checkint(self.data["attack_box"][3]),checkint(self.data["attack_box"][4]))
	self.viewOffset     = cc.p(checkint(self.data["view_box"][1]),checkint(self.data["view_box"][2]))
	self.viewSize       = cc.size(checkint(self.data["view_box"][3]),checkint(self.data["view_box"][4]))

end

--[[
	重置基础数值属性值
--]]
function TowerModel:setProperty()
	for k,v in pairs(self.property) do
		self[k] = v
	end
	
	self.hp          = self.maxHp	
	self.powerGet    = self.baseProperty.powerGet 
end

--[[
	公式计算成长属性赋值基础数值属性
--]]
function TowerModel:setUpgradeProperty()
	for k,v in pairs(self.upgradeProperty) do
		self.property[k] = Formula[14](self.baseProperty[k],self.level,self.upgradeProperty[k],self.starLv)
	end
end

--[[
	设置塔等级，重新重新按等级计算属性
--]]
function TowerModel:setLevel(level)
	self.level = level
	self:setUpgradeProperty()
	self:setProperty()
	--self:updateProperty()
end

return TowerModel