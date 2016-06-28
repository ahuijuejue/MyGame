--
-- Author: zsp
-- Date: 2015-04-08 11:50:41
--

local StateBase = import(".StateBase")
local BattleEvent = import("..BattleEvent")

local EscortWalkState = class("EscortWalkState", StateBase)

--[[
	角色的空闲状态
--]]
function EscortWalkState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入移动")
	owner:playWalk()
end

function EscortWalkState:execute(owner,dt,frame)

	local x,y = owner:getPosition()
	
	if x < 0  then
		--todo 敌人穿过大门了 发送通知
		return
	end

	if BattleManager.hasObstruct(owner,true) then
		owner:doIdle()
	end
	

	local speed = owner.model.walkSpeed
	x = x + (speed * dt)
	owner:setPosition(x,y)

	if frame % 5 == 0 then
		if owner:hasViewRange() then
			owner:doIdle()
			return
		end
	end

	if x >=  BattleManager.targetWidth then

		-- --发送护送结束事件
	 --    BattleEvent:dispatchEvent({
	 --       name  = BattleEvent.ESCORT_END,
	 --       dead  = owner
	 --    })

		owner:doWin()
	end

end

function EscortWalkState:exit(owner)
	-- body
end

function EscortWalkState:executeAnim(owner,frame,finish)
	-- body
end

return EscortWalkState