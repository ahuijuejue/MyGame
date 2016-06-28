--
-- Author: zsp
-- Date: 2014-12-21 21:09:21
--

local StateBase = import(".StateBase")

local MemberAttackDelayState = class("MemberAttackDelayState", StateBase)

--[[
	攻击间隔
--]]
function MemberAttackDelayState:enter(owner)
	owner:playIdle()
end

function MemberAttackDelayState:execute(owner,dt)
	
end

function MemberAttackDelayState:exit(owner)
	-- body
	owner.dtAtkInterval = 0
end

function MemberAttackDelayState:executeAnim(owner,frame,finish)
	-- body
end

return MemberAttackDelayState