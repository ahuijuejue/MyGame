--[[
艾恩葛朗特 获得奖励界面 
]]
local AincradMaoScene = class("AincradMaoScene", base.Scene)

function AincradMaoScene:initData() 
	self.items = AincradData:getWillReward() 
end

function AincradMaoScene:initView()	
	-- 背景
	CommonView.background_aincrad()
	:addTo(self)
	:center()


	-- 按钮层
	app:createView("widget.MenuLayer", {back=false, menu=false, wealth="castle"}):addTo(self)	
	:zorder(0)
	:onBack(function(layer)
		
	end)

	CommonView.blackLayer2()
	:addTo(self)
	
---------------------------------------------------------------------
	-- 背景框 
	CommonView.titleLinesFrame2()
	:addTo(self.layer_, 2)
	:pos(480, 520)

	display.newSprite("word_maochang.png")
	:addTo(self.layer_, 2)
	:pos(480, 520)
	:scale(0.9)
	
---------------------------------------------------------------------
	display.newSprite("Aincrad_Data_Award.png"):addTo(self.layer_)
	:pos(160, 320)

	display.newSprite("Aincrad_Data_Award.png"):addTo(self.layer_)
	:pos(800, 320)

	display.newSprite("Aincrad_CastleCoin.png"):addTo(self.layer_)
	:pos(160, 240)

	display.newSprite("Aincrad_Award_Random.png"):addTo(self.layer_)
	:pos(160, 400)

	display.newSprite("Aincrad_Award_Diamond.png"):addTo(self.layer_)
	:pos(800, 240)

	display.newSprite("Aincrad_Award_Gold.png"):addTo(self.layer_)
	:pos(800, 400)

	base.Label.new({text="稀有奖励", size=22}):addTo(self.layer_)
	:align(display.CENTER)
	:pos(160, 500)

	base.Label.new({text="常规奖励", size=22}):addTo(self.layer_)
	:align(display.CENTER)
	:pos(800, 500)

---------------------------------------------------------------------
	
	display.newSprite("Aincrad_Data.png"):addTo(self.layer_)
	:pos(480, 300)

------------------------------------------------------------------
-- 花费宝石 
	display.newSprite("Diamond.png"):addTo(self.layer_)
	:pos(580, 120)
	:scale(0.7)

	self.labelCost = base.Label.new({text="", size=20, color=cc.c3b(0,162,255)})
	:addTo(self.layer_)
	:pos(630, 120)

-----------------------------------------------------------------
	-- 离开按钮 
	self.outButton = CommonButton.yellow("离开")
	:addTo(self.layer_, 2)
	:pos(340, 70)
	:onButtonClicked(function()
		CommonSound.click() -- 音效

		self:onButtonOut()
	end)

	-- 开启按钮 
	self.openButton = CommonButton.yellow("开启")
	:addTo(self.layer_, 2)
	:pos(620, 70)
	:onButtonClicked(function()
		CommonSound.click() -- 音效
		
		self:onButtonOk()
	end)
-----------------------------------------------------------------
	-- 动画
	local posX = 480
	self:showUpAni(posX-20, 0.005, 1)
	self:showUpAni(posX+20, 0.0055, 1)

	self:showUpAni(posX- 60, 0.004, 0.9)
	self:showUpAni(posX+ 60, 0.004, 0.9)

	self:showUpAni(posX - 100, 0.002, 0.5)
	self:showUpAni(posX + 100, 0.002, 0.5)

end 

function AincradMaoScene:showUpAni(posX, speed, scale)
	CommonView.animation_move_b2u({
		target = self.layer_,
		fromX = posX,
		toX = posX,
		fromY = 320-display.cy,
		toY = 320+display.cy,
		zorder = 0,
		speed = speed,
		space = 20,
		scale = scale or 1,
	})
end 

-- 离开事件
function AincradMaoScene:onButtonOut()
	self.outButton:setButtonEnabled(false) 
	print("离开")
	app:pushScene("AincradScene")	
end 

-- 开启事件
function AincradMaoScene:onButtonOk()	 
	NetHandler.request("OpenAincradBox", {
		onsuccess = function(items)
			UserData:showReward(items)
			self:updateCost()
		end,		
	}, self)
end 

function AincradMaoScene:updateView()
	self:updateCost()
end 

function AincradMaoScene:updateCost()
	local str = string.format("%d", AincradData:getAwardCost())
	self.labelCost:setString(str)
end 

return AincradMaoScene
