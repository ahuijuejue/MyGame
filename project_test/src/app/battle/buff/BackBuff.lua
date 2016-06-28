--
-- Author: zsp
-- Date: 2015-01-28 20:32:20
--

--[[
	击退buff
--]]
local BuffBase = import(".BuffBase")
local BackBuff = class("BackBuff",BuffBase)

function BackBuff:doBegin()
	-- -- body
	self.owner.tumbleDistance = self.data
	--self.owner:addBuffEffect(self.cfg)
	self.owner.stateMgr:changeState(self.owner.state.demage2)
	
end

function BackBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function BackBuff:doEnd()
	-- body
   self.owner.tumbleDistance = self.owner.defaultTumbleDistance
   --self.owner:removeBuffEffect(self.cfg)
end

function BackBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return BackBuff