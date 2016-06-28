local CoinLayer = class("CoinLayer",function ()
	return display.newNode()
end)

local TabNode = import("app.ui.TabNode")
local CoinFindLayer = import(".CoinFindLayer")
local CoinDecomposeLayer = import(".CoinDecomposeLayer")
local CoinExchangeLayer = import(".CoinExchangeLayer")
local GafNode = import("app.ui.GafNode")

local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"
local BgImg = "HeroBoard.png"

local BUTTON_ID = {
    BUTTON_FIND = 1,
    BUTTON_DEPART = 2,
    BUTTON_EXCHANGE = 3,
}

function CoinLayer:ctor()
    self:initData()
    self:initView()
end

function CoinLayer:initData()
	self.viewTag = 1
end

function CoinLayer:initView()
	self.spriteBg = display.newSprite(BgImg):pos(display.cx-50,display.cy-20):addTo(self)

    display.newSprite("bg_001.png"):addTo(self.spriteBg)
    :align(display.BOTTOM_LEFT):pos(38, 31)

    self:createCardAct()

    self:createTabButton()
    self:createFindLayer()
    self:createDepartLayer()
    self:createExchangeLayer()
end

function CoinLayer:createTabButton()
    local btnEvent = handler(self,self.buttonEvent)
    local param = {normal = tabNormalImage, pressed = tabPressImage,event = btnEvent}
    local findTab = TabNode.new(param)
    findTab:setPosition(890,420)
    findTab:setTag(BUTTON_ID.BUTTON_FIND)
    findTab:setString("寻宝")
    self.spriteBg:addChild(findTab)

    findTab:setLocalZOrder(3)
    findTab:setPressedStatus()

    local departTab = TabNode.new(param)
    departTab:setTag(BUTTON_ID.BUTTON_DEPART)
    departTab:setPosition(890,340)
    departTab:setString("分解")
    self.spriteBg:addChild(departTab, -1)

    local exchangeTab = TabNode.new(param)
    exchangeTab:setTag(BUTTON_ID.BUTTON_EXCHANGE)
    exchangeTab:setPosition(890,260)
    exchangeTab:setString("兑换")
    self.spriteBg:addChild(exchangeTab, -1)

    self.tabNodes = {findTab, departTab, exchangeTab}

end

function CoinLayer:resetTabStatus()
    for k in pairs(self.tabNodes) do
        self.tabNodes[k]:setNormalStatus()
        self.tabNodes[k]:setLocalZOrder(-1)
    end
end

function CoinLayer:hideView()
    if self.viewTag == 1 then
        self.findLayer:setVisible(false)
    elseif self.viewTag == 2 then
        self.decomposeLayer:setVisible(false)
    elseif self.viewTag == 3 then
    	self.exchangeLayer:setVisible(false)
    end
end

function CoinLayer:showView()
    if self.viewTag == 1 then
        self.findLayer:setVisible(true)
        self.findLayer:updateData()
        self.findLayer:updateView()
    elseif self.viewTag == 2 then
        self.decomposeLayer:setVisible(true)
        self.decomposeLayer:updateData()
        self.decomposeLayer:updateView()
    elseif self.viewTag == 3 then
        NetHandler.gameRequest("ShowExchangeItems")
    end
end

function CoinLayer:createFindLayer()
    self.findLayer = CoinFindLayer.new()
    self.findLayer.delegate = self
    self.spriteBg:addChild(self.findLayer, 5)
end

function CoinLayer:createDepartLayer()
    self.decomposeLayer = CoinDecomposeLayer.new()
    self.decomposeLayer:setVisible(false)
    self.decomposeLayer.delegate = self
    self.spriteBg:addChild(self.decomposeLayer, 5)
end

function CoinLayer:createExchangeLayer()
    self.exchangeLayer = CoinExchangeLayer.new()
    self.exchangeLayer:setVisible(false)
    self.exchangeLayer.delegate = self
    self.spriteBg:addChild(self.exchangeLayer, 5)
end

function CoinLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")

    local tag = event.target:getTag()
    self:resetTabStatus()
    event.target:setLocalZOrder(3)
    event.target:setPressedStatus()

    self.tabNodes[self.viewTag]:setNormalStatus()
    self.tabNodes[self.viewTag]:setLocalZOrder(-1)

    self:hideView()
    self.viewTag = tag
    self:showView()
end

function CoinLayer:createCardAct()
    local param = {gaf = "coin_trip",width = display.width,height = display.height}
    self.effectNode = GafNode.new(param)
    self.effectNode:setGafPosition(482, 286)
    self.spriteBg:addChild(self.effectNode)
    self.effectNode:hide()
end

function CoinLayer:showCardAnimation(callback)
    self.effectNode:show()
    self.effectNode:playAction("coin_trip",false)
    self.effectNode:setActCallback(function(name)
            if name == "coin_trip" then
                callback()
                self.effectNode:hide()
            end
        end)
end

function CoinLayer:updateData()
    self.findLayer:updateData()
end

function CoinLayer:updateView()
    self.findLayer:updateView()
end

return CoinLayer
