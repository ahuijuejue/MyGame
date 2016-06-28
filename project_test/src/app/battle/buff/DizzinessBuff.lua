--
-- Author: zsp
-- Date: 2014-12-10 15:22:27
--

--[[
	眩晕
--]]
local BuffBase   = import(".BuffBase")
local DizzinessBuff = class("DizzinessBuff",BuffBase)

function DizzinessBuff:doBegin()
	-- body
	self.owner.disabled = true
	self.owner:addBuffEffect(self)
	self.owner:doIdle()
end

function DizzinessBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function DizzinessBuff:doEnd()
	-- body
	--中多个眩晕时不取消状态
	local tb = self.owner.buffMgr:getBuffByType(self.type)
	if #tb <= 1 then
		self.owner.disabled = false
	end
	
	self.owner:removeBuffEffect(self,true)
end

function DizzinessBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return DizzinessBuff