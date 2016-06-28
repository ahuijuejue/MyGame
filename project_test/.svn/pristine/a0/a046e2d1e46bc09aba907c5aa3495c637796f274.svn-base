--
-- Author: zsp
-- Date: 2015-03-24 11:00:14
--
local StateBase = import(".StateBase")

local LeaderWinState = class("LeaderWinState", StateBase)

local BattleEvent          = require("app.battle.BattleEvent")

--[[
	角色的胜利状态
--]]
function LeaderWinState:enter(owner)
	owner.buffMgr:clean()
	owner:playCheer()
	owner:hideHpBar()
end

function LeaderWinState:execute(owner,dt,frame)
	
end

function LeaderWinState:exit(owner)
	-- body
end

function LeaderWinState:executeAnim(owner,frame,finish)
	if finish then
		owner:doIdle()
		owner.stateMgr.lockState = true
	end
	BattleSound.playWin(owner.roleId,frame)
end

return LeaderWinState