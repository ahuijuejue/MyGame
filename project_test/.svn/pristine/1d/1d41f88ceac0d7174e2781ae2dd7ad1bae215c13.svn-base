--
-- Author: zsp
-- Date: 2014-12-12 15:58:00
--
local StateBase = import(".StateBase")

local LeaderEvolveState = class("LeaderEvolveState", StateBase)

--[[
	角色的空闲状态
--]]
function LeaderEvolveState:enter(owner)
	owner:playEvolve()
end

function LeaderEvolveState:execute(owner,dt,frame)
end

function LeaderEvolveState:exit(owner)
end

function LeaderEvolveState:executeAnim(owner,frame,finish)
	if finish then
		owner:doIdle()
	end
end

return LeaderEvolveState