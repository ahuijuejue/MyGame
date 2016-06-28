--[[
    宝藏系统 兑换
]]
local CoinExchangeLayer = class("CoinExchangeLayer", function()
	return display.newNode()
end)

local bgImage = "Coin_Exchange_Bg.png"

function CoinExchangeLayer:ctor()
	self:initData()
	self:initView()
end

function CoinExchangeLayer:initData()
	self.data = {}
end

function CoinExchangeLayer:initView()

	-- 商品列表
	self.listView_ = base.GridView.new({
		rows = 2,
		viewRect = cc.rect(0, 0, 760, 480),
		direction = "horizontal",
		itemSize = cc.size(190, 240),
	}):addTo(self)
	:setBounceable(false)
	:pos(60, 40)
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

end
function CoinExchangeLayer:updateListView()
    self.listView_
    :removeAllItems()
    :addItems(#self.data, function(event)
        local index = event.index
        local data = self.data[index]
        local grid = base.Grid.new({type=1})
            :setBackgroundImage(display.newSprite("Coin_Exchange_Banner.png"):pos(10, 5))
        self:setGridShow(grid, data)

        return grid
    end)
    :reload()
end

function CoinExchangeLayer:updateView()
    self:updateListView()
end

function CoinExchangeLayer:updateData()
    self.data = CoinData.exchangeItems
end

function CoinExchangeLayer:setGridShow(grid, data)
    grid:addItems({
        UserData:createItemView(data.itemId, {tips=false}):pos(0, 25):scale(0.8),
        display.newSprite(CoinData:getSellIcon(data.sellType)):pos(-34, -44):scale(0.6),   -- 黄金碎片图标
        base.Label.new({text = tostring(data.price), size=18}):pos(8, -44):align(display.CENTER),
        display.newSprite("Shop_Goods_Name.png"):pos(0, -103),
        base.Label.new({text = data.name, color = UserData:getItemColor(data.itemCfg), size=20}):pos(0, -103):align(display.CENTER)
        })
    if data.count > 1 then
        grid:addItems({
            display.newSprite("Banner_Level.png"):pos(34, -6):scale(0.7),
            base.Label.new({text = tostring(data.count), size=18})
                :align(display.CENTER):pos(34, -6),
        })
    end
end

function CoinExchangeLayer:selectedIndex(index)
    local data = self.data[index]
    self.delegate.delegate:createBuyItemLayer({itemId = data.itemId, pos = index, count = data.count, price = data.price })
end

return CoinExchangeLayer
