--
-- Author: zsp
-- Date: 2014-11-26 12:08:18
--

-- 暂时 还没用攻击间隔这个状态

local StateBase = import(".StateBase")

local LeaderAttackDelayState = class("LeaderAttackDelayState", StateBase)

--[[
	攻击间隔
--]]
function LeaderAttackDelayState:enter(owner)
	owner:playIdle()
end

function LeaderAttackDelayState:execute(owner,dt)
	
end

function LeaderAttackDelayState:exit(owner)
	-- body
	owner.dtAtkInterval = 0
end

function LeaderAttackDelayState:executeAnim(owner,frame,finish)
	-- body
end

return LeaderAttackDelayState