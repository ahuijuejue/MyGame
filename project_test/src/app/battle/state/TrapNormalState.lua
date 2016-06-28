--
-- Author: zsp
-- Date: 2015-02-03 16:27:33
--

local StateBase = import(".StateBase")

local TrapNormalState = class("TrapNormalState", StateBase)

--[[
	陷阱正常状态
--]]
function TrapNormalState:enter(owner)
	--print("进入默认陷阱")
	owner:playNormal()
	
	owner:runAction(
		cc.Sequence:create(
			cc.DelayTime:create(owner.interview),
			cc.CallFunc:create(function()
				 owner:doReady()
			end
	)))
end

function TrapNormalState:execute(owner,dt,frame)
	
end

function TrapNormalState:exit(owner)
	-- body
end

function TrapNormalState:executeAnim(owner,frame,finish)
	-- body
end

return TrapNormalState
