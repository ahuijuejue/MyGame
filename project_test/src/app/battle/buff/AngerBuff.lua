--
-- Author: zsp
-- Date: 2015-04-18 16:32:42
--
local BuffBase  = import(".BuffBase")
local AngerBuff = class("AngerBuff",BuffBase)

function AngerBuff:doBegin()
	--print("AttributeBuff:doBegin()")
	--self.method
	self:doBuff()
	self.owner:addBuffEffect(self)
end

function AngerBuff:doBuff()

	--附加值

	self.attach = 0
	
	-- body
	if self.up_down == 0 then
		--todo
		if self.method  == 0 then
			self.attach = self.owner.model.anger* self.data
		else
			self.attach = self.data
		end
		
		self.owner:setAnger(self.owner.model.anger - self.attach )
	else
		if self.method  == 0 then
			self.attach = self.owner.model.anger * self.data
		else
			self.attach = self.data
		end
		
		self.owner:setAnger(self.owner.model.anger + self.attach )
	end

end

function AngerBuff:doEnd()
	
	--print("AttributeBuff:doEnd()")

	-- body
	--对于持续生效的，到时间后要恢复属性
	if self.time > 0 then
		if self.up_down == 0 then
			self.owner:setAnger(self.owner.model.anger + self.attach )
		else
			self.owner:setAnger(self.owner.model.anger - self.attach )
		end
	end

	self.owner:removeBuffEffect(self)
end

function AngerBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return AngerBuff