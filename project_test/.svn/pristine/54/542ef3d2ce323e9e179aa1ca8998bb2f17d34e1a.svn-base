--
-- Author: zsp
-- Date: 2015-06-06 12:11:26
--
local StateBase = import(".StateBase")
local TowerIdleState = class("TowerIdleState", StateBase)

--[[
	角色的空闲状态
--]]
function TowerIdleState:enter(owner)
	-- body
	--printInfo(owner.towerId.."进入待机")
	owner:playIdle()
end

function TowerIdleState:execute(owner,dt,frame)

	if not owner.isAttack then
		return
	end

	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 20 ~= 0 then
		return
	end

	local hasAttack = owner:hasAttackRange()
	if hasAttack then
		owner:doAttack()
	end
end

function TowerIdleState:exit(owner)
	-- body
end

function TowerIdleState:executeAnim(owner,frame,finish)
	-- body
end

return TowerIdleState