--
-- Author: zsp
-- Date: 2015-03-24 11:02:27
--
local StateBase = import(".StateBase")

local MemberWinState = class("MemberWinState", StateBase)

--[[
	角色的胜利状态
--]]
function MemberWinState:enter(owner)
	owner.buffMgr:clean()
	owner:playCheer()
	owner:hideHpBar()
end

function MemberWinState:execute(owner,dt,frame)
	
end

function MemberWinState:exit(owner)
	-- body
end

function MemberWinState:executeAnim(owner,frame,finish)
	if finish then
		owner:doIdle()
		owner.stateMgr.lockState = true
	end
end

return MemberWinState