--
-- Author: zsp
-- Date: 2015-04-08 12:05:10
--
local StateBase = import(".StateBase")
local BattleEvent = import("..BattleEvent")
local EscortWinState = class("EscortWinState", StateBase)

--[[
	角色的胜利状态
--]]
function EscortWinState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入待机")
	if owner.dead then
		return
	end

	owner.buffMgr:clean()
	owner:playIdle()

	owner:stopAllActions()
	owner:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.Hide:create()))
	
end

function EscortWinState:execute(owner,dt,frame)
	
end

function EscortWinState:exit(owner)
	-- body
end

function EscortWinState:executeAnim(owner,frame,finish)
	-- body
end

return EscortWinState