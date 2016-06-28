--
-- Author: zsp
-- Date: 2015-01-28 20:33:09
--

--[[
	增减血上限buff
--]]
local BuffBase   = import(".BuffBase")
local MaxHpBuff = class("MaxHpBuff",BuffBase)

function MaxHpBuff:doBegin()
	
	--self.method
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function MaxHpBuff:doBuff()
	-- body
	if self.up_down == 0 then
		--todo
		if self.method  == 0 then
			self.owner:setMaxHp( self.owner.model.maxHp - self.owner.model.maxHp * self.data) 
		else
			self.owner:setMaxHp( self.owner.model.maxHp - self.data) 
		end
		
	else
		if self.method  == 0 then
			self.owner:setMaxHp( self.owner.model.maxHp + self.owner.model.maxHp * self.data) 
		else
			self.owner:setMaxHp( self.owner.model.maxHp + self.data) 
		end
		
	end
end

function MaxHpBuff:doEnd()
	-- body
	self.owner:removeBuffEffect(self)
end

function MaxHpBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return MaxHpBuff