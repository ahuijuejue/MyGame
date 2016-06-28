local GamblingModel = class("GamblingModel")

function GamblingModel:ctor()
	self.cost = 0
	self.maxBonus = 0
	self.closeTime = 0
	self.bonus = 0
	self.times = 0
	self.info = {}
end

function GamblingModel:update(data)
	self.cost = data.param2
	self.maxBonus = data.param3
	self.times = data.param4
	self.closeTime = data.param5
end

function GamblingModel:insertInfo(data)
	table.insert(self.info,data)
end

function GamblingModel:isCanGambling()
	if self.times > 7 then
		return false
	end
	return true
end

function GamblingModel:isOpen()
	if UserData.curServerTime < self.closeTime then
		return true
	end
	return false
end

function GamblingModel:clean()
	self.cost = 0
	self.maxBonus = 0
	self.closeTime = 0
	self.bonus = 0
	self.times = 0
	self.info = {}
end

return GamblingModel