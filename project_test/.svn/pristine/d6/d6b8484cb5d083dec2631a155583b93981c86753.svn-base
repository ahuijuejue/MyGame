--
-- Author: zsp
-- Date: 2015-04-08 11:53:48
--
local StateBase = import(".StateBase")

local EscortDamage2State = class("EscortDamage2State", StateBase)

--[[
	角色的空闲状态
--]]
function EscortDamage2State:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤1")
	owner:playDamage2()
	if owner.camp == GameCampType.right  then
		if owner:getPositionX() + owner.tumbleDistance < BattleManager.sceneWidth then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(owner.tumbleDistance,0))
			))
		end
	else
		if owner:getPositionX() - owner.tumbleDistance > 0  then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(-owner.tumbleDistance,0))
			))
		end
	end

end

function EscortDamage2State:execute(owner,dt)
	
end

function EscortDamage2State:exit(owner)
	-- body
end

function EscortDamage2State:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return EscortDamage2State