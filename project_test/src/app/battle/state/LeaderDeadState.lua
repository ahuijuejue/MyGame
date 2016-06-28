--
-- Author: zsp
-- Date: 2014-11-24 17:24:55
--

local StateBase = import(".StateBase")
local BattleEvent = require("app.battle.BattleEvent")

local LeaderDeadState = class("LeaderDeadState", StateBase)

--[[
	角色的空闲状态
--]]
function LeaderDeadState:enter(owner)
	owner.dead = true
	owner:playDead()
	owner:resumeAll()
	owner.buffMgr:clean()
	owner.stateMgr.lockState = true
	BattleEvent:dispatchEvent({
		name = BattleEvent.KILL_CHARACTER,
		dead = owner
    })
end

function LeaderDeadState:execute(owner,dt)
	
end

function LeaderDeadState:exit(owner)
	-- body
end

function LeaderDeadState:executeAnim(owner,frame,finish)
	BattleSound.playDead(owner.roleId,frame)
	if not finish then
		return	
	end
	BattleManager.removeLeader(owner.camp)
	owner:setVisible(false)
	owner:pauseAll()
	owner.animNode:unregisterScriptHandler()
end

return LeaderDeadState