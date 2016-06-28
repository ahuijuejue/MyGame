--
-- Author: zsp
-- Date: 2015-05-14 15:40:16
--
local BattleEvent = require("app.battle.BattleEvent")
local ClockDeadState = class("ClockDeadState", StateBase)

--[[
	角色的空闲状态
--]]
function ClockDeadState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入死亡")
	if owner.dead then
		return
	end

	owner.dead = true
	owner:playDead()

	owner:showEffect("atk_effect_2",function()
		 self.remove = true	
	end) 

	--发送死亡事件
    BattleEvent:dispatchEvent({
      name  = BattleEvent.KILL_CLOCK,
      dead  = owner
   })

end

function ClockDeadState:execute(owner,dt)
	
end

function ClockDeadState:exit(owner)
	-- body
end

function ClockDeadState:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end


	owner:setVisible(false)
	owner.remove = true

	owner:pauseAll()
	owner.animNode:unregisterScriptHandler()
	

end

return ClockDeadState