local HeroListView = class("HeroListView",function()
	return display.newNode()
end)

local listBgImage = "HeroBoard.png"
local boardImage = "Hero_Banner.png"
local lineImage = "Line.png"
local itemImage = "HeroList.png"
local boardImage = "bg_001.png"

local HeroNode = import(".HeroNode")

local unit = 4

function HeroListView:ctor()
    local listBgSprite = display.newSprite(listBgImage)
    listBgSprite:setPosition(display.cx-50,display.cy-30)
    self:addChild(listBgSprite)

    local board = display.newSprite(boardImage)
    board:setPosition(438,273)
    listBgSprite:addChild(board)

    self.listView = self:createListView()
    self:updateListView(LIST_TYPE.HERO_ALL)
    board:addChild(self.listView)
end

function HeroListView:createListView()
    local listView = cc.TableView:create(cc.size(790,480))
    listView:setPosition(0,2)
    listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    return listView
end

function HeroListView:cellSizeForTable(table,idx)
    if self.ownLine > 0 and self.unownLine > 0 then
        if idx == self.ownLine then
            return 35
        else
            return 240
        end
    end
    return 240
end

function HeroListView:tableCellAtIndex(table,idx)
    local cell
    if self.ownLine > 0 then
        if idx < self.ownLine then
            cell = self:createItem(idx,self.ownList,idx)
        elseif idx == self.ownLine then
            cell = self:createLineItem(idx)
        else
            local index = idx - self.ownLine - 1
            cell = self:createItem(index,self.unownList,idx)
        end
    else
        cell = self:createItem(idx,self.unownList,idx)
    end
    return cell
end

function HeroListView:numberOfCellsInTableView(table)
    local count = self.ownLine + self.unownLine
    if self.ownLine > 0 and self.unownLine > 0 then
        count = count + 1
    end
    return count
end

function HeroListView:createItem(idx,heroList,cellIdx)
    local item = cc.TableViewCell:new()
    item:setIdx(cellIdx)

    for count = 1,unit do
        local index = idx*unit + count
        if index <= #heroList then
            local posX = 195*(count - 1) + 12
            local heroNode = HeroNode.new(heroList[index])
            heroNode.delegate = self
            heroNode:setPosition(posX,0)
            item:addChild(heroNode)
        end
    end
    return item
end

function HeroListView:createLineItem(cellIdx)
    local item = cc.TableViewCell:new()
    item:setIdx(cellIdx)

    local lineSprite = display.newSprite(lineImage)
    lineSprite:setRotation(90)
    lineSprite:setPosition(420,13)
    item:addChild(lineSprite)

    return item
end

function HeroListView:updateList(viewType)
    self.ownList,self.unownList = HeroListData:getListWithType(viewType)
    self.ownLine = math.ceil(#self.ownList/unit)
    self.unownLine = math.ceil(#self.unownList/unit)

    HeroListData:sortHeroList(self.ownList)

    --未激活列表
    local canActList = {}
    local notActList = {}
    for i,v in ipairs(self.unownList) do
        local num = ItemData:getItemCountWithId(v.stoneId)
        if num >= v.stoneNum then
            table.insert(canActList,v)
        else
            table.insert(notActList,v)
        end
    end
    local sortFunc = function (a,b)
        local num1 = ItemData:getItemCountWithId(a.stoneId)
        local num2 = ItemData:getItemCountWithId(b.stoneId)
        return num1>num2
    end
    table.sort(notActList,sortFunc)

    self.unownList = {}
    for i,v in ipairs(canActList) do
        table.insert(self.unownList,v)
    end
    for i,v in ipairs(notActList) do
        table.insert(self.unownList,v)
    end
end

function HeroListView:updateListView(viewType)
    self:updateList(viewType)
    self.listView:reloadData()
end

function HeroListView:setListTouchEnabled(enabled)
    self.listView:setTouchEnabled(enabled)
end

return HeroListView