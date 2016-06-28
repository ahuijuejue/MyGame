--
-- Author: zsp
-- Date: 2015-05-14 15:36:52
--
local StateBase = import(".StateBase")

local ClockIdleState = class("ClockIdleState", StateBase)

--[[
	角色的空闲状态
--]]
function ClockIdleState:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入待机")
	owner:playIdle()
end

function ClockIdleState:execute(owner,dt,frame)

end

function ClockIdleState:exit(owner)
	-- body
end

function ClockIdleState:executeAnim(owner,frame,finish)
	-- body
end

return ClockIdleState