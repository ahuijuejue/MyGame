--
-- Author: zsp
-- Date: 2015-04-14 11:47:38
--

local TailSkill        = import(".TailSkill")

local TailSkillManager = class("TailSkillManager")

--[[
	尾兽技能管理类
--]]
function TailSkillManager:ctor(camp)

	--尾兽技能所属阵营
	self.camp = camp

	--切换下一个技能回调
	self.onNext     = nil
	self.onCooldown = nil
	
	self.skills     = {}
	
	--技能自动释放时的编号
	-- key = 编号123 value = skillId
	self.numMap     = {}
	
	--当前技能编号
	self.skillNum   = 1
	
	self.isPaused = false

	--全部使用过后 不能再使用了
	self.isAllUsed = false

end

--[[
	添加技能
--]]
function TailSkillManager:addSkill(skillId,level)
	self.skills[skillId] = TailSkill.new(skillId,level)
	
	self.numMap[table.nums(self.skills)] = skillId

	return self.skills[skillId]
end

--[[
	设置要释放技能的id
--]]
function TailSkillManager:setReleaseSkillById(skillId)
	local num     = table.keyof(self.numMap,skillId)
	self.skillNum = num
end

function TailSkillManager:setReleaseSkillByNum(num)
	self.skillNum = num
end

--[[
	获取技能总数
--]]
-- function TailSkillManager:getTotal()
-- 	-- body
-- 	return table.nums(self.skills)
-- end

--[[
	设置下一个技能编号
--]]
function TailSkillManager:doNextSkillNum()
	-- body
	local num = self.skillNum
	num = num + 1
	
	if num > table.nums(self.skills) then
		num = 1
		self.isAllUsed = true
	end

	self.skillNum = num

	if self.onNext then
		self.onNext(self.numMap[num])
	end
end


function TailSkillManager:update(dt)

	if self.isAllUsed then
		return
	end
	-- body
	if self.isPaused then
		return
	end

	local skill = self:getSkillByCurrent()
	if skill then
		skill:update(dt)
		if self.onCooldown then
			self.onCooldown(skill.skillId,skill.dtCooldown,skill.cd_time)
		end
	end

end


--[[
	按编号获取技能 起始为1
--]]
function TailSkillManager:getSkillByNum(num)
	-- body
	
	local sid = self.numMap[num]
	return self.skills[sid]
end

--[[
	按技能id获取
--]]
function TailSkillManager:getSkillById(skillId)
	-- body
	return self.skills[skillId]
end

--[[
	获取当前技能
--]]
function TailSkillManager:getSkillByCurrent()
	-- body
	return self:getSkillByNum(self.skillNum)
end

-- --[[
-- 	释放指定技能的id
-- --]]
-- function TailSkillManager:releaseSkillById( sid , skillRatio, isFinish)
-- 	self.skills[sid]:doRelease(skillRatio,isFinish)
-- end

-- --[[
-- 	释放第几个技能
-- --]]
-- function TailSkillManager:releaseSkillByNum( num ,skillRatio, isFinish)
-- 	-- body
-- 	local sid = self.numMap[num]
-- 	self:releaseSkillById(sid,skillRatio,isFinish)
-- end


--[[
 	技能是否能使用
--]]
function TailSkillManager:checkEnableById(sid)
	

	local skill = self:getSkillById(sid)
	--释放技能的角色异常
	if BattleManager.getLeader(self.camp) == nil 
	or BattleManager.getLeader(self.camp):isActive() == false then
		return false
	end

	--角色行动被禁用
	-- if self.owner.disabled then
	-- 	return false
	-- end

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

	return true
end

--[[
	检测技能是否可用
--]]
function TailSkillManager:checkEnableByNum(num)
	local sid = self.numMap[num]
	return self:checkEnableById(sid)
end

--[[
	检测当前技能是否可用
--]]
function TailSkillManager:checkEnableByCurrent()
	self:checkEnableByNum(self.skillNum)
end

--[[
	重置技能冷却 用技能id
--]]
function TailSkillManager:resetCooldownById( sid )
	-- body
	local skill = self.skills[sid]
	skill:resetCooldown()
	
	if self.onCooldown then
		self.onCooldown(skill.skillId,skill.dtCooldown,skill.cd_time)
	end
end

--[[
	重置技能冷却 用编号
--]]
function TailSkillManager:resetCooldownByNum( num )
	-- body
	local sid = self.numMap[num]
	self:resetCooldownById(sid)
end

--[[
	重置全部的技能冷却时间
--]]
function TailSkillManager:resetCooldown()
	for k,v in pairs(self.skills) do
		v:resetCooldown()
		
		if self.onCooldown then
			self.onCooldown(skill.skillId,skill.dtCooldown,skill.cd_time)
		end
	end
end

--[[
	设置全部技能冷却时间完成
--]]
function TailSkillManager:setCooldownFinish()
	for k,v in pairs(self.skills) do
		v:setCooldownFinish()

		if self.onCooldown then
			self.onCooldown(v.skillId,v.dtCooldown,v.cd_time)
		end

	end
end

function TailSkillManager:setPause(pause)
	self.isPaused = pause
end

return TailSkillManager