local UserResLayer = class("UserResLayer",function()
    return display.newNode()
end)

local scheduler = require("framework.scheduler")

local BUTTON_ID = {
    BUTTON_CASH = 1,
    BUTTON_DIAMOND = 2,
    BUTTON_EP = 3,
    BUTTON_SKILL = 4,
}

UserResLayer.Type = {
    EP_TYPE = 1, -- 体力
    SOUL_TYPE = 2, -- 灵能值
    CARD_TYPE = 3, -- 抽卡积分
    ARENA_TYPE = 4, -- 竞技场
    TREE_TYPE = 5, -- 尾兽/神树
    CASTLE_TYPE = 6, -- 城建币
    SKILL_TYPE = 7, -- 技能点
    UNION_TYPE = 8, -- 公会币
    UNIONINSTANCE_TYPE = 9, -- 公会副本体力
    COIN_TYPE = 10, -- 黄金碎片
}

local skillImage = "SkillPoint.png"
local nameBgImageName = "Banner_Number.png"
local cashImageName = "Gold.png"
local diamondImageName = "Diamond.png"
local epImageName = "Energy.png"
local soulImage = "Skill.png"
local cardImage = "CardScore.png"
local plusImageName = "Plus.png"
local arenaImage = "ArenaCoin.png"
local treeImage = "TailsCoin.png"
local castleImage = "CastleCoin.png"
local unionImage = "UnionGold.png"
local isntanceImageName = "item_14.png"
local coinImage = "CoinGold.png" -- 黄金碎片图片

function UserResLayer:ctor(type_)
    self.type = type_ or UserResLayer.Type.EP_TYPE
    self.btnCallBack = handler(self,self.buttonEvent)
    if self.type == UserResLayer.Type.EP_TYPE then
        self:createCashView()
        self:createDiamondView()
        self:createEpView()
        self:createEpInfoView()
    elseif self.type == UserResLayer.Type.SOUL_TYPE then
        self:createCashView()
        self:createDiamondView()
        self:createSoulView()
    elseif self.type == UserResLayer.Type.CARD_TYPE then
        self:createCashView()
        self:createDiamondView()
        self:createCardScoreView()
    elseif self.type == UserResLayer.Type.SKILL_TYPE then
        self:createSkillPointView()
        self:createDiamondView()
        self:createSoulView()
    elseif self.type == UserResLayer.Type.ARENA_TYPE then
        self:createCashView()
        self:createDiamondView()
        self.arenaLabel = self:createThirdView(arenaImage)
    elseif self.type == UserResLayer.Type.TREE_TYPE then
        self:createCashView()
        self:createDiamondView()
        self.treeLabel = self:createThirdView(treeImage)
    elseif self.type == UserResLayer.Type.CASTLE_TYPE then
        self:createCashView()
        self:createDiamondView()
        self.castleLabel = self:createThirdView(castleImage)
    elseif self.type == UserResLayer.Type.UNION_TYPE then
        self:createCashView()
        self:createDiamondView()
        self.unionLabel = self:createThirdView(unionImage)
    elseif self.type == UserResLayer.Type.UNIONINSTANCE_TYPE then
        self:createCashView()
        self:createDiamondView()
        self:createInstanceEpView()
    elseif self.type == UserResLayer.Type.COIN_TYPE then
        self:createCashView()
        self:createDiamondView()
        self.coinLabel = self:createThirdView(coinImage)
    end
    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function UserResLayer:createCashView()
    local cashBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    :onButtonClicked(self.btnCallBack)
    cashBtn:setPosition(105,26)
    cashBtn:setTag(BUTTON_ID.BUTTON_CASH)
    self:addChild(cashBtn)

    --金币icon
    local cashIconSprite = display.newSprite(cashImageName)
    cashIconSprite:setPosition(-89,1)
    cashBtn:addChild(cashIconSprite)

    --金币数量
    local param = {text=tostring(UserData.gold),color = display.COLOR_WHITE}
    self.cashLabel = display.newTTFLabel(param)
    self.cashLabel:setPosition(-65,0)
    self.cashLabel:setAnchorPoint(0,0.5)
    cashBtn:addChild(self.cashLabel)

    --增加icon
    local plus = display.newSprite(plusImageName)
    plus:setPosition(86,0)
    cashBtn:addChild(plus)
end

function UserResLayer:createSkillPointView()
    self.skillBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    :onButtonClicked(self.btnCallBack)
    self.skillBtn:setPosition(105,26)
    self.skillBtn:setTag(BUTTON_ID.BUTTON_SKILL)
    self:addChild(self.skillBtn)

    --icon
    local iconSprite = display.newSprite(skillImage)
    iconSprite:setPosition(-85,2)
    self.skillBtn:addChild(iconSprite)

    --技能点数
    self.pointLabel = display.newTTFLabel({})
    self.pointLabel:setPosition(-65,0)
    self.pointLabel:setAnchorPoint(0,0.5)
    self.skillBtn:addChild(self.pointLabel)

    self.timeLabel = display.newTTFLabel({})
    self.timeLabel:setPosition(65,0)
    self.timeLabel:setAnchorPoint(1,0.5)
    self.skillBtn:addChild(self.timeLabel)

    --增加icon
    self.skillPlus = display.newSprite(plusImageName)
    self.skillPlus:setPosition(86,0)
    self.skillBtn:addChild(self.skillPlus)
end

function UserResLayer:createDiamondView()
    local diamondBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    :onButtonClicked(self.btnCallBack)
    diamondBtn:setPosition(335,26)
    diamondBtn:setTag(BUTTON_ID.BUTTON_DIAMOND)
    self:addChild(diamondBtn)

    --钻石icon
    local diamondIconSprite = display.newSprite(diamondImageName)
    diamondIconSprite:setPosition(-85,2)
    diamondBtn:addChild(diamondIconSprite)

    --钻石数量
    local param = {text=tostring(UserData.diamond),color = display.COLOR_WHITE}
    self.diamondLabel = display.newTTFLabel(param)
    self.diamondLabel:setPosition(-65,0)
    self.diamondLabel:setAnchorPoint(0,0.5)
    diamondBtn:addChild(self.diamondLabel)

    --增加icon
    local plus = display.newSprite(plusImageName)
    plus:setPosition(86,0)
    diamondBtn:addChild(plus)
end

function UserResLayer:startSkillTimer()
    if self.skillTimeHandle then
        return
    end
    self.skillTimeHandle = scheduler.scheduleGlobal(handler(self,self.updateSkillTime),1)
end

function UserResLayer:stopSkillTimer()
    if self.skillTimeHandle then
        scheduler.unscheduleGlobal(self.skillTimeHandle)
        self.skillTimeHandle = nil
    end
end

function UserResLayer:createEpView()
    --体力背景框
    local epBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    :onButtonClicked(self.btnCallBack)
    epBtn:setPosition(581,26)
    epBtn:setTag(BUTTON_ID.BUTTON_EP)
    self:addChild(epBtn)

    --体力icon
    local epIconSprite = display.newSprite(epImageName)
    epIconSprite:setPosition(-89,2)
    epBtn:addChild(epIconSprite)

    --体力数
    local param = {text = string.format("%d/%d",UserData.power, UserData:getPowerMax()),color = display.COLOR_WHITE}
    self.epLabel = display.newTTFLabel(param)
    self.epLabel:setPosition(-65,0)
    self.epLabel:setAnchorPoint(0,0.5)
    epBtn:addChild(self.epLabel)

    --增加icon
    local plus = display.newSprite(plusImageName)
    plus:setPosition(86,0)
    epBtn:addChild(plus)
end

-- 体力恢复
function UserResLayer:createEpInfoView()
    local powerLayer = nil

    base.Grid.new()
    :addTo(self)
    :pos(581,26)
    :onTouch(function(event)
        if event.name == "began" then
            powerLayer = app:createView("widget.PowerInfoLayer"):zorder(101)

            powerLayer:addTo(self)
            :pos(400, -100)
            :onEvent(function(tipEvent)
                if tipEvent.name == "exit" then
                    powerLayer = nil
                end
            end)

        elseif event.name == "moved" then
            if powerLayer then
                powerLayer:removeSelf()
                powerLayer = nil
            end
        elseif event.name == "ended" then
            if powerLayer then
                powerLayer:removeSelf()
                powerLayer = nil
            end
        end
    end, cc.size(100, 50))

end

-- 公会副本体力
function UserResLayer:createInstanceEpView()
    --体力背景框
    local epBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    :onButtonClicked(self.btnCallBack)
    epBtn:setPosition(581,26)
    self:addChild(epBtn)

    --体力icon
    local epIconSprite = display.newSprite(isntanceImageName)
    epIconSprite:setPosition(-89,2)
    epIconSprite:setScale(0.4)
    epBtn:addChild(epIconSprite)

    --体力数
    local param = {text = tostring(UserData.unionPower),color = display.COLOR_WHITE}
    self.unionEpLabel = display.newTTFLabel(param)
    self.unionEpLabel:setPosition(-65,0)
    self.unionEpLabel:setAnchorPoint(0,0.5)
    epBtn:addChild(self.unionEpLabel)

    --增加icon
    local plus = display.newSprite(plusImageName)
    plus:setPosition(86,0)
    epBtn:addChild(plus)
end

function UserResLayer:createSoulView()
    local soulBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    soulBtn:setPosition(581,26)
    self:addChild(soulBtn)

    local iconSprite = display.newSprite(soulImage)
    iconSprite:setPosition(-85,2)
    soulBtn:addChild(iconSprite)

    local param = {text = UserData.soul,color = display.COLOR_WHITE}
    self.soulLabel = display.newTTFLabel(param)
    posX = iconSprite:getContentSize().width + 6
    posY = iconSprite:getContentSize().height/2
    self.soulLabel:setPosition(-65,0)
    self.soulLabel:setAnchorPoint(0,0.5)
    soulBtn:addChild(self.soulLabel)
end

function UserResLayer:createCardScoreView()
    local cardBtn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    cardBtn:setPosition(581,26)
    self:addChild(cardBtn)

    local iconSprite = display.newSprite(cardImage)
    iconSprite:setPosition(-85,2)
    cardBtn:addChild(iconSprite)

    local param = {text = UserData.cardValue,color = display.COLOR_WHITE}
    self.cardLabel = display.newTTFLabel(param)
    self.cardLabel:setPosition(-65,0)
    self.cardLabel:setAnchorPoint(0,0.5)
    cardBtn:addChild(self.cardLabel)
end

function UserResLayer:createThirdView(imgName,isButton)
    local btn = cc.ui.UIPushButton.new({normal = nameBgImageName,pressed = nameBgImageName})
    btn:setPosition(581,26)
    self:addChild(btn)

    local iconSprite = display.newSprite(imgName)
    iconSprite:setPosition(-85,2)
    btn:addChild(iconSprite)

    local param = {text = "",color = display.COLOR_WHITE}
    local label = display.newTTFLabel(param)
    label:setPosition(-65,0)
    label:setAnchorPoint(0,0.5)
    btn:addChild(label)

    if isButton then
        local plus = display.newSprite(plusImageName)
        plus:setPosition(86,0)
        btn:addChild(plus)
    end

    return label
end

--更新用户金钱
function UserResLayer:updateUserCash()
    if self.cashLabel then
        self.cashLabel:setString(tostring(UserData.gold))
    end
end

--更新用户钻石
function UserResLayer:updateUserDiamond()
    if self.diamondLabel then
        self.diamondLabel:setString(tostring(UserData.diamond))
    end
end

--更新用户体力
function UserResLayer:updateUserEp()
    if self.epLabel then
        self.epLabel:setString(string.format("%d/%d",UserData.power, UserData:getPowerMax()))
    end
end

--更新用户副本体力
function UserResLayer:updateUserInatanceEp()
    if self.unionEpLabel then
        self.unionEpLabel:setString(tostring(UserData.unionPower))
    end
end

--更新用户灵能值
function UserResLayer:updateSoulValue()
    if self.soulLabel then
        self.soulLabel:setString(tostring(UserData.soul))
    end
end

--更新用户抽卡积分
function UserResLayer:updateCardScoreValue()
    if self.cardLabel then
        self.cardLabel:setString(tostring(UserData.cardValue))
    end
end

--更新用户竞技场积分
function UserResLayer:updateArenaValue()
    if self.arenaLabel then
        self.arenaLabel:setString(tostring(UserData.arenaValue))
    end
end

--更新 尾兽/神树 积分
function UserResLayer:updateTreeValue()
    if self.treeLabel then
        self.treeLabel:setString(tostring(UserData.treeValue))
    end
end

--更新城建币
function UserResLayer:updateCastleValue()
    if self.castleLabel then
        self.castleLabel:setString(tostring(UserData.cityValue))
    end
end

--更新公会币
function UserResLayer:updateUnionValue()
    if self.unionLabel then
        self.unionLabel:setString(tostring(UserData.unionValue))
    end
end

--更新黄金碎片
function UserResLayer:updateCoinValue()
    if self.coinLabel then
        self.coinLabel:setString(tostring(UserData.coinValue))
    end
end

--更新技能点数
function UserResLayer:updateSkillPoint()
    local limitPoint = tonumber(GameConfig.Global["1"].SkillPointLimit)
    local cycle = tonumber(GameConfig.Global["1"].SkillPointRecover)

    self.point = UserData:getSkillPoint()
    self.pointLabel:setString(self.point)

    if self.point < limitPoint then
        self:startSkillTimer()
        if self.point == 0 then
            self.skillPlus:setVisible(true)
            self.skillBtn:setButtonEnabled(true)
        else
            self.skillPlus:setVisible(false)
            self.skillBtn:setButtonEnabled(false)
        end
        local text = string.format("(%s)",formatTime1(self.leftTime))
        self.timeLabel:setString(text)
    else
        self:stopSkillTimer()
        self.leftTime = cycle
        self.timeLabel:setString("(MAX)")
        self.skillPlus:setVisible(false)
        self.skillBtn:setButtonEnabled(false)
    end
end

function UserResLayer:updateSkillTime()
    self.leftTime = self.leftTime - 1
    if self.leftTime <= 0 then
        self.leftTime = tonumber(GameConfig.Global["1"].SkillPointRecover)
        self:updateSkillPoint()
    else
        local text = string.format("(%s)",formatTime1(self.leftTime))
        self.timeLabel:setString(text)
    end
end

function UserResLayer:updateView()
    if self.type == UserResLayer.Type.EP_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateUserEp()
    elseif self.type == UserResLayer.Type.SOUL_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateSoulValue()
    elseif self.type == UserResLayer.Type.CARD_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateCardScoreValue()
    elseif self.type == UserResLayer.Type.ARENA_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateArenaValue()
    elseif self.type == UserResLayer.Type.TREE_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateTreeValue()
    elseif self.type == UserResLayer.Type.CASTLE_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateCastleValue()
    elseif self.type == UserResLayer.Type.UNION_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateUnionValue()
    elseif self.type == UserResLayer.Type.COIN_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateCoinValue()
    elseif self.type == UserResLayer.Type.UNIONINSTANCE_TYPE then
        self:updateUserCash()
        self:updateUserDiamond()
        self:updateUserInatanceEp()
    elseif self.type == UserResLayer.Type.SKILL_TYPE then
        self.leftTime = UserData:getSkillTime()
        self:updateSkillPoint()
        self:updateUserDiamond()
        self:updateSoulValue()
    end
end

function UserResLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    if tag == BUTTON_ID.BUTTON_CASH then
        GoldAlert:info()
    elseif tag == BUTTON_ID.BUTTON_DIAMOND then
        app:pushToScene("RechargeScene")
    elseif tag == BUTTON_ID.BUTTON_EP then
        PowerAlert:show()
    elseif tag == BUTTON_ID.BUTTON_SKILL then
        buySkillAlert()
    end
end

function UserResLayer:onEnter()
    self:updateView()
    --注册监听事件
    self.updateResEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.UPDATE_USER_RES,handler(self,self.updateView))
end

function UserResLayer:onExit()
    self:stopSkillTimer()
    --移除监听事件
    GameDispatcher:removeEventListener(self.updateResEvent)
end

return UserResLayer