--
-- Author: zsp
-- Date: 2015-03-17 15:34:49
--

--[[
	召唤npc buff
--]]

local BuffBase    = import(".BuffBase")
local CallNpcBuff = class("CallNpcBuff",BuffBase)
local CharacterNode   = require("app.battle.node.CharacterNode")

function CallNpcBuff:doBegin()
	-- printInfo("召唤npc")
	 local npc = CharacterNode.new({
          --roleId         = self.owner.roleId,
          isLeader       = false,
          followDistance = 50,
          auto = true,
          -- camp = self.owner.camp,
          -- enemyCamp = self.owner.camp,
          model = self.owner.model
      })
    npc:setLocalZOrder(self.owner.getParent():getLocalZOrder())
    local x,y = self.owner:getPosition()
    npc:setPosition(x + 30,y)
    npc:addTo(self.owner:getParent())

	self.remove = true
end

function CallNpcBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function CallNpcBuff:doEnd()
	
end

function CallNpcBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return CallNpcBuff