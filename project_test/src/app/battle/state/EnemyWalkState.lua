--
-- Author: zsp
-- Date: 2014-11-25 18:33:51
--
local StateBase = import(".StateBase")

local EnemyWalkState = class("EnemyWalkState", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyWalkState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入移动")
	owner:playWalk()
end

function EnemyWalkState:execute(owner,dt,frame)

	local x,y = owner:getPosition()
	
	if x < 0  then
		--todo 敌人穿过大门了 发送通知
		return
	end

	local speed = owner.model.walkSpeed
	x = x - (speed * dt)
	owner:setPosition(x,y)
	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 10 ~= 0 then
		return
	end

	local hasEnemy = owner:hasViewRange()
	if owner:autoRealseSkill(hasEnemy) then
		return
	end  
	
	if hasEnemy then
		if owner.attackTotal == 0  then
			owner:doIdle()
		else
			owner:doAttack()
		end	
	end

end

function EnemyWalkState:exit(owner)
	-- body
end

function EnemyWalkState:executeAnim(owner,frame,finish)
	-- body
end

return EnemyWalkState