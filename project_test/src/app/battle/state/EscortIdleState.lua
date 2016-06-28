--
-- Author: zsp
-- Date: 2015-04-08 11:46:31
--

local StateBase = import(".StateBase")

local EscortIdleState = class("EscortIdleState", StateBase)

--[[
	角色的空闲状态
--]]
function EscortIdleState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入待机")
	owner:playIdle()
	
end

function EscortIdleState:execute(owner,dt,frame)
	if owner.disabled then
		return
	end
	
	if BattleManager.hasObstruct(owner,true) then
		return
	end

	--todo 视野范围内没又敌人在走
	if not owner:hasViewRange() then
		owner:doWalk()
	end
	
end

function EscortIdleState:exit(owner)
	-- body
end

function EscortIdleState:executeAnim(owner,frame,finish)
	-- body
end

return EscortIdleState