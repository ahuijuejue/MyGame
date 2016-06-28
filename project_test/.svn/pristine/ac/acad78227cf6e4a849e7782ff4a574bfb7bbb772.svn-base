local BuffBase = import(".BuffBase")
local DelShieldBuff = class("DelShieldBuff",BuffBase)

function DelShieldBuff:doBegin()
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function DelShieldBuff:doBuff()
	self.manager:removeBuffByType(4)
	self.manager:removeBuffByType(5)
	self.manager:removeBuffByType(7)
end

function DelShieldBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function DelShieldBuff:doUpdate(dt)
	
end

return DelShieldBuff