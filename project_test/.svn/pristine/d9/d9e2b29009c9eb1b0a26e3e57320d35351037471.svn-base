local FlashScene = class("FlashScene",function ()
	return display.newScene()
end)

local adviceImage = "health_game.png"

function FlashScene:ctor()
	local colorLayer = display.newColorLayer(cc.c4b(255,255,255,255))
	self:addChild(colorLayer)

	local adviceSprite = display.newSprite(adviceImage)
	adviceSprite:setOpacity(0)
	adviceSprite:setPosition(display.cx,display.cy)
	colorLayer:addChild(adviceSprite)

	local sequence = transition.sequence({
	    cc.FadeIn:create(0.3),
	    cc.DelayTime:create(0.5),
	    cc.FadeOut:create(1),
	})
	transition.execute(adviceSprite, sequence, {onComplete = function ()
		require("update.LoadSrc")
	end})
end

return FlashScene