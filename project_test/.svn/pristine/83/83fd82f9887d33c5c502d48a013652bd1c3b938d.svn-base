--
-- Author: zsp
-- Date: 2015-07-02 10:17:35
--

--[[
	吸血 buff
--]]

local BuffBase = import(".BuffBase")
local SuckBuff = class("SuckBuff",BuffBase)

function SuckBuff:doBegin()
	--printInfo("roleId == %s SuckBuff 吸血buff 开始",self.owner.roleId)
	self.owner:addBuffEffect(self)
end

function SuckBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function SuckBuff:doEnd()
	--printInfo("roleId == %s SuckBuff 吸血buff 结束",self.owner.roleId)
	self.owner:removeBuffEffect(self)
end

function SuckBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return SuckBuff