--
-- Author: zsp
-- Date: 2015-01-28 20:32:46
--

--[[
	增/减血buff
--]]

local BuffBase   = import(".BuffBase")
local HpBuff = class("HpBuff",BuffBase)

function HpBuff:doBegin()
	
	--self.method
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function HpBuff:doBuff()
	-- body
	if self.up_down == 0 then
		--todo
		if self.method  == 0 then
			self.owner:doBuffDamage(self.attacker, self.owner.model.maxHp * self.data) 
		else
			self.owner:doBuffDamage(self.attacker, self.data)
		end
		
	else
		if self.method  == 0 then
			self.owner:doRecover(self.owner.model.maxHp * self.data)
		else
			self.owner:doRecover(self.data)
		end
		
	end
end

function HpBuff:doEnd()
	-- body
	self.owner:removeBuffEffect(self)
end

function HpBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return HpBuff