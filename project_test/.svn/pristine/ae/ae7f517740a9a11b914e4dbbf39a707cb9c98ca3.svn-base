--[[
修炼圣地子关卡详细信息场景
]]

local HolyLandInfoSubScene = class("HolyLandInfoSubScene", base.Scene)

-- options.grade 难度

function HolyLandInfoSubScene:initData(options)	
	self.grade = options.grade or 1
	self.items_ = {}
end

function HolyLandInfoSubScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()
	
	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer"):addTo(self)	
	:onBack(function(layer)
		self:pop()
	end)

	self:initBackgroundFrame()
	self:initDescriptionShow()
	
end 

-- 背景框
function HolyLandInfoSubScene:initBackgroundFrame()

	display.newSprite("Lamp_Borad.png")
	:addTo(self.layer_)
	:pos(435, 280)

	-- 标题	
	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(430, 540)
	:zorder(2)

	-- 阵型介绍
	display.newSprite("Lamp_Formation.png")
	:addTo(self.layer_)
	:pos(270, 260)

	-- 信息
	display.newSprite("Lamp_Info.png")
	:addTo(self.layer_)
	:pos(680, 290)

	-- 3波类型
	display.newSprite("Lamp_huawen3.png")
	:addTo(self.layer_)
	:pos(115, 110)

	display.newSprite("Lamp_huawen3.png")
	:addTo(self.layer_)
	:pos(270, 110)

	display.newSprite("Lamp_huawen3.png")
	:addTo(self.layer_)
	:pos(425, 110)

	self.posLabel1 = base.Label.new({text="", size=20})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(115, 110)

	self.posLabel2 = base.Label.new({text="", size=20})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(270, 110)

	self.posLabel3 = base.Label.new({text="", size=20})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(425, 110)

	-- 标题
	local title = self:createTitle()
	if title then 
		title:addTo(self.layer_)
		:pos(430, 540)
		:zorder(2)
	end 

	title = self:createSubTitle1()
	if title then 
		title:addTo(self.layer_)
		:pos(260, 485)
	end 

	title = self:createSubTitle2()
	if title then 
		title:addTo(self.layer_)
		:pos(685, 485)
	end 


	-- 出征 按钮
	base.Grid.new()
	:addTo(self.layer_)
	:pos(710, 80)
	:zorder(5)
	:setNormalImage(display.newSprite("Lamp_Button.png"))
	-- :addItem(base.Label.new({text="出征", size=22}):align(display.CENTER))
	:onClicked(function(event)
		CommonSound.click() -- 音效		
		self:toBattleScene()
	end)

end 

-- 场景标题
function HolyLandInfoSubScene:createTitle()
end 

-- 副标题1 阵型字
function HolyLandInfoSubScene:createSubTitle1()
end 

-- 副标题2
function HolyLandInfoSubScene:createSubTitle2()
end 

function HolyLandInfoSubScene:initDescriptionShow()
end 

function HolyLandInfoSubScene:toBattleScene()
end 

function HolyLandInfoSubScene:updateView()
	self:updateFormation()
end

-- 更新阵型显示
function HolyLandInfoSubScene:updateFormation()	
end 

return HolyLandInfoSubScene

