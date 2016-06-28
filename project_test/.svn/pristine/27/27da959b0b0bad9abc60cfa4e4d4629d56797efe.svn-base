--
-- Author: zsp
-- Date: 2014-11-21 18:11:20
--

local StateBase = class("StateBase")

--[[
	状态的基类 子类重写事件方法
--]]
function StateBase:ctor()
	-- body
end

--[[
	进入状态
--]]
function StateBase:enter(owner)
	-- body
	printError("StateBase:enter() - must override in inherited class")
end

--[[
	执行状态里的逻辑
--]]
function StateBase:execute(owner,dt,frame)
	printError("StateBase:execute() - must override in inherited class")
end

--[[
	退出状态
--]]
function StateBase:exit(owner)
	-- body
	printError("StateBase:exit() - must override in inherited class")
end

--[[
	动画帧驱动执行的状态逻辑
--]]
function StateBase:executeAnim(owner,frame,finish)
	-- body
	printError("StateBase:executeAnim() - must override in inherited class")
end

return StateBase