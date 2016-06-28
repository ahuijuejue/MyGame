--
-- Author: zsp
-- Date: 2015-03-26 15:47:53
--
local StateBase = import(".StateBase")

local MemberEvolveState = class("MemberEvolveState", StateBase)

function MemberEvolveState:enter(owner)
	owner:playEvolve()
end

function MemberEvolveState:execute(owner,dt,frame)

end

function MemberEvolveState:exit(owner)
	-- body
end

function MemberEvolveState:executeAnim(owner,frame,finish)
	if finish then
		owner:doIdle()
	end
end

return MemberEvolveState