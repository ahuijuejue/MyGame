--
-- Author: zsp
-- Date: 2015-03-13 10:41:16
--
--[[
	反弹伤害buff
--]]
local BuffBase   = import(".BuffBase")
local ReboundBuff = class("ReboundBuff",BuffBase)

function ReboundBuff:doBegin()
	-- body
	--1表物理，2表魔法，3表全部
	--printInfo("ReboundBuff 开始")
	if self.key == "1" then
		self.owner.rebound = true
	elseif self.key == "2" then
		self.owner.magicRebound = true
	else
		self.owner.rebound = true
		self.owner.magicRebound = true
	end
	
	self.owner:addBuffEffect(self)
	--self.manager:removeDeBuff()
end

function ReboundBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function ReboundBuff:doEnd()
	-- body
	--print("ReboundBuff 结束")
	local a = 0
	local b = 0
	local c = 0
	
	local tb = self.owner.buffMgr:getBuffByType(self.type)
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
			self.owner.rebound = false
		end
		
	elseif self.key == "2" then
		if b <= 1 then
			self.owner.magicRebound = false
		end
		
	else
		if c <= 1 then
			self.owner.rebound = false
			self.owner.magicRebound = false
		end
	end

	self.owner:removeBuffEffect(self)
end

function ReboundBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return ReboundBuff