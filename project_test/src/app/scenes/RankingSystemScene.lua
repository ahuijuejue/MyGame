--[[
排名系统 场景
]]

local RankingSystemScene = class("RankingSystemScene", base.Scene)

function RankingSystemScene:initData()
	self.listData = {}
	table.insert(self.listData, {
		icon = "Icon_Ranking_Level.png",
		name = "等级排名",
		layerName = "rank.TeamLvRankingLayer", -- 层 名
		orderName = 4, 	-- 排行榜类型名 "teamLv"

	})
	table.insert(self.listData, {
		icon = "Icon_Ranking_Sword.png",
		name = "战斗力排名",
		layerName = "rank.SwordRankingLayer", -- 层 名
		orderName = 3, 	-- 请求服务器 "sword"rank
	})
	table.insert(self.listData, {
		icon = "Icon_Ranking_Stage.png",
		name = "关卡排名",
		layerName = "rank.StageStarRankingLayer", -- 层 名
		orderName = 5, 	-- 请求服务器 "stageStar"
	})
	table.insert(self.listData, {
		icon = "Icon_Ranking_Union.png",
		name = "公会排名",
		layerName = "rank.UnionRankingLayer", -- 层 名
		orderName = 7, 	-- 请求服务器 "union"
	})

	self.selectedIndex_ = 1

	self.isRequired = {}
	for i,v in ipairs(self.listData) do
		table.insert(self.isRequired, false)
	end
end

function RankingSystemScene:initView()

	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	self.menuLayer = app:createView("widget.MenuLayer"):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)

-------------------------------------------------
-- 背景框
	CommonView.boardFrame1()
	:addTo(self.layer_)
	:pos(430, 280)


	CommonView.frameScale9(220, 484)
	:addTo(self.layer_)
	:pos(138, 280)

	CommonView.frameScale9(580, 484)
	:addTo(self.layer_)
	:pos(542, 280)

-------------------------------------------------
-------------------------------------------------
-- 列表
	-- 箭头
	local arrowUp = display.newSprite("UpAndDown.png"):pos(170, 515):addTo(self.layer_):rotation(0):hide()
	local arrowDown = display.newSprite("UpAndDown.png"):pos(170, 40):addTo(self.layer_):rotation(180):hide()
	self.arrow_ = {arrowUp, arrowDown}

	-- 列表
	self.listView_ = base.GridViewOne.new({
		viewRect = cc.rect(0, 0, 240, 430),
		itemSize = cc.size(240, 110),
		page = true,
	})
	:addTo(self.layer_)
	:zorder(5)
	:pos(35, 78)
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

-------------------------------------------------
	self.layers = {}
	for i,v in ipairs(self.listData) do
		local layer = app:createView(v.layerName)
		:addTo(self.layer_)
		:pos(260, 50)
		table.insert(self.layers, layer)
	end

end

function RankingSystemScene:selectedIndex(index)
	print("index:", index)
	if self.selectedIndex_ ~= index and #self.listData > 0 then
		self:__selectedIndex(index)
	end
end

function RankingSystemScene:__selectedIndex(index)
	print("did selected:", index)
	local data = self.listData[index]
	if data then
		self.listView_:walkItems(function(event)
			event.item:setSelected(index == event.index)
		end)

		self.selectedIndex_ = index
		self.listView_:showRow(index)
		self:showLayer(index)
	end
end

function RankingSystemScene:showLayer(index)
	for i,v in ipairs(self.layers) do
		if i == index then
			v:show()
		else
			v:hide()
		end
	end

	if not self.isRequired[index] then
		local orderName = self.listData[index].orderName
		local layer = self.layers[index]
		NetHandler.request("CommonRankingShow", {
			data = {param1=orderName},
			onsuccess = function()
				self.isRequired[index] = true
				layer:updateData()
				layer:updateView()
			end
		}, self)
	end
end

function RankingSystemScene:updateData()

end

function RankingSystemScene:updateView()

	self:updateListView()
	self:updateArrow()
	self:__selectedIndex(self.selectedIndex_)

end

function RankingSystemScene:updateListView()
	self.listView_
	:resetData()
	:addSection({
		count=#self.listData,
		getItem = handler(self, self.createItem)
	})
	:reload()
end

function RankingSystemScene:createItem(event)
	local index = event.index
	local data = self.listData[index]
	-- dump(data)
	local grid = base.Grid.new()

	grid:setNormalImage(display.newSprite("NaviBar1_Normal.png"):pos(-16, 0))
	grid:setSelectedImage(display.newSprite("NaviBar1_Selected.png"), 2)


	grid:addItem(display.newSprite(data.icon):pos(-80, 0))
	local nameLabel = base.Label.new({text=data.name, size=24, color=CommonView.color_orange()}):align(display.CENTER):pos(10, -5)
	grid:addItem(nameLabel)


	return grid
end

function RankingSystemScene:updateArrow()
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

return RankingSystemScene



