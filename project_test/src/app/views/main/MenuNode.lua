local MenuNode = class("MenuNode",function()
    return display.newNode()
end)

local BUTTON_ID = {
    BUTTON_MENU = 1,
    BUTTON_HERO = 2,
    BUTTON_QUEST = 3,
    BUTTON_FRIEND = 4,
    BUTTON_PET = 5,
    BUTTON_SHOP = 6,
    BUTTON_BAG = 7,
    BUTTON_ACTIVITY = 8,
    BUTTON_UNION = 9,
    BUTTON_CARD = 10,
}

local closeImageName = "Button_Close.png"
local openImageName = "Button_Open.png"
local heroBtnImageName = "Button_Hero.png"
local missonBtnImageName = "Button_Quest.png"
local petBtnImageName = "Button_Pet.png"
local friendBtnImageName = "Button_Friend.png"
local shopBtnImageName = "Button_Shop.png"
local cardBtnImageName = "Button_Card.png"
local activityBtnImageName = "Button_Coin.png"
local bagBtnImageName = "Button_Bag.png"
local rankBtnImageName = "Button_Union.png"
local menuImage = "menu_bg.png"
local pointImage = "Point_Red.png"

function MenuNode:ctor()
    self.points = {}
    self:setHorBtnVisible(true)
    self:setVerBtnVisible(true)
    self:createMenu()
    self:setMenuOpen(false)
    self:setBtnsEnabled()

    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function MenuNode:createMenu()
    --按钮回调
    local btnCallBack = handler(self,self.buttonEvent)

    --主菜单按钮
    self.menuBtn = cc.ui.UIPushButton.new()
    :onButtonClicked(btnCallBack)
    self.menuBtn:setTag(BUTTON_ID.BUTTON_MENU)

    self:setMenuBtnImage()

    --垂直方向按钮
    local verticalBtnCount = 4
    local verticalImagesName = {heroBtnImageName,missonBtnImageName,friendBtnImageName,petBtnImageName}
    self.verticalBtns = {}
    for i=1,verticalBtnCount do
        local btn = cc.ui.UIPushButton.new({normal = menuImage})
        :onButtonClicked(btnCallBack)
        btn:setVisible(false)
        btn:setTag(BUTTON_ID.BUTTON_MENU+i)
        self:addChild(btn)

        local sprite = display.newSprite(verticalImagesName[i])
        sprite:setPosition(0,18)
        btn:addChild(sprite)

        local point = display.newSprite(pointImage)
        point:setVisible(false)
        point:setPosition(30,40)
        btn:addChild(point)

        table.insert(self.points,point)
        table.insert(self.verticalBtns,btn)
    end

    --水平方向按钮
    local horizontalBtnCount = 5
    local horizontalImagesName = {shopBtnImageName,bagBtnImageName,activityBtnImageName,rankBtnImageName,cardBtnImageName}
    self.horizontalBtns = {}

    for i=1,horizontalBtnCount do
        local btn = cc.ui.UIPushButton.new({normal = menuImage})
        :onButtonClicked(btnCallBack)
        btn:setVisible(false)
        btn:setTag(BUTTON_ID.BUTTON_PET+i)
        self:addChild(btn)

        local sprite = display.newSprite(horizontalImagesName[i])
        sprite:setPosition(0,15)
        btn:addChild(sprite)

        local point = display.newSprite(pointImage)
        point:setVisible(false)
        point:setPosition(30,40)
        btn:addChild(point)

        table.insert(self.points,point)
        table.insert(self.horizontalBtns, btn)
    end
    self:addChild(self.menuBtn)
end

--添加提示点
function MenuNode:showPoint(index,visible)
    self.points[index]:setVisible(visible)
end

--设置菜单栏是否打开
function MenuNode:setMenuOpen(opened)
    self.isMenuOpen = opened
end

--设置水平方向按钮是否可见
function MenuNode:setHorBtnVisible(visible)
	self.horVisible = visible
end

--设置垂直方向按钮是否可见
function MenuNode:setVerBtnVisible(visible)
	self.verVisible = visible
end

--设置menu上的按钮是否可用
function MenuNode:setBtnsEnabled()
    if self.verVisible then
    	for key in pairs(self.verticalBtns) do
        	local verBtn = self.verticalBtns[key]
        	verBtn:setButtonEnabled(self.isMenuOpen)
    	end
    end
    if self.horVisible then
    	for key in pairs(self.horizontalBtns) do
        	local horBtn = self.horizontalBtns[key]
        	horBtn:setButtonEnabled(self.isMenuOpen)
    	end
    end
end

--设置menu按钮状态图片
function MenuNode:setMenuBtnImage()
    if self.isMenuOpen then
        self.menuBtn:setButtonImage("normal",openImageName)
        self.menuBtn:setButtonImage("pressed",openImageName)
    else
        self.menuBtn:setButtonImage("normal",closeImageName)
        self.menuBtn:setButtonImage("pressed",closeImageName)
    end
end

--菜单栏按钮伸缩效果
function MenuNode:showMenuBtnsAnimation()
    local offset = 100
    local offsetY = 10
    local t = 0.2
    local dir = 1
    local eas = "backOut"
    if self.isMenuOpen then
        dir = -1
        eas = "backIn"
    end

    --垂直方向
    if self.verVisible then
    	for i=1,#self.verticalBtns do
            self.verticalBtns[i]:setVisible(true)
        	local param = {y = (offset*i - offsetY)*dir, easing = eas, time = t, onComplete = function (target)
                target:setVisible(self.isMenuOpen)
            end}
        	transition.moveBy(self.verticalBtns[i],param)
    	end
    end

    --水平方向
    if self.horVisible then
    	for i=1,#self.horizontalBtns do
            self.horizontalBtns[i]:setVisible(true)
        	local param = {x = -offset*i*dir, easing = eas, time = t, onComplete = function (target)
                target:setVisible(self.isMenuOpen)
            end}
        	transition.moveBy(self.horizontalBtns[i],param)
    	end
    end
end

function MenuNode:hideMenu()
    self:setMenuOpen(false)
    self:setMenuBtnImage()
    --垂直方向
    if self.verVisible then
        for i=1,#self.verticalBtns do
            self.verticalBtns[i]:setVisible(false)
            self.verticalBtns[i]:setPosition(0,0)
        end
    end

    --水平方向
    if self.horVisible then
        for i=1,#self.horizontalBtns do
            self.horizontalBtns[i]:setVisible(false)
            self.horizontalBtns[i]:setPosition(0,0)
        end
    end
end

--按钮事件
function MenuNode:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()

    if tag == BUTTON_ID.BUTTON_MENU then
        self:menuBtnEvent()
    elseif tag == BUTTON_ID.BUTTON_HERO then
        app:pushToScene("HeroListScene")
    elseif tag == BUTTON_ID.BUTTON_QUEST then
        SceneData:pushScene("Task", self)
    elseif tag == BUTTON_ID.BUTTON_FRIEND then
        SceneData:pushScene("City", self)
    elseif tag == BUTTON_ID.BUTTON_PET then
        if UserData:getUserLevel() >= OpenLvData.tails.openLv then
            SceneData:pushScene("Tails", self)
        else
            local param = {text = OpenLvData.tails.openLv.."级开启",size = 30,color = display.COLOR_RED}
            showToast(param)
        end
    elseif tag == BUTTON_ID.BUTTON_SHOP then
        NetHandler.gameRequest("OpenShop",{param1 = 1})
    elseif tag == BUTTON_ID.BUTTON_BAG then
        app:pushToScene("BackpackScene")
    elseif tag == BUTTON_ID.BUTTON_ACTIVITY then
        local openLevel = GameConfig["CoinInfo"]["1"].OpenLeve
        if UserData:getUserLevel() >= openLevel then
            app:pushScene("CoinScene")  -- 宝藏系统
        else
            showToast({text = string.format("%d级开启！", openLevel) })
        end
    elseif tag == BUTTON_ID.BUTTON_UNION then -- 公会
        if UserData:getUserLevel() < GameConfig["ConsortiaInfo"]["1"].ConsortiaOpenLeve then
            showToast({text = GameConfig["ConsortiaInfo"]["1"].ConsortiaOpenLeve.."级开启"})
        else
            NetHandler.gameRequest("ShowUnionInfo")
        end
    elseif tag == BUTTON_ID.BUTTON_CARD then
        NetHandler.gameRequest("OpenChoukaFrame")
    end
end

function MenuNode:menuBtnEvent()
    self:showMenuBtnsAnimation()
    self:setMenuOpen(not self.isMenuOpen)
    self:setBtnsEnabled()
    self:setMenuBtnImage()
end

function MenuNode:backpackBtnEvent()
    app:pushScene("BackpackScene")
end

function MenuNode:onEnter()
    self:updateDot()
end

-- 红点显示
function MenuNode:updateDot()
    self:showPoint(9,SummonData:hasFreeSummon())
    self:showPoint(1,GamePoint.hasHeroSystemCanUpdate())
    self:showPoint(2, TaskData:haveOkTask()) -- 任务
    self:showPoint(8, UnionListData:isJoinUnion() or UnionListData:isShowApplyRedPoint() or UnionListData:isShowSignRedPoint() or UnionListData:isShowSendRedPoint() or UnionListData:isShowBackRedPoint()) -- 公会
    self:showPoint(7, CoinData:hasFreeTrip())
end

function MenuNode:onExit()
    --移除监听事件
    SceneData:removeTarget(self)
end

return MenuNode