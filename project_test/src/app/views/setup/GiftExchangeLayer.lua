
local GiftExchangeLayer = class("GiftExchangeLayer", function()
	return display.newNode()
end)

function GiftExchangeLayer:ctor()
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

	-- 标题
	CommonView.titleFrame1()
	:addTo(self.layer_)	
	:pos(480, 480)

	display.newSprite("Word_Gift_Exchange.png"):addTo(self.layer_)	
	:pos(480, 480)

	-- 名字底框
	CommonView.barFrame2()
	:addTo(self.layer_)	
	:pos(480, 340)

--------------------------------------------
	-- 输入框
	local function onEdit(event, editbox)
	    if event == "began" then
	        -- 开始输入
	    elseif event == "changed" then
	        -- 输入框内容发生变化
	        local _text = editbox:getText()
			local _trimed = string.trim(_text)
			_trimed = parseString(_trimed, 20, 2)
			if _trimed ~= _text then
			    editbox:setText(_trimed)
			end
	    elseif event == "ended" then
	        -- 输入结束
	    elseif event == "return" then
	        -- 从输入框返回
	    end
	end

	local textBack = display.newScale9Sprite()
	textBack:setOpacity(100)

	local textfield = cc.ui.UIInput.new({		
	    UIInputType = 1,
	    image = textBack,
	    -- "Input_Box.png",	    
	    size = cc.size(330, 35),
	   	x = 315,
	    y = 345,
	    listener = onEdit,
	}):addTo(self.layer_)
	:align(display.LEFT_CENTER)
	
	textfield:setPlaceHolder("请输入兑换码")
	
---------------------------------------------------	
-- 按钮	
	-- 取消
	CommonButton.red("取消")
	:addTo(self.layer_)    
    :pos(325, 190)
    :onButtonClicked(function(event)
        self:onEvent_({name="close"})

        CommonSound.click() -- 音效
    end)

    -- 确定
    CommonButton.green("确定")
    :addTo(self.layer_)    
    :pos(635, 190) 
    :onButtonClicked(function(event)
    	local nameStr = textfield:getText()    	   		
        self:onEvent_({name="ok", text=nameStr})

        CommonSound.click() -- 音效
    end)

	----------------------

end

function GiftExchangeLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end

function GiftExchangeLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 

return GiftExchangeLayer


