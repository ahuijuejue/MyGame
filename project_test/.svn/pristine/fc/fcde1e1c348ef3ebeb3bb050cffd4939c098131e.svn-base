--
-- Author: zsp
-- Date: 2015-02-03 16:27:53
--

local StateBase = import(".StateBase")

local TrapReadyState = class("TrapReadyState", StateBase)

--[[
	陷阱的准备状态
--]]
function TrapReadyState:enter(owner)
	--print("进入准备陷阱")
	owner:playReady()
end

function TrapReadyState:execute(owner,dt,frame)
	
end

function TrapReadyState:exit(owner)
	-- body
end

function TrapReadyState:executeAnim(owner,frame,finish)
	if finish then
		owner:doFire()
	end
end

return TrapReadyState

