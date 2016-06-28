local MainLayer = class("MainLayer",function()
    return display.newNode()
end)

local PredictionView = require("app.views.prediction.PredictionView")

local lvBgImageName = "user_level.png"
local headBgImageName = "Banner_Name.png"
local vipImageName = "VIP.png"
local emailBtnImage = "Button_Mail.png"
local signInImage = "Button_Register.png"
local sevenSignImage = "Button_Register_Seven.png" -- 七天礼包
local discountImage = "Discount_Button.png"
local pointImage = "Point_Red.png"
local bottomImage = "main_bottom_bg.png"
local carnivalImage = "Carnival.png"  -- 开服盛典
local rankImage = "Button_Rank.png"   -- 排行榜
local activityImage = "Button_Activity_Small.png" -- 活动
local swordActivityImage = "Button_Sword.png"     -- 战力活动
local firstRehargeImage = "Button_FirstRecharge.png"
local v5RehargeImage = "Button_V5gift.png"
local rechargeImage = "Button_Recharge.png"
local RoleLayer = import(".RoleLayer")
local GafNode = import("app.ui.GafNode")
local wealthImage = "wealth_icon.png" -- 财神到

local BUTTON_ID = {
    BUTTON_HEAD = 1,
    BUTTON_EMAIL = 2,
    BUTTON_SIGNIN = 3,
    BUTTON_SEVEN = 4, -- 七日礼包
    BUTTON_CARNIVAL = 5, -- 开服活动
    BUTTON_ACTIVITY = 6,  -- 通用活动
    BUTTON_SWORD = 7, -- 战力活动
    BUTTON_FIRSTRECHARGE = 8, -- 首充活动
    BUTTON_RECHARGRE = 9, -- 充值
    BUTTON_SEVENBUY = 10, --七日打折礼包
    BUTTON_TIGERSHOP = 11,
    BUTTON_FLIPFUN = 12, --翻翻乐
    BUTTON_WEALTH = 13, --财神到
    BUTTON_BACKFEED = 14,
    BUTTON_RANK = 15, -- 排行榜
    BUTTON_V5GIFT = 16, -- V5福利
}

function MainLayer:ctor()
    self.items1 = {} -- 横向子按钮
    self.items2 = {} -- 竖向子按钮

    self.points = {}
    self.actions = {}
    self.roleList = {}
    self.heroList = {}
    self:createBottomTop()
    self:createUserInfo()
    self:createStageInfo()
    self:createMenu()
    self:createPreView()
    self:createSecretShopButton()

    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)


end

function MainLayer:createBottomTop()
    local bottom = display.newSprite(bottomImage)
    local width = bottom:getContentSize().width
    local height = bottom:getContentSize().height
    bottom:flipY(true)
    bottom:setPosition(display.cx,height/2)
    self:addChild(bottom)

    local top = display.newSprite(bottomImage)
    top:setPosition(display.cx,display.height - height/2)
    self:addChild(top)
end

function MainLayer:createUserInfo()
    --按钮回调
    local btnCallBack = handler(self,self.buttonEvent)

    self.headBtn = display.newSprite(headBgImageName)
    self.headBtn:setPosition(130,display.height-52)
    self.headBtn:addTo(self)
    self.headBtn:setTouchEnabled(true)
    self.headBtn:setTouchSwallowEnabled(false)
    local tableRect = self.headBtn:getBoundingBox()
    local center = tableRect.x+90
    self.headBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
        elseif event.name == "ended" then
            if event.x < center then
                app:pushScene("PlayerSetScene")
            elseif event.x > center then
                app:pushScene("VipScene")
            end
        end
    end)


    --用户等级背景框
    local lvBgSprite = display.newSprite(lvBgImageName)
    lvBgSprite:setPosition(59,display.height-82)
    self:addChild(lvBgSprite,2)

    --用户等级
    self.lvLabel = cc.Label:createWithCharMap("number.png",11,17,48)
    self.lvLabel:setPosition(43,25)
    self.lvLabel:setString(UserData:getUserLevel())
    lvBgSprite:addChild(self.lvLabel,2)

    --VIP等级
    self.vipLabel = cc.Label:createWithCharMap("number.png",11,16,48)
    self.vipLabel:setPosition(157,display.height-68)
    self:addChild(self.vipLabel,2)

    --用户名
    local param = {text = UserData.name,color = display.COLOR_WHITE,size = 20}
    self.nameLabel = display.newTTFLabel(param)
    self.nameLabel:setPosition(157,display.height-45)
    self:addChild(self.nameLabel,2)
end

function MainLayer:createHeroInfo()
    local gafPath = {}
    local tempRole = {}
    local rolePoint = {
        cc.p(display.cx-110,display.cy-220),
        cc.p(display.cx-210,display.cy-170),
        cc.p(display.cx-280,display.cy-220),
        cc.p(display.cx-380,display.cy-170),
    }
    --role如果不存在 重新创建
    for i,v in ipairs(UserData:getBattleMember()) do
        local index = 0
        for j=1,#self.heroList do
            if v == self.heroList[j] then
                index = j
                break
            end
        end
        if index~=0 then
            table.insert(tempRole,self.roleList[index])
			self.roleList[index]:setScale(0.95)
            self.roleList[index]:setPosition(rolePoint[i])
            self.roleList[index]:setLocalZOrder(math.mod(i,2)+2)
        else
            local hero = HeroListData:getRole(v)
            local roleLayer = RoleLayer.new(hero.image)
			roleLayer:setScale(0.95)
            roleLayer:setPosition(rolePoint[i])
            self:addChild(roleLayer,math.mod(i,2)+2)
            table.insert(tempRole,roleLayer)
        end
    end
    --移除不在队伍中的role
    for i=1,#self.roleList do
        local index = 0
        for j=1,#tempRole do
            if self.roleList[i] == tempRole[j] then
                index  = i
                break
            end
        end
        if index == 0 then
            self.roleList[i]:removeFromParent(true)
            self.roleList[i] = nil
        end
    end
    self.heroList = UserData:getBattleMember()
    self.roleList = tempRole
end

function MainLayer:createStageInfo()
    local param = {gaf = "TheGate",width = 150,height = 500,callback = function ()
        if UserData:getUserLevel() >= OpenLvData.arena.openLv then
            -- SceneData:pushScene("Arena", self)
            app:pushScene("ArenaMenuScene")
        else
            local param = {text = OpenLvData.arena.openLv.."级开启",size = 30,color = display.COLOR_RED}
            showToast(param)
        end
    end}
    self.arenaGaf = GafNode.new(param)
    self.arenaGaf:setGafPosition(display.cx+330,display.cy-170)
	self.arenaGaf:setScale(0.85)
    self:addChild(self.arenaGaf,1)

    local param = {gaf = "TheBook",width = 150,height = 500,callback = function ()
        if UserData:getUserLevel() >= OpenLvData.dreamBook.openLv then
            app:pushScene("TrialScene")
        else
            local param = {text = OpenLvData.dreamBook.openLv.."级开启",size = 30,color = display.COLOR_RED}
            showToast(param)
        end
    end}
    self.bookGaf = GafNode.new(param)
    self.bookGaf:setGafPosition(display.cx+50,display.cy-175)
	self.bookGaf:setScale(0.85)
    self:addChild(self.bookGaf,1)

    local param = {gaf = "TheStone",width = 150,height = 500,callback = function ()
        SceneData:pushScene("Chapter", self)
    end}
    self.chapterGaf = GafNode.new(param)
    self.chapterGaf:playAction("on",true)
    self.chapterGaf:setGafPosition(display.cx+185,display.cy-255)
	self.chapterGaf:setScale(0.85)
    self:addChild(self.chapterGaf,1)
end

function MainLayer:createMenu()
    -- 按钮回调
    local btnCallBack = handler(self,self.buttonEvent)
    local node = nil

    -- 邮箱按钮
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = emailBtnImage,pressed = emailBtnImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_EMAIL)
    self:addPoint("mail", 30, 25, node)
    self.emailBtn = node
    table.insert(self.items2, node)
    self.emailBtn = node

    -- 充值按钮
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = rechargeImage,pressed = rechargeImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_RECHARGRE)
    self.rechargeBtn = node
    table.insert(self.items2, node)

    -- 首充活动按钮
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = firstRehargeImage,pressed = firstRehargeImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_FIRSTRECHARGE)
    self:addPoint("firstRecharge", 30, 25, node)
    self:addAction("firstRecharge", 2, -9, node)
    self.firstRechargeBtn = node
    table.insert(self.items2, node)

    -- V5福利
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = v5RehargeImage,pressed = v5RehargeImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_V5GIFT)
    self:addPoint("firstRecharge_", 30, 25, node)
    self:addAction("firstRecharge_", 2, -9, node)
    self.firstRechargeBtn_ = node
    table.insert(self.items2, node)

    -- 排行榜
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = rankImage,pressed = rankImage}) -- rankImage
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_RANK)
    :hide()
    self.rankBtn = node
    table.insert(self.items1, node)

    -- 通用活动
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = activityImage,pressed = activityImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_ACTIVITY)
    self:addPoint("normalActivity", 30, 25, node)
    self:addAction("normalActivity", 2, -9, node)
    self.activityBtn = node
    table.insert(self.items1, node)

    -- 签到按钮
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = signInImage,pressed = signInImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 10, BUTTON_ID.BUTTON_SIGNIN)
    self:addPoint("signIn", 30, 25, node)
    table.insert(self.items1, node)

    -- 七日礼包按钮
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = sevenSignImage,pressed = sevenSignImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_SEVEN)
    self:addPoint("sevenAward", 30, 25, node)
    self.signSevenBtn = node
    table.insert(self.items1, node)

    -- 开服七天活动按钮
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = carnivalImage,pressed = carnivalImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_CARNIVAL)
    self:addPoint("carnival", 30, 25, node)
    self:addAction("carnival", 2, -9, node)
    self.carnivalBtn = node
    table.insert(self.items1, node)

    -- 七日打折商品礼包
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = discountImage,pressed = discountImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_SEVENBUY)
    self:addPoint("sevenBuy", 30, 25, node)
    self.sevenBuyBtn = node
    table.insert(self.items1, node)

    -- 战力活动
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = swordActivityImage,pressed = swordActivityImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_SWORD)
    self:addPoint("sword", 30, 25, node)
    self.swordBtn = node
    table.insert(self.items1, node)

    -- 老虎机活动
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = SlotModel.iconImage,pressed = SlotModel.iconImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_TIGERSHOP)
    self:addPoint("slot",30,25,node)
    self.tigerBuyBtn = node
    table.insert(self.items1, node)

    -- 翻翻乐活动
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = FlopModel.iconImage,pressed = FlopModel.iconImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_FLIPFUN)
    self:addPoint("flop",30,25,node)
    self.flipFunBtn = node
    table.insert(self.items1, node)

    -- 财神到 福禄丸
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = wealthImage,pressed = wealthImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_WEALTH)
    self:addPoint("gambling",30,25,node)
    self.wealthFunBtn = node
    table.insert(self.items1, node)

    --充值反馈
    node = display.newNode():addTo(self, 10)
    cc.ui.UIPushButton.new({normal = FeedbackModel.iconImage,pressed = FeedbackModel.iconImage})
    :onButtonClicked(btnCallBack)
    :addTo(node, 0, BUTTON_ID.BUTTON_BACKFEED)
    self:addPoint("feedback",30,25,node)
    self.feedbackBtn = node
    table.insert(self.items1, node)
end

function MainLayer:createPreView()
    self.node = PredictionView.new()
    self.node:pos(display.left+50,display.bottom+40)
    self.node:addTo(self)
end

-- 神秘商店入口按钮
function MainLayer:createSecretShopButton()
    self.secretDoor = display.newSprite("open.png"):pos(display.cx-410,display.cy-32):addTo(self)

    local param = {gaf = "shop_open",width = 145,height = 100,callback = function ()
        NetHandler.gameRequest("OpenShop",{param1 = 7})
    end}
    self.secretLight = GafNode.new(param)
    self.secretLight:playAction("shop_open",true)
    self.secretLight:setGafPosition(display.cx-202,display.cy+43)
    self:addChild(self.secretLight)

end

-- 更新神秘商店按钮是否出现
function MainLayer:updateSecretButton()
    local nowTime = UserData:getServerSecond()
    local isOpen = VipData:isTreeShopOpen()

    if isOpen then
        self.secretLight:show()
        self.secretDoor:show()
    elseif UserData:getSecretTime() > nowTime then
        self.secretLight:show()
        self.secretDoor:show()
    else
        self.secretLight:hide()
        self.secretDoor:hide()
    end
end

--更新开启内容提示栏
function MainLayer:updatePreView()
    if self.node:getIsShow() then
        self.node:show()
    else
        self.node:hide()
    end
    self.node:updateView()
end

--更新用户名
function MainLayer:updateUserName()
    self.nameLabel:setString(UserData.name)
end

--更新用户等级
function MainLayer:updateUserLv()
    self.lvLabel:setString(tostring(UserData:getUserLevel()))
end

--更新用户头像
function MainLayer:updateAvatar()
    if self.headSprite then
        self.headSprite:removeFromParent(true)
        self.headSprite = nil
    end
    self.headSprite = display.newSprite(UserData.headIcon)
    self.headSprite:pos(45, 45)
    self.headSprite:setScale(0.75)
    self.headBtn:addChild(self.headSprite,3)
end

--更新用户vip
function MainLayer:updateVip()
    self.vipLabel:setString(UserData:getVip())
end

function MainLayer:updateUserInfo()
    self:updateUserName()
    self:updateUserLv()
    self:updateAvatar()
    self:updateVip()
end

--更新gaf
function MainLayer:updateGaf()
    if UserData:getUserLevel() >= OpenLvData.arena.openLv then
        self.arenaGaf:playAction("on",true)
    else
        self.arenaGaf:playAction("off",true)
    end

    if UserData:getUserLevel() >= OpenLvData.dreamBook.openLv then
        self.bookGaf:playAction("on",true)
    else
        self.bookGaf:playAction("off",true)
    end

    if UserData:getUserLevel() < 8 then
        if self.arrow then
            self.arrow:removeFromParent(true)
            self.arrow = nil
        end
        self.arrow = createAniArrow()
        self.arrow:setPosition(display.cx+183,display.cy+90)
        self:addChild(self.arrow)
        self.arrow:zorder(10)
    else
        if self.arrow then
            self.arrow:removeFromParent(true)
            self.arrow = nil
        end
    end
end

--按钮事件
function MainLayer:buttonEvent(event)
    CommonSound.click() -- 音效

    local tag = event.target:getTag()
    if tag == BUTTON_ID.BUTTON_TIGERSHOP then
        self.delegate:createSlotView()
    elseif tag == BUTTON_ID.BUTTON_FLIPFUN then
        self.delegate:createFlopView()
    elseif tag == BUTTON_ID.BUTTON_WEALTH then
        self.delegate:createGamblingView()
    elseif tag == BUTTON_ID.BUTTON_BACKFEED then
        self.delegate:createFeedbackView()
    elseif tag == BUTTON_ID.BUTTON_EMAIL then
        SceneData:pushScene("Mail", self)
    elseif tag == BUTTON_ID.BUTTON_ACTIVITY then
        app:pushScene("NormalActivityScene")
    elseif tag == BUTTON_ID.BUTTON_SIGNIN then
        SceneData:pushScene("SignIn", self)
    elseif tag == BUTTON_ID.BUTTON_SEVEN then
        self.sevenLayer = app:createView("signin.SignInSevenLayer")
        :addTo(app:getCurrentScene())
        :zorder(10)
        :onEvent(function(event)
            if event.name == "close" then
                self:updateDot()
                event.target:removeSelf()
                self:updateShowView()
                self.sevenLayer = nil
            end
        end)
    elseif tag ==BUTTON_ID.BUTTON_SEVENBUY then
        self.delegate:createDiscountView()
    elseif tag == BUTTON_ID.BUTTON_CARNIVAL then
        self.openActivityLayer = app:createView("activity.OpenActivityLayer")
        :addTo(app:getCurrentScene())
        :zorder(10)
        :onEvent(function(event)
            if event.name == "close" then
                self:updateDot()
                event.target:removeSelf()
                self.openActivityLayer = nil
            end
        end)
    elseif tag == BUTTON_ID.BUTTON_SWORD then
        if not self.swordLayer then
            self.swordLayer = app:createView("activity.SwordActivityLayer")
            :addTo(app:getCurrentScene())
            :zorder(10)
            :onEvent(function(event)
                if event.name == "close" then
                    -- self:updateDot()
                    event.target:removeSelf()
                    self.swordLayer = nil
                end
            end)
        end
    elseif tag == BUTTON_ID.BUTTON_RECHARGRE then  -- 充值
        app:pushScene("RechargeScene")
    elseif tag == BUTTON_ID.BUTTON_FIRSTRECHARGE then -- 首充活动
        if not self.firstRechargeLayer then
            self.firstRechargeLayer = app:createView("activity.FirstRechargeLayer")
            :addTo(app:getCurrentScene())
            :zorder(10)
            :onEvent(function(event)
                if event.name == "close" then
                    if self.firstRechargeLayer then
                        self.firstRechargeLayer:removeSelf()
                        self.firstRechargeLayer = nil
                        self:updateDot()
                        self:updateShowView()
                    end

                    if UserData:getFirstRecharge()[1] == "1" and UserData:getFirstRecharge()[2] == "1" then
                        if not self.v5giftLayer then
                            self.v5giftLayer = app:createView("activity.V5GiftLayer")
                            :addTo(app:getCurrentScene())
                            :zorder(10)
                            :onEvent(function(event)
                                if event.name == "close" then
                                    if self.v5giftLayer then
                                        self.v5giftLayer:removeSelf()
                                        self.v5giftLayer = nil
                                        self:updateDot()
                                        self:updateShowView()
                                    end
                                end
                            end)
                        end
                    end

                end
            end)
        end
    elseif tag == BUTTON_ID.BUTTON_V5GIFT then
        if not self.v5giftLayer then
            self.v5giftLayer = app:createView("activity.V5GiftLayer")
            :addTo(app:getCurrentScene())
            :zorder(10)
            :onEvent(function(event)
                if event.name == "close" then
                    if self.v5giftLayer then
                        self.v5giftLayer:removeSelf()
                        self.v5giftLayer = nil
                        self:updateDot()
                        self:updateShowView()
                    end
                end
            end)
        end
    elseif tag == BUTTON_ID.BUTTON_RANK then
        app:pushToScene("RankingSystemScene")
    end
end

function MainLayer:onEnter()
    self:updateGaf()
    self:updateUserInfo()
    self:updateDot()
    self:createHeroInfo()
    self:updateShowView()
    self:updatePreView()
    self:updateSecretButton()
end

-- 更新显示提示点
function MainLayer:updateDot()
    self:showPoint("carnival", ActivityOpenData:haveActivityOpenAndOk()) -- 开服盛典
    self:showPoint("mail", UserData:isHaveMail()) -- 任务
    self:showPoint("signIn", not SignInData:isSigned() or not SignInData:isVipSigned()) -- 签到
    self:showPoint("sevenAward", not SignInData:isSevenCompleted() and not SignInData:isSevenSigned()) -- 七天礼包
    self:showPoint("sword", false) -- 战力活动
    self:showPoint("normalActivity", ActivityNormalData:haveOkActivity()) -- 通用活动
    self:showPoint("firstRecharge", UserData:isShowRechargeDot()) -- 首充活动
    self:showPoint("firstRecharge_", UserData:isShowRechargeDot()) -- V5首充活动
    self:showPoint("flop",FlopModel:isCanFlop())
    self:showPoint("gambling",GamblingModel:isCanGambling())
    self:showPoint("feedback",FeedbackModel:isCanActivate())
    self:showPoint("slot",SlotModel:isCanSlot())
    self:showPoint("sevenBuy",DiscountShopModel:isCanBuy())
end

--显示提示点
function MainLayer:showPoint(key,visible)
    local point = self.points[key]
    if point then
        point:setVisible(visible)
    end
end

--添加提示点
function MainLayer:addPoint(key, x, y, target)
    local point = self.points[key]
    if not point then
        point = display.newSprite(pointImage):addTo(target or self):zorder(11)
        self.points[key] = point
    end
    point:pos(x, y)

end

--添加提示动画
function MainLayer:addAction(key, x, y, target)
    local action = self.actions[key]
    if not action then
        action = GafNode.new({gaf = "interface_gaf"}):addTo(target or self):zorder(10)
        action:playAction("interface_gaf",true)
        action:setScale(0.5)
        action:setVisible(true)
        action:setTouchEnabled(false)
        self.actions[key] = action
    end
    action:setGafPosition(x, y)
end

-- 更新控件显示
function MainLayer:updateShowView()
    self.signSevenBtn:setVisible(not SignInData:isSevenOver())  -- 七天礼包
    self.carnivalBtn:setVisible(ActivityOpenData:isOpenning())  -- 开服盛典
    self.swordBtn:setVisible(SwordActivityData:isOpenning())    -- 战力活动

    if not UserData:isFirstBuy() then
        self.firstRechargeBtn:setVisible(not UserData:isFirstBuy()) -- 首充活动
        self.firstRechargeBtn_:setVisible(false)
    else
        self.firstRechargeBtn:setVisible(false)
        if UserData.v5Rmb < GameConfig.Global["1"].V5RMB then
            self.firstRechargeBtn_:setVisible(true)
        else
            self.firstRechargeBtn_:setVisible(false)
        end
    end

    self.sevenBuyBtn:setVisible(DiscountShopModel:isOpen())  -- 打折商店
    self.tigerBuyBtn:setVisible(SlotModel:isOpen())
    self.flipFunBtn:setVisible(FlopModel:isOpen())
    self.wealthFunBtn:setVisible(GamblingModel:isOpen())
    self.feedbackBtn:setVisible(FeedbackModel:isOpen())
    -- 排列按钮
    self:updateSubButtonShow()
end

function MainLayer:closeLayer(layername, withoutname)
    if layername and self[layername] then
        if withoutname and withoutname==layername then
            return
        end
        self:updateDot()
        self[layername]:removeSelf()
        self:updateShowView()
        self[layername] = nil
    end
end

-- 移除所有子层
function MainLayer:removeSubLayer(withoutname)
    self:closeLayer("sevenLayer", withoutname)
    self:closeLayer("openActivityLayer", withoutname)
end

function MainLayer:updateSubButtonShow()
    -- 横向
    local addX = 90
    local posY = display.top - 110
    local posX = 140
    for i,v in ipairs(self.items1) do
        if v:isVisible() then
            if i == 1 then
                v:pos(posX, posY-13)
            else
                v:pos(posX, posY)
            end
            posX = posX + addX
        end
    end

    -- 竖向
    local addY = 90
    local posY = display.top - 200
    local posX = 60
    for i,v in ipairs(self.items2) do
        if v:isVisible() then
            v:pos(posX, posY)
            posY = posY - addY
        end
    end

end

function MainLayer:onExit()
    SceneData:removeTarget(self)
end

return MainLayer