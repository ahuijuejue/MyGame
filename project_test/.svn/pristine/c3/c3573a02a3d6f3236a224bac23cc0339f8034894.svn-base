--
-- Author: zsp
-- Date: 2014-12-21 15:26:26
--
local StateBase = import(".StateBase")

local MemberDamage1State = class("MemberDamage1State", StateBase)

function MemberDamage1State:enter(owner)
	owner:playDamage1()
end

function MemberDamage1State:execute(owner,dt)
	
end

function MemberDamage1State:exit(owner)
	-- body
end

function MemberDamage1State:executeAnim(owner,frame,finish)
	-- body
	if not finish then
		return	
	end

	owner:doIdle()
end

return MemberDamage1State