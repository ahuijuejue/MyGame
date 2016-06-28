--
-- Author: zsp
-- Date: 2014-11-24 11:19:08
--
local StateBase = import(".StateBase")

local LeaderWalkState = class("LeaderWalkState", StateBase)

--[[
	角色的移动状态 以后如有需要 可能需要拆分成前进后退两个状态，前进状态有寻敌人普通攻击和技能攻击
--]]
function LeaderWalkState:enter(owner)
	owner:playWalk()
end

function LeaderWalkState:execute(owner,dt,frame)

	local x = owner:getPositionX()
	
	local speed = owner.model.walkSpeed

	
	if not owner.auto then
		if owner.isForward and owner:hasObstruct() then
			return
		end
	end
	
	if (owner.camp == GameCampType.left and  owner.isForward == true) or 
		(owner.camp == GameCampType.right and owner.isForward == false) then

		if( x + owner:getNodeRect().width * 0.5 + speed * dt < BattleManager.sceneWidth) then
			x = x + (speed * dt)
			owner:setPositionX(x)
		else
			owner:doIdle()
			return
		end

	else

		if( x - owner:getNodeRect().width * 0.5 - speed * dt > 0) then
			x = x - (speed * dt)
			owner:setPositionX(x)
		else
			owner:doIdle()
			return
		end
	end
	
	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 5 ~= 0 then
		return
	end

	if not owner.auto then
		return
	end

	--todo
	local hasEnemy = owner:hasViewRange()
	
	if owner:autoRealseSkill(hasEnemy) then
		return
	end 
	
	if hasEnemy then
		--if owner:isEvolve() then
		if owner.attackTotal == 0 then
			owner:doIdle()
		else
			owner:doAttack()
		end
	end

end

function LeaderWalkState:exit(owner)
	-- body
end

function LeaderWalkState:executeAnim(owner,frame,finish)
	-- body
	BattleSound.playFoot(owner.roleId,frame)
end

return LeaderWalkState