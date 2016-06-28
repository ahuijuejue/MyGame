--[[
    公会主界面
]]

local BasicScene = import("..ui.BasicScene")
local UnionScene = class("UnionScene", BasicScene)

local UnionLayer = import("..views.union.UnionLayer")
local MenuNode = import("..views.main.MenuNode")

local TAG = "UnionScene"
local bgImageName = "UnionBack.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"
local changeAd = "change_union_ad.png"
local bottomImage = "main_bottom_bg.png"

function UnionScene:ctor()
	UnionScene.super.ctor(self,TAG)

    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="union"}):addTo(self):zorder(10)
    :onBack(function(layer)
        self:pop()
    end)

    self:createBottomTop()
	self:createBackground()
	self:createMenuNode()
	self:createEnterLayer()
end

function UnionScene:createBackground()
    local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)
end

function UnionScene:createBottomTop()
    local bottom = display.newSprite(bottomImage)
    local width = bottom:getContentSize().width
    local height = bottom:getContentSize().height
    bottom:flipY(true)
    bottom:setPosition(display.cx,height/2)
    self:addChild(bottom, 9)

    local top = display.newSprite(bottomImage)
    top:setPosition(display.cx,display.height - height/2)
    self:addChild(top, 9)
end

function UnionScene:createBackBtn()
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

function UnionScene:createMenuNode()
	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)
end

function UnionScene:createEnterLayer()
	self.unionLayer = UnionLayer.new()
	self:addChild(self.unionLayer)
    self.unionLayer.delegate = self
end

-- 输入框
function UnionScene:createUnionEditBox(options)
    local msg_ = options.msg
    self.layer = CommonView.blackLayer1():addTo(self, 15)
    local function onEdit(event, editbox)
        if event == "began" then
        elseif event == "changed" then
            local _text = editbox:getText()
            options.msg = _text

            local _trimed = string.trim(_text)
            _trimed = parseString(_trimed, options.fontNum, 2)
            if _trimed ~= _text then
                editbox:setText(_trimed)
                options.msg = _text
            end
        elseif event == "ended" then
        elseif event == "return" then
        end
    end

    local textBack = display.newScale9Sprite(changeAd)
    textName = cc.ui.UIInput.new({
        UIInputType = 1,
        image = textBack,
        size = cc.size(options.width, options.height),
        x = options.posX,
        y = options.posY,
        listener = onEdit,
    }):addTo(self.layer, 5)
    :align(display.CENTER)
    textName:setPlaceHolder(options.des)
    textName:setMaxLength(options.maxLength)

    self.layer:setTouchEnabled(true)
    self.layer:setTouchSwallowEnabled(true)
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name == "began" then
            return true
        elseif event.name == "moved" then
        elseif event.name == "ended" then
            if options.msg ~= msg_ and options.msg ~= "" then
                NetHandler.gameRequest("ModifyUnionInfo", {param1 = options.changeType, param2 = options.msg})
            else
                self:removeUnionEditBox()
            end
        end
    end)
end
function UnionScene:removeUnionEditBox()
    if self.layer then
        self.layer:removeFromParent()
        self.layer = nil
    end
end

function UnionScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.NoticeUnionMemberProcess then
        self:updateData()
        self:updateView()
    elseif order == OperationCode.ModifyUnionInfoProcess then  -- 修改公告
        self:removeUnionEditBox()
        self:updateData()
        self:updateView()
    elseif order == OperationCode.ShowUnionRandomProcess then
        app:pushToScene("UnionArenaScene")
    elseif order == OperationCode.OpenShopProcess then
        app:pushScene("ShopScene")
    end
end

function UnionScene:updateData()
    self.unionLayer:updateData()
end

function UnionScene:updateView()
    self.unionLayer:updateView()
end

function UnionScene:onEnter()
    if UnionListData.isTheNewUnion == 1 then
        showToast({text = "公会创建成功！"})
        UnionListData.isTheNewUnion = 0
    end
    if UnionListData.isApplyPass == 1 then
        showToast({text = "您的申请通过了！"})
        UnionListData.isApplyPass = 0
    end
    self:updateData()
    self:updateView()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function UnionScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionScene
