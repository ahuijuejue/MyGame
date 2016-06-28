--
-- Author: zsp
-- Date: 2015-05-14 15:39:25
--
local StateBase = import(".StateBase")
local ClockDamageState = class("ClockDamageState", StateBase)

--[[
	角色的空闲状态
--]]
function ClockDamageState:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤1")
	owner:playDamage()
end

function ClockDamageState:execute(owner,dt)
	
end

function ClockDamageState:exit(owner)
	-- body
end

function ClockDamageState:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return ClockDamageState