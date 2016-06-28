--
-- Author: zsp
-- Date: 2014-12-23 15:44:17
--
local StateBase = import(".StateBase")
local EnemySkillState = class("EnemySkillState", StateBase)

--[[
	角色的空闲状态
--]]
function EnemySkillState:enter(owner)
	owner.skillLock = true

	local num = owner.skillMgr.skillNum
	local skillId = owner.skillMgr.numMap[num]

	owner.skillMgr:resetCooldownById(skillId)
	owner:playSkill()

	 --伤害次数
   	owner.__skillExecuteCount = 1

   	
 	if num > 1 then
 		owner:showSkillName(owner.skillMgr.skills[skillId].name)
 	end

end

function EnemySkillState:execute(owner,dt)
	
end

function EnemySkillState:exit(owner)
	--if owner.auto then
		owner.skillMgr:doNextSkillNum()
	--end
	owner.__skillExecuteCount = 1

	owner.skillLock = false
end

function EnemySkillState:executeAnim(owner,frame,finish)
	local num = owner.skillMgr.skillNum
	local frameMap = owner:getSkillFrameMap(num)
	
	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
		return
	end

	if finish then
		--todo
		owner:doIdle()
	else

		local isFinish = (table.nums(frameMap) == owner.__skillExecuteCount)
		local skillRatio = owner.model.skillRatioMap[num][owner.__skillExecuteCount]
		owner.skillMgr:releaseSkillByNum(num,checknumber(skillRatio),isFinish)
		owner.__skillExecuteCount = owner.__skillExecuteCount + 1
	end
	
	--播放音乐 增加hit
end

return EnemySkillState