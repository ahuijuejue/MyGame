--
-- Author: zsp
-- Date: 2014-12-04 14:40:49
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local BattleEvent = require("app.battle.BattleEvent")
local StateBase = import(".StateBase")

local LeaderSkillState = class("LeaderSkillState", StateBase)

--[[
	角色的释放技能状态
--]]
function LeaderSkillState:enter(owner)
	
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
 	

	--变身后的角色不发送技能特效事件
	if num < 3 then
		return
	end

   --发送技能特效开启事件
   BattleEvent:dispatchEvent({
      name    = BattleEvent.SKILL_EFFECT_BEGIN,
      sender  = owner,
      skillId = skillId,
    })

   --n秒后发送技能特效结束事件 
   if self.handle then
   		scheduler.unscheduleGlobal(self.handle)
   		self.handle = nil
   end
  
   self.handle = scheduler.performWithDelayGlobal(function()
		BattleEvent:dispatchEvent({
			name    = BattleEvent.SKILL_EFFECT_END,
			sender  = owner,
			skillId = skillId,
		})
  end, 1)

end

function LeaderSkillState:execute(owner,dt)
	
end

function LeaderSkillState:exit(owner)
	if owner.auto then
		owner.skillMgr:doNextSkillNum()
	end

	owner.__skillExecuteCount = 1
	owner.skillLock = false
end

function LeaderSkillState:executeAnim(owner,frame,finish)


	local num = owner.skillMgr.skillNum
	local frameMap = owner:getSkillFrameMap(num)
	local unlocakFrame = owner:getSkillUnLockFrame(num)

	BattleSound.playSkill(owner.roleId,num,frame)

	if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false and unlocakFrame ~= frame then
		return
	end

	if finish then
		--todo
		owner:doIdle()
		--owner.skillLock = false
	else

		local isFinish = (table.nums(frameMap) == owner.__skillExecuteCount)
		local skillRatio = owner.model.skillRatioMap[num][owner.__skillExecuteCount]

		owner.skillMgr:releaseSkillByNum(num,checknumber(skillRatio),isFinish)
		owner.__skillExecuteCount = owner.__skillExecuteCount + 1

		--释放技能最后一个生效帧 解锁移动
		if unlocakFrame == frame then
			owner.skillLock = false
		end

	end
	
	--播放音乐 增加hit
end

return LeaderSkillState