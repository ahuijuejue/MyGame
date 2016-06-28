--[[
商店场景基类
]]

local ShopItemLayer = app:getView("shop.ShopItemLayer")

local ShopScene = class("ShopScene", base.Scene)
local TabNode = import("app.ui.TabNode")

local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"

local OPENSHOP = {
    ["1"] = "OpenShopNormal",
    ["2"] = "OpenShopScore",
    ["4"] = "OpenShopArena",
    ["3"] = "OpenShopTree",
    ["6"] = "OpenShopAincrad",
    ["9"] = "OpenShopUnion",
}

local BUTTON_ID = {
	BUTTON_NORMAL  = 1,
	BUTTON_SCORE   = 2,
	BUTTON_AINCRAD = 3,
	BUTTON_TREE    = 4,
	BUTTON_UNION   = 5,
}

function ShopScene:initData(params)
	params = params or {}
	-- self.sceneOrder = params.sceneOrder
	-- self.shopType = params.shopType
	self.data = {}
	self.viewTag = ShopList.shopType
	print("ShopList.shopType -- "..ShopList.shopType)

end

function ShopScene:initView()
	-- self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

    self.menuNode = app:createView("widget.MenuLayer", {wealth="card"}):addTo(self):zorder(10)
	:onBack(function(layer)
		self:pop()
	end)
--------------------------------------------------------
-- 背景框
	local posX = 435

	CommonView.backgroundFrame2()
	:addTo(self.layer_)
	:pos(posX, 280)
	:zorder(2)

	display.newSprite("Board_Shop.png"):addTo(self.layer_)
	:pos(posX, 148)
	:zorder(2)

	display.newSprite("Board_Shop.png"):addTo(self.layer_)
	:pos(posX, 358)
	:zorder(2)

	display.newSprite("Banner_Title.png"):addTo(self.layer_)
	:pos(posX, 535)
	:zorder(2)

--------------------------------------------------------
	-- 侧边栏按钮
	self:createTabButton()

	-- 商品列表
	self.listView_ = base.GridView.new({
		rows = 2,
		viewRect = cc.rect(0, 0, 750, 420),
		direction = "horizontal",
		itemSize = cc.size(180, 210),
	}):addTo(self.layer_)
	:setBounceable(false)
	:pos(70, 55)
	:zorder(2)
	:onTouch(function(event)
		if event.name == "clicked" then
			local index = event.itemPos
			if index then
				CommonSound.click() -- 音效

				self:selectedIndex(index)
			end
		end
	end)

	-- 下次刷新
	display.newSprite("Word_Shop_NextTime.png"):addTo(self.layer_)
	:pos(120, 475)
	:zorder(2)

	self.refreshTime_ = base.Label.new({
		color = display.COLOR_GREEN,
		size = 18,
	}):addTo(self.layer_)
	:pos(210, 477)
	:zorder(2)

	-- 刷新按钮
	self.refreshBtn_ = CommonButton.red()
	:add(display.newSprite("Word_Shop_Refresh.png"))
	:addTo(self.layer_)
	:pos(750, 490)
	:zorder(2)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效

		print("刷新")
		local msg = {
			base.Label.new({text="是否花费"}):pos(30, 100),
			base.Label.new({text=string.format("x%d刷新商品", self.data.value)}):pos(200, 100),
			display.newSprite(self.data:getRefreshIcon()):pos(165, 100),
		}

		AlertShow.show2("提示", msg, "确定", function()
			self:refreshShop()
		end)
	end)

	-- 物品弹出信息
	self.shopItemLayer_ = ShopItemLayer.new()
	:addTo(self)
	:zorder(11)
	:onOk(function(item)
		print("ok")
		self:willBuyIndex(item:getIndex())
	end)
	:onCancel(function(item)
		print("cancel")
		item:hide()
	end)
	:hide()

end

function ShopScene:createTabButton()
	local btnEvent = handler(self, self.buttonEvent)
	local param = {normal = tabNormalImage, pressed = tabPressImage, size = 22, event = btnEvent}

    local normalTab = TabNode.new(param)
    normalTab:pos(885, 420)
    normalTab:setTag(BUTTON_ID.BUTTON_NORMAL)
    normalTab:setString("普通")
    normalTab:addTo(self.layer_)

    local scoreTab = TabNode.new(param)
    scoreTab:pos(885, 345)
    scoreTab:setTag(BUTTON_ID.BUTTON_SCORE)
    scoreTab:setString("积分")
    scoreTab:addTo(self.layer_)

    local aincradTab = TabNode.new(param)
    aincradTab:pos(885, 270)
    aincradTab:setTag(BUTTON_ID.BUTTON_AINCRAD)
    aincradTab:setString("葛朗特")
    aincradTab:addTo(self.layer_)

    local treeTab = TabNode.new(param)
    treeTab:pos(885, 195)
    treeTab:setTag(BUTTON_ID.BUTTON_TREE)
    treeTab:setString("世界树")
    treeTab:addTo(self.layer_)

    local unionTab = TabNode.new(param)
    unionTab:pos(885, 120)
    unionTab:setTag(BUTTON_ID.BUTTON_UNION)
    unionTab:setString("公会")
    unionTab:addTo(self.layer_)

    self.tabNodes = {normalTab, scoreTab, aincradTab, treeTab, unionTab}

	self.tabNodes[self.viewTag]:setPressedStatus()
    self.tabNodes[self.viewTag]:setLocalZOrder(3)

end

function ShopScene:hideView()
	self.data = {}
end

function ShopScene:showView()
	if self.viewTag == 1 then
		NetHandler.gameRequest("OpenShop",{param1 = 1})
	elseif self.viewTag == 2 then
		NetHandler.gameRequest("OpenShop",{param1 = 2})
	elseif self.viewTag == 3 then
		NetHandler.gameRequest("OpenShop",{param1 = 6})
	elseif self.viewTag == 4 then
		NetHandler.gameRequest("OpenShop",{param1 = 3})
	elseif self.viewTag == 5 then
		NetHandler.gameRequest("OpenShop",{param1 = 9})
	end
end

function ShopScene:resetTabStatus()
	for k in pairs(self.tabNodes) do
		self.tabNodes[k]:setNormalStatus()
		self.tabNodes[k]:setLocalZOrder(1)
	end
end

function ShopScene:buttonEvent(event)
	AudioManage.playSound("Click.mp3")
	local tag = event.target:getTag()
	self:resetTabStatus()
    event.target:setLocalZOrder(3)
    event.target:setPressedStatus()

    self.tabNodes[self.viewTag]:setNormalStatus()
    self.tabNodes[self.viewTag]:setLocalZOrder(1)

    self:hideView()
    self.viewTag = tag
    self:showView()
end

function ShopScene:selectedIndex(index)
	local data = self.data.items[index]
	if data.sell then
		self.shopItemLayer_:show()
		:setIndex(index)
		:setTitle(data.name, UserData:getItemColor(data.itemCfg))
		:setHave(data.have)
		:setDescription(data.desc)
		:setIcon(UserData:createItemView(data.itemId, {tips=false}))
		:setItemNum(data.count)
		:setPrice(data.price)
		:setPriceUnit(data:getSellIcon())
	end

end

-- ///////////////////////
function ShopScene:setRefreshTime(txt)
	self.refreshTime_:setString(txt)
end

function ShopScene:setGridShow(grid, data)
	grid:addItems({
		UserData:createItemView(data.itemId, {tips=false}):pos(0, 25):scale(0.8),
		display.newSprite(data:getSellIcon()):pos(-32, -36):scale(0.6),
		base.Label.new({text = tostring(data.price), size=18}):pos(10, -36):align(display.CENTER),
		display.newSprite("Shop_Goods_Name.png"):pos(0, -88),
		base.Label.new({text = data.name, color = UserData:getItemColor(data.itemCfg), size=20}):pos(0, -88):align(display.CENTER)
		})
	if data.count > 1 then
		grid:addItems({
			display.newSprite("Banner_Level.png"):pos(34, -6):scale(0.7),
			base.Label.new({text = tostring(data.count), size=18})
				:align(display.CENTER):pos(34, -6),
		})
	end
	-- if data.sale and data.sale ~= 0 then   -- 图标 折扣
	-- 	grid:addItems({
	-- 		-- display.newSprite(".png"):pos(30, 70),
	-- 		base.Label.new({text = data.sale.."折", size=18}):pos(20, 60):zorder(3)
	-- 	})
	-- end

	grid:setSelected(not data:isSelling())
end

function ShopScene:willBuyIndex(index)
	local data = self.data.items[index]
	local shopIndex = self.data:getShopIndex()
	NetHandler.request("BuyShopGoods", {
		data = {
			param1 	= data.id,
			param2 	= index-1,
			param3 	= shopIndex,
		},
		onsuccess = function()
			self:updateView()
			self:didBuyItem()
			showToast({text="购买成功"})
		end
	}, self)
end

function ShopScene:didBuyItem()
	showToast({text="购买成功"})
	self.shopItemLayer_:hide()
end

function ShopScene:refreshShop()
	local shopIndex = self.data:getShopIndex()
	NetHandler.request("HandRefreshShop", {
		data = {param1=shopIndex},
		onsuccess = function()
			self:updateData()
			self:updateView()
		end
	}, self)
end

function ShopScene:updateData()
	if self.viewTag == 1 then
		self.data = ShopList:getShop("normal")
	elseif self.viewTag == 2 then
		self.data = ShopList:getShop("score")
	elseif self.viewTag == 3 then
		self.data = ShopList:getShop("aincrad")
	elseif self.viewTag == 4 then
		self.data = ShopList:getShop("tree")
	elseif self.viewTag == 5 then
		self.data = ShopList:getShop("union")
	end
end

function ShopScene:updateView()
	self:updateTabButton()
	self:updateMenuLayer()
	self:updateListView()
	self:setRefreshTime(self.data.timeStr)
end

function ShopScene:updateMenuLayer()
	if self.menuNode then
		self.menuNode:removeFromParent()
		self.menuNode = nil
	end
	if self.viewTag == 1 or self.viewTag == 2 then
		self.menuNode = app:createView("widget.MenuLayer", {wealth="card"}):addTo(self):zorder(10)
		:onBack(function(layer)
			self:pop()
		end)
	elseif self.viewTag == 3 then
		self.menuNode = app:createView("widget.MenuLayer", {wealth="castle"}):addTo(self):zorder(10)
		:onBack(function(layer)
			self:pop()
		end)
	elseif self.viewTag == 4 then
		self.menuNode = app:createView("widget.MenuLayer", {wealth="tree"}):addTo(self):zorder(10)
		:onBack(function(layer)
			self:pop()
		end)
	elseif self.viewTag == 5 then
		self.menuNode = app:createView("widget.MenuLayer", {wealth="union"}):addTo(self):zorder(10)
		:onBack(function(layer)
			self:pop()
		end)
	end
end

function ShopScene:updateTabButton()
	self.tabNodes[3]:setVisible(AincradData:isAincradOpen())
	self.tabNodes[4]:setVisible(TreeData:isTreeOpen())
	if UserData.unionId then
		self.tabNodes[5]:setVisible(UserData.unionId ~= "")
	else
		self.tabNodes[5]:setVisible(false)
	end
end

function ShopScene:updateListView()
	self.listView_
	:removeAllItems()
	:addItems(#self.data.items, function(event)
		local index = event.index
		local data = self.data.items[index]
		local grid = base.Grid.new({type=1})
			:setBackgroundImage(display.newSprite("Banner_Goods.png"):pos(7, 5))
			:setSelectedImage("Sold_Out.png", 6)
		self:setGridShow(grid, data)

		return grid
	end)
	:reload()
end

function ShopScene:netCallback(event)
    local data = event.data
    local order = event.order
    if order == OperationCode.BuyShopGoodsResponse and data.result == 5 then
		local shopIndex = tonumber(data.param3)
		NetHandler.gameRequest("OpenShop",{param1=shopIndex})
    elseif order == OperationCode.OpenShopResponse then
    	self:updateData()
    	self:updateView()
    end
end

function ShopScene:onEnter()
	self:updateData()
	self:updateView()
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function ShopScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
	ShopScene.super.onExit(self)
end

return ShopScene
