--
-- Author: zsp
-- Date: 2014-11-25 18:41:27
--
local StateBase = import(".StateBase")

local EnemyAttackState = class("EnemyAttackState", StateBase)

--[[
	角色的攻击状态
--]]
function EnemyAttackState:enter(owner)
	owner.attackNum = 1
	-- body
	if owner.model.missileId ~= "" then
		--todo
		owner:doFarAttack()
	else
		owner:doNearAttack()
	end
end

function EnemyAttackState:execute(owner,dt)
	
end

function EnemyAttackState:exit(owner)
	-- body
end

function EnemyAttackState:executeAnim(owner,frame,finish)
	-- body
end

return EnemyAttackState