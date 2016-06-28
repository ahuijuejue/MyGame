--
-- Author: zsp
-- Date: 2014-12-21 16:31:41
--
local StateBase = import(".StateBase")

local MemberAttackState = class("MemberAttackState", StateBase)

function MemberAttackState:enter(owner)
	owner.attackNum = 1
	if owner.model.missileId ~= "" then
		owner:doFarAttack()
	else
		owner:doNearAttack()
	end
end

function MemberAttackState:execute(owner,dt)
	
end

function MemberAttackState:exit(owner)
	-- body
end

function MemberAttackState:executeAnim(owner,frame,finish)
	-- body
end

return MemberAttackState