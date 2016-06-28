--
-- Author: zsp
-- Date: 2014-11-26 10:30:58
--

local StateBase = import(".StateBase")
local BattleEvent = require("app.battle.BattleEvent")

local EnemyDeadState = class("EnemyDeadState", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyDeadState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入死亡")
	if owner.dead then
		return
	end

	owner.dead = true
	owner:playDead()

	--发送死亡事件
    BattleEvent:dispatchEvent({
      name  = BattleEvent.KILL_ENEMY,
      dead  = owner
   })

end

function EnemyDeadState:execute(owner,dt)
	
end

function EnemyDeadState:exit(owner)
	-- body
end

function EnemyDeadState:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end


	owner:setVisible(false)
	owner.remove = true

	owner:pauseAll()
	owner.animNode:unregisterScriptHandler()
	

end

return EnemyDeadState