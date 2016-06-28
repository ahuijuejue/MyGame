local BuffBase = import(".BuffBase")
local CleanEffectBuff = class("CleanEffectBuff",BuffBase)

function CleanEffectBuff:doBegin()
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function CleanEffectBuff:doBuff()
	self.manager:removeEffectBuff()
	self.remove = true
end

function CleanEffectBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function CleanEffectBuff:doUpdate(dt)
	
end

return CleanEffectBuff