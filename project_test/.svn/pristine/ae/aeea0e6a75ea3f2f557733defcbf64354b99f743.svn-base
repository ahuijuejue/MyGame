--
-- Author: zsp
-- Date: 2014-12-21 16:01:45
--

local MemberWalkState = class("MemberWalkState", StateBase)

--[[
	角色的移动状态 以后如有需要 可能需要拆分成前进后退两个状态，前进状态有寻敌人普通攻击和技能攻击
--]]
function MemberWalkState:enter(owner)
	owner:playWalk()
end

function MemberWalkState:execute(owner,dt,frame)

	local x = owner:getPositionX()
	
	local speed = owner.model.walkSpeed
	
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

	if owner.isFollowLeader then
		--跟随队长的位置 重新站位
		local leader = BattleManager.getLeader(owner.camp)
		if leader then
			local leaderPosX = leader:getPositionX()
			local ownerPosX = owner:getPositionX()

			if owner.camp == GameCampType.left then
					--相同方向 队长角色在队员前边移动超过 followDistance + leaderDistance 距离后，队员开始跟随
					if owner.isForward then
						if ((leaderPosX - ownerPosX) < (owner.followDistance + owner.leaderDistance)) then
				            owner:doIdle()
				            return
						end
					else
						if ((leaderPosX - ownerPosX) > owner.leaderDistance) then
							owner:doIdle()
							return
						end
					end	
			else
				if owner.isForward then
					if (math.abs(leaderPosX - ownerPosX) < (owner.followDistance + owner.leaderDistance)) then
			            owner:doIdle()
			            return
					end
				else
					if (leaderPosX - ownerPosX  < -owner.leaderDistance) then
						owner:doIdle()
						return
					end
				end	
			end	
		else
			print("队长挂了")
			owner.isFollowLeader = false
		end
	else
		
	end

	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 4 ~= 0 then
		return
	end

	--跟随队长侧推时不检测攻击
	if not owner.isForward then
		return
	end

	--自动攻击 优先释放技能 释放技能是敌人的
	local hasAttack = owner:hasAttackRange()
	
	if owner:autoRealseSkill( hasAttack ) then
		return
	end	
	
	if hasAttack then
		--if owner:isEvolve() then
		if owner.attackTotal == 0 then
			owner:doIdle()
		else
			owner:doAttack()
		end
	end

end

function MemberWalkState:exit(owner)
	-- body
end

function MemberWalkState:executeAnim(owner,frame,finish)
	-- body
end

return MemberWalkState