--
-- Author: zsp
-- Date: 2014-11-26 10:27:56
--
local StateBase = import(".StateBase")

local EnemyDamage1State = class("EnemyDamage1State", StateBase)

--[[
	角色的空闲状态
--]]
function EnemyDamage1State:enter(owner)
	-- body
	-- printInfo(owner.roleId.."进入受伤1")
	owner:playDamage1()

end

function EnemyDamage1State:execute(owner,dt)
	
end

function EnemyDamage1State:exit(owner)
	-- body
end

function EnemyDamage1State:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return EnemyDamage1State