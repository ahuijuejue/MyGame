--[[
修炼圣地子关卡
]]
local HolyLandSubScene = class("HolyLandSubScene", base.Scene)

function HolyLandSubScene:initData() 		
	self.data = nil
	self.items_ = nil
end

function HolyLandSubScene:initView()
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


-- 主层
-----------------------------------------------------------
-- 背景框

	-- 底板框
	CommonView.backgroundFrame2()
	:addTo(self.layer_)
	:pos(430, 280)

	-- 标题
	CommonView.titleLinesFrame2()
	:addTo(self.layer_)
	:pos(430, 540)

	-- display.newSprite("word_light.png"):addTo(self.layer_)
	-- :pos(430, 540)

-----------------------------------------------------------

	-- 剩余次数 
	self.labelTimes = base.Label.new({size=22}):addTo(self.layer_)
	:pos(600, 460) 

	-- -- 开放描述
	-- base.Label.new({text=self.data.desc, size=22}):addTo(self.layer_)
	-- :pos(100, 460)

	-- 难度选择
	base.Label.new({text="难度选择", size=20}):addTo(self.layer_)
	:pos(80, 420)

	-- 玩法说明
	base.Label.new({text="玩法说明：", size=20}):addTo(self.layer_)
	:align(display.CENTER)
	:pos(100, 145)

	-- 玩法说明
	self.playDesc_ = base.Label.new({
		text = self.data.info,
		size=18,
		dimensions = cc.size(740, 90),
		align = cc.TEXT_ALIGNMENT_LEFT,			
	}):addTo(self.layer_)
	:pos(60, 130)
	:align(display.TOP_LEFT)

	-- 箭头
	local arrowLeft = display.newSprite("UpAndDown.png"):pos(50, 290):addTo(self.layer_):rotation(-90):hide()
	local arrowRight = display.newSprite("UpAndDown.png"):pos(810, 290):addTo(self.layer_):rotation(90):hide()
	self.arrow_ = {arrowLeft, arrowRight}

	-- 列表
	self.listView_ = base.ListView.new({
		viewRect = cc.rect(0, 0, 700, 200),
		direction = "horizontal",
		itemSize = cc.size(160, 200),
		page = true,
	})
	:addTo(self.layer_)
	:zorder(5)
	:pos(78, 195)
	:setBounceable(false)
	:onTouch(function(event)
		if event.name == "clicked" then 	
			CommonSound.click() -- 音效
					
			local index = event.itemPos
			if index then
				self:selectedIndex(index)			
			end

		elseif event.name == "moved" then  
			self:updateArrow()
		end 

	end)


end 

function HolyLandSubScene:selectedIndex(index)
	local data = self.items_[index]

	if self.lv >= data.level then 			
		print("选择难度:", index)
		if self.data.limitTimes > self.data.overTimes then 
			self:toInfoScene(index)
		else 
			showToast({text="次数已用完"})
		end 
	end 
end 

function HolyLandSubScene:toInfoScene(index)
end 

function HolyLandSubScene:updateArrow()
	local rect = self.listView_:getScrollNodeRect()
	local viewRect = self.listView_:getViewRect()

	local scrollX = self.listView_:getScrollNode():getPositionX()
	if scrollX < viewRect.x then 
		self.arrow_[1]:show()
	else
		self.arrow_[1]:hide()
	end 

	if scrollX + rect.width > viewRect.x + viewRect.width then 
		self.arrow_[2]:show()
	else 
		self.arrow_[2]:hide()
	end 
end

------------------------------------------

function HolyLandSubScene:updateData()
	self.lv = UserData:getUserLevel()

end

function HolyLandSubScene:updateView()
	self:updateListView()
	self:updateArrow()
	self:updateHaveTimes() 
end

function HolyLandSubScene:updateListView()
	self.listView_
	:removeAllItems()
	:addItems(#self.items_, function(event)
		local index = event.index 
		local data = self.items_[index]
		local grid = base.Grid.new()
		:addItem(display.newSprite("Trainning_Difficulty.png"))
		:addItem(display.newSprite(self:getDiffImgName()))
		:addItem(base.Label.new({text="难度"..convertToGreekNum(index)}):pos(0, 70):align(display.CENTER))

		if self.lv >= data.level then 
			-- 已解锁
			grid:addItem(base.Label.new({text="点击进入", color=cc.c3b(0,255,0), size=18}):pos(0, -70):align(display.CENTER))
			
		else 
			grid:addItems({
				base.Label.new({text=string.format("%d级开启", data.level), color=cc.c3b(255,0,0), size=18}):pos(0, -70):align(display.CENTER),
				display.newSprite("Trainning_Difficulty_Lock.png"),
			})
		end 

		return grid 
	end)
	:reload()
end 

-- 今日剩余次数
function HolyLandSubScene:updateHaveTimes()
	local str = string.format("今日剩余%d/%d次", self.data.limitTimes - self.data.overTimes, self.data.limitTimes)

	self.labelTimes:setString(str)
end 


return HolyLandSubScene



