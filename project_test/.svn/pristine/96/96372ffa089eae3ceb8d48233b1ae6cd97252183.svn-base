--
-- Author: zsp
-- Date: 2015-06-06 12:25:35
--
local StateBase = import(".StateBase")
local TowerAttackDelayState = class("TowerAttackDelayState", StateBase)

--[[
	攻击间隔
--]]
function TowerAttackDelayState:enter(owner)
	owner:playIdle()
	--printInfo(owner.roleId.."攻击间隔")
	owner.dtAtkInterval = 0 
end

function TowerAttackDelayState:execute(owner,dt,frame)
	
	owner.dtAtkInterval = owner.dtAtkInterval + dt

	if owner.dtAtkInterval >  owner.model.atkInterval then
		owner:doIdle()
		return
	end

	if frame % 5 ~= 0 then
		return
	end
	

	local hasAttack = owner:hasAttackRange()

	if hasAttack then
		owner:doIdle()
		return
	end
	
end

function TowerAttackDelayState:exit(owner)
	-- body
	owner.dtAtkInterval = 0
end

function TowerAttackDelayState:executeAnim(owner,frame,finish)
	-- body
end

return TowerAttackDelayState