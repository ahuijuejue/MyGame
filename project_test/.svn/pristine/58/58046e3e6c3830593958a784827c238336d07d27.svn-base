--
-- Author: zsp
-- Date: 2014-11-26 10:29:36
--
local StateBase = import(".StateBase")

local EnemyDamage2State = class("EnemyDamage2State", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyDamage2State:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤1")
	owner:playDamage2()

	local tumbleDistance = owner.tumbleDistance or 0
	if owner.camp == GameCampType.right  then
		if owner:getPositionX() + tumbleDistance < BattleManager.sceneWidth  then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(tumbleDistance,0))
			))
		end
	else
		if owner:getPositionX() - tumbleDistance > 0  then
			owner:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.1,cc.p(-tumbleDistance,0))
			))
		end
	end

end

function EnemyDamage2State:execute(owner,dt)
	
end

function EnemyDamage2State:exit(owner)
	-- body
end

function EnemyDamage2State:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return EnemyDamage2State