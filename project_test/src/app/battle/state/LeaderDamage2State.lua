--
-- Author: zsp
-- Date: 2014-11-24 17:21:52
--
local StateBase = import(".StateBase")

local LeaderDamage2State = class("LeaderDamage2State", StateBase)

--[[
	角色的空闲状态
--]]
function LeaderDamage2State:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入受伤2")
	owner:playDamage2()
	
	if owner.camp == GameCampType.right  then
		if owner:getPositionX() + owner.tumbleDistance < BattleManager.sceneWidth then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(owner.tumbleDistance,0))
			))
		end
	else
		if owner:getPositionX() - owner.tumbleDistance > 0 then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(-owner.tumbleDistance,0))
			))
		end
	end
end

function LeaderDamage2State:execute(owner,dt)
	
end

function LeaderDamage2State:exit(owner)
	-- body
end

function LeaderDamage2State:executeAnim(owner,frame,finish)

	BattleSound.playDamage(owner.roleId,2,frame)

	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return LeaderDamage2State