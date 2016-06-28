--
-- Author: zsp
-- Date: 2015-01-24 09:56:54
--

local AwakeSkillManager = class("AwakeSkillManager")

--[[
	队长觉醒技能管理，当队长觉醒时，按队长品质一次触发
--]]
function AwakeSkillManager:ctor(owner)
	self.owner = owner

	printInfo("roleId = %s 执行队长技能",self.owner.roleId)

	-- strongLv 只能激活前5条

	
	-- 	直接激活了6项强化 忽略strongLv 激活队长技能

	-- if memberWater > 0
	-- 	直接激活了6项强化 忽略strongLv 激活登场技
	self:releaseSkill()
end

function AwakeSkillManager:releaseSkill()

	if self.owner.model:lWaterTime() > 0 then
		self:releaseAll()
		return	
	end

	if self.owner.model.strongLv > 0 then
		for i=1,self.owner.model.strongLv do
			self[string.format("release%d",i)](self)
		end
	end
end
	
--[[
	可以在战斗中变身
--]]
function AwakeSkillManager:release1()
	--为了提前加载变身后资源 创建model构造中设置过一次 
	printInfo("roleId=%s,释放队长技1,可以在战斗中变身",self.owner.roleId)
	self.owner.evolve = true
end

--[[
	初始怒气增加25%
--]]
function AwakeSkillManager:release2()
	printInfo("roleId=%s,释放队长技2,初始怒气增加",self.owner.roleId)
	local anger = self.owner.model.maxAnger * 0.25
	self.owner:appendAnger(anger)
end

--[[
	变身前怒气获得增加5
--]]
function AwakeSkillManager:release3()
	printInfo("roleId=%s,释放队长技3,变身前怒气获得增加1",self.owner.roleId)
	self.owner.addAnger = 3
end

--[[
	变身后怒气消耗减少
--]]
function AwakeSkillManager:release4()
	printInfo("roleId=%s,释放队长技4,变身后怒气消耗减少",self.owner.roleId)
	--创建变身时 会复制值给变身后的角色
	self.owner.subAnger = 1
end

--[[
	变身后怒气获得增加5
--]]
function AwakeSkillManager:release5()
	printInfo("roleId=%s,释放队长技5,变身后怒气获得增加1",self.owner.roleId)
	self.owner.evolveAddAnger = 3
end

--[[
	变身后技能无初始CD
--]]
function AwakeSkillManager:release6()
	printInfo("roleId=%s,释放队长技6,变身后技能无初始CD",self.owner.roleId)
	self.owner.isSkillCooldownEnable = true
end

--[[
	觉醒全部技能
--]]
function AwakeSkillManager:releaseAll()
	for i=1,6 do
		self[string.format("release%d",i)](self)
	end
end

return AwakeSkillManager