local BasicScene = import("..ui.BasicScene")
local JoinUnionScene = class("JoinUnionScene", BasicScene)

local UnionEnterLayer = import("..views.union.UnionEnterLayer")
local MenuNode = import("..views.main.MenuNode")
local UnionIconListLayer = import("..views.union.UnionIconListLayer")

local TAG = "JoinUnionScene"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"

function JoinUnionScene:ctor()
	JoinUnionScene.super.ctor(self,TAG)

    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="union"}):addTo(self):zorder(10)
    :onBack(function(layer)
        self:pop()
    end)

	self:createBackground()
	self:createMenuNode()
	self:createEnterLayer()
end

function JoinUnionScene:createBackground()
    local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)
end

function JoinUnionScene:createBackBtn()
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

function JoinUnionScene:createMenuNode()
	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)
end

function JoinUnionScene:createEnterLayer()
	self.unionLayer = UnionEnterLayer.new()
    self.unionLayer.delegate = self
	self:addChild(self.unionLayer)
end

function JoinUnionScene:createUnionIconLayer()
    self.unionLayer.createLayer.textName:setVisible(false)
    self.unionIconLayer = UnionIconListLayer.new()
    self.unionIconLayer.delegate = self
    self:addChild(self.unionIconLayer, 10)
end

function JoinUnionScene:removeUnionIconLayer()
    self.unionLayer.createLayer.textName:setVisible(true)
    self.unionIconLayer:removeFromParent(true)
    self.unionIconLayer = nil
end

function JoinUnionScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.CreateUnionProcess then
        if data.result ~= 1 then
            self.unionLayer.createLayer:initInputView()
        else
            app:enterToScene("UnionScene")
        end
    elseif order == OperationCode.SearchUnionProcess then
        self.unionLayer.findLayer:updateData()
        self.unionLayer.findLayer:updateView()
    elseif order == OperationCode.ApplyUnionProcess then
        if data.result == 1 then
            self.unionLayer.joinLayer:updateData()
            self.unionLayer.joinLayer:updateView()
        elseif data.result == 2 then
            app:popToScene()
            NetHandler.gameRequest("ShowUnionInfo")
        end
    elseif order == OperationCode.SHowUnionByPageProcess then
        self.unionLayer.joinLayer:updateData()
        self.unionLayer.joinLayer:insertListCell()
    elseif order == OperationCode.NoticeUnionMemberProcess then
        if self.unionLayer.viewTag == 1 then
            if data.param3 == "0" then  -- 拒绝
                showToast({text = "您的申请被拒绝！"})
                self.unionLayer.joinLayer:updateData()
                self.unionLayer.joinLayer:updateView()
            elseif data.param3 == "1" then  -- 同意 加入申请人信息 刷新成员列表
                showToast({text = "您的申请通过了！"})
                app:popToScene()
                NetHandler.gameRequest("ShowUnionInfo")
            end
        end
    end
end

function JoinUnionScene:onEnter()
    if self.unionLayer.viewTag == 2 then
        if self.unionLayer.createLayer.textName then
            self.unionLayer.createLayer.textName:removeAllChildren()
            self.unionLayer.createLayer.textName = nil
        end
        self.unionLayer.createLayer:initInputView()
    end
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function JoinUnionScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return JoinUnionScene
