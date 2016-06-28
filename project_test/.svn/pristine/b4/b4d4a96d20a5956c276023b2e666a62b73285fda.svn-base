local BuffBase = import(".BuffBase")
local DamageIncreaseBuff = class("DamageIncreaseBuff",BuffBase)

function DamageIncreaseBuff:doBegin()
	self.owner:addBuffEffect(self)
end

function DamageIncreaseBuff:doBuff()
end

function DamageIncreaseBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function DamageIncreaseBuff:doUpdate(dt)
end

return DamageIncreaseBuff