--
-- Author: zsp
-- Date: 2014-11-25 18:29:57
--

local StateBase = import(".StateBase")

local EnemyIdleState = class("EnemyIdleState", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyIdleState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入待机")
	owner:playIdle()
	
end

function EnemyIdleState:execute(owner,dt,frame)
	if owner.disabled then
		return
	end

	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 25 ~= 0 then
		return
	end
	
	local hasEnemy = owner:hasViewRange()
	if owner:autoRealseSkill(hasEnemy) then
		return
	end 
		
	if hasEnemy then
		if owner.attackTotal == 0 then
			--只有技能攻击
		else
			owner:doAttack()
		end
		
	else
		owner:doWalk()
	end
end

function EnemyIdleState:exit(owner)
	-- body
end

function EnemyIdleState:executeAnim(owner,frame,finish)
	-- body
end

return EnemyIdleState