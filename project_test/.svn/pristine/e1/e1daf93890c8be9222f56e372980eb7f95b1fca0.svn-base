--
-- Author: zsp
-- Date: 2014-11-25 18:11:23
--

local RoleModel = import(".RoleModel")

--[[
	敌人的数据模型封装 读取配置后做 属性加成等计算
--]]
local EnemyModel = class("EnemyModel",RoleModel)

function EnemyModel:ctor(params)
	self.roleId = params.roleId or "1"
	self.level  = params.level or 1
	local skillLv = params.skillLevel or 1

	--dump(params,self.roleId)

	--todo 技能等级 skillLevel 是key 是skillId
	--self.skillLevel = {skillLevel,skillLevel,skillLevel}
	--cfg.level
	EnemyModel.super.ctor(self,GameConfig.enemy[self.roleId])

	self.skillLevel = {}
	for k,v in pairs(self.skillids) do
		self.skillLevel[v] = skillLv
	end

	--dump(self.skillLevel,self.roleId)

	--设置敌人特有的属性
	self:setEnemyProperty()
	self:setProperty()
end

function RoleModel:initBaseProperty()
	-- 角色属性----------------------------------------------------------------
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


	-- 角色属性----------------------------------------------------------------
end


function EnemyModel:setEnemyProperty()

	self.nodeScale   = checknumber(self.data["node_scale"])
	self.atkInterval = checknumber(self.data["atk_interval"])
	self.deadFrame   = self.data.dead_frame
	--self.loot      = self.data.loot
	self.type        = checkint(self.data["type"])
	self.parameter   = {}

	if self.data.Parameter then
		for i=1,#self.data.Parameter do
			local data = self.data.Parameter[i]
			local tb = string.split(data,":")
			local k = tb[1]
			local v = checknumber(tb[2])
			self.parameter[k] = v
		end
	end
	
	if self.data.boss == "1" then
		self.boss = true
	else
		self.boss = false
	end
end


return EnemyModel