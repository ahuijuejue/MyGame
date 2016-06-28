
local TrialRuleLayer = class("TrialRuleLayer", function()
	return display.newNode()
end)


function TrialRuleLayer:ctor()
	self:initView()
end

function TrialRuleLayer:initView()
	CommonView.blackLayer2()
	:addTo(self)
	:onTouch(function(event)
		
	end)

	-------
	-- 背景
	display.newSprite("Trials_Rule.png"):addTo(self)
	:pos(display.cx, display.cy)

	-------
	-- 标题
	self.title_ = base.Grid.new():addTo(self)
	:pos(display.cx, display.cy + 230)
	
	-- 规则内容
	self.rule_ = base.Label.new({
		size=20,
		dimensions = cc.size(405, 430),
		align = cc.TEXT_ALIGNMENT_LEFT,	
		color = cc.c3b(71,25,0),
		border = false
	}):addTo(self)
	:pos(display.cx, display.cy + 175)
	:align(display.CENTER_TOP)

	-- 关闭按钮
	base.Grid.new():addTo(self)
	:pos(display.cx + 250, display.cy + 230)
	:setNormalImage("Close.png")
	:onTouch(function(event)
		if event.name == "clicked" then 
			CommonSound.close() -- 音效

			if self.closeEvent_ then 
				self.closeEvent_({target=self})
			end 
		end 
	end)
end

function TrialRuleLayer:setTitle(txt)
	local spr = txt 
	if type(txt) == "string" then 
		spr = display.newSprite(txt)
	end 
	self.title_:setNormalImage(spr)

	return self 
end 

function TrialRuleLayer:setRule(txt)
	self.rule_:setString(txt)

	return self 
end 

function TrialRuleLayer:onClose(listener)
	self.closeEvent_ = listener 

	return self 
end 


return TrialRuleLayer






