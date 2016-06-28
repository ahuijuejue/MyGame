--
-- Author: zsp
-- Date: 2014-11-26 10:07:28
--

local StateBase = import(".StateBase")
local EnemyAttackDelayState = class("EnemyAttackDelayState", StateBase)

--[[
	攻击间隔
--]]
function EnemyAttackDelayState:enter(owner)
	owner:playIdle()
	--printInfo("roleId = %s 攻击间隔=%d",owner.roleId,owner.model.atkInterval)
end

function EnemyAttackDelayState:execute(owner,dt,frame)
	
	owner.dtAtkInterval = owner.dtAtkInterval + dt

	if owner.dtAtkInterval >  owner.model.atkInterval then
		owner:doIdle()
		return
	end

	if frame % 5 ~= 0 then
		return
	end
	
	local hasEnemy = owner:hasViewRange()

	if owner:autoRealseSkill(hasEnemy) then
		return
	end 

	-- if hasEnemy then
	-- 	owner:doIdle()
	-- 	return
	-- end
	
end

function EnemyAttackDelayState:exit(owner)
	-- body
	owner.dtAtkInterval = 0
end

function EnemyAttackDelayState:executeAnim(owner,frame,finish)
	-- body
end

return EnemyAttackDelayState