local ConnectManage = class("ConnectManage")
local scheduler = require("framework.scheduler")

local sendInterval = 3
local MAX_RETRY_TIMES = 2

function ConnectManage:ctor()
	self.tickTimer = nil
	self.isSending = false
	self.retryTimes = 0
end

function ConnectManage:setTick(tick)
	self.tick = tick
end

function ConnectManage:setTickBreakCallback(callback)
	self.tickCallback = callback
end

function ConnectManage:start()
	if not self.tickTimer then
		self.tickTimer = scheduler.scheduleGlobal(function ()
			if self.isSending then
				if self.retryTimes < MAX_RETRY_TIMES then
					self.retryTimes = self.retryTimes + 1
					if self.tick then
						self.tick()
					end
				else
					self:stop()
					if self.tickCallback then
						self.tickCallback()
					end
				end
			else
				self.retryTimes = 0
				if self.tick then
					self.isSending = true
					self.tick()
				end
			end
		end,sendInterval)
	end
end

function ConnectManage:stop()
	self.retryTimes = 0
	self.isSending = false
	if self.tickTimer then
		scheduler.unscheduleGlobal(self.tickTimer)
		self.tickTimer = nil
	end
end

return ConnectManage
