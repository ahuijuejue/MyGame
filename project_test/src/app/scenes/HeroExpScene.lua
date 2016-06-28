local BasicScene = import("..ui.BasicScene")
local HeroExpScene = class("HeroExpScene", BasicScene)

local MenuNode = import("..views.main.MenuNode")
local HeroExpLayer = import("..views.hero.HeroExpLayer")
local UserResLayer = import("..views.main.UserResLayer")

local TAG = "HeroExpScene"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"

function HeroExpScene:ctor()
    HeroExpScene.super.ctor(self,TAG)
	self:createBackground()
	--创建界面
	self.expLayer = HeroExpLayer.new()
	self:addChild(self.expLayer)

	local resLayer = UserResLayer.new(2)
    resLayer:setPosition((display.width-760)/2,display.height-55)
    self:addChild(resLayer,3)

    local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)

    self:createBackBtn()
end

function HeroExpScene:onEnter()
    HeroExpScene.super.onEnter(self)
    self:onGuide()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function HeroExpScene:onExit()
    HeroExpScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.netEvent)
end

function HeroExpScene:createBackground()
	local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)
end

function HeroExpScene:createBackBtn()
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

function HeroExpScene:onGuide()
    if not GuideData:isCompleted("experience") and OpenLvData:isOpen("expMode") then
        self.expLayer.expListView:setListTouchEnabled(false)
        self:step1()
    end
end

function HeroExpScene:step1()
    local rect = {x = display.cx + 380 , y = display.cy -90, width = 80 ,height = 80}
    local posX = rect.x - 250
    local posY = rect.y + rect.height/2+110
    local text = GameConfig.tutor_talk["35"].talk
    local param = {rect = rect, text = text,x = posX ,y = posY,callback = function (tutor)
        self:step2()
        self.expLayer.expItemView:selectExpItem(3)
        tutor:removeFromParent(true)
        tutor = nil
    end}
    showTutorial(param)
end

function HeroExpScene:step2()
    local step = 1
    local rect = {x = display.cx - 430, y = display.cy-20, width = 190 ,height = 220}
    local posX = rect.x + 390
    local posY = rect.y + rect.height/2+110
    local text = GameConfig.tutor_talk["35"].talk
    local param = {rect = rect, text = text,x = posX ,y = posY,scale = -1, callback = function (tutor)
        step = step + 1
        local guideNode = self.expLayer.expListView.guideNode
        if guideNode then
            guideNode:useExpItem()
        end
        if step == 2 then
            text = GameConfig.tutor_talk["40"].talk
            tutor:setTips(text)
        elseif step == 3 then
            text = GameConfig.tutor_talk["41"].talk
            tutor:setTips(text)
        elseif step == 4 then
            self.tutor = tutor
            NetHandler.gameRequest("NewComerGuide",{param1 = "experience"})
        end
    end}
    showTutorial(param)
end

function HeroExpScene:step3()
    local rect = {x = display.width-110, y = display.height-85, width = 110, height = 80}
    local posX = rect.x - 250
    local posY = rect.y + rect.height/2 - 50
    local text = GameConfig.tutor_talk["9"].talk
    local param = {rect = rect, text = text,x = posX,y = posY,callback = function (tutor)
        tutor:removeFromParent(true)
        tutor = nil
        app:pushToScene("MissionScene",true,{{latestType = 1}})
    end}
    showTutorial(param)
end

function HeroExpScene:expTutorial()
    local config = GameConfig.item[EXP_ITEM[3]]
    local exp = config.Content.exp * 3

    local hero = HeroListData:getRoleWithId(GameConfig.Global["1"].DC1stHeroID)
    hero.exp = GameExp.getFinalExp(hero.exp,exp)
    hero:setLevel(GameExp.getLevel(hero.exp))

    ItemData:reduceMultipleItem(itemId,3)
end

function HeroExpScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.BuyShopGoodsProcess then
        local itemId = data.param1
        local count = data.param4
        local unit = GameConfig.item[itemId].Content.count
        self.expLayer.expItemView:addExpItem(count*unit)
    elseif order == OperationCode.NewComerGuideProcess then
        self.tutor:removeFromParent(true)
        self.tutor = nil

        self:expTutorial()
        self:step3()
    end
end

return HeroExpScene