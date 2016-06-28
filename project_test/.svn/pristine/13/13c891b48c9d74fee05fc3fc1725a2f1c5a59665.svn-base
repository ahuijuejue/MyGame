--[[
    公会礼拜
]]

local BasicScene = import("..ui.BasicScene")
local UnionSignInScene = class("UnionSignInScene", BasicScene)

local UnionSignInLayer = import("..views.union.UnionSignInLayer")
local MenuNode = import("..views.main.MenuNode")

local TAG = "UnionSignInScene"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"

function UnionSignInScene:ctor()
	UnionSignInScene.super.ctor(self,TAG)

    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="union"}):addTo(self):zorder(10)
    :onBack(function(layer)
        self:pop()
    end)

	self:createBackground()
	self:createMenuNode()
	self:createEnterLayer()
end

function UnionSignInScene:createBackground()
    local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)
end

function UnionSignInScene:createBackBtn()
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

function UnionSignInScene:createMenuNode()
	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)
end

function UnionSignInScene:createEnterLayer()
	self.unionSignLayer = UnionSignInLayer.new()
	self:addChild(self.unionSignLayer)
    self.unionSignLayer:updateData()
    self.unionSignLayer:updateView()
end

function UnionSignInScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.UnionSignProcess then
        -- 显示奖励 刷新界面
        self.unionSignLayer:updateData()
        self.unionSignLayer:updateView()

        -- 增加公会经验  公会币
        local unionCounts = GameConfig.ConsortiaCredit[tostring(data.param1)].GetItemNum[1]
        local unionExp = GameConfig.ConsortiaCredit[tostring(data.param1)].GetConsortiaExp

        UserData:showReward({{itemId = "13", count = unionCounts, name = "公会币"},
                             {itemId = "12", count = unionExp, name = "公会经验"}})
    end
end


function UnionSignInScene:onEnter()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function UnionSignInScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionSignInScene
