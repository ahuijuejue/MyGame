local BasicScene = import("..ui.BasicScene")
local BackpackScene = class("BackpackScene", BasicScene)

local MenuNode = import("..views.main.MenuNode")
local UserResLayer = import("..views.main.UserResLayer")
local BackpackLayer = import("..views.item.BackpackLayer")

local TAG = "BackpackScene"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"

function BackpackScene:ctor()
    BackpackScene.super.ctor(self,TAG)
	self:createBackground()

	--创建界面
    self.packLayer = BackpackLayer.new()
    self:addChild(self.packLayer)

    local resLayer = UserResLayer.new()
    resLayer:setPosition((display.width-760)/2,display.height-55)
    self:addChild(resLayer,3)

	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)

    self:createBackBtn()
end

function BackpackScene:createBackground()
	local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)
end

function BackpackScene:createBackBtn()
	local backBtn = cc.ui.UIPushButton.new({normal = backImage, pressed = backImage2})
    :onButtonClicked(function ()
        AudioManage.playSound("Back.mp3")
        app:popToScene()
    end)
    self:addChild(backBtn,4)

    local posX = display.width - 55
    local posY = display.height - 45
    backBtn:setPosition(posX,posY)
end

function BackpackScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.UseItemProcess then
        local itemId = data.param2
        local item = ItemData:getItemWithId(itemId)
        if item then
            self.packLayer:updateListView()
        else
            self.packLayer:updateList()
            self.packLayer:showItemLayer(self.packLayer.list[1])
            self.packLayer.item = self.packLayer.list[1]
            self.packLayer:updateListView()
        end
        local showItems = {}
        for i,v in ipairs(data.a_param1) do
            local iConfig = GameConfig.item[tostring(v.param1)]
            local isSaved = false
            local itemCount = v.param3 or 1
            for i2,v2 in ipairs(showItems) do
                if showItems[i2].itemId == tostring(v.param1) then
                    isSaved = true
                    showItems[i2].count = showItems[i2].count + itemCount
                    break
                end
            end
            if not isSaved then
                table.insert(showItems, {
                    itemId  = tostring(v.param1),
                    count   = itemCount,
                    name    = iConfig.Name,
                })
            end
        end
        UserData:showReward(showItems)
    elseif order == OperationCode.SellGoodsProcess then  
        AudioManage.playSound("Sell.mp3")
        local itemId = data.param1
        local config = GameConfig.item[itemId]
        local item = nil
        if config.Type == 2 then
            item = data.param2
        else
            item = ItemData:getItemWithId(itemId)
        end
        if item then
            self.packLayer:updateListView()
        else
            self.packLayer:updateList()
            self.packLayer:showItemLayer(self.packLayer.list[1])
            self.packLayer.item = self.packLayer.list[1]
            self.packLayer:updateListView()
        end
    end
end

function BackpackScene:onEnter()
    BackpackScene.super.onEnter(self)
    local item = nil
    if self.packLayer.item.Type == 2 then
        local uId = self.packLayer.item.uniqueId
        item = ItemData:getEquipWithUid(uId)
    else
        local itemId = self.packLayer.item.itemId
        item = ItemData:getItemWithId(itemId)
    end
    if item then
        self.packLayer:updateListView()
    else
        self.packLayer:updateList()
        self.packLayer:showItemLayer(self.packLayer.list[1])
        self.packLayer.item = self.packLayer.list[1]
        self.packLayer:updateListView()
    end
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function BackpackScene:onExit()
    BackpackScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.netEvent)
end

return BackpackScene