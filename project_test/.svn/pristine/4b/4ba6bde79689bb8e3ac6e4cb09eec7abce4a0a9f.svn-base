--
-- Author: zsp
-- Date: 2015-07-30 14:40:06
--

--[[
	沉默 buff
--]]

local BuffBase = import(".BuffBase")
local SilentBuff = class("SilentBuff",BuffBase)

function SilentBuff:doBegin()
	printInfo("roleId == %s SilentBuff 沉默buff 开始",self.owner.roleId)
	self.owner:addBuffEffect(self)
end

function SilentBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function SilentBuff:doEnd()
	printInfo("roleId == %s SilentBuff 沉默buff 结束",self.owner.roleId)
	self.owner:removeBuffEffect(self)
end

function SilentBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return SilentBuff