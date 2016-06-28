
local UpdateLayer = class("UpdateLayer", function()
	return display.newNode()
end)

function UpdateLayer:ctor()
	self:initView()
end

function UpdateLayer:initView()
	display.newSprite("Update_Board.png"):addTo(self)

	display.newSprite("Update_litle.png")
	:addTo(self)
	:pos(0, 222)

	cc.ui.UILabel.new({
		text = "当前不是最新版本，请更新最新版本！",
		size = 24,
		color = cc.c3b(250, 250, 0)
	})
	:align(display.CENTER)
	:addTo(self)
	:pos(0, 60)

	-- 更新通知需要更新大小的label
    self.sizeLabel_ = cc.ui.UILabel.new({
    	text = "",
    	size = 24,
    	color = cc.c3b(250, 250, 0),
		align = cc.TEXT_ALIGNMENT_CENTER,
	})
    :align(display.CENTER)
    :addTo(self)
    :pos(0, -80)

	local btn = cc.ui.UIPushButton.new({normal="Login_Enter.png"})
	btn:setButtonLabel(cc.ui.UILabel.new({text="确定", size=20}):align(display.CENTER))

	btn:addTo(self)
	:pos(0, -185)
	:onButtonClicked(function(event)
		self:onEvent_({name="clicked"})		
	end)

	
end

function UpdateLayer:onEvent(listener)
    self.event_ = listener 

    return self 
end

function UpdateLayer:onEvent_(event)
    if not self.event_ then return end 
    event.target = self 
    self.event_(event)
end 

function UpdateLayer:setSizeLabel(txt)
	self.sizeLabel_:setString(txt)
end 


return UpdateLayer
