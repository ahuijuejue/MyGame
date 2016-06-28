--
-- Author: zsp
-- Date: 2014-11-24 14:13:25
--
local StateBase         = import(".StateBase")
local LeaderAttackState = class("LeaderAttackState", StateBase)

--[[
	角色的空闲状态
--]]
function LeaderAttackState:enter(owner)
	
	owner.attackNum = 1

	-- body
	if owner.model.missileId ~= "" then
		--todo
		owner:doFarAttack()
	else
		owner:doNearAttack()
	end
end

function LeaderAttackState:execute(owner,dt)
	
end

function LeaderAttackState:exit(owner)
	-- body
end

function LeaderAttackState:executeAnim(owner,frame,finish)
	-- body
end

return LeaderAttackState