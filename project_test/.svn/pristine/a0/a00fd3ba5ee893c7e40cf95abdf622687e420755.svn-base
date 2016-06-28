local StageModel = class("StageModel")
	
function StageModel:ctor()
	self.star = 0
	self.leftTimes = tonumber(GameConfig["StageInfo"]["1"].ConsortiaLimit)
end

function StageModel:addStar(value)
	self.star = self.star + value
end

function StageModel:addLeftTimes(value)
	self.leftTimes = self.leftTimes + value
end

return StageModel
