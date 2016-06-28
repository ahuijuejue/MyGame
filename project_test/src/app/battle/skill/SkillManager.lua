--
-- Author: zsp
-- Date: 2014-12-02 18:54:39
--

local Skill        = import(".Skill")

local SkillManager = class("SkillManager")

--[[
	角色技能管理类 负责管理SkillBase的扩展子类
--]]
function SkillManager:ctor(owner)

--------------------------------------------------------------------------------------
---- 技能冷却进度回调接口，提供给界面显示用
--------------------------------------------------------------------------------------
	
	--[[
		冷却时间回调，用于界面上显示进度条
	--]]
	-- function SkillManager:onCooldown(role,skillId,dt,cooldown)
	-- end

	self.onCooldown = nil

	self.owner      = owner
	
	self.skills     = {}
	
	--技能自动释放时的编号
	-- key = 编号123 value = skillId
	self.numMap     = {}
	
	--当前技能编号
	self.skillNum   = 1
	
	self.isPaused = false

end

--[[
	设置要释放技能的id
--]]
function SkillManager:setReleaseSkillById(skillId)
	local num = table.keyof(self.numMap,skillId)
	--dump(value, desciption, nesting)
	self.skillNum = num
end

function SkillManager:setReleaseSkillByNum( num )
	self.skillNum = num
end

--[[
	获取技能总数
--]]
function SkillManager:getTotal()
	-- body
	return table.nums(self.skills)
end

--[[
	设置下一个技能编号
--]]
function SkillManager:doNextSkillNum()
	-- body
	local num = self.skillNum
	num = num + 1
	
	if num > #self.skills then
		num = 1
	end

	self.skillNum = num
end


function SkillManager:update(dt)
	-- body
	if self.isPaused then
		return
	end

	for k,v in pairs(self.skills) do
		v:update(dt)
		if self.onCooldown ~= nil then
			self.onCooldown(self.owner,v.skillId,v.dtCooldown,v.cd_time)
		end
	end
end

--[[
	添加技能
--]]
function SkillManager:addSkill(skillId,num,level)
	
	self.skills[skillId] = Skill.new(skillId,self.owner,level)
	
	self.numMap[num] = skillId

	return self.skills[skillId]
end

--[[
	按编号获取技能 起始为1
--]]
function SkillManager:getSkillByNum(num)
	-- body
	local sid = self.numMap[num]
	return self.skills[sid]
end

--[[
	按技能id获取
--]]
function SkillManager:getSkillById(skillId)
	-- body
	return self.skills[skillId]
end

--[[
	获取当前技能
--]]
function SkillManager:getSkillByCurrent()
	-- body
	return self:getSkillByNum(self.skillNum)
end

--[[
	释放指定技能的id
--]]
function SkillManager:releaseSkillById( sid , skillRatio, isFinish)
	self.skills[sid]:doRelease(skillRatio,isFinish)
end

--[[
	释放第几个技能
--]]
function SkillManager:releaseSkillByNum( num ,skillRatio, isFinish)
	-- body
	local sid = self.numMap[num]
	self:releaseSkillById(sid,skillRatio,isFinish)
end

--[[
	重置技能冷却 用技能id
--]]
function SkillManager:resetCooldownById( sid )
	-- body
	self.skills[sid]:resetCooldown()
end

--[[
	重置技能冷却 用编号
--]]
function SkillManager:resetCooldownByNum( num )
	-- body
	local sid = self.numMap[num]
	self:resetCooldownById(sid)
end

--[[
 	技能是否能使用
--]]
function SkillManager:checkEnableById(sid)
	local skill = self:getSkillById(sid)

	--释放技能的角色异常
	if self.owner:isActive() == false then
		--todo
		return false
	end

	--角色行动被禁用
	if self.owner.disabled then
		return false
	end

	--没有释放的技能
	if table.nums(self.skills) == 0 then
		--todo
		return false
	end

	--释放的技能没有找到
	if skill == nil then
		--todo
		return false
	end

	--技能冷却时间未到
	if not skill:isCooldown() then
		--todo
		return false
	end

	--沉默不能释放
	if table.nums(self.owner.buffMgr:getSilentBuff()) > 0 then
		--todo
		return false
	end

	--自动控制角色，条件满足后，没有释放目标
	if self.owner.auto then
		local tb = self.owner:findSkillRange(sid)
		if table.nums(tb) ==0 then
			return false
		end
	end

	return true
end

--[[
	检测技能是否可用
--]]
function SkillManager:checkEnableByNum(num)
	local sid = self.numMap[num]
	return self:checkEnableById(sid)
end

--[[
	检测当前技能是否可用
--]]
function SkillManager:checkEnableByCurrent()
	self:checkEnableByNum(self.skillNum)
end

--[[
	重置全部的技能冷却时间
--]]
function SkillManager:resetCooldown()
	for k,v in pairs(self.skills) do
		v:resetCooldown()
		if self.onCooldown ~= nil then
			self.onCooldown(self.owner,v.skillId,v.dtCooldown,v.cd_time)
		end
	end
end

--[[
	设置全部技能冷却时间完成
--]]
function SkillManager:setCooldownFinish()
	for k,v in pairs(self.skills) do
		v:setCooldownFinish()
		if self.onCooldown ~= nil then
			self.onCooldown(self.owner,v.skillId,v.dtCooldown,v.cd_time)
		end
	end
end


function SkillManager:setPause(pause)
	self.isPaused = pause
end

return SkillManager