
local SetSoundLayer = class("SetSoundLayer", function()
	return display.newNode()
end)

function SetSoundLayer:ctor()

	-- 灰层背景
	-- display.newSprite("Background.png"):addTo(self):center()
	
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

	-- 标题
	CommonView.titleFrame1()
	:addTo(self.layer_)	
	:pos(480, 480)

	display.newSprite("Word_SoundSet.png"):addTo(self.layer_)	
	:pos(480, 480)

--------------------------------------------
	local mOpen = PlayerSetData:isMusicOpen()
	local sOpen = PlayerSetData:isSoundOpen()

	-- 音乐
	base.Grid.new():addTo(self.layer_)
	:pos(370, 260)
	:setBackgroundImage(display.newSprite("SoundEffect_Button.png"):pos(0, 90))
	:setNormalImage(display.newSprite("CloseButton.png"))
	:setSelectedImage(display.newSprite("Open_Button.png"))
	:onClicked(function(event)
		local isOpen = event.target:isSelected()
		isOpen = not isOpen
		
		event.target:setSelected(isOpen)

		PlayerSetData:openMusic(isOpen)
		-- self:onEvent_({name="music", open=isOpen})

		CommonSound.click() -- 音效
	end, cc.size(90, 50))
	:setSelected(mOpen)

	-- 音效
	base.Grid.new():addTo(self.layer_)
	:pos(590, 260)
	:setBackgroundImage(display.newSprite("Music_Button.png"):pos(0, 90))
	:setNormalImage(display.newSprite("CloseButton.png"))
	:setSelectedImage(display.newSprite("Open_Button.png"))
	:onClicked(function(event)
		local isOpen = event.target:isSelected()
		isOpen = not isOpen		
		event.target:setSelected(isOpen)
		PlayerSetData:openSound(isOpen)
		
		self:onEvent_({name="sound", open=isOpen})

		CommonSound.click() -- 音效
	end, cc.size(90, 50))
	:setSelected(sOpen)


	---------------------------
	-- 按钮
	CommonButton.green("确定")
	:addTo(self.layer_)    
    :pos(480, 185)    
    :onButtonClicked(function(event)
        self:onEvent_({name="close"})

        CommonSound.click() -- 音效
    end)

	----------------------


end

function SetSoundLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end

function SetSoundLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 


return SetSoundLayer


