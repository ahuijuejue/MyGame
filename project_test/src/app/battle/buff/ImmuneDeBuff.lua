local BuffBase = import(".BuffBase")
local ImmuneDeBuff = class("ImmuneDeBuff",BuffBase)

function ImmuneDeBuff:doBegin()
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function ImmuneDeBuff:doBuff()
	self.manager:removeDeBuff()
end

function ImmuneDeBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function ImmuneDeBuff:doUpdate(dt)
	
end

return ImmuneDeBuff