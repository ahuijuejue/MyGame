--
-- Author: zsp
-- Date: 2014-12-21 15:24:21
--
local StateBase = import(".StateBase")
local BattleEvent = require("app.battle.BattleEvent")

local MemberDeadState = class("MemberDeadState", StateBase)

--[[
	角色的空闲状态
--]]
function MemberDeadState:enter(owner)
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

function MemberDeadState:execute(owner,dt)
	--printInfo("MemberDeadState:execute roleId=%d",owner.roleId)
end

function MemberDeadState:exit(owner)
	--printInfo("MemberDeadState:exit roleId=%d",owner.roleId)
end

function MemberDeadState:executeAnim(owner,frame,finish)
	if not finish then
		return	
	end
	owner:setVisible(false)
	owner:pauseAll()
end

return MemberDeadState