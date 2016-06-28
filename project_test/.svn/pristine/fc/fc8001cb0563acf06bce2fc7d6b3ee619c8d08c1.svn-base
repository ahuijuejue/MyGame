--
-- Author: zsp
-- Date: 2014-12-10 15:46:25
--

--[[
	无敌buff
--]]
local BuffBase   = import(".BuffBase")
local UnbeatableBuff = class("UnbeatableBuff",BuffBase)

function UnbeatableBuff:doBegin()
	-- body
	--1表物理，2表魔法，3表全部
	--printInfo("UnbeatableBuff 开始")
	if self.key == "1" then
		self.owner.unbeatable = true
	elseif self.key == "2" then
		self.owner.magicUnbeatable = true
	else
		self.owner.unbeatable = true
		self.owner.magicUnbeatable = true
	end
	
	self.owner:addBuffEffect(self)
	--self.manager:removeDeBuff()
end

function UnbeatableBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function UnbeatableBuff:doEnd()
	-- body
	--printInfo("UnbeatableBuff 结束")
	
	local tb = self.owner.buffMgr:getBuffByType(self.type)
	local a = 0
	local b = 0
	local c = 0
	for k,v in pairs(tb) do
		if v.key == "1" then
			a = a + 1
		elseif v.key == "2" then
			b = b + 1
		else
			c = c + 1
		end
	end

	if self.key == "1" then
		if a <= 1 then
			self.owner.unbeatable = false
		end
	elseif self.key == "2" then
		if b <= 1 then
			self.owner.magicUnbeatable = false
		end
	else
		if c <= 1 then
			self.owner.unbeatable = false
			self.owner.magicUnbeatable = false
		end
	end

	self.owner:removeBuffEffect(self,true)
end

function UnbeatableBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return UnbeatableBuff