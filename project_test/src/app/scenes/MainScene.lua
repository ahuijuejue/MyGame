local BasicScene = import("..ui.BasicScene")
local MainScene  = class("MainScene", BasicScene)

local MainLayer    = import("..views.main.MainLayer")
local UserResLayer = import("..views.main.UserResLayer")
local MenuNode     = import("..views.main.MenuNode")
local BannerLayer  = import("..views.banner.BannerLayer")
local ChatLeftView = import("..views.chat.ChatLeftView")
local ChatSetView  = import("..views.chat.ChatSetView")
local ChatLayer    = import("..views.chat.ChatLayer")
local ChatExpressView = import("..views.chat.ChatExpressView")

local TAG         = "MainScene"
local bgImageName = "Background.png"
local skyImage    = "Sky_Left.png"

function MainScene:ctor()
    MainScene.super.ctor(self,TAG)
	self:createBackground()
	self.resLayer = UserResLayer.new()
    self.resLayer:setPosition((display.width-460)/2,display.height-55)
    self:addChild(self.resLayer,3)

	self.mainLayer = MainLayer.new()
    self.mainLayer.delegate = self
	self:addChild(self.mainLayer)

    --主菜单按钮
    local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:showMenuBtnsAnimation()
    menuNode:setMenuOpen(true)
    menuNode:setBtnsEnabled()
    menuNode:setMenuBtnImage()
    self:addChild(menuNode,5)

    self:createBannerView()
    self:createChatLeftView()
    self:createChatView()

end

function MainScene:createBackground()
    local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)
end

-- 活动banner显示
function MainScene:createBannerView()
    self.bannerLayer = BannerLayer.new()
    self.bannerLayer:addTo(self,100)
    self.bannerLayer.delegate = self
end

-- 更新活动banner显示
function MainScene:updateBannerView()
    if self.bannerLayer then
        if #UserData:getBannerImage()>0 then
            self.bannerLayer:show()
        else
            self.bannerLayer:hide()
        end
    end
end

-- 移除活动banner显示
function MainScene:removeBannerLayer()
    self.bannerLayer:removeFromParent()
    self.bannerLayer = nil
end

-- 左下角聊天显示
function MainScene:createChatLeftView()
    self.chatLeftView = ChatLeftView.new()
    self.chatLeftView:addTo(self)
    self.chatLeftView.delegate = self

    if self.mainLayer.node:getIsShow() then
        self.chatLeftView:pos(display.left+50,display.bottom+150)
    else
        self.chatLeftView:pos(display.left+50,display.bottom+40)
    end
end

-- 更新左下角聊天显示
function MainScene:updateChatLeftView()
    if OpenLvData:isOpen("chat") then
        self.chatLeftView:show()
        self.chatLeftView:updateData()
        self.chatLeftView:updateView()
    else
        self.chatLeftView:hide()
    end
end

-- 聊天界面显示
function MainScene:createChatView()
    self.chatView = ChatLayer.new()
    self.chatView:addTo(self,10)
    self.chatView.delegate = self
end

-- 聊天设置界面
function MainScene:createChatSetView()
    self.setView = ChatSetView.new()
    self.setView:addTo(self,10)
    self.setView:updateChooseState()
    self.setView.delegate = self
end

-- 移除聊天设置界面
function MainScene:removeSetView()
    self.setView:removeFromParent()
    self.setView = nil
end

-- 聊天表情界面
function MainScene:createExpressView()
    self.expressView = ChatExpressView.new()
    self.expressView:addTo(self,10)
    self.expressView.delegate = self
    self.expressView:updateData()
    self.expressView:updateView()
end

-- 移除聊天表情界面
function MainScene:removeExpressView()
    self.expressView:removeFromParent()
    self.expressView = nil
end

function MainScene:updateView()
    if self.chatView.textfield then
        self.chatView.textfield:removeFromParent()
        self.chatView.textfield = nil
    end
    self.chatView:hide()
    self:updateBannerView()
    self:updateChatLeftView()
end

function MainScene:createSlotView()
    self.tigerLayer = app:createView("activity.TigerLayer")
    self:addChild(self.tigerLayer,10)

    self.tigerLayer.closeFunc = function ()
        self.tigerLayer:removeFromParent(true)
        self.tigerLayer = nil
    end
end

function MainScene:createFlopView()
    self.flipLayer = app:createView("activity.FlipFunLayer")
    self:addChild(self.flipLayer,10)

    self.flipLayer.closeFunc = function ()
        self.flipLayer:removeFromParent(true)
        self.flipLayer = nil
    end
end

function MainScene:createFeedbackView()
    self.backfeedLayer = app:createView("activity.BackfeedLayer")
    self:addChild(self.backfeedLayer,10)

    self.backfeedLayer.closeFunc = function ()
        self.backfeedLayer:removeFromParent(true)
        self.backfeedLayer = nil
    end
end

function MainScene:createGamblingView()
    self.wealthLayer = app:createView("activity.WealthLayer")
    self:addChild(self.wealthLayer,10)

    self.wealthLayer.closeFunc = function ()
        self.wealthLayer:removeFromParent(true)
        self.wealthLayer = nil
    end
end

function MainScene:createDiscountView()
    self.sevenDiscountLayer = app:createView("activity.SevenDiscountLayer")
    self:addChild(self.sevenDiscountLayer,10)

    self.sevenDiscountLayer.closeFunc = function ()
        self.sevenDiscountLayer:removeFromParent(true)
        self.sevenDiscountLayer = nil
    end
end

--网络请求回调
function MainScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.OpenChoukaFrameProcess then
        app:pushToScene("SummonScene")
        if self.tutor then
            self.tutor:removeFromParent(true)
            self.tutor = nil
        end
    elseif order == OperationCode.OpenShopProcess and tonumber(data.param1) == 1 then
        app:pushScene("ShopScene")
    elseif order == OperationCode.OpenShopProcess and tonumber(data.param1) == 7 then
        app:pushScene("ShopSecretScene")
    elseif order == OperationCode.BuyShopGoodsProcess then
        local index = tonumber(data.param1)
        if self.sevenDiscountLayer then
            self.sevenDiscountLayer:updateBuyBtn(index)
        end
        UserData:showReward(UserData:parseItems(data.a_param1))
        self.mainLayer:showPoint("sevenBuy",DiscountShopModel:isCanBuy())
    elseif order == OperationCode.RecieveChatMsgProcess then
        if data.param1 == "5" then
            if self.wealthLayer then
                self.wealthLayer:updateTable()
            end
        else
            self.chatLeftView:updateData()
            self.chatLeftView:updateView()
            if self.chatView:isVisible() then
                self.chatView:updateView()
            end
        end
    elseif order == OperationCode.ShowUnionInfoProcess then
        if data.param1 == 1 then
            app:pushToScene("UnionScene")
        elseif data.param1 == 2 then
            app:pushToScene("JoinUnionScene")
        end
    elseif order == OperationCode.OnearmBunditProcess then
        hideLoading()
        if self.tigerLayer then
            if data.param1 == 1 then
                self.tigerLayer:doSlot()
                self.tigerLayer:updateView()
            else
                self.tigerLayer:doSlot2()
            end
        end
        self.mainLayer:showPoint("slot",SlotModel:isCanSlot())
    elseif order == OperationCode.OpenCardActProcess then
        if self.flipLayer then
            if data.param1 ~= -1 then
                self.flipLayer:touchFlip(data.param1)
                self.flipLayer:updateView()
            else
                self.flipLayer:autoFlip()
                self.flipLayer:updateView()
            end
        end
        UserData:showReward(UserData:parseItems(data.a_param1))
        self.mainLayer:showPoint("flop",FlopModel:isCanFlop())
    elseif order == OperationCode.FreshOpenCardProcess then
        if self.flipLayer then
            self.flipLayer:resetNode()
        end
    elseif order == OperationCode.GodOfFortuneProcess then
        hideLoading()
        if self.wealthLayer then
            self.wealthLayer:doGambling()
        end
        self.mainLayer:showPoint("gambling",GamblingModel:isCanGambling())
    elseif order == OperationCode.GetSevenRechargeAwardProcess then
        if self.backfeedLayer then
            self.backfeedLayer:updateView()
        end
        UserData:showReward(UserData:parseItems(data.a_param1))
        self.mainLayer:showPoint("feedback",FeedbackModel:isCanActivate())
    end
end

function MainScene:onEnter()
    MainScene.super.onEnter(self)
    AudioManage.playMusic("Main.mp3",true)

    self:updateView()

    --注册监听事件
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
	self:onGuide()
end

function MainScene:onExit()
    -- AudioManage.stopMusic(true)
    MainScene.super.onExit(self)

    --移除监听事件
    GameDispatcher:removeEventListener(self.netEvent)
end

function MainScene:onGuide()
	local haveGuide, layerName = GuideManager:makeGuide(self)
    if haveGuide then
        self.mainLayer:removeSubLayer(layerName)
    end
end


return MainScene