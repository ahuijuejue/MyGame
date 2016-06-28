--
-- Author: zsp
-- Date: 2014-11-20 16:25:34
--
local RoleModel = class("RoleModel")

--[[
	角色的数据模型基类 包扩敌人和英雄的共有属性设置
--]]
function RoleModel:ctor(data)
	self.data = data
	
	--角色配置表里读取原始属性
	self.baseProperty = {}
	--角色属性成长配置
	self.upgradeProperty = {}
	--角色计算加成后的属性 包括(属性成长 道具加成 技能加成)
	self.property = {}

	--加载基础属性配置数据 子类重写
	self:initBaseProperty()
	--初始化成长属性数据
	self:initUpgradeProperty()
	--初始化通用属性
	self:initProperty()
	--计算成长属性
	self:setUpgradeProperty()
end


function RoleModel:initUpgradeProperty()

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

function RoleModel:initProperty()
	self.name = self.data["name"]
	self.info = self.data["info"]
	self.missileId       = self.data["fly_id"] or ""
	self.image           = self.data["image"]
	self.damageType      = checkint(self.data["damage_type"])
	self.atkEffect       = self.data["atk_effect"]
	
	self.nodeOffset      = cc.p(checkint(self.data["body_box"][1]),checkint(self.data["body_box"][2]))
	self.nodeSize        = cc.size(checkint(self.data["body_box"][3]),checkint(self.data["body_box"][4]))
	self.attackOffset    = cc.p(checkint(self.data["attack_box"][1]),checkint(self.data["attack_box"][2]))
	self.attackSize      = cc.size(checkint(self.data["attack_box"][3]),checkint(self.data["attack_box"][4]))
	self.viewOffset      = cc.p(checkint(self.data["view_box"][1]),checkint(self.data["view_box"][2]))
	self.viewSize        = cc.size(checkint(self.data["view_box"][3]),checkint(self.data["view_box"][4]))
	self.maxAnger    = 400
	
   	self.skillRatioMap = {}
   	self.skillids = {}
   	self:setSkillsId()
end

--[[
	重置属性值
--]]
function RoleModel:setProperty()
	for k,v in pairs(self.property) do
		self[k] = v
	end
	
	self.hp          = self.maxHp	
	self.powerGet    = self.baseProperty.powerGet 
	self.powerConsum = self.baseProperty.powerConsum 
	self.animSpeed   = self.baseProperty.animSpeed 
	self.walkSpeed   = self.baseProperty.walkSpeed 

	self.anger       = 0
end

function RoleModel:setUpgradeProperty()
	-- self.level 是在子类里设置的
	for k,v in pairs(self.upgradeProperty) do
		if k == "breakValue" or k == "tumble" then
			self.property[k] = Formula[14](self.baseProperty[k],self.level,self.upgradeProperty[k],self.starLv,0)
		else
			self.property[k] = Formula[14](self.baseProperty[k],self.level,self.upgradeProperty[k],self.starLv)
		end	
	end
end

-- 设置英雄技能
function RoleModel:setSkillsId()
	local count = 3
	if self.starLv and self.starLv <= 1 then
		count = 2
	end
	for i=1,count do
		local sid = self.data[string.format("skill%d",i)]
   		local ratio = self.data[string.format("skill%d_ratio",i)]
   		if sid ~= "0" then
   			self.skillids[i] = sid
   			local ratioArr = string.split(ratio, ",")
   			self.skillRatioMap[i] = ratioArr
   		end
	end
end

return RoleModel