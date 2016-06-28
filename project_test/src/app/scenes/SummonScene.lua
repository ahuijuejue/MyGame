local BasicScene = import("..ui.BasicScene")
local SummonScene = class("SummonScene", BasicScene)

local SummonLayer = import("..views.summon.SummonLayer")
local UserResLayer = import("..views.main.UserResLayer")
local MenuNode = import("..views.main.MenuNode")
local GafNode = import("app.ui.GafNode")

local TAG = "SummonScene"
local skyImage = "Sky_Left.png"
local bgImageName = "Background_gray.jpg"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"

function SummonScene:ctor()
	SummonScene.super.ctor(self,TAG)
	self:createBackground()

	local resLayer = UserResLayer.new(3)
    resLayer:setPosition((display.width-760)/2,display.height-55)
	self:addChild(resLayer,5)

	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)

	--创建抽卡界面
	self.summonLayer = SummonLayer.new()
    self.summonLayer.delegate = self
	self:addChild(self.summonLayer)

	self:createBackBtn()
    self:createCardAct()

end

function SummonScene:createBackground()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,150))
    self:addChild(colorLayer)

	local bgSprite = display.newSprite("Background_1.jpg")
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)
end

function SummonScene:createBackBtn()
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

function SummonScene:createCardAct()
    local param = {gaf = "card_flip_gaf",width = display.width,height = display.height}
    self.effectNode = GafNode.new(param)
    self.effectNode:setGafPosition(display.cx,display.cy)
    self.effectNode:setScale(1.3)
    self:addChild(self.effectNode,10)
    self.effectNode:hide()
end

function SummonScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.OneGoldChoukaProcess then
        self:showCardAnimation(function()
            app:pushToScene("SummonResultScene")
        end)
    elseif order == OperationCode.TenGoldChoukaProcess then
        self:showCardAnimation(function()
            app:pushToScene("SummonResultScene")
        end)
    elseif order == OperationCode.OneDiamondChoukaProcess then
        self:showCardAnimation(function()
            app:pushToScene("SummonResultScene")
        end)
    elseif order == OperationCode.TenDiamondChoukaProcess then
        self:showCardAnimation(function()
            app:pushToScene("SummonResultScene")
        end)
    elseif order == OperationCode.SecretChoukaProcess then
        self:showCardAnimation(function()
            app:pushToScene("SummonResultScene")
        end)
    end
end

function SummonScene:showCardAnimation(callback)
    self.effectNode:show()
    self.effectNode:playAction("card_flip_gaf",false)
    self.effectNode:setActCallback(function(name)
            if name == "card_flip_gaf" then
                callback()
                self.effectNode:hide()
            end
        end)
end

function SummonScene:onGuide()
    if not GuideData:isCompleted("Card") then
        local rect = {x = display.cx+80, y = display.cy - 195, width = 160 ,height = 200}
        local text = GameConfig.tutor_talk["7"].talk
        local param = {x = 400, y = 355, rect = rect, text = text, callback = function (tutor)
            self.summonLayer.diamondNode:playEnterAnimation(1)
            tutor:removeFromParent(true)
            tutor = nil
        end}
        showTutorial(param)
    else
        if not GuideData:isCompleted("FirstCard") then
            self.summonLayer.diamondNode:createFirstTip()
        else
            self.summonLayer.diamondNode:removeFirstTip()
        end
    end
end

function SummonScene:onEnter()
    SummonScene.super.onEnter(self)
    self:onGuide()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function SummonScene:onExit()
    SummonScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.netEvent)
end

return SummonScene