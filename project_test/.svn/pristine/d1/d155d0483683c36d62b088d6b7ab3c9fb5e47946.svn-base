--
-- Author: zsp
-- Date: 2014-12-21 12:11:55
--
local StateBase       = import(".StateBase")
local BattleEvent     = import("..BattleEvent")
local MemberIdleState = class("MemberIdleState", StateBase)

--[[
	角色的空闲状态
--]]
function MemberIdleState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入待机")
	owner.isForward = true
	owner:playIdle()

	--BattleEvent:addEventListener(BattleEvent.LEADER_ATTACK, handler(self, self.onLeaderAttack))
	
end

-- function MemberIdleState:onLeaderAttack(event)

-- end

function MemberIdleState:execute(owner,dt,frame)
	
	if owner.disabled then
		return
	end

	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 20 ~= 0 then
		return
	end

	--todo 先跟随队长移动 还是先攻击判断？？测试
	
	--自动攻击 优先释放技能 释放技能是敌人的
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
				--owner.stateMgr:changeState(owner.state.moveAttackRange)
				return
			else
				owner:doAttack()
			end
			
		else			
			owner.stateMgr:changeState(owner.state.moveAttackRange)
		end
	end


	if owner.isFollowLeader then
		local leader = BattleManager.getLeader(owner.camp)
		if leader then
			local leaderPosX = leader:getPositionX()
			local ownerPosX = owner:getPositionX()
			
			if owner.camp == GameCampType.left then
				--相同方向 队长角色在队员前边移动超过 followDistance + leaderDistance 距离后，队员开始跟随
				if (leaderPosX - ownerPosX) > 0 then
					if ((leaderPosX - ownerPosX) > owner.followDistance + owner.leaderDistance) then
			            owner:doWalk()
			            return
					end
				else
					if (math.abs(leaderPosX - ownerPosX) > owner.retreatDistance + leader.model.attackSize.width - owner.model.attackSize.width ) then
						--print(string.format("后退b==== %d %d",leaderPosX - ownerPosX ,owner.retreatDistance + leader.model.attackSize.width - owner.model.attackSize.width ))
						owner.isForward = false
						owner:doWalk()
						return
					end
				end	
			else
				if (leaderPosX - ownerPosX) < 0 then
					if (math.abs(leaderPosX - ownerPosX) > owner.followDistance + owner.leaderDistance) then
			            owner:doWalk()
			            return
					end
				else
					if (math.abs(leaderPosX - ownerPosX)  > owner.retreatDistance + leader.model.attackSize.width - owner.model.attackSize.width) then
						owner.isForward = false
						owner:doWalk()
						return
					end
				end
			end
		else
			owner.isFollowLeader = false
		end
	else
		if BattleManager.sceneWidth > 0 then
			local sWidth = BattleManager.sceneWidth
			local rect = owner:getNodeRect()
			local x = owner:getPositionX()	
			owner:autoWalk()
		end
	end

end

function MemberIdleState:exit(owner)
	-- body
	 --BattleEvent:removeEventListener(self)
end

function MemberIdleState:executeAnim(owner,frame,finish)
	-- body
end

return MemberIdleState