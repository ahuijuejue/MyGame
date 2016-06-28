local FeedbackModel = class("FeedbackModel")

function FeedbackModel:ctor()
	self.items = {}
	self.process = 1
	self.isFinish = 0
	self.closeTime = 0
	self.rechargeValue = 0
	self.rechargeLimit = {6,6,6,6,6}
	self.iconImage = "backfeed_icon_saber.png"
	self.bgImage = "backfeed_bg_saber.png"
end

function FeedbackModel:update(data)
	self.process = data.param2
	self.rechargeValue = data.param3
	self.isFinish = data.param4
	self.closeTime = data.param5
	self.iconImage = data.param10
	self.bgImage = data.param11
	self.items = data.a_param1
	if data.param6 then
		local arr = string.split(data.param6,",")
		for i,v in ipairs(arr) do
			self.rechargeLimit[i] = tonumber(v)
		end
	end
end

function FeedbackModel:setRechargeValue(value)
	self.rechargeValue = value
end

function FeedbackModel:getRechargeLimit()
	return self.rechargeLimit[self.process]
end

function FeedbackModel:isCanActivate()
	if self:isCompleted() then
		return false
	end
	if self.rechargeValue < self:getRechargeLimit() then
		return true
	else
		if self.isFinish == 0 then
			return true
		end
	end
	return false
end

function FeedbackModel:isOpen()
	if UserData.curServerTime < self.closeTime and not self:isCompleted() then
		return true
	end
	return false
end

function FeedbackModel:isCompleted()
	if self.process >= #self.rechargeLimit and self.isFinish == 1 then
		return true
	end
	return false
end

function FeedbackModel:clean()
	self.items = {}
	self.process = 1
	self.isFinish = 0
	self.closeTime = 0
	self.rechargeValue = 0
	self.rechargeLimit = {6,6,6,6,6}
	self.iconImage = "backfeed_icon_saber.png"
	self.bgImage = "backfeed_bg_saber.png"
end

return FeedbackModel