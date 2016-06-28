--[[
开场引导场景
]]
local OpenScene = class("OpenScene", base.Scene)


local showType = {
	cartoon1 = "cartoon1",
	cartoon2 = "cartoon2",
}


function OpenScene:initData()
	print("OpenScene:initData()")
	self.showType_ = showType.cartoon1 
end 

function OpenScene:initView()
	self:autoCleanImage()

	local wordTips = base.Label.new({text="点击跳过", size=24, color=cc.c3b(250,0,0)})
	:align(display.CENTER)

    local sequence = transition.sequence({
        cc.DelayTime:create(1),
        cc.FadeTo:create(1, 10),
        cc.DelayTime:create(0.5),
        cc.FadeTo:create(1, 255),        
    })
    local action = cc.RepeatForever:create(sequence)   
    wordTips:runAction(action)

	self.nextButton = base.Grid.new() 
	:addItem(wordTips:pos(0, -display.cy + 100))
	:addTo(self)
	:zorder(5)
	:center()
	:onClicked(function()
		CommonSound.click() -- 音效
		
		self:onNext()
	end, cc.size(display.width, display.height))
	
end 

function OpenScene:updateView()

	self.nextButton:hide() 
end 

function OpenScene:onGuide()
	if not GuideManager:makeOpenGuide(targetScene) then -- 没有引导了 
		app:enterScene("MainScene")
	end 
end 

function OpenScene:onNext() 
	self.showIndex = self.showIndex + 1 
	if self.showIndex <= self.showMax then 
		self.arr[self.showIndex]:show()
	else 
		self:onEnd()
	end 
end 

function OpenScene:onEnd()
	self.nextButton:hide()
	if self.showType_ == showType.cartoon1 then 
		self:cartoon1End()
	elseif self.showType_ == showType.cartoon2 then 
		self:cartoon2End()
	end 
end 

return OpenScene 