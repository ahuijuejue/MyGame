
--[[
	竞技场商店
]]

local ArenaShopScene = class("ArenaShopScene", base.Scene)
local ShopItemLayer = app:getView("shop.ShopItemLayer")

function ArenaShopScene:initData()
	self.data = {}
end

function ArenaShopScene:initView()
	ArenaShopScene.super.initView(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {wealth="arena"}):addTo(self)
	:onBack(function(layer)
		app:popScene()
	end)
--------------------------------------------------------
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

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

--------------------------------------------------------
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

--------------------------------------------------------
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
	:zorder(5)
	:setSelected(true)

	-- 积分
	base.Grid.new()
	:setBackgroundImage("Label_Normal.png")
	:setSelectedImage("Label_Select.png", 2)
	:addItems({
		base.Label.new({text="积分", size=22}):align(display.CENTER):pos(5, 0)
	})
	:addTo(self.layer_)
	:pos(885, 300)
	:zorder(1)
	:onClicked(function(event)
		CommonSound.click() -- 音效

		app:enterScene("ArenaIntegralScene")
	end)

------------------------------------------------------------
-- 提示红点
	self.redPoint = display.newSprite("Point_Red.png"):addTo(self.layer_)
	:zorder(5)
	:pos(940, 330)
	:hide()

end

function ArenaShopScene:selectedIndex(index)
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
function ArenaShopScene:setRefreshTime(txt)
	self.refreshTime_:setString(txt)
end

function ArenaShopScene:setGridShow(grid, data)
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

function ArenaShopScene:willBuyIndex(index)
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

function ArenaShopScene:didBuyItem()
	showToast({text="购买成功"})
	self.shopItemLayer_:hide()
end

function ArenaShopScene:refreshShop()
	local shopIndex = self.data:getShopIndex()
	NetHandler.request("HandRefreshShop", {
		data = {param1=shopIndex},
		onsuccess = function()
			self:updateData()
			self:updateView()
		end
	}, self)
end


function ArenaShopScene:updateData()
	self.data = ShopList:getShop("arena")
end

function ArenaShopScene:updateView()
    self:updateListView()
	self:updateRedPoint()
end

function ArenaShopScene:updateListView()
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

function ArenaShopScene:updateRedPoint()
	if ArenaData:haveAward() then
		self.redPoint:show()
	else
		self.redPoint:hide()
	end
end

function ArenaShopScene:netCallback(event)
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

function ArenaShopScene:onEnter()
	self:updateData()
	self:updateView()
	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function ArenaShopScene:onExit()
	NetHandler.removeTarget(self)
	GameDispatcher:removeEventListener(self.netEvent)
end

return ArenaShopScene
