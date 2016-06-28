local BuffBase = import(".BuffBase")
local CleanDeBuff = class("CleanDeBuff",BuffBase)

function CleanDeBuff:doBegin()
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function CleanDeBuff:doBuff()
	self.manager:removeDeBuff()
	self.remove = true
end

function CleanDeBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function CleanDeBuff:doUpdate(dt)
	
end

return CleanDeBuff