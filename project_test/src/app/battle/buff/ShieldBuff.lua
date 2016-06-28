--
-- Author: zsp
-- Date: 2014-12-10 15:51:35
--

--[[
	魔法/物理 护盾buff 
--]]
local BuffBase   = import(".BuffBase")
local ShieldBuff = class("ShieldBuff",BuffBase)

function ShieldBuff:doBegin()
	if self.key == "1" then
		self.owner.shield = self.owner.shield + self.data
	elseif self.key == "2" then
		self.owner.magicShield = self.owner.magicShield + self.data
	elseif self.key == "3" then
		self.owner.shield = self.owner.shield + self.data
		self.owner.magicShield = self.owner.magicShield + self.data
	end
	self.owner:addBuffEffect(self)
end

function ShieldBuff:doBuff()
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function ShieldBuff:doEnd()
	if self.key == "1" then
		self.owner.shield = math.max(self.owner.shield - self.data, 0)
	elseif self.key == "2" then
		self.owner.magicShield = math.max(self.owner.magicShield - self.data, 0)
	elseif self.key == "3" then
		self.owner.shield = math.max(self.owner.shield - self.data, 0)
		self.owner.magicShield = math.max(self.owner.magicShield - self.data, 0)
	end
	self.owner:removeBuffEffect(self)
end

function ShieldBuff:doUpdate(dt)
	if self.key == "1" then
		if self.owner.shield <= 0 then
			self.remove = true
		end
	elseif self.key == "2" then
		if self.owner.magicShield <= 0 then
			self.remove = true
		end
	elseif self.key == "3" then
		if self.owner.shield <=0 or self.owner.magicShield <= 0 then
			self.remove = true
		end
	end
end

return ShieldBuff