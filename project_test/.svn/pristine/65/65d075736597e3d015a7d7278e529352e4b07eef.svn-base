--
-- Author: zsp
-- Date: 2015-01-26 18:24:07
--

local Skill        = import(".Skill")

local EnterSkillManager = class("EnterSkillManager")

--[[
	角色登场技能管理类 替补队员登场时释放
--]]
function EnterSkillManager:ctor(owner)

--------------------------------------------------------------------------------------
---- 技能冷却进度回调接口，提供给界面显示用
--------------------------------------------------------------------------------------
	
	--[[
		冷却时间回调，用于界面上显示进度条
	--]]

	self.owner    = owner
	self.strongLv = self.owner.model.strongLv
	
	
	if self.owner.model:mWaterTime() > 0 then
		--进场cd时间
		local cfgEnterCd = self.owner.model.data["enter_cd"]
		local cfgHpCd    = self.owner.model.data["hp_cd"]
		local cfgSkill   =  self.owner.model.data["enter_skill"]

		self.owner.model.enterCd = checkint(cfgEnterCd[#cfgEnterCd]) 
		self.owner.model.hpCd    = checkint(cfgEnterCd[#cfgHpCd]) 
		self.owner.model.enterSkillId  = cfgSkill[#cfgSkill] 

		self.skillId  = self.owner.model.enterSkillId
		self.skill  = Skill.new(self.skillId,self.owner,self.strongLv + 1)
	end
	
	if self.owner.model.strongLv > 0 then
		self.skillId = self.owner.model.enterSkillId
		self.skill  = Skill.new(self.skillId,self.owner,self.strongLv + 1)
	end

end

function EnterSkillManager:releaseSkill()
	if self.skill then
		print(string.format("角色roleId = %s 释放登场技 skillId = %s", self.owner.roleId,self.skill.skillId))
		self.skill:doRelease(1,true)
	end
end

function EnterSkillManager:getSkill()
	return self.skill
end

return EnterSkillManager
