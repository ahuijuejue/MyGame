--[[
世界树选择英雄界面
]]
local TreeSelectLayer = class("TreeSelectLayer", function()
	return display.newNode()
end)

function TreeSelectLayer:setSuperCount(count)
	for i,v in ipairs(self.getViewList_) do
		if i <= self.limitGet_ then
			local grid = self.getViewList_[i]
			if i <= count then
				grid:setBackgroundImage(display.newSprite("PlatformLight2.png"):pos(0, -55), 3)
				:setSelectedImage(display.newSprite("PlatformLight_Effect2.png"):pos(0, -10), 6)
			else
				grid:setBackgroundImage(display.newSprite("PlatformLight.png"):pos(0, -55), 3)
				:setSelectedImage(display.newSprite("PlatformLight_Effect.png"):pos(0, -10), 6)
			end
		end
	end
end

function TreeSelectLayer:ctor(options)
	options=options or {}
	self:initData(options)
	self:initView()
	self:setNodeEventEnabled(true)
end

function TreeSelectLayer:initData(options)
	-- 位置上限
	self.maxGet_ = 7
	-- 可以选取英雄上限
	self.limitGet_ = options.limitnum or self.maxGet_
	self.limitGet_ = math.min(self.maxGet_, self.limitGet_)
	self.getDataList_ = {}
	self.data_ = {} -- 所有英雄数据
	print("limit:", self.limitGet_)
end

function TreeSelectLayer:initView()
	local layer_ = display.newNode():size(960, 640):align(display.CENTER):addTo(self):center()
	self.layer_ = layer_

	-- 背景框
	self.back = display.newSprite("Herolist_Board.png"):addTo(self):pos(display.cx, 70)

	-- 战斗力
	local posY = display.top - 90
	display.newSprite("Effective_Banner.png"):addTo(self):pos(130, posY)

	self.battleLabel_ = base.Grid.new():setNormalImage(NumberData:font2(0))
	:addTo(self)
	:zorder(1)
	:pos(110, posY)

	-- 已选取区域
	self:createGetLayer()
	self:setSuperCount(1)

	-- 欲操作说明
	-- display.newSprite("Tree_Title.png")
	CommonView.titleFrame2()
	:addTo(self)
	:pos(display.cx, 220)

	self.tipsLabel = base.Label.new({size=22})
	:addTo(self)
	:pos(display.cx, 220)
	:align(display.CENTER)

	-- 选择英雄 层
	self.layer1_ = self:createLayer1()
	:addTo(self.back)
	:pos(12, 20)
	:hide()

	-- 功能按钮 层
	self.layer2_ = self:createLayer2()
	:addTo(self.back)
	:pos(12, 20)
	:hide()

	-- 剩余次数
	self.haveTimesGrid = base.Grid.new()
	:addLabel({text="剩余次数", size=22})
	:addItemWithKey("times", base.Label.new({size=22}):align(display.CENTER):pos(0, -25))
	:addTo(self)
	:pos(display.cx - 400, 220)

	self:zorder(2)
end

local heroLabel = {
	"Word_Leader",
	"Word_Member1",
	"Word_Member2",
	"Word_Member3",
	"Word_Bench1",
	"Word_Bench2",
	"Word_Bench3"
}

-- -- 已选取区域
function TreeSelectLayer:createGetLayer()

	local function createHeroPos(zorder, pos)
		local index = #self.getViewList_ + 1

		local grid = base.Grid.new():addTo(self.layer_, zorder):pos(pos.x, pos.y)
		:setIndex(index)

		grid:addBase(display.newSprite(heroLabel[index] .. ".png"):pos(40, -65))

		return grid
	end

	self.getViewList_ = {}
	table.insert(self.getViewList_, createHeroPos(2, cc.p(800, 385)))
	table.insert(self.getViewList_, createHeroPos(2, cc.p(520, 360)))
	table.insert(self.getViewList_, createHeroPos(2, cc.p(320, 360)))
	table.insert(self.getViewList_, createHeroPos(2, cc.p(120, 360)))
	table.insert(self.getViewList_, createHeroPos(1, cc.p(610, 490)))
	table.insert(self.getViewList_, createHeroPos(1, cc.p(410, 490)))
	table.insert(self.getViewList_, createHeroPos(1, cc.p(210, 490)))

end

-- 选择英雄 层
function TreeSelectLayer:createLayer1()
	local layer = display.newNode()

	-- 世界树商店按钮
	self:createTreeShopButton():addTo(layer)
	:pos(100, 105)
	--------------------
	-- 刷新状态
	self.refreshBtn = base.Grid.new()
	:addItem("Tree_Refresh.png")
	:addLabel({text="刷新", size=22, x=0, y=55})
	:addTo(layer)
	:pos(820, 95)
	:onClicked(function()
		self:onButtonRefresh()
	end)

	local pri = display.newSprite("Tree_Number_Bar.png")

	display.newSprite("Diamond.png"):addTo(pri)
	:pos(15, 17)

	self.costGrid = base.Grid.new()
	:setNormalImage(base.Label.new({text="免费", size=22, color=cc.c3b(0,250,2)}):align(display.CENTER))
	:setSelectedImage(pri)
	:addItemWithKey("cost", base.Label.new({size=22, x=60, y=0}):align(display.CENTER_RIGHT))
	:addTo(layer, 2)
	:pos(820, 40)
	------------------
	-- 英雄列表
	local function createCacheHeroPos(index, point)
		local grid = base.Grid.new():addTo(layer, zorder):pos(point.x, point.y)
		:onClicked(function()
			self:selectedIndex(index)
		end, cc.size(180, 150))

		return grid
	end

	self.cacheViewList_ = {}
	table.insert(self.cacheViewList_, createCacheHeroPos(1, cc.p(290, 95)))
	table.insert(self.cacheViewList_, createCacheHeroPos(2, cc.p(470, 95)))
	table.insert(self.cacheViewList_, createCacheHeroPos(3, cc.p(650, 95)))

	return layer
end

-- 功能按钮 层
function TreeSelectLayer:createLayer2()
	local layer = display.newNode()

	-- 世界树商店按钮
	self:createTreeShopButton():addTo(layer)
	:pos(180, 105)

	-- 胜利场次
	self.winGrid = base.Grid.new()
	:addItem(display.newSprite("Tree_Win.png"))
	:addTo(layer)
	:pos(380, 105)

	-- 结束保卫
	base.Grid.new()
	:addItem(display.newSprite("Tree_Exit.png"))
	:onClicked(function()
		self:onButtonExitProtected()
	end, cc.size(160, 130))
	:addTo(layer)
	:pos(580, 105)

	-- 查看奖励
	base.Grid.new()
	:addItem(display.newSprite("Tree_Award.png"))
	:onClicked(function()
		self:onButtonCheckAwardList()
	end, cc.size(130, 130))
	:addTo(layer)
	:pos(780, 105)

	return layer
end

-- 世界树商店按钮
function TreeSelectLayer:createTreeShopButton()
	local btn = base.Grid.new()
	:addItem(display.newSprite("Tree_Shop.png"))
	-- :addItem(display.newSprite("Ready_Name_Banner.png"):pos(0, -70))
	-- :addLabel({text="世界树商店", size=20, x=0, y=-70}, 5)
	:onClicked(function()
		CommonSound.click() -- 音效
		print("世界树商店")
		NetHandler.gameRequest("OpenShop",{param1 = 3})
	end, cc.size(110, 110))

	return btn
end
-- 点击刷新按钮
function TreeSelectLayer:onButtonRefresh()
	CommonSound.click() -- 音效
	print("刷新")
	if TreeData.isTips then
		local msg = display.newNode()
		local cost = TreeData:getRefreshCost()

		if cost > 0 then
			local label1 = base.Label.new({text="是否花费", size= 24, color=cc.c3b(250,250,0)}):addTo(msg)
			local label2 = base.Label.new({text="刷新列表", size= 24, color=cc.c3b(250,250,0)}):addTo(msg)
			local label3 = base.Label.new({text=string.format("%d", cost), size= 24, color=cc.c3b(250,250,250)}):addTo(msg)
			local diamond = display.newSprite("Diamond.png"):addTo(msg)
			local w1 = label1:getContentSize().width
			local w2 = label2:getContentSize().width
			local w3 = label3:getContentSize().width
			local w4 = diamond:getContentSize().width
			w4 = w4 * 1.5
			local sX = (w1 + w2 + w3 + w4) * (-0.5)
			local posY = 30
			label1:pos(sX, posY)
			label2:pos(sX + w1 + w4 + w3, posY)
			label3:pos(sX + w1 + w4, posY)
			diamond:pos(sX + w1 + w4 * 0.5, posY)

		else
			base.Label.new({text="是否免费刷新列表", size= 24, color=cc.c3b(250,250,0)}):align(display.CENTER)
			:addTo(msg)
			:pos(0, 30)
		end

		base.Grid.new()
		:setBackgroundImage(display.newSprite("Check_Banner.png"))
		:setSelectedImage(display.newSprite("Check.png"))
		:onClicked(function(event)
			event.target:setSelected(TreeData.isTips)
			TreeData.isTips = not TreeData.isTips
		end)
		:addTo(msg)
		:pos(-80, -30)

		base.Label.new({text="今日不在提醒", size=20})
		:addTo(msg)
		:pos(-30, -30)

		AlertShow.show2("友情提示", msg, "确定", function()
			self:onRefresh()
		end)
	else
		self:onRefresh()
	end
end

function TreeSelectLayer:onRefresh()
	local cost = TreeData:getRefreshCost()
	if cost > UserData.diamond then
		GemsAlert:show()
	else
		self:onNetRefresh()
	end
end

-- 执行刷新
function TreeSelectLayer:onNetRefresh()
	print("确定刷新")
	showLoading()
	NetHandler.request("RefreshTreeWorldHeroList", {
		onsuccess = function()
			self:updateRefreshCost()
			self:updateListView()

			hideLoading()
		end,
		onerror = function()
			hideLoading()
		end
	}, self)

end

-- 点击结束保卫按钮
function TreeSelectLayer:onButtonExitProtected()
	CommonSound.click() -- 音效
	local msg = base.Label.new({text="是否退出此次保卫，\n直接领取奖励？", size=24, color=cc.c3b(250,250,0)}):align(display.CENTER)

	AlertShow.show2("退出保卫", msg, "确定", function()
		self:onExitProtected()
	end)
end

-- 结束保卫
function TreeSelectLayer:onExitProtected()
	print("结束保卫")
	NetHandler.request("EndTreeWorldAndReward", {
		onsuccess = function(params)
			UserData:showReward(params.items, function(event)
				if event.show == false then
					print("奖励为空")
				end
				app:popScene()
			end)
			hideLoading()
		end,
		onerror = function()
			hideLoading()
		end
	}, self)

end

-- 点击 查看奖励 按钮
function TreeSelectLayer:onButtonCheckAwardList()
	CommonSound.click() -- 音效
	self:onCheckAwardList()
end

-- 查看奖励
function TreeSelectLayer:onCheckAwardList()
	print("奖励列表")
	app:createView("trial.TreeAwardLayer")
	:addTo(self, 49)
	:onEvent(function(event)
		if event.name == "close" then
			event.target:removeSelf()
		end
	end)
end

-----------------------------------------------
-- 选择第几个
function TreeSelectLayer:selectedIndex(index)
	CommonSound.click() -- 音效
	print("选择：", index)

	local data = self:getCurrentList()[index]
	if data then
		-- 选中一个英雄
		showLoading()
		NetHandler.request("TreeWorldSelectHero", {
			data = {
				param1 = data.roleId,
			},
			onsuccess = function(params)
				self:selectedGetList(params.hero)
				self:updateRefreshCost()
				self:updateListView()
				self:updateTips()
				self:updateStart()

				hideLoading()
			end,
			onerror = function()
				hideLoading()
			end
		}, self)
	end
end

-----------------------------------------------
function TreeSelectLayer:canSelected()
	return #self.getDataList_ < self.limitGet_
end

function TreeSelectLayer:selectedGetList(data)
	if not data then return end
	table.insert(self.getDataList_, data)
	local show = self.getViewList_[#self.getDataList_]:removeItems()
	self:showGridGet(show, data, #self.getDataList_)

	self:updateBattle()
	self:listenerEvent_{name="selected"}
end

function TreeSelectLayer:showGrid(grid, data)
	local nameLayer = display.newNode():zorder(2)
	local typeImg = self:getHeroTypeImage(data.roleId)

	display.newSprite("Ready_Name_Banner.png"):addTo(nameLayer)
	base.Label.new({text=data.name, size=18}):align(display.CENTER):addTo(nameLayer)
	grid:addItemsWithKey({
		icon_ = display.newSprite(UserData:getHeroIcon(data.roleId)):pos(0, 20):zorder(2),
		border_ = display.newSprite(UserData:getHeroBorder(data)):pos(0, 20),
		-- border2_ = display.newSprite("Ready_Hero_Circle.png"):pos(0, 20):zorder(3),
		name_ = nameLayer:zorder(3):pos(0, -60),
		lvbk_ = display.newSprite("Name_Banner.png"):pos(40, -25):zorder(4),
		lvLabel_ = base.Label.new({text=tostring(data.level), color=cc.c3b(250,250,250), size=18}):align(display.CENTER):pos(40, -25):zorder(5),
		typeIcon_ = display.newSprite(typeImg):pos(-45, 55):zorder(6),
		typeIconBoarder_ = display.newSprite("Job_Circle.png"):pos(-45, 55):zorder(5),
		createStarIcon(data.starLv):pos(-50, -20):zorder(5),
	})

	return self
end

function TreeSelectLayer:showGridGet(grid, data, index)

	local typeImg = self:getHeroTypeImage(data.roleId)

	if index and index == 1 then
		local oldData = TreeData:getBattleHero(data.roleId)
		local hpProcess = 1
		local angerProcess = 0
		if oldData then
			hpProcess = oldData.hp
			angerProcess = oldData.anger / data.maxAnger
		end
		grid:addItemsWithKey({
			hpBack = display.newSprite("P_Slip.png"):pos(-55, -50):zorder(10):align(display.CENTER_LEFT),
			angerBack = display.newSprite("P_Slip.png"):pos(-55, -70):zorder(10):align(display.CENTER_LEFT),
			hpBar = UserData:slider("HP_Slip.png", hpProcess):zorder(11):align(display.CENTER_LEFT):pos(-52, -50),
			angerBar = UserData:slider("RP_Slip.png", angerProcess):zorder(11):align(display.CENTER_LEFT):pos(-52, -70),
		})
	else
		grid:addItemWithKey("hpBack", nil)
		grid:addItemWithKey("angerBack", nil)
		grid:addItemWithKey("hpBar", nil)
		grid:addItemWithKey("angerBar", nil)
	end

	grid:addItemsWithKey({
		icon = display.newSprite(UserData:getHeroIcon(data.roleId)):zorder(2):pos(0, 20),
		back = display.newSprite(UserData:getHeroBorder(data)):pos(0, 20),
		lvbk_ = display.newSprite("Name_Banner.png"):pos(40, -25):zorder(4),
		lvLabel_ = base.Label.new({text=tostring(data.level), color=cc.c3b(250,250,250), size=18}):align(display.CENTER):pos(40, -25):zorder(5),
		typeIcon_ = display.newSprite(typeImg):pos(-45, 55):zorder(6),
		typeIconBoarder_ = display.newSprite("Job_Circle.png"):pos(-45, 55):zorder(5),
		createStarIcon(data.starLv):pos(-50, -20):zorder(5),
	})
	:setSelected(true)

	return self
end

---------------------------------------------
function TreeSelectLayer:setHeroList(list)
	assert(type(list) == "table", "hero id list")
	while #list > self.limitGet_ do
		table.remove(list)
	end
	self.heroList_ = list
	return self
end

function TreeSelectLayer:getHeroList()
	local listData = {
		team1 = {},
		team2 = {},
	}
	for i,v in ipairs(self.getDataList_) do
		if i > 4 then
			table.insert(listData.team2, v)
		else
			table.insert(listData.team1, v)
		end

	end
	return listData
end

function TreeSelectLayer:getHeroCount()
	return #self.getDataList_
end

---------------------------------------------
function TreeSelectLayer:onTouch(listener)
	self.listener_ = listener
	return self
end

function TreeSelectLayer:listenerEvent_(event)
	if not self.listener_ then 	return 	end

	event.target = self
	event.count = #self.getDataList_
	self.listener_(event)
end
---------------------------------------------
---------------------------------------------

function TreeSelectLayer:onEnterTransitionFinish()
	self:updateData()
	self:updateView()
end

function TreeSelectLayer:updateData()
	local heroList_ = self.heroList_ or {}
	self.getDataList_ = {}
	for i,v in ipairs(heroList_) do
		table.insert(self.getDataList_, v)
	end

end

function TreeSelectLayer:getCurrentList()
	return TreeData:getHeroCacheList()
end

function TreeSelectLayer:updateView()
	self:updateListView()
	for i,v in ipairs(self.getDataList_) do
		local grid = self.getViewList_[i]
		self:showGridGet(grid, v, i)
	end

	for i=#self.getDataList_ + 1, self.limitGet_ do
		self.getViewList_[i]:removeItems()
	end

	self:updateBattle()
	if #self.getDataList_ > 0 then
		self:listenerEvent_{name="selected_pre"}
	end

	self:updateTips()
	self:updateRefreshCost()
	self:updateStart()
	self:updateWin()
	self:updateHaveTimes()
	self:updateExitProtected()
end

function TreeSelectLayer:updateListView()
	local datas = self:getCurrentList()

	for i,v in ipairs(self.cacheViewList_) do
		v:removeItems()
		local data = datas[i]
		if data then
			self:showGrid(v, data)
		end
	end

end

function TreeSelectLayer:updateBattle()
	local battle = 0
	for i,v in ipairs(self.getDataList_) do
		battle = battle + v:getHeroTotalPower()
	end
	-- print(battle)
	self.battleLabel_:setNormalImage(NumberData:font2(battle))
end

--------------------------
local tips = {
"选择队长",
"选择队员1",
"选择队员2",
"选择队员3",
"选择替补1",
"选择替补2",
"选择替补3",
"保卫世界树",
}
-- 更新提示
function TreeSelectLayer:updateTips()
	local index = #self.getDataList_ + 1
	self.tipsLabel:setString(tips[index])
end
--------------------------
-- 更新开始状态
function TreeSelectLayer:updateStart()
	local count = #self.getDataList_
	if count == 7 then -- 已经选择完毕
		self.layer2_:show()
		self.layer1_:hide()
	else -- 未选择完毕
		self.layer1_:show()
		self.layer2_:hide()
	end
end

--------------------------
-- 更新 刷新消耗状态
function TreeSelectLayer:updateRefreshCost()
	local cost = TreeData:getRefreshCost()
	if cost > 0 then
		self.costGrid:setSelected(true)
		self.costGrid:getItem("cost"):setString(tostring(cost))
	else
		self.costGrid:setSelected(false)
		self.costGrid:getItem("cost"):setString("")
	end
end

--------------------------
-- 更新胜利场次
function TreeSelectLayer:updateWin()
	local winLabel = self:createNum(TreeData.winTimes)
	self.winGrid:setNormalImage(winLabel:pos(0, 30), 10)
	self:showNumAni(winLabel, "BOUNCEOUT")

end

function TreeSelectLayer:createNum(value)
	return NumberData:font4(value):align(display.CENTER)
end

function TreeSelectLayer:showNumAni(target, actname)
	local action = cc.RepeatForever:create(transition.sequence({
		transition.create(cc.MoveBy:create(0.3, cc.p(0, 20)), {easing="EaseSineIn"}),
		transition.create(cc.MoveBy:create(0.5, cc.p(0, -20)), {easing=actname}),
		cc.DelayTime:create(2),

	}))

	target:runAction(action)
end

--------------------------
-- 更新剩余次数
function TreeSelectLayer:updateHaveTimes()
	local count = TreeData:getHaveTimes()
	local countMax = TreeData:getTimesMax()
	self.haveTimesGrid:getItem("times"):setString(string.format("(%d/%d)次", count, countMax))
end

-- 更新 结束保卫 状态
function TreeSelectLayer:updateExitProtected()

end

--------------------------
function TreeSelectLayer:onExit()
	self.heroList_ = self.getDataList_
	NetHandler.removeTarget(self)
end

function TreeSelectLayer:getHeroTypeImage(id)
	local cfg = GameConfig.Hero[id]
	return cfg.HeroJob
end

return TreeSelectLayer
