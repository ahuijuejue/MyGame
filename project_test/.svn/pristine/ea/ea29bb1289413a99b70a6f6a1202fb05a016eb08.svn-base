

import(".AlertShow")
local GemsAlert = class("GemsAlert")

function GemsAlert:cort()
	self.isRequesting = false
	self.isShowing = false
end

function GemsAlert:show()
	if self.isShowing or self.isRequesting then return end

	local msg = base.Label.new({text="储备资金短缺，快去充值吧！", size = 22}):align(display.CENTER):pos(200, 100)

	self.isShowing = true
	AlertShow.show2("提示", msg, "充值", function()
		if self.isShowing then
			self.isShowing = false
			app:pushScene("RechargeScene")
		end
	end, function()
		self.isShowing = false
	end)
	:onEvent(function(event)
		if event.name == "exit" then
			self.isShowing = false
		end
	end)
end

function GemsAlert:enterVip()
	-- showToast({text="vip系统暂未开放"})
	app:pushScene("RechargeScene")
end

return GemsAlert