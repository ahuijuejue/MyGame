--[[
战力活动层
]]
local SwordActivityLayer = class("SwordActivityLayer", function()
	return display.newNode()
end)

function SwordActivityLayer:ctor()
	self:initData()
	self:initView()
	self:setNodeEventEnabled(true)
end

function SwordActivityLayer:initData()
	self.requestCount = 0
	self.selectedIndex = 1
	self.haveDate = {
		day = 0,
		hour = 4,
		min = 9,
		sec = 11,
		s = 15111,
	}
	self.sword = 0
	for i,v in ipairs(HeroListData.heroList) do
        self.sword = self.sword + v:getHeroTotalPower()
    end  

	local data = SwordActivityData:getSwordAwardList()[1]
	self.okSword = data.battle

end

function SwordActivityLayer:initView()
	-- 灰层背景
	CommonView.blackLayer2()
    :addTo(self)
    :onTouch(function()
    	-- body
    end)

    self.layer_ = display.newNode():size(960, 640):align(display.CENTER)
    :addTo(self)
    :center()

    -- 关闭按钮
	CommonButton.close():addTo(self.layer_, 1)
	:pos(900, 535)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		self:onEvent_{name="close"}		
	end)

	---------------------------------
	CommonView.frame4()
	:addTo(self.layer_)
	:pos(480, 285)

	CommonView.frame5()
	:addTo(self.layer_)
	:pos(480, 257)

	display.newSprite("sword_role.png")
	:addTo(self.layer_)
	:pos(480, 550)

	display.newSprite("sword_coverLine.png")
	:addTo(self.layer_, 2)
	:pos(480, 377)

	local function moveNote(note, dt, fromX, fromY, addX, addY)
		note:pos(fromX, fromY)

		local seq = transition.sequence({
			transition.create(cc.MoveTo:create(dt, cc.p(fromX+addX, fromY+addY))),
   			transition.create(cc.MoveTo:create(dt, cc.p(fromX, fromY))),
		})
		local action = cc.RepeatForever:create(seq)
		note:runAction(action)
	end
	local noteSpr = nil 
	noteSpr = display.newSprite("sword_note_01.png")
	:addTo(self.layer_, 2)
	moveNote(noteSpr, 1, 590, 550, 0, 20)

	noteSpr = display.newSprite("sword_note_02.png")
	:addTo(self.layer_, 2)
	moveNote(noteSpr, 1, 340, 590, -10, 20)

	noteSpr = display.newSprite("sword_note_03.png")
	:addTo(self.layer_, 2)
	moveNote(noteSpr, 1, 540, 600, 0, -30)

	noteSpr = display.newSprite("sword_note_04.png")
	:addTo(self.layer_, 2)
	moveNote(noteSpr, 1, 295, 560, 10, -30)

	---------------------------------

	self.layers_ = {}
	table.insert(self.layers_, app:createView("activity.ActivityAwardLayer")) 		-- 活动奖励层
	table.insert(self.layers_, app:createView("activity.SwordAwardLayer")) 			-- 战力奖励层
	table.insert(self.layers_, app:createView("activity.ActivityRankingLayer")) 	-- 活动排名层
	table.insert(self.layers_, app:createView("activity.MikuIntroductionLayer")) 	-- 初音介绍层
	table.insert(self.layers_, app:createView("activity.ActivityRuleLayer")) 		-- 活动规则层

	for i,v in ipairs(self.layers_) do
		v:hide()
		:addTo(self.layer_)
		:pos(65, 62)
	end

-------------------------------------------------
	local function createNormalImage(text)
		local btnwidget = display.newSprite("sword_btn_normal.png")
		local label = base.Label.new({
			text=text, 
			size=26, 
			borderColor=cc.c4b(70, 18, 0, 255),
			color=cc.c3b(255,255,255),			
		})
		:addTo(btnwidget)
		:align(display.CENTER)
		:pos(btnwidget:getContentSize().width * 0.5, btnwidget:getContentSize().height * 0.5)

		return btnwidget
	end

	local function createSelectedImage(text)
		local btnwidget = display.newSprite("sword_btn_selected.png"):pos(0, 3)

		local label = base.Label.new({
			text=text, 
			size=26, 			
			borderColor=cc.c4b(100, 28, 0, 255),
			color=cc.c3b(255,255,255),	
		})
		:addTo(btnwidget)
		:align(display.CENTER)
		:pos(btnwidget:getContentSize().width * 0.5, btnwidget:getContentSize().height * 0.5)

		return btnwidget
	end
-- 侧边栏
	local btnNormalImage = "sword_btn_normal.png"	
	self.btnGroup_ = base.ButtonGroup.new({
		zorder1 = 1, 
		zorder2 = 1,		
	})		
	:addButtons({
		base.Grid.new({normal = createNormalImage("活动奖励"), selected = createSelectedImage("活动奖励")}),
		base.Grid.new({normal = createNormalImage("战力奖励"), selected = createSelectedImage("战力奖励")}),
		base.Grid.new({normal = createNormalImage("活动排名"), selected = createSelectedImage("活动排名")}),
		base.Grid.new({normal = createNormalImage("初音介绍"), selected = createSelectedImage("初音介绍")}),
		base.Grid.new({normal = createNormalImage("活动规则"), selected = createSelectedImage("活动规则")}),	
	})
	:walk(function(index, button)
		button:pos(153 + (index-1) * 164, 413):addTo(self.layer_)
	end)
	:onEvent(function(event)
		CommonSound.click() -- 音效
		self:updateLayerShow()
		
	end)
	:selectedButtonAtIndex_(self.selectedIndex)
---------------------------------------------------

	-- 日期
	-- display.newSprite("word_finishtime_activity.png")
	-- :addTo(self.layer_)
	-- :pos(745, 512)

	-- display.newSprite("word_day_1.png")
	-- :addTo(self.layer_)
	-- :pos(690, 485)

	self.timeLabel = base.Label.new({size=18, border=false})
	:addTo(self.layer_)
	:pos(790, 475)

	self.dayLabel = base.Grid.new()
	:addTo(self.layer_)
	:pos(710, 495)

	self:schedule(function()
        self:updateDateView()
    end, 0.2)

----------------------------------------------
	-- 信息
	self.infoBar = display.newNode()
	:addTo(self.layer_)
	:pos(90, 45)
	-- :hide()

	base.Label.new({text="我的战力：", size=22, border=false})
	:addTo(self.infoBar)

	self.swordLabel = base.Label.new({size=22, border=false})
	:addTo(self.infoBar)
	:pos(110, 0)

	self.rankLabel = base.Label.new({
		text = "",
		size=22, 
		border=false,
	})
	:align(display.CENTER)
	:addTo(self.infoBar)
	:pos(270, 0)

	self.rewardLabel = base.Label.new({
		text = string.format("战力达到%d才能发放排名奖励", self.okSword),
		size=22, 
		border=false,
		color=cc.c3b(210, 120, 60),
	})
	:addTo(self.infoBar)
	:pos(400, 0)

end

function SwordActivityLayer:showInfoBar(b)
	self.infoBar:setVisible(b)
end 

function SwordActivityLayer:showLayerAtIndex(index)
	for i,v in ipairs(self.layers_) do
		if i == index then 
			v:show()
		else 
			v:hide()
		end 
	end
end 

function SwordActivityLayer:getLayerAtIndex(index)
	return self.layers_[index]	
end 

function SwordActivityLayer:showAndUpdateLayer(index)
	for i,v in ipairs(self.layers_) do
		if i == index then 
			v:show()
			v:updateData()
			v:updateView()
		else 
			v:hide()
		end 		
	end

	-- self:showInfoBar(index == 1 or index == 2 or index == 3)
end 

function SwordActivityLayer:onEvent(listener)
	self.eventListener = listener 

	return self 
end

function SwordActivityLayer:onEvent_(event)
	if not self.eventListener then return end  

	event.target = self 
	self.eventListener(event)
end

function SwordActivityLayer:onEnter()
	
	self:updateData()
	self:updateView()

	CommonView.animation_show_out(self.layer_)
end

function SwordActivityLayer:updateData()
	self.ranking = 0
	if self.requestCount > 0 then 		
		self:updateListData()
	else 
		self:netShow()
	end 
end

function SwordActivityLayer:updateListData( ... )
	local data = RankData:getRank("sword") 
	self.ranking = data.rank 
	self:updateSword() 
end

function SwordActivityLayer:netShow()
	NetHandler.request("CommonRankingShow", {
			data = {param1 = 3},
			onsuccess = function()
		self:updateListData()

		self.requestCount = self.requestCount + 1
	end}, self) 
end 

function SwordActivityLayer:updateView()
	self:updateLayerShow()
	self:updateSword()
end

function SwordActivityLayer:updateLayerShow()
	self:showAndUpdateLayer(self.btnGroup_:getSelectedIndex())
end

function SwordActivityLayer:updateDateView()
	-- if SwordActivityData:isOpen() then 
	-- 	print("open")
	-- else 		
	-- 	print("不在开放时间")
	-- end 

	local date = SwordActivityData:getHaveDate()
	
	self.dayLabel:addItemWithKey("day", NumberData:font5(date.day):align(display.CENTER))
	self.timeLabel:setString(string.format("%02d:%02d:%02d", date.hour, date.min, date.sec))
end

function SwordActivityLayer:updateSword()
	local swordString = tostring(self.sword)
	self.swordLabel:setString(swordString)
	if self.ranking <= 50 then 		
		self.rankLabel:setString(string.format("%d名", self.ranking))
	else 
		self.rankLabel:setString("未上榜")
	end 
end 

return SwordActivityLayer