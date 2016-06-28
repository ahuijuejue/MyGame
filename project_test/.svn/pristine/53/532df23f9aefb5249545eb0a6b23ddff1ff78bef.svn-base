--
-- Author: zsp
-- Date: 2014-12-21 16:34:29
--

local StateBase = import(".StateBase")
local MemberSkillState = class("MemberSkillState", StateBase)

--[[
	角色的空闲状态
--]]
function MemberSkillState:enter(owner)

	owner.skillLock = true

	local num = owner.skillMgr.skillNum
	local skillId = owner.skillMgr.numMap[num]

	owner.skillMgr:resetCooldownById(skillId)
	owner:playSkill()
	 --伤害次数
    owner.__skillExecuteCount = 1

end

function MemberSkillState:execute(owner,dt)
	
end

function MemberSkillState:exit(owner)
	owner.__skillExecuteCount = 1
	owner.skillMgr:doNextSkillNum()

	owner.skillLock = false

end

function MemberSkillState:executeAnim(owner,frame,finish)
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
		
		-- if checknumber(skillRatio) == 0 then
		-- 		--todo
		-- 	--printInfo("bbbbbbbbbbbbbbbbbbb=======%s ===== %d === %s",owner.skillMgr.numMap[num],owner.__skillExecuteCount,frame)
		-- 	--dump(owner.model.skillRatioMap[num])
		-- 	--print(owner.model.skillRatioMap[num][owner.__skillExecuteCount])
		-- end
		
		owner.skillMgr:releaseSkillByNum(num,checknumber(skillRatio),isFinish)
		owner.__skillExecuteCount = owner.__skillExecuteCount + 1
	end
	
	--播放音乐 增加hit
end

return MemberSkillState