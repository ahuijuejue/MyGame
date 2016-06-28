local HeroListLayer = class("HeroListLayer",function ()
	return display.newNode()
end)

local TabNode = import("app.ui.TabNode")
local HeroListView = import(".HeroListView")
local ItemDropLayer = import("..item.ItemDropLayer")

local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"

local BUTTON_ID = {
    BUTTON_ALL = 1,
    BUTTON_TANK = 2,
    BUTTON_ATK = 3,
    BUTTON_AID = 4,
}

function HeroListLayer:ctor()
    self.type_ = LIST_TYPE.HERO_ALL
    self:createListView()
    self:createTabButton()
end

function HeroListLayer:createListView()
    self.heroListView = HeroListView.new()
    self:addChild(self.heroListView,2)
end

function HeroListLayer:createTabButton()
    local btnEvent = handler(self,self.buttonEvent)
    local param = {normal = tabNormalImage, pressed = tabPressImage, event = btnEvent}
    local allTab = TabNode.new(param)
    allTab:setPosition(display.cx+402,display.cy+170)
    allTab:setTag(BUTTON_ID.BUTTON_ALL)
    allTab:setString(GET_TEXT_DATA("TAB_ALL"))
    self:addChild(allTab)

    allTab:setLocalZOrder(3)
    allTab:setPressedStatus()

    local tankTab = TabNode.new(param)
    tankTab:setTag(BUTTON_ID.BUTTON_TANK)
    tankTab:setPosition(display.cx+402,display.cy+90)
    tankTab:setString(GET_TEXT_DATA("TEXT_RANGE_1"))
    self:addChild(tankTab)

    local atkTab = TabNode.new(param)
    atkTab:setTag(BUTTON_ID.BUTTON_ATK)
    atkTab:setPosition(display.cx+402,display.cy+10)
    atkTab:setString(GET_TEXT_DATA("TEXT_RANGE_2"))
    self:addChild(atkTab)

    local aidTab = TabNode.new(param)
    aidTab:setTag(BUTTON_ID.BUTTON_AID)
    aidTab:setPosition(display.cx+402,display.cy-70)
    aidTab:setString(GET_TEXT_DATA("TEXT_RANGE_3"))
    self:addChild(aidTab)

    self.tabNodes = {allTab,tankTab,atkTab,aidTab}
end

function HeroListLayer:resetTabStatus()
    for k in pairs(self.tabNodes) do
        self.tabNodes[k]:setNormalStatus()
        self.tabNodes[k]:setLocalZOrder(1)
    end
end

function HeroListLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    self:resetTabStatus()
    event.target:setLocalZOrder(3)
    event.target:setPressedStatus()

    if tag == BUTTON_ID.BUTTON_ALL then
        self.type_ = LIST_TYPE.HERO_ALL
        self.heroListView:updateListView(LIST_TYPE.HERO_ALL)
    elseif tag == BUTTON_ID.BUTTON_TANK then
        self.type_ = LIST_TYPE.HERO_TANK
        self.heroListView:updateListView(LIST_TYPE.HERO_TANK)
    elseif tag == BUTTON_ID.BUTTON_ATK then
        self.type_ = LIST_TYPE.HERO_DPS
        self.heroListView:updateListView(LIST_TYPE.HERO_DPS)
    elseif tag == BUTTON_ID.BUTTON_AID then
        self.type_ = LIST_TYPE.HERO_AID
        self.heroListView:updateListView(LIST_TYPE.HERO_AID)
    end 
end

return HeroListLayer