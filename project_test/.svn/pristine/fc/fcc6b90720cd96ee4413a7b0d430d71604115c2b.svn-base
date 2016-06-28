--[[
起名
]]
local TakeNameLayer = class("TakeNameLayer", function()
	return display.newNode()
end)

function TakeNameLayer:ctor()
	-- 灰层背景
	-- display.newSprite("Background.png"):addTo(self):center()
	
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self)
    :center()
    -- :pos(display.cx, display.cy + 130)
	self.layer_ = layer_

--------------------------------------------
-- 背景框
	-- 底板
	CommonView.mFrame1()
	:addTo(self.layer_)
	:pos(480, 320)

	-- 标题
	CommonView.titleLinesFrame1()
	:addTo(self.layer_)	
	:pos(480, 490)

	display.newSprite("Word_ChangeName.png"):addTo(self.layer_)	
	:pos(480, 480)

	-- 名字底框
	CommonView.barFrame2()
	:addTo(self.layer_)	
	:pos(480, 340)
	
	base.Label.new({text="起个响亮的名字吧", size=20}):addTo(self.layer_)	
	:pos(305, 395)
--------------------------------------------

	local function changeName(editbox)
		local _text = editbox:getText()
		local _trimed = string.trim(_text)
		_trimed = parseString(_trimed, 12, 2)
		if _trimed ~= _text then
		    editbox:setText(_trimed)
		end
		return _trimed
	end

	-- 输入框
	local function onEdit(event, editbox)
	    if event == "began" then
	        -- 开始输入
	    elseif event == "changed" then
	        -- 输入框内容发生变化
	        changeName(editbox)
	    elseif event == "ended" then
	        -- 输入结束
	        changeName(editbox)
	    elseif event == "return" then
	        -- 从输入框返回
	        local str = changeName(editbox)
	        -- self:onEvent_({name="ok", text=str}) 
	    end
	end

	local textBack = display.newScale9Sprite()
	textBack:setOpacity(100)

	local textfield = cc.ui.UIInput.new({		
	    UIInputType = 1,
	    image = textBack,
	    -- "Input_Box.png",	    
	    size = cc.size(280, 35),
	   	x = 315,
	    y = 345,
	    listener = onEdit,
	}):addTo(self.layer_)
	:align(display.LEFT_CENTER)
	
	textfield:setPlaceHolder("最多六个汉字")

---------------------------
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

   	-- 随机名字
    cc.ui.UIPushButton.new({
		normal = "RadomName.png",
        pressed = "RadomName.png",        
	}):addTo(self.layer_)
    :pos(635, 340)        
    :onButtonClicked(function(event)    	
    	local nameStr = NameData:getName()    	
   		textfield:setText(nameStr)

   		CommonSound.click() -- 音效
    end) 
----------------------

	local nameStr = NameData:getName()    	
   	textfield:setText(nameStr)
end

function TakeNameLayer:onEvent(listener)
	self.eventListener_ = listener 
	return self 
end

function TakeNameLayer:onEvent_(event)
	if not self.eventListener_ then return end 
	event.target = self 
	self.eventListener_(event)
end 

return TakeNameLayer


