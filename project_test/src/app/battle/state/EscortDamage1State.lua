--
-- Author: zsp
-- Date: 2015-04-08 11:52:13
--
local StateBase = import(".StateBase")

local EscortDamage1State = class("EscortDamage1State", StateBase)

--[[
	角色的空闲状态
--]]
function EscortDamage1State:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤1")
	owner:playDamage1()
end

function EscortDamage1State:execute(owner,dt)
	
end

function EscortDamage1State:exit(owner)
	-- body
end

function EscortDamage1State:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return EscortDamage1State