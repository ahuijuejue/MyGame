--
-- Author: zsp
-- Date: 2015-06-06 12:13:31
--
local StateBase         = import(".StateBase")
local TowerAttackState = class("TowerAttackState", StateBase)

--[[
	角色的空闲状态
--]]
function TowerAttackState:enter(owner)
	
	-- body
	if owner.model.missileId ~= "" then
		--todo
		owner:doFarAttack()
	else
		owner:doNearAttack()
	end
end

function TowerAttackState:execute(owner,dt)
	
end

function TowerAttackState:exit(owner)
	-- body
end

function TowerAttackState:executeAnim(owner,frame,finish)
	-- body
end

return TowerAttackState