local BuffBase = import(".BuffBase")
local CureDecreaseBuff = class("CureDecreaseBuff",BuffBase)

function CureDecreaseBuff:doBegin()
	self.owner:addBuffEffect(self)
end

function CureDecreaseBuff:doBuff()
end

function CureDecreaseBuff:doEnd()
	self.owner:removeBuffEffect(self)
end

function CureDecreaseBuff:doUpdate(dt)
end

return CureDecreaseBuff