--
-- Author: zsp
-- Date: 2015-04-08 12:03:57
--

local StateBase = import(".StateBase")
local BattleEvent = require("app.battle.BattleEvent")

local EscortDeadState = class("EscortDeadState", StateBase)

--[[
	角色的空闲状态
--]]
function EscortDeadState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入死亡")
	if owner.dead then
		return
	end

	owner.dead = true
	owner:playDead()

	--发送死亡事件
     BattleEvent:dispatchEvent({
       name  = BattleEvent.KILL_ESCORT,
       dead  = owner
    })

end

function EscortDeadState:execute(owner,dt)
	
end

function EscortDeadState:exit(owner)
	-- body
end

function EscortDeadState:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end


	owner:setVisible(false)
	owner.remove = true

	owner:pauseAll()
	owner.animNode:unregisterScriptHandler()

end

return EscortDeadState