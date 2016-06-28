local BuffBase = import(".BuffBase")
local NotAttackBuff = class("NotAttackBuff",BuffBase)

function NotAttackBuff:doBegin()
	self.owner:addBuffEffect(self)
end

function NotAttackBuff:doBuff()
end

function NotAttackBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function NotAttackBuff:doUpdate(dt)
end

return NotAttackBuff