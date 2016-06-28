local BasicScene = import("..ui.BasicScene")
local HeroListScene = class("HeroListScene", BasicScene)

local HeroListLayer = import("..views.hero.HeroListLayer")
local HeroListView = import("..views.hero.HeroListView")
local MenuNode = import("..views.main.MenuNode")
local UserResLayer = import("..views.main.UserResLayer")
local TutorialLayer = import("..ui.TutorialLayer")

local TAG = "HeroListScene"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"
local expImage = "Exp_Button.png"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local pointImage = "Point_Red.png"

function HeroListScene:ctor()
    HeroListScene.super.ctor(self,TAG)
    self:createBackground()
	--创建界面
	self.listLayer = HeroListLayer.new()
	self:addChild(self.listLayer)

    local resLayer = UserResLayer.new(2)
    resLayer:setPosition((display.width-760)/2,display.height-55)
    self:addChild(resLayer,3)

	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)

    self:createBackBtn()
    self:createExpBtn()

    self.guideStep = 0
end

function HeroListScene:createBackground()
	local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)
end

function HeroListScene:createBackBtn()
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

function HeroListScene:createExpBtn()
    self.expBtn = cc.ui.UIPushButton.new({normal = expImage,pressed = expImage})
    :onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
        app:pushToScene("HeroExpScene")
    end)
    self.expBtn:setPosition(display.cx+415,160)
    self:addChild(self.expBtn)

    self.expPoint = display.newSprite(pointImage)
    self.expPoint:setPosition(30,30)
    self.expBtn:addChild(self.expPoint)
end

function HeroListScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.SummonHeroProcess then
        local heroId = data.param1
        local hero = HeroListData:getRoleWithId(heroId)
        app:pushToScene("HeroGetScene",false,{hero})
        self.listLayer.heroListView:updateListView(self.listLayer.type_)
    elseif order == OperationCode.NewComerGuideProcess then
        self.tutor:removeFromParent(true)
        self.tutor = nil
        app:pushToScene("MissionScene",true,{{latestType = 1}})
    end
end

function HeroListScene:onEnter()
    HeroListScene.super.onEnter(self)
    if UserData:getUserLevel() >= OpenLvData.expMode.openLv then
        self.expBtn:setVisible(true)
    else
        self.expBtn:setVisible(false)
    end
    self.expPoint:setVisible(GamePoint.haveExpItem())
    self:onGuide()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function HeroListScene:onExit()
    HeroListScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.netEvent)
end

function HeroListScene:onGuide()
    if not GuideData:isCompleted("Awaken") then           -- 英雄觉醒
        self.listLayer.heroListView:setListTouchEnabled(false)
        local rect = {x = display.cx - 430, y = display.cy-20, width = 190 ,height = 220}
        local text = GameConfig.tutor_talk["16"].talk
        local param = {rect = rect, text = text, x = display.cx-55, y = display.cy+220, scale = -1,callback = function (tutor)
            self.listLayer.heroListView:setListTouchEnabled(true)
            local hero = HeroListData:getRoleWithId(GameConfig.Global["1"].DC1stHeroID)
            self:addTempItem(hero)
            app:pushToScene("HeroAwakeScene",false,{hero})
            tutor:removeFromParent(true)
            tutor = nil
        end}
        showTutorial(param)
    elseif not GuideData:isCompleted("Activate") then
        self.listLayer.heroListView:setListTouchEnabled(false)
        if self.guideStep == 0 then
            local rect = {x = display.cx - 430, y = display.cy-280, width = 190 ,height = 220}
            local text = GameConfig.tutor_talk["22"].talk
            local param = {rect = rect, text = text,x = display.cx-55, y = display.cy-55, scale = -1,callback = function (tutor)
                self.guideStep = 1
                tutor:removeFromParent(true)
                tutor = nil

                local heroId = GameConfig.Beginnersguide["Activate"].itemid
                local hero = HeroListData:activateHeroWithId(heroId)
                ItemData:reduceMultipleItem(hero.stoneId,hero.stoneNum)
                app:pushToScene("HeroGetScene",false,{hero})

                self.listLayer.heroListView:updateListView(self.listLayer.type_)
            end}
            showTutorial(param)
        elseif self.guideStep == 1 then
            local rect = {x = display.width-110, y = display.height-85, width = 110, height = 80}
            local posX = rect.x - 250
            local posY = rect.y + rect.height/2 - 50
            local text = GameConfig.tutor_talk["9"].talk
            local param = {rect = rect, text = text, x = posX, y = posY, callback = function (tutor)
                self.tutor = tutor
                self.listLayer.heroListView:setListTouchEnabled(true)
                NetHandler.gameRequest("NewComerGuide",{param1 = "Activate"})
            end}
            showTutorial(param)
        end
    elseif GuideData:isNotCompleted("StarUp") and UserData:getUserLevel() >= OpenLvData.starUp.openLv then
        self.listLayer.heroListView:setListTouchEnabled(false)
        local rect = {x = display.cx - 430, y = display.cy-20, width = 190 ,height = 220}
        local text = GameConfig.tutor_talk["33"].talk
        local param = {rect = rect, text = text,x = display.cx-55, y = display.cy+220, scale = -1,callback = function (tutor)
            self.listLayer.heroListView:setListTouchEnabled(true)
            --临时增加物品数据
            ItemData:addMultipleItem("10003",15)
            local hero = HeroListData:getRoleWithId(GameConfig.Global["1"].DC1stHeroID)
            app:pushToScene("HeroAwakeScene",false,{hero})
            self.listLayer.heroListView:setListTouchEnabled(true)
            tutor:removeFromParent(true)
            tutor = nil
        end}
        showTutorial(param)
    elseif not GuideData:isCompleted("experience") and UserData:getUserLevel() >= OpenLvData.expMode.openLv then
        self.listLayer.heroListView:setListTouchEnabled(false)
        local rect = {x = display.cx + 370 , y = 120, width = 84 ,height = 84}
        local posX = rect.x - 250
        local posY = rect.y + rect.height/2+110
        local text = GameConfig.tutor_talk["35"].talk
        local param = {rect = rect, text = text,x = posX ,y = posY,callback = function (tutor)
            self.listLayer.heroListView:setListTouchEnabled(true)
            ItemData:addMultipleItem(EXP_ITEM[3],3)
            app:pushToScene("HeroExpScene")
            tutor:removeFromParent(true)
            tutor = nil
        end}
        showTutorial(param)
    elseif not GuideData:isCompleted("Equipment") and OpenLvData:isOpen("equip") then
        self.listLayer.heroListView:setListTouchEnabled(false)
        local rect = {x = display.cx - 430, y = display.cy-20, width = 190 ,height = 220}
        local text = GameConfig.tutor_talk["33"].talk
        local param = {rect = rect, text = text,x = display.cx-55, y = display.cy+220, scale = -1,callback = function (tutor)
            self.listLayer.heroListView:setListTouchEnabled(true)
            local hero = HeroListData:getRoleWithId(GameConfig.Global["1"].DC1stHeroID)
            app:pushToScene("HeroAwakeScene",false,{hero})
            tutor:removeFromParent(true)
            tutor = nil
        end}
        showTutorial(param)
    end
end

function HeroListScene:addTempItem(hero)
    local awakeInfo = GameConfig.hero_awake[hero.roleId]
    for index=1,STONE_INSERT_COUNT do
        local key = string.format("ItemID%d",hero.awakeLevel+1)
        local targetId = awakeInfo[key][index]
        local targetItem = ItemData:getItemConfig(targetId)
        local length = #targetItem.content.NeedItemID
        for i=1,length do
            local count = targetItem.content.NeedItemNum[i]
            local id = targetItem.content.NeedItemID[i]
            ItemData:addMultipleItem(id,count)
        end
    end
end

return HeroListScene