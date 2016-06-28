
--[[
机器人数据
]]
local GameRobot = import(".GameRobot")
local RobotData = class("RobotData")

function RobotData:ctor()
	local cfg = GameConfig["robot"]
	self.dict = {} 

	for k,v in pairs(cfg or {}) do
		self.dict[k] = GameRobot.new({
			cfg = v,
			id = k,
		})
	end
end

function RobotData:getRobot(cfgId)
	return self.dict[cfgId]
end 


return RobotData
