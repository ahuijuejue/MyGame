local ExpListView = class("ExpListView",function()
	return display.newNode()
end)

local ExpNode = import(".ExpNode")

local listBgImage = "HeroBoard.png"
local boardImage = "bg_001.png"

local unit = 4

function ExpListView:ctor()
    self.ownLine = 0
    self.ownList = {}

 	local listBgSprite = display.newSprite(listBgImage)
    listBgSprite:setPosition(display.cx-50,display.cy-30)
    self:addChild(listBgSprite)

    local board = display.newSprite(boardImage)
    board:setPosition(438,273)
    listBgSprite:addChild(board)

    self.listView = self:createListView()
    self:updateViewWithType()
    board:addChild(self.listView,2)
end

function ExpListView:createListView()
    local listView = cc.TableView:create(cc.size(790,480))
    listView:setPosition(0,2)
    listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)
    listView:setDelegate()

    listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)

    return listView
end

function ExpListView:cellSizeForTable(table,idx)
    return 240
end

function ExpListView:tableCellAtIndex(table,idx)
    return self:createItem(idx,self.ownList)
end

function ExpListView:numberOfCellsInTableView(table)
    return self.ownLine
end

function ExpListView:createItem(idx,heroList)
    local item = cc.TableViewCell:new()
    for count = 1,unit do
        local index = idx*unit + count
        if index <= #heroList then
            local posX = (count-1)*195 + 12
            local expNode = ExpNode.new(heroList[index])
            expNode.delegate = self
            expNode:setPosition(posX,0)
            item:addChild(expNode)
            if index == 1 and not GuideData:isCompleted("experience") then
                self.guideNode = expNode
            end
        end
    end

    return item
end

function ExpListView:setListTouchEnabled(enabled)
    self.listView:setTouchEnabled(enabled)
end

function ExpListView:updateViewWithType()
    self.ownList = HeroListData:getListWithType(LIST_TYPE.HERO_EXP)
    self.ownLine = math.ceil(#self.ownList/unit)
    HeroListData:sortHeroList(self.ownList)

    self.listView:reloadData()
end

return ExpListView