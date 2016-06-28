local BackpackLayer = class("BackpackLayer",function ()
	return display.newNode()
end)

local TabNode = import("app.ui.TabNode")
local ItemNode = import(".ItemNode")
local ItemLayer = import(".ItemLayer")

local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"
local bgImage = "HeroBoard.png"
local selectImage = "Exp_Select.png"
local listImage = "bg_001.png"
local lineImage = "Line.png"

local unit = 4

local BUTTON_ID = {
    BUTTON_ALL = 1,
    BUTTON_COIN = 2,
    BUTTON_EQUIP = 3,
    BUTTON_SOUL = 4,
    BUTTON_CONSUME = 5,	
}

function BackpackLayer:ctor()
    self.type_ = 0
    self:createBackView()
    self:updateList()
    self:createListView()
    self:updateListView()
    self:showItemLayer(self.list[1])
    self.item = self.list[1]
    self:createTabButton()
end

function BackpackLayer:createBackView()
    self.backSprite = display.newSprite(bgImage)
    self.backSprite:setPosition(display.cx-50,display.cy-30)
    self:addChild(self.backSprite,2)
end

function BackpackLayer:createListView()
    local posX = self.backSprite:getContentSize().width/2
    local posY = self.backSprite:getContentSize().height/2

    local lineSprite = display.newSprite(lineImage)
    lineSprite:setPosition(400,posY)
    self.backSprite:addChild(lineSprite,2)

    local listBg = display.newSprite(listImage)
    listBg:setPosition(posX,posY)
    self.backSprite:addChild(listBg)

    self.listView = cc.TableView:create(cc.size(405,483))
    self.listView:setPosition(380,0)
    self.listView:setDirection(cc.SCROLLVIEW_DIRECTION_VERTICAL)
    self.listView:setVerticalFillOrder(cc.TABLEVIEW_FILL_TOPDOWN)

    self.listView:registerScriptHandler(handler(self, self.cellSizeForTable), cc.TABLECELL_SIZE_FOR_INDEX)
    self.listView:registerScriptHandler(handler(self, self.tableCellAtIndex), cc.TABLECELL_SIZE_AT_INDEX)
    self.listView:registerScriptHandler(handler(self, self.numberOfCellsInTableView), cc.NUMBER_OF_CELLS_IN_TABLEVIEW)
    listBg:addChild(self.listView)
end

function BackpackLayer:cellSizeForTable(table,idx)
    return 100
end

function BackpackLayer:tableCellAtIndex(table,idx)
    local cell = self:createCell(idx)
    return cell
end

function BackpackLayer:numberOfCellsInTableView(table)
    return self.line
end

function BackpackLayer:createCell(idx)
    local cell = cc.TableViewCell:new()
    for count=1,unit do
        local index = idx*unit + count
        if index <= #self.list then
            local posX = (count-1)*100 + 10
            local node = ItemNode.new(self.list[index])
            node:setCallBack(handler(self,self.nodeCallback))
            node:setPosition(posX,0)
            cell:addChild(node)
            if self.item == self.list[index] then
                self.choose = display.newSprite(selectImage)
                self.choose:setPosition(58,58)
                node.bgSprite:addChild(self.choose,-1)
            end
        end
    end
    return cell
end

function BackpackLayer:sourceDelegate(listView, tag, idx)
    if UIListView.COUNT_TAG == tag then
        return self.line
    elseif UIListView.CELL_TAG == tag then
        local item = self.listView:newItem()
        local content = display.newNode()
        for count=1,unit do
            local index = (idx-1)*unit + count
            if index <= #self.list then
                local posX = count*100-45
                local node = ItemNode.new(self.list[index])
                node:setCallBack(handler(self,self.nodeCallback))
                node:setContentSize(100,100)
                node:setPosition(posX,0)
                content:addChild(node)
                if self.item == self.list[index] then
                    self.choose = display.newSprite(selectImage)
                    self.choose:setPosition(58,58)
                    node.bgSprite:addChild(self.choose,-1)
                end
            end
        end      
        content:setContentSize(500,100)
        item:addContent(content)
        item:setItemSize(400,100)
        return item
    end
end

function BackpackLayer:updateList()
    self.list = ItemData:getItemWithType(self.type_)
    self.line = math.ceil(#self.list/unit)
end

function BackpackLayer:updateListView()
    if self.choose then
        self.choose:removeFromParent(true)
        self.choose = nil
    end
    self.listView:reloadData()
end

function BackpackLayer:nodeCallback(node)
    self:showItemLayer(node.item)
    self:showSelectSprite(node)
    self.item = node.item
end

function BackpackLayer:showItemLayer(item)
    if not item then
        if self.itemLayer then
            self.itemLayer:removeFromParent(true)
            self.itemLayer = nil
        end
        return
    end
    if self.item == item then
        return
    end
    if self.itemLayer then
        self.itemLayer:updateView(item)
    else
        self.itemLayer = ItemLayer.new()
        self.itemLayer.delegate = self
        self.itemLayer:updateView(item)
        self.backSprite:addChild(self.itemLayer)
    end
end

function BackpackLayer:setListTouchEnabled(enabled)
    self.listView:setTouchEnabled(enabled)
end

function BackpackLayer:showSelectSprite(node)
    if self.item == node.item then
        return
    end
    if self.choose then
        self.choose:removeFromParent(true)
        self.choose = nil
    end
    self.choose = display.newSprite(selectImage)
    self.choose:setPosition(58,58)
    node.bgSprite:addChild(self.choose,-1)
end

function BackpackLayer:createTabButton()
    local btnEvent = handler(self,self.buttonEvent)
    local param = {normal = tabNormalImage, pressed = tabPressImage, event = btnEvent}
    local allTab = TabNode.new(param)
    allTab:setPosition(display.cx+402,display.cy+170)
    allTab:setTag(BUTTON_ID.BUTTON_ALL)
    allTab:setString(GET_TEXT_DATA("TAB_ALL"))
    self:addChild(allTab)

    allTab:setLocalZOrder(3)
    allTab:setPressedStatus()

    local coinTab = TabNode.new(param)
    coinTab:setTag(BUTTON_ID.BUTTON_COIN)
    coinTab:setPosition(display.cx+402,display.cy+90)
    coinTab:setString(GET_TEXT_DATA("TEXT_COIN"))
    self:addChild(coinTab)

    local equipTab = TabNode.new(param)
    equipTab:setTag(BUTTON_ID.BUTTON_EQUIP)
    equipTab:setPosition(display.cx+402,display.cy+10)
    equipTab:setString(GET_TEXT_DATA("TEXT_EQUIP"))
    self:addChild(equipTab)

    local soulTab = TabNode.new(param)
    soulTab:setTag(BUTTON_ID.BUTTON_SOUL)
    soulTab:setPosition(display.cx+402,display.cy-70)
    soulTab:setString(GET_TEXT_DATA("TEXT_HOLY_SOUL"))
    self:addChild(soulTab)

    local consumeTab = TabNode.new(param)
    consumeTab:setTag(BUTTON_ID.BUTTON_CONSUME)
    consumeTab:setPosition(display.cx+402,display.cy-150)
    consumeTab:setString(GET_TEXT_DATA("TEXT_CONSUME"))
    self:addChild(consumeTab)

    self.tabNodes = {allTab,coinTab,equipTab,soulTab,consumeTab}
end

function BackpackLayer:resetTabStatus()
    for k in pairs(self.tabNodes) do
        self.tabNodes[k]:setNormalStatus()
        self.tabNodes[k]:setLocalZOrder(1)
    end
end

function BackpackLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    self:resetTabStatus()
    event.target:setLocalZOrder(3)
    event.target:setPressedStatus()
    
    if tag == BUTTON_ID.BUTTON_ALL then
        self.type_ = 0
    elseif tag == BUTTON_ID.BUTTON_COIN then
        self.type_ = 1
    elseif tag == BUTTON_ID.BUTTON_EQUIP then
        self.type_ = 2
    elseif tag == BUTTON_ID.BUTTON_SOUL then
        self.type_ = 3
    elseif tag == BUTTON_ID.BUTTON_CONSUME then
        self.type_ = 4
    end 
    self:updateList()
    if not self.item then
        self:showItemLayer(self.list[1])
        self.item = self.list[1]
    end
    self:updateListView()
end

return BackpackLayer