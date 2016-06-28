
local SetNotifLayer = class("SetNotifLayer", function()
	return display.newNode()
end)

function SetNotifLayer:ctor()
	-- 灰层背景	
	CommonView.blackLayer2()
    :addTo(self)
    
    local layer_ = display.newNode():size(960, 640):align(display.CENTER)
    layer_:addTo(self):center()
	self.layer_ = layer_
	CommonView.animation_show_out(self.layer_)

--------------------------------------------
-- 背景框
	-- 底板
	CommonView.mFrame1()
	:addTo(self.layer_)
	:pos(480, 320)

	CommonView.mFrame3()
	:addTo(self.layer_)
	:pos(480, 315)

	-- 标题
	CommonView.titleFrame1()
	:addTo(self.layer_)	
	:pos(480, 480)

	display.newSprite("Word_PushSet.png"):addTo(self.layer_)	
	:pos(480, 480)

--------------------------------------------
	local open1 = PlayerSetData:isNotiPowerMax() 			-- 体力回满
	local open2 = PlayerSetData:isNotiPowerGet()			-- 领取体力
	local open3 = PlayerSetData:isNotiShopRefresh()			-- 商店刷新
	local open4 = PlayerSetData:isNotiActivity()			-- 活动开启

	-- 体力回满
	base.Grid.new():addTo(self.layer_)
	:pos(415, 360)
	:addLabel({text="体力回满", size=20, x=-90, y=0})
	:setNormalImage(display.newSprite("CloseButton.png"))
	:setSelectedImage(display.newSprite("Open_Button.png"))
	:onClicked(function(event)
		local isOpen = event.target:isSelected()
		isOpen = not isOpen

		event.target:setSelected(isOpen)
		PlayerSetData:openNotiPowerMax(isOpen)

		self:onEvent_({name="power_max", open=isOpen})

		CommonSound.click() -- 音效
	end, cc.size(90, 50))
	:setSelected(open1)

	-- 领取体力
	base.Grid.new():addTo(self.layer_)
	:pos(640, 360)
	:addLabel({text="领取体力", size=20, x=-90, y=0})
	:setNormalImage(display.newSprite("CloseButton.png"))
	:setSelectedImage(display.newSprite("Open_Button.png"))
	:onClicked(function(event)
		local isOpen = event.target:isSelected()
		isOpen = not isOpen

		event.target:setSelected(isOpen)
		PlayerSetData:openNotiPowerGet(isOpen)

		self:onEvent_({name="power_get", open=isOpen})

		CommonSound.click() -- 音效
	end)
	:setSelected(open2)

	-- 商店刷新
	base.Grid.new():addTo(self.layer_)
	:pos(415, 270)
	:addLabel({text="商店刷新", size=20, x=-90, y=0})
	:setNormalImage(display.newSprite("CloseButton.png"))
	:setSelectedImage(display.newSprite("Open_Button.png"))
	:onClicked(function(event)
		local isOpen = event.target:isSelected()
		isOpen = not isOpen

		event.target:setSelected(isOpen)
		PlayerSetData:openNotiShopRefresh(isOpen)

		self:onEvent_({name="shop_refresh", open=isOpen})

		CommonSound.click() -- 音效
	end)
	:setSelected(open3)

	-- 活动开启
	base.Grid.new():addTo(self.layer_)
	:pos(640, 270)
	:addLabel({text="活动开启", size=20, x=-90, y=0})
	:setNormalImage(display.newSprite("CloseButton.png"))
	:setSelectedImage(display.newSprite("Open_Button.png"))
	:onClicked(function(event)
		local isOpen = event.target:isSelected()
		isOpen = not isOpen

		event.target:setSelected(isOpen)
		PlayerSetData:openNotiActivity(isOpen)

		self:onEvent_({name="activity", open=isOpen})

		CommonSound.click() -- 音效
	end)
	:setSelected(open4)




	-- 按钮
	cc.ui.UIPushButton.new({
		normal = "Close.png",
        
	}):addTo(self.layer_)    
    :pos(725, 490)    
    :onButtonClicked(function(event)
        self:onEvent_({name="close"})

        CommonSound.close() -- 音效
    end)

	----------------------



end

function SetNotifLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end

function SetNotifLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 

return SetNotifLayer


