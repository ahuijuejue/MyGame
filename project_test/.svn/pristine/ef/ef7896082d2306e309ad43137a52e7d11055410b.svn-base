
local ArenaIntegralScene = class("ArenaIntegralScene", base.Scene)

function ArenaIntegralScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {wealth="arena"}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

	local layer_ = self.layer_

	app:createView("arena.ArenaIntegralLayer"):addTo(self.layer_, 2)
	:onEvent(function()
		self:updateRedPoint()
	end)
	

---------------------------------------------------------
-- 侧边按钮
	-- 竞技
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="竞技", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 450)
	:zorder(1)
	:onClicked(function(event)	
		CommonSound.click() -- 音效

		SceneData:enterScene("Arena", self) 		
	end)

	-- 商店
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="商店", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 375)
	:zorder(1)
	:onClicked(function(event)			
		CommonSound.click() -- 音效
		
		SceneData:enterScene("ShopArena", self)	
	end)

	-- 积分
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="积分", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 300)
	:zorder(5)
	:setSelected(true) 

------------------------------------------------------------
-- 提示红点
	self.redPoint = display.newSprite("Point_Red.png"):addTo(self.layer_)
	:zorder(5)
	:pos(940, 330)
	:hide()

------------------------------------------------------------

end 

function ArenaIntegralScene:updateView()
	self:updateRedPoint()
end 

function ArenaIntegralScene:updateRedPoint()
	if ArenaData:haveAward() then 
		self.redPoint:show()
	else 
		self.redPoint:hide()
	end 
end 

return ArenaIntegralScene