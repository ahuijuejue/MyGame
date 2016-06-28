--[[
    骨骼动画
]]
local TestParticleDisplay = class("TestParticleDisplay", function()
	return display.newColorLayer(cc.c4b(0, 0, 0, 255))
end)

function TestParticleDisplay:ctor()
    local manager = ccs.ArmatureDataManager:getInstance()
    manager:addArmatureFileInfo("robot.png", "robot.plist", "robot.xml")

    self.animationID = 0

    self.armature = ccs.Armature:create("robot")
    self.armature:getAnimation():playWithIndex(0)
    self.armature:setPosition(display.cx, display.cy)
    self.armature:setScale(0.48)
    self:addChild(self.armature)

    local function onTouchEnded()
        self.animationID = (self.animationID + 1) % self.armature:getAnimation():getMovementCount()
        self.armature:getAnimation():playWithIndex(self.animationID)
        print(self.animationID)
    end

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name=='began' then
    		return true
    	elseif event.name=='ended' then
    		onTouchEnded()
    	end
    end)
end

return TestParticleDisplay


