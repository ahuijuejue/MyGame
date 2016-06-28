--
-- Author: zsp
-- Date: 2014-11-24 17:11:17
--
local StateBase = import(".StateBase")

local LeaderDamage1State = class("LeaderDamage1State", StateBase)

--[[
	角色的空闲状态
--]]
function LeaderDamage1State:enter(owner)
	-- body
	--printInfo(owner.roleId.."进入受伤1")
	owner:playDamage1()
end

function LeaderDamage1State:execute(owner,dt)
	
end

function LeaderDamage1State:exit(owner)
	-- body
end

function LeaderDamage1State:executeAnim(owner,frame,finish)

	BattleSound.playDamage(owner.roleId,1,frame)

	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return LeaderDamage1State