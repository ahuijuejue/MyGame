--[[
通用活动场景
]]
local BasicScene = import("..ui.BasicScene")
local NormalActivityScene = class("NormalActivityScene",BasicScene)

function NormalActivityScene:ctor()
	NormalActivityScene.super.ctor(self,"NormalActivityScene")

	self.layer_ = display.newLayer()
	:addTo(self)
	:size(960, 640)
	:pos(display.cx, display.cy)
	:align(display.CENTER)
	:zorder(1)

	self:initData()
	self:initView()
end

function NormalActivityScene:initData()
	self.sectionIndex = 1
	self.data = {}
end

function NormalActivityScene:initView()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer2()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {menu=false, back=false})
	:addTo(self)

	-- 关闭按钮
	CommonButton.close()
	:addTo(self.layer_, 7)
	:pos(900, 535)
	:scale(0.8)
	:onButtonClicked(function()
		CommonSound.close() -- 音效

		app:popScene()
	end)

-----------------------------
	CommonView.frame4()
    :addTo(self.layer_)
    :pos(480, 285)

    CommonView.mFrame5()
    :addTo(self.layer_)
    :pos(594, 266)

    display.newSprite("nor_activity_light.png")
    :addTo(self.layer_)
    :pos(595, 448)

    display.newSprite("nor_activity_title.png")
    :addTo(self.layer_)
    :pos(480, 540)



-----------------------------

	-- 列表 活动任务
	self.listView_ = base.GridViewOne.new({
		ver = 1,
		viewRect = cc.rect(0, 0, 600, 310),
		itemSize = cc.size(600, 130),
	}):addTo(self.layer_)
	:pos(295, 50)

	-- 添加主分区按钮
	self:addSectionButtons()

	self.titleLabel = base.Label.new({color=CommonView.color_white(), size=34,border = false,shadow = 1})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(594, 460)
	:zorder(5)

	self.desLabel = base.Label.new({color=cc.c3b(99,182,245), size=20})
	:align(display.CENTER)
	:addTo(self.layer_)
	:pos(594, 380)
	:zorder(5)

	self.timeLabel = base.Label.new({text = "活动倒计时：", color=CommonView.color_green(), size=20})
	:addTo(self.layer_)
	:pos(430, 410)
	:zorder(5)

	self:schedule(function()
        self:updateTimeLabel()
    end, 0.2)

end


-- 主分区按钮
function NormalActivityScene:addSectionButtons()

	-- 侧边 按钮	列表
	local addLeft = 15
	self.listView2_ = base.GridViewOne.new({
		viewRect = cc.rect(-addLeft, 0, 240+addLeft, 425),
		itemSize = cc.size(240, 101),
		page = true,
	})
	:addTo(self.layer_)
	:zorder(7)
	:pos(70, 70)
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

	-- 箭头
	local arrowUp = display.newSprite("UpAndDown.png"):pos(172, 515):addTo(self.layer_):rotation(0):hide()
	local arrowDown = display.newSprite("UpAndDown.png"):pos(172, 50):addTo(self.layer_):rotation(180):hide()
	self.arrow_ = {arrowUp, arrowDown}
end

function NormalActivityScene:updateArrow()
	local rect = self.listView2_:getScrollNodeRect()
	local viewRect = self.listView2_:getViewRect()

	local scrollY = self.listView2_:getScrollNode():getPositionY()
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

----------------------------------------------------------
-- ///////////////// 只设置显示 无数据操作//////////////////


-- 显示 选中 主分区一个按钮
function NormalActivityScene:showSelectedSectionIndex(index)
	if self.sectionIndex ~= index then
		local grid = self.listView2_:getItemAtIndex(self.sectionIndex)
		if grid then
			grid:setSelected(false)
		end
	end
	if #self.sectionList > 0 then
		local grid = self.listView2_:getItemAtIndex(index)
		grid:setSelected(true)
		self.titleLabel:setString(self.sectionList[index].title)
		self.desLabel:setString(self.sectionList[index].desc)
	end
end

-- ///////////////// 只设置显示 无数据操作//////////////////
------------------------------------------------------------

------------------------------------------------------------
------------------------------------------------------------
function NormalActivityScene:selectedIndex(index)
	if self.sectionIndex ~= index then
		local grid = self.listView2_:getItemAtIndex(self.sectionIndex)
		if grid then
			grid:setSelected(false)
		end

		grid = self.listView2_:getItemAtIndex(index)
		grid:setSelected(true)
		self:selectedSection(index)

		self:updateTimeLabel()
		self:updateDot()
	end
end

-- 点击了第index个主分区
function NormalActivityScene:selectedSection(index)
	self.sectionIndex = index
	self:updateActivity()
	self.titleLabel:setString(self.sectionList[index].title)
	self.desLabel:setString(self.sectionList[index].desc)
end


------------------------------------------------------------
function NormalActivityScene:updateData()
	self.sectionList = ActivityNormalData:getOpenArray()
	if self.sectionIndex > #self.sectionList then
		self.sectionIndex = 1
	end
end



function NormalActivityScene:updateView()
	print("updateView")
	self:updateSectionButtons()
	self:showSelectedSectionIndex(self.sectionIndex)

	self:updateActivity()
	self:updateTimeLabel()
	self:updateDot()
	self:updateArrow()

	if not self.isExit then
		CommonView.animation_show_out(self.layer_)
	end

	if self.listOffset then
		self.listView2_:getScrollNode():pos(unpack(self.listOffset))
	end
end

-- 更新侧边按钮
function NormalActivityScene:updateSectionButtons()
	print("更新侧边按钮")
	-- 重置侧栏按钮
	self.listView2_
	:resetData()
	:addSection({
		count = #self.sectionList,
		getItem = function(event)
			local index = event.index
			local data = self.sectionList[index]

			local btn = base.Grid.new()
			:setNormalImage(display.newSprite("nor_activity_btn_normal.png"):pos(-15, 0))
			:setSelectedImage(display.newSprite("nor_activity_btn_selected.png"), 2)
			:addItem(base.Label.new({text=data.name, size=24, color=CommonView.color_white()}):align(display.CENTER):pos(20, -5))

			btn:addItem(display.newSprite(data.icon):pos(-75, 0))

			btn:addItemWithKey("dot", display.newSprite("Point_Red.png"):zorder(11):pos(86, 41))

			return btn
		end
	})
	:reload()

end

-- 更新红点
function NormalActivityScene:updateDot()
	local list = ActivityNormalData:getOkIndexes(self.sectionList).list
	-- dump(list, "list")
	for i,v in ipairs(list) do
		local dotView = self.listView2_:getItemAtIndex(i):getItem("dot")
		dotView:setVisible(v)
	end
end

-- 更新活动
function NormalActivityScene:updateActivity()
	local sectionData = {}
	if #self.sectionList > 0 then
		sectionData = self.sectionList[self.sectionIndex]
	end
	-- local sectionData = self.sectionList[self.sectionIndex]
	local dataList = self:getActivityDataList()
	self:updateActivityData(dataList)
	self:updateListView(dataList)
	if sectionData.openType == 4 and UserData.buyGrowGift == 0 then
		if not self.growLayer then
			self.growLayer = require("app.views.activity.GrowGiftLayer").new()
			self.layer_:addChild(self.growLayer,6)
		end
	else
		if self.growLayer then
			self.growLayer:removeFromParent(true)
			self.growLayer = nil
		end
	end
end

-- 更新活动 数据
function NormalActivityScene:updateActivityData(dataList)
	-- ActivityUtil.parseActivities(dataList)
	ActivityNormalData:updateData()
	ActivityUtil.sortActivities(dataList)
end

-- 获取当前活动列表
function NormalActivityScene:getActivityDataList()
	if #self.sectionList > 0 then
		local sectionData = self.sectionList[self.sectionIndex]

		if sectionData then
			return sectionData.activity
		end
	end

	return {}
end

-- 更新显示具体活动列表
function NormalActivityScene:updateListView(dataList)
	if not self.listView_ then return end

	self.listView_
	:resetData()
	:addSection({
		count = table.nums(dataList),
		getItem = function(event)
			local index = event.index
			return self:createItemGrid(dataList[index])
		end
	})
	:reload()
end

function NormalActivityScene:updateTimeLabel()
	local data = self.sectionList[self.sectionIndex]
	if data then
		local openType = data.openType
		if openType == 3 or openType == 4 then
			self.timeLabel:setString("")
		else
			local sec = data.closeSec - UserData:getServerSecond()
			local date = convertSecToDate(sec)
			local labelstr = "活动倒计时："
			if date.day > 0 then
				labelstr = labelstr..tostring(date.day).."天"
			end
			labelstr = labelstr..string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
			if sec <= 0 then
				self.timeLabel:setString("活动已过期")
			else
				self.timeLabel:setString(labelstr)
			end
		end
	end
end

function NormalActivityScene:createItemGrid(data)
	local grid = base.Grid.new()

	grid:addItem(display.newSprite("nor_activity_cell.png"))

	if not data then return grid end
	local item = nil
	-- 任务描述
	local item = base.Label.new({text=data.desc, size=20})
	grid:addItem(item:pos(-250, 40))

	-- 任务奖励
	if data.isExchange then
		self:addExchangeItems(data, grid)
	else
		self:addNormalItems(data, grid)
	end

	-- 完成情况
	if data:isCompleted() then
		if data.isExchange then
			item = display.newSprite("btn_exchanged_gray.png")
		else
			item = display.newSprite("all_button_gray.png")
		end

		item:align(display.CENTER)
		grid:addItem(item:pos(205, -15))
	elseif data:isOk() then
		if data.isExchange then
			item = CommonButton.button({
				normal = "btn_exchange_yellow_normal.png",
				pressed = "btn_exchange_yellow_light.png",
			})

		else
			item = CommonButton.button({
				normal = "Activity_button.png",
				pressed = "Activity_button_light.png",
			})
		end
		item:onButtonClicked(function(event)
			CommonSound.click() -- 音效
			local time = self.sectionList[self.sectionIndex].closeSec
			local type_ = self.sectionList[self.sectionIndex].openType
			local isNeedCloseTime = type_ ~= 4 and type_ ~= 3
			if time - UserData:getServerSecond() <= 0 and isNeedCloseTime then
				showToast({text = "活动已过期！"})
			else
				NetHandler.gameRequest("FinishGeneralActivity",{param1 = data.id})
			end
		end)

		grid:addItem(item:pos(205, -15))
		grid:addItem(CommonView.animation_btn2():pos(205, -11))
	else
		item = CommonButton.yellow1()
        :onButtonClicked(function(event)
            CommonSound.click() -- 音效
            ActivityUtil.jumpUI(data, self)
        end)

		grid:addItem(item:pos(205, -15))

		-- 进度
		item = base.Label.new({text=data:getProcessString(), size=20})
		:align(display.CENTER_RIGHT)
		grid:addItem(item:pos(250, 40))
	end

	return grid
end

function NormalActivityScene:addNormalItems(data, grid)
	local item = nil
	local posX = -200
	local addX = 0
	for i,v in ipairs(data.items) do
		addX = (i-1) * 90

		-- 物品图像
		item = UserData:createItemView(v.id, {
			quality = v.quality,
			scale = 0.6,
		})
		grid:addItem(item:pos(posX+addX, -10))

		-- 物品数量
		item = base.Label.new({text=tostring(v.count), size=20})
		:align(display.CENTER_RIGHT)
		grid:addItem(item:pos(posX+addX + 40, -40))
	end
end

function NormalActivityScene:addExchangeItems(data, grid)
	local item = nil
	local posX = -200
	local addX = 0
	for i,v in ipairs(data.need) do
		addX = (i-1) * 80

		-- 物品图像
		item = UserData:createItemView(v.id, {
			scale = 0.7,
		})
		grid:addItem(item:pos(posX+addX, -10))

		-- 物品数量
		item = base.Label.new({text=tostring(v.count), size=20})
		:align(display.CENTER_RIGHT)
		grid:addItem(item:pos(posX+addX + 40, -40))
	end

	local posX = 80
	local addX = 0
	for i,v in ipairs(data.items) do
		addX = (i-1) * 80

		-- 物品图像
		item = UserData:createItemView(v.id, {
			quality = v.quality,
			scale = 0.7,
		})
		grid:addItem(item:pos(posX+addX, -10))

		-- 物品数量
		item = base.Label.new({text=tostring(v.count), size=20})
		:align(display.CENTER_RIGHT)
		grid:addItem(item:pos(posX+addX + 40, -40))
	end
	-- 箭头
	-- grid:addItem(CommonView.rAward1():pos(-20, -10))
	grid:addItem(CommonView.rAward1():pos(20, -10))

end

function NormalActivityScene:netCallback(event)
	local data = event.data
    local order = data.order
    if order == OperationCode.FinishGeneralActivityProcess then
		self:updateActivity()
		self:updateDot()

    	showToast({text="领取成功"})

		local showItems = UserData:parseItems(data.a_param1)
		UserData:showReward(showItems)
    elseif order == OperationCode.PurchaseFundProcess then
    	self:updateActivity()
    	showToast({text="购买成功"})
    end
end


function NormalActivityScene:onEnter()
	self:updateData()
	self:updateView()

	NormalActivityScene.super.onEnter(self)

	self.buyGoldOkEvent = UserData:addEvent(EVENT_CONSTANT.BUY_GOLD_SUCCESS, function()
		self:updateActivity()
		self:updateDot()
	end)
	self.buyPowerOkEvent = UserData:addEvent(EVENT_CONSTANT.BUY_POWER_SUCCESS, function()
		self:updateActivity()
		self:updateDot()
	end)
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function NormalActivityScene:onExit()
	UserData:removeEvent(self.buyGoldOkEvent)
	UserData:removeEvent(self.buyPowerOkEvent)

	self.listOffset = {self.listView2_:getScrollNode():getPosition()}
	NormalActivityScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.netEvent)
end

return NormalActivityScene
