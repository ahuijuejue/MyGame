--
-- Author: zsp
-- Date: 2015-03-17 14:21:44
--

--[[
	召唤塔buff
--]]

local BuffBase      = import(".BuffBase")
local CallTowerBuff = class("CallTowerBuff",BuffBase)
local TowerNode     = require("app.battle.node.TowerNode")

function CallTowerBuff:doBegin()
	local tower = TowerNode.new({
		towerId   = self.key,
		camp      = self.owner.camp,
		enemyCamp = self.owner.enemyCamp,
		level     = self.level,
		liveTime  = self.time
	})

	if self.owner.camp == GameCampType.left then
		tower:setPosition(cc.pAdd(cc.p(self.owner:getPosition()), cc.p(250,0)))
	else
		tower:setPosition(cc.pSub(cc.p(self.owner:getPosition()), cc.p(250,0)))
	end
	
	tower:addTo(self.owner:getParent())
	tower:createAnimNode()
	self.remove = true
end

function CallTowerBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function CallTowerBuff:doEnd()
	
end

function CallTowerBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return CallTowerBuff