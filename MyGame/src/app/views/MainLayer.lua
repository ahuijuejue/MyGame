
local MainLayer = class("MainLayer", function()
	return display.newColorLayer(cc.c4b(100, 100, 100, 100))
end)

function MainLayer:ctor()
    display.addSpriteFrames("image.plist", "image.pvr.ccz")

	local sprite = display.newSprite()
	:addTo(self)
	:pos(display.cx,display.cy)
	sprite:setScale(2)
    
    local frame = display.newFrames("image_%d.jpg",1,20)
    local animation = display.newAnimation(frame,0.3)
    transition.playAnimationForever(sprite, animation)

    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
    	if event.name == "began" then
    		self.touch = true
    		return true
    	elseif event.name == "moved" then
    		self.touch = false
    		print("moved")
    	elseif event.name == "ended" then
	    	if self.touch then
	    		display.removeSpriteFramesWithFile("image.plist", "image.pvr.ccz")
	    		self:removeFromParent()
                self.touch = nil
	    	end
    	end
    end)

end

return MainLayer
