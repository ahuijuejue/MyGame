--[[
    宝藏系统 分解
]]
local CoinDecomposeLayer = class("CoinDecomposeLayer", function()
	return display.newNode()
end)

local SealGrid = import("app.views.tails.SealGrid")
local scheduler = require("framework.scheduler")
local GafNode = import("app.ui.GafNode")

local leftBanner = "Coin_Dec_BgL.png"
local rightBanner = "Coin_Dec_BgR.png"
local getBanner= "Coin_Dec_GetBanner.png"

local unit = 4

function CoinDecomposeLayer:ctor()
	self:initData()
	self:initView()
end

function CoinDecomposeLayer:initData()
	self.list = {}
    self.line = 0
    self.willCost = {}
    self.counts = 0
end

function CoinDecomposeLayer:initView()
    -- 背景板
    display.newSprite(getBanner):pos(645,273):addTo(self)

    -- gaf
    local gafNode = GafNode.new({gaf = "coin_decompose"})
    gafNode:playAction("coin_decompose", true)
    gafNode:setGafPosition(480,282)
    gafNode:setTouchEnabled(false)
    gafNode:addTo(self)

	-- 待分解物品listView
    self.listView = cc.TableView:create(cc.size(410,470))
    self.listView:setPosition(40,38)
    self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    self.listView:setDelegate()

    self.listView:registerScriptHandler(handler(self, self.scrollViewDidScroll), 0)
    self.listView:registerScriptHandler(handler(self, self.tableCellTouched), cc.TABLECELL_TOUCHED)
    self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    self.listView:reloadData()
    self:addChild(self.listView)

    self.getGoldCount = display.newTTFLabel({text = "X"..self.counts, size = 30})
    self.getGoldCount:pos(580+self.getGoldCount:getContentSize().width, 85)
    self.getGoldCount:addTo(self)

    -- 分解按钮
    CommonButton.yellow("分解")
    :onButtonClicked(function ()
        if self.counts > 0 then
            self:onButtonClickedDec()
        else
            showToast({text = "没有分解的物品啊！"})
        end
    end)
    :pos(760,80)
    :addTo(self,3)
end

function CoinDecomposeLayer:scrollViewDidScroll(table)

end

function CoinDecomposeLayer:tableCellTouched(table,cell)
    -- print("cellIdx:"..cell:getIdx())
end

function CoinDecomposeLayer:cellSizeForTable(table,idx)
    return 100
end

function CoinDecomposeLayer:tableCellAtIndex(table,idx)
    local cell = self:createCell(idx)
    return cell
end

function CoinDecomposeLayer:numberOfCellsInTableView(table)
    return self.line
end

function CoinDecomposeLayer:createCell(idx)
    local cell = cc.TableViewCell:new()
    for count=1,unit do
        local index = idx*unit + count
        if index <= #self.list then

            local posX = (count-1)*100 + 60
            local data = self.list[index]

            self.willCost[index] = self.willCost[index] or 0
            local costValue = self.willCost[index]
            local borderName = UserData:getItemBorder(data)

            local node = SealGrid.new({flag = borderName,size = 24})
            node:setScale(0.75)

            node:setIcon(UserData:getItemIcon(data))
            node:setBorder(borderName)
            node:setItemFlag(UserData:getItemFlag(data))

            node:setCount(costValue, data.count)
            node:onSubButtonEvent(function()
                self:reduceIndex(index, node)
            end)

            if costValue > 0 then
                node:showSubButton(true)
            else
                node:showSubButton(false)
            end

            local isSelected = false
            node:setTouchEnabled(true)
            node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                if event.name == "began" then
                    isSelected = true
                    return isSelected
                elseif event.name == "moved" then
                    isSelected = false
                    return isSelected
                elseif event.name == "ended" then
                    if isSelected then
                        self:selectedIndex(index, node)
                    end
                    isSelected = false
                end
            end)
            node:setPosition(posX,45)
            cell:addChild(node)
        end
    end
    return cell
end

function CoinDecomposeLayer:selectedIndex(index, target)
    local data = self.list[index]
    if self.willCost[index] < data.count then
        self.counts = self.counts + data.seal
        self.getGoldCount:setString("X"..self.counts)
        self.willCost[index] = self.willCost[index] + 1
        self:updateItemView(target, self.willCost[index], data.count)
    end
end

function CoinDecomposeLayer:updateItemView(item, count, countMax)
    if count > 0 then
        item:showSubButton(true)
        item:setCount(count, countMax)
    else
        item:showSubButton(false)
        item:setCount(count, countMax)
    end
end

function CoinDecomposeLayer:reduceIndex(index, target)
	if self.willCost[index] > 0 then
        local data = self.list[index]
        self.counts = self.counts - data.seal
        self.getGoldCount:setString("X"..self.counts)
        self.willCost[index] = self.willCost[index] - 1
        self:updateItemView(target, self.willCost[index], data.count)
    end
end

function CoinDecomposeLayer:onButtonClickedDec()
    local itemsStr = ""
    for i,v in ipairs(self.willCost) do
        if v > 0 then
            local item = self.list[i]
            if type(item.uniqueId) == "table" then
                local tablelen = #item.uniqueId + 1
                for i2=1,v do
                    itemsStr = itemsStr..tostring(item.uniqueId[tablelen-i2]).."_1,"
                end
            else
                itemsStr = itemsStr..tostring(item.uniqueId).."_" ..tostring(v) .. ","
            end
        end
    end

    AlertShow.show2("提示", "确定要分解这些物品？", "确定", function(event)
        NetHandler.gameRequest("Decompose", {param1 = itemsStr})
    end, function()
    end)
end

function CoinDecomposeLayer:updateData()
	self.list = CoinData:getDecomposeItems()
    self.line = math.ceil(#self.list/unit)
    self.willCost = {}
    for i,v in ipairs(self.list) do
    	self.willCost[i] = 0
    end
    self.counts = 0
end

function CoinDecomposeLayer:updateView()
    self.listView:reloadData()
    self.getGoldCount:setString("X"..self.counts)
end

return CoinDecomposeLayer
