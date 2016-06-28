local SecretShopTip = class("SecretShopTip", function()
	return display.newColorLayer(cc.c4f(0, 0, 0, 180))
end)

function SecretShopTip:ctor(params)
    local sprite = display.newSprite("SecretShopTalk.png"):pos(display.cx,display.cy):addTo(self)
    CommonView.animation_show_out(sprite)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			return true
		elseif event.name == "ended" then
			self:removeFromParent()
			if params and params.callback then
				params.callback()
			end
		end
    end)
end

return SecretShopTip