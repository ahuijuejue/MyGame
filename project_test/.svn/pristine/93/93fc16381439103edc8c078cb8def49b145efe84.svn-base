--
-- Author: zsp
-- Date: 2014-12-22 14:48:54
--
local StateBase = import(".StateBase")

--[[
	队员的视野范围会被扩大 队长前边有敌人时候可以冲到前边
	队员当坚持到视野范围内有敌人时，如果过没有进入攻击范围这进入到这个状态 先移动到攻击目标 然后在攻击
--]]
local MemberMoveAttackRangeState = class("MemberMoveAttackRangeState", StateBase)

--[[
	角色的移动状态 以后如有需要 可能需要拆分成前进后退两个状态，前进状态有寻敌人普通攻击和技能攻击
--]]
function MemberMoveAttackRangeState:enter(owner)

	--print("MemberMoveAttackRangeState")
	owner:playWalk()
end

function MemberMoveAttackRangeState:execute(owner,dt,frame)

	local x = owner:getPositionX()
	local speed = owner.model.walkSpeed

	-- if x < 3400 - owner.limitRight and x > owner.limitLeft then
		
	-- 	local speed = owner.model.walkSpeed

	-- 	if owner.camp == GameCampType.left then
	-- 		--todo
	-- 		if owner.isForward then
	-- 			--todo
	-- 			x = x + (speed * dt)
	-- 		end
	-- 	else
	-- 		if owner.isForward then
	-- 			--todo
	-- 			x = x - (speed * dt)
	-- 		end
	-- 	end

	-- 	owner:setPositionX(x)
	
	-- else
	-- 	owner:doIdle()
	-- 	return
	-- end

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
	if frame % 20 ~= 0 then
		return
	end

	local hasAttack = owner:hasAttackRange()
	
	if owner:autoRealseSkill( hasAttack ) then
		return
	end

	local hasView = owner:hasViewRange()
	if hasView then
		--视野范围内有敌人 并在攻击范围内 直接攻击
		if hasAttack then
			--if owner:isEvolve() then
			if owner.attackTotal == 0 then
				owner:doIdle()
			else
				owner:doAttack()
			end
		end
	else
		owner:doIdle()
	end

end

function MemberMoveAttackRangeState:exit(owner)
	-- body
end

function MemberMoveAttackRangeState:executeAnim(owner,frame,finish)
	-- body
end

return MemberMoveAttackRangeState