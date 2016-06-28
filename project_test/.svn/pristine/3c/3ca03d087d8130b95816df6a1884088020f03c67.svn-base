--
-- Author: zsp
-- Date: 2014-11-21 18:26:34
--
local StateBase = import(".StateBase")

local LeaderIdleState = class("LeaderIdleState", StateBase)

--[[
	角色的空闲状态
--]]
function LeaderIdleState:enter(owner)
	owner.isForward = true
	owner:playIdle()
	
end

function LeaderIdleState:execute(owner,dt,frame)
	
	if owner.disabled then
		return
	end

	--优化逻辑：每隔n帧执行下边的逻辑
	if frame % 20 ~= 0 then
		return
	end

	local hasEnemy = owner:hasViewRange()
	
	--自动攻击 优先释放技能
	if owner:autoRealseSkill(hasEnemy) then
		return
	end

	--普通角色会自动攻击

	if hasEnemy then
		--if owner:isEvolve() then
		if owner.attackTotal == 0 then
			--只有技能攻击
			--todo 视野范围要第要大于技能范围时 会卡在这
		else
			owner:doAttack()
		end

		return
	end

	--自动控制角色,自动行走
	if BattleManager.sceneWidth > 0 then
		local sWidth = BattleManager.sceneWidth
		local rect = owner:getNodeRect()
		local x = owner:getPositionX()
		owner:autoWalk()
	end

	
end

function LeaderIdleState:exit(owner)
	-- body
end

function LeaderIdleState:executeAnim(owner,frame,finish)
	-- body
end

return LeaderIdleState