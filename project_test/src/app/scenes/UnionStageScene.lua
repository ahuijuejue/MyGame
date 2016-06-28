local BasicScene = import("..ui.BasicScene")
local UnionStageScene = class("UnionStageScene", BasicScene)


local starString = {
	"塔不倒",
	"队员不死",
	"不使用变身",
	"不召唤替补",
	"单人通关",
	"基地血量大于等于50%",
	"基地不受到伤害",
	"出场人数小于等于3人",
	"出场人数小于等于5人",
	"60秒过关",
}

local typeString = {
	"普通",
	"防守",
	"护送",
	"逃跑",
	"单骑",
}

function UnionStageScene:ctor(chapter)
	UnionStageScene.super.ctor(self,"UnionStageScene")
	self.chapterData = chapter
	self:initView()
end

function UnionStageScene:initView()
	self.layer_ = display.newLayer()
	:addTo(self)
	:size(960, 640)
	:pos(display.cx, display.cy)
	:align(display.CENTER)
	:zorder(1)

	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	self.menuLayer = app:createView("widget.MenuLayer", {wealth="instancePower"}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

	-- 背景框
	CommonView.boardFrame1()
	:addTo(self.layer_)
	:pos(435, 280)

	display.newSprite("Stage_Left.png"):addTo(self.layer_):pos(575, 295)
	display.newSprite("Stage_Right.png"):addTo(self.layer_):pos(173, 280)
	display.newSprite("Stage_SubBack1.png"):addTo(self.layer_):pos(575, 195)
	display.newSprite("Stage_Line.png"):addTo(self.layer_):pos(575, 465)

	-- 三星条件
	base.Label.new({text="三星条件：", color=cc.c3b(255,255,0), size=20})
	:addTo(self.layer_):pos(370, 380)

	-- 可能掉落
	display.newSprite("Word_Fall.png"):addTo(self.layer_):pos(420, 240)--:scale(0.9)

	-- 体力
	base.Label.new({text=string.format("体力消耗：%d",self.chapterData:getCostPower()), color=cc.c3b(255,255,250), size=20})
	:addTo(self.layer_):pos(370, 415)

	display.newSprite("item_14.png"):addTo(self.layer_):pos(525, 415):scale(0.25)

	-- 星星
	for i=1,3 do
		display.newSprite("Star_Gray.png"):addTo(self.layer_):pos(675 + 35 * i, 470)
	end

	display.newSprite("Star_Yellow.png"):addTo(self.layer_):pos(665, 526)
	for i=1,3 do
		display.newSprite("Star_Yellow.png"):addTo(self.layer_):pos(410, 250 + i * 35):scale(0.7)
	end

	-- 关卡列表
	local arrowUp = display.newSprite("UpAndDown.png"):pos(170, 515):addTo(self.layer_):rotation(0):hide()
	local arrowDown = display.newSprite("UpAndDown.png"):pos(170, 40):addTo(self.layer_):rotation(180):hide()
	self.arrow_ = {arrowUp, arrowDown}

	self.listView_ = base.GridViewOne.new({
		viewRect = cc.rect(0, 0, 256, 410),
		itemSize = cc.size(256, 113),
		page = true,
	})
	:addTo(self.layer_)
	:zorder(5)
	:pos(40, 78)
	:setBounceable(false)
	:onTouch(function(event)
		if event.name == "selected" then
			local index = event.index
			if index then
				self:selectedIndex(index)

				CommonSound.click() -- 音效
			end
		elseif event.name == "moved" or event.name == "page_ended" then
			self:updateArrow()
		end

	end)

	-- 出征 按钮
	self.startBtn = CommonButton.button({
		normal="Button_Ready.png",
		pressed="Button_Ready_Light.png"
	})
	:addTo(self.layer_)
	:pos(720, 85)
	:onButtonClicked(function()
		CommonSound.click() -- 音效

		self:startGame()
	end)

	createAniArrow():addTo(self.layer_, 10)
	:pos(720, 160)

	-- 扫荡
	local btnSweep = CommonButton.yellow("扫荡", {borderColor=cc.c4b(69,31,4,255)})
	:pos(480, 85)
	:onButtonClicked(function()
		CommonSound.click()
		self:didSweep()
	end)

	self.grid_ = base.Grid.new():addTo(self.layer_):zorder(2)


	self.grid_:addItemsWithKey({
		btnSweep = btnSweep,
		labelSweep = base.Label.new({text="关卡达到三星可以\n开启扫荡功能", size=20, color=cc.c3b(0,250,10)}):pos(390, 85):hide(),
		dropItems = display.newNode():pos(430, 175),
		--
		chapter = base.Label.new({size=22, color=cc.c3b(250,250, 0)}):pos(530, 525):align(display.CENTER), -- 章节名
		mission = base.Label.new({size=20, color=cc.c3b(0,250, 250)}):pos(400, 470), -- 关卡名
		chapterStar = base.Label.new({size=20}):pos(690, 525), -- 章节获得星星
		labelStar1 = base.Label.new({size=20}):pos(430, 355),
		labelStar2 = base.Label.new({size=20}):pos(430, 320),
		labelStar3 = base.Label.new({size=20}):pos(430, 285),
		star1 = display.newSprite("Star_Yellow.png"):pos(710, 470),
		star2 = display.newSprite("Star_Yellow.png"):pos(745, 470),
		star3 = display.newSprite("Star_Yellow.png"):pos(780, 470),
	})

	if self.chapterData.type ~= 1 then
		self.grid_:addItem(base.Label.new({text="剩余次数：", color=cc.c3b(255,255,250), size=20}):pos(630, 385))
		self.grid_:addItemWithKey("remaining", base.Label.new({color=cc.c3b(255,255,250), size=20}):pos(740, 385))
	end
end

-- 是否是精英关卡
function UnionStageScene:toAddEliteTimes()
	local data = self:getSelectedData()
	ElitAlert:show(data.id, function()
		self:showInfoView(self.selectedIndex_)
	end)
end

-- 是否是精英关卡
function UnionStageScene:isElite()
	return self.chapterData_:isElite()
end

function UnionStageScene:selectedIndex(index)
	if self.selectedIndex_ ~= index and #self.items_ > 0 then
		self:__selectedIndex(index)
	end
end

function UnionStageScene:__selectedIndex(index)
	local data = self.items_[index]
	if data and UnionListData:isStageOpen(data.id) then
		self.listView_:walkItems(function(event)
			event.item:setSelected(index == event.index)
		end)

		self.selectedIndex_ = index
		self:showInfoView(index)

		self.listView_:showRow(index)
	end
end

function UnionStageScene:getSelectedData()
	local index = self.selectedIndex_
	return self.items_[index]
end

function UnionStageScene:showInfoView(index) -- 显示关卡信息
	local data = self.items_[index]
	local grid = self.grid_

	local preNameStr
	if data.Order then
		preNameStr = string.format("%d-%d-%d", self.chapterData.sort, data.Sort, data.Order)
	else
		preNameStr = string.format("%d-%d", self.chapterData.sort, data.Sort)
	end

	grid:getItem("mission"):setString(string.format("%s  %s", preNameStr, data.Name))
	grid:getItem("labelStar1"):setString("通过本关")
	grid:getItem("labelStar2"):setString(string.format("%d秒内通关", data.SecondStarTime))
	grid:getItem("labelStar3"):setString(starString[tonumber(data.ThirdStarCondition)])

	-- 关卡种类
	if data.Type > 1 then
		grid:addItemsWithKey({
			typeMark = self:createMark(data):pos(660, 470)
		})
	else
		grid:addItemWithKey("typeMark", nil)
	end

	-- 3星通关
	if UnionListData:getStageStar(data.id) >= 3 then
		grid:getItem("btnSweep"):show()
		grid:getItem("labelSweep"):hide()
	else
		grid:getItem("labelSweep"):show()
		grid:getItem("btnSweep"):hide()
	end
	-- 关卡星级显示
	for i=1,3 do
		if UnionListData:getStageStar(data.id) >= i then
			grid:getItem(string.format("star%d", i)):show()
		else
			grid:getItem(string.format("star%d", i)):hide()
		end
	end

	if self.chapterData.type ~= 1 then
		local leftTimes = UnionListData:getStageLeftTimes(data.id)
		local limitTimes = self.chapterData:getPassTimes()
		grid:getItem("remaining"):setString(string.format("%d/%d", leftTimes, limitTimes))
	end

	-- 可能掉落
	local dropLayer = grid:getItem("dropItems")
	dropLayer:removeAllChildren()
	for i,v in ipairs(data.FallItem) do
		UserData:createItemView(v):addTo(dropLayer):pos((i - 1) * 105, 0):scale(0.7)
	end
end

function UnionStageScene:createMark(data)
	local spr = display.newSprite("Stage_Mark.png")
	base.Label.new({text=typeString[data.Type], size=20}):align(display.CENTER)
	:addTo(spr)
	:pos(32.5, 20)

	return spr
end

function UnionStageScene:didSweep()
	local stage = self:getSelectedData()
	if UnionListData:getStageLeftTimes(stage.id) < 1 then
		local param = {text = "次数不足",size = 30,color = display.COLOR_RED}
        showToast(param)
		return
	end
	if UserData.unionPower < self.chapterData:getCostPower() then
		local param = {text = "工会体力不足，请前往战争之地获取",size = 30,color = display.COLOR_RED}
        showToast(param)
		return
	end
	NetHandler.gameRequest("SaoDang",{param1 = stage.id, param2 = 1, param3 = self.chapterData.type})
end

-- 点击开始游戏
function UnionStageScene:startGame()
	local data = self:getSelectedData()
	local times = UnionListData:getStageLeftTimes(data.id)
	if times < 1 then
		local param = {text = "次数不足",size = 30,color = display.COLOR_RED}
        showToast(param)
		return
	end

	if UserData.unionPower < self.chapterData:getCostPower() then
		local param = {text = "工会体力不足，请前往战争之地获取",size = 30,color = display.COLOR_RED}
        showToast(param)
		return
	end

	app:pushScene("UnionReadyBattleScene", {data})
end

function UnionStageScene:showSweep(data)
	local arrShow = {}
	for i,v in ipairs(data) do
		local showItem = UserData:parseItems(v)
		table.insert(arrShow,showItem)
	end

	local stage = self:getSelectedData()
	local power = self.chapterData:getCostPower()
	local userLv = UserData:getUserLevel()
	local gold = stage.Gold + userLv * 50 * power
	local uCoin = math.floor(userLv/10) + 1

	app:createView("sweep.SweepDisplayLayer", {
		name = stage.Name,
		drops = arrShow,
		drugs = {},
		gold = {gold},
		uCoin = {uCoin},
		soul = {0},
		exp = 0,
	}):addTo(self)
	:zorder(10)
	:onEvent(function(event)
		if event.name == "close" then
			event.target:removeSelf()
		elseif event.name == "completed" then
			self:updateElite()
		end
	end)
	:start()
end

function UnionStageScene:updateData()
	self.items_ = UnionListData:getShowStages(self.chapterData)
	if UnionListData:isChapterPass(self.chapterData) then
		self.selectedIndex_ = 1
	else
		self.selectedIndex_ = #self.items_ - 1
	end
end

function UnionStageScene:updateView()
	self:updateListView()
	self:updateArrow()
	self:updateChapterInfo()
	self:updateElite()
	self:__selectedIndex(self.selectedIndex_)
end

function UnionStageScene:updateListView()
	self.listView_
	:resetData()
	:addSection({
		count=#self.items_,
		getItem = handler(self, self.createItem)
	})
	:reload()
end

function UnionStageScene:createItem(event)
	local index = event.index
	local data = self.items_[index]
	local grid = base.Grid.new()

	local preNameStr
	if data.Order then
		preNameStr = string.format("%d-%d-%d", self.chapterData.sort, data.Sort, data.Order)
	else
		preNameStr = string.format("%d-%d", self.chapterData.sort, data.Sort)
	end
	local preName = base.Label.new({text = preNameStr, color=cc.c3b(0,250, 250), size=20})
	local stageName = base.Label.new({text = data.Name, size=20}):align(display.CENTER)

	if data.Order then
		grid:setNormalImage(display.newSprite("SubStage_Button.png"):pos(20, 0))
		grid:setSelectedImage(display.newSprite("SubStage_Select.png"):pos(20, 0), 2)
		preName:pos(-65, 27)
		stageName:pos(20, 0)
		grid:addItem(display.newSprite("SubStage_Line.png"):pos(-115, 0))
	else
		grid:setNormalImage(display.newSprite("Button.png"))
		grid:setSelectedImage(display.newSprite("Button_Select.png"), 2)
		preName:pos(-105, 27)
		stageName:pos(0, 0)
	end
	grid:addItem(preName)
	grid:addItem(stageName)

	if data.Type > 1 then
		grid:addItem(self:createMark(data):pos(90, 27))
	end

	if UnionListData:isStageOpen(data.id) then -- 关卡解锁
		local stars = {}
		for i=1,3 do
			local star = display.newSprite("Star_Gray.png"):pos(30 + 20 * i, -30):scale(0.6)
			table.insert(stars, star)
			if UnionListData:getStageStar(data.id) >= i then
				star = display.newSprite("Star_Yellow.png"):pos(30 + 20 * i, -30):scale(0.6)
				table.insert(stars, star)
			end
		end
		grid:addItems(stars)
	else
		grid:addItem(base.Label.new({text="未开放", size=20}):align(display.CENTER):pos(70, -30))
	end

	return grid
end

function UnionStageScene:updateArrow()
	local rect = self.listView_:getScrollNodeRect()
	local viewRect = self.listView_:getViewRect()

	local scrollY = self.listView_:getScrollNode():getPositionY()
	if scrollY < viewRect.y then
		self.arrow_[2]:show()
	else
		self.arrow_[2]:hide()
	end

	if scrollY + rect.height > viewRect.y + viewRect.height then
		self.arrow_[1]:show()
	else
		self.arrow_[1]:hide()
	end
end

function UnionStageScene:updateChapterInfo() -- 显示章节信息
	local data = self.chapterData
	self.grid_:getItem("chapter"):setString(string.format("%s %s", data.title, data.name))
	self.grid_:getItem("chapterStar"):setString(string.format("%d/%d",UnionListData:getChapterStar(data), data.maxStar))
end

function UnionStageScene:updateElite()
	local data = self:getSelectedData()
	if data then
		local leftTimes = UnionListData:getStageLeftTimes(data.id)
		local limitTimes = self.chapterData:getPassTimes()
		self.grid_:getItem("remaining"):setString(string.format("%d/%d", leftTimes, limitTimes))
	end
end

function UnionStageScene:onEnter()
	UnionStageScene.super.onEnter(self)
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
	self:updateData()
	self:updateView()
end

function UnionStageScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.SaoDangProcess then
		self:showSweep(data.a_param1)
    end
end

function UnionStageScene:onExit()
	UnionStageScene.super.onExit(self)
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionStageScene
