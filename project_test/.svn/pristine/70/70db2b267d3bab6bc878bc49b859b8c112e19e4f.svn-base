--[[
    公会大厅
]]
local BasicScene = import("..ui.BasicScene")
local UnionHallScene = class("UnionHallScene", BasicScene)

local UnionHallLayer = import("..views.union.UnionHallLayer")
local MenuNode = import("..views.main.MenuNode")
local UnionManageLayer = import("..views.union.UnionManageLayer")
local UnionApplyLayer = import("..views.union.UnionApplyLayer")
local UnionSetLayer = import("..views.union.UnionSetLayer")
local UnionMailLayer = import("..views.union.UnionMailLayer")
local UnionMemberLayer = import("..views.union.UnionMemberLayer")
local UnionLogLayer = import("..views.union.UnionLogLayer")
local UnionFucLayer = import("..views.union.UnionFucLayer")

local TAG = "UnionHallScene"
local bgImageName = "Background_gray.jpg"
local skyImage = "Sky_Left.png"
local backImage = "Return.png"
local backImage2 = "Return_Light.png"
local changeAd = "change_union_ad.png"

function UnionHallScene:ctor()
	UnionHallScene.super.ctor(self,TAG)

    -- 按钮层
    app:createView("widget.MenuLayer", {wealth="union"}):addTo(self):zorder(10)
    :onBack(function(layer)
        self:pop()
    end)

	self:createBackground()
	self:createMenuNode()
    self:createUnionHallLayer()
end

function UnionHallScene:createBackground()
    local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)

    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)
end

function UnionHallScene:createBackBtn()
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

function UnionHallScene:createMenuNode()
	local menuNode = MenuNode.new()
    menuNode:setPosition(display.width-60,50)
    menuNode:setHorBtnVisible(false)
    self:addChild(menuNode,4)
end

-- 公会大厅
function UnionHallScene:createUnionHallLayer()
	self.unionHallLayer = UnionHallLayer.new()
	self.unionHallLayer:addTo(self)
    self.unionHallLayer.delegate = self
end

-- 公会日志
function UnionHallScene:createUnionLogLayer()
    self.unionHallLayer.listView:setTouchEnabled(false)
    self.unionLogLayer = UnionLogLayer.new()
    self.unionLogLayer:addTo(self, 10)
    self.unionLogLayer.delegate = self
end
function UnionHallScene:removeUnionLogLayer()
    self.unionHallLayer.listView:setTouchEnabled(true)
    if self.unionLogLayer then
        self.unionLogLayer:removeFromParent()
        self.unionLogLayer = nil
    end
end

-- 公会管理
function UnionHallScene:createUnionManageLayer()
    self.unionHallLayer.listView:setTouchEnabled(false)
    self.unionManageLayer = UnionManageLayer.new()
    self.unionManageLayer:addTo(self, 10)
    self.unionManageLayer.delegate = self
    self.unionManageLayer:updateView()
end
function UnionHallScene:removeUnionManageLayer()
    self.unionHallLayer.listView:setTouchEnabled(true)
    if self.unionManageLayer then
        self.unionManageLayer:removeFromParent()
        self.unionManageLayer = nil
    end
end

-- 查看成员信息
function UnionHallScene:createUnionMemberLayer()
    self.unionHallLayer.listView:setTouchEnabled(false)
    self.unionMemberLayer = UnionMemberLayer.new() -- 传入指定成员信息表
    self.unionMemberLayer:addTo(self, 10)
    self.unionMemberLayer.delegate = self
    self.unionMemberLayer:updateListView()
end
function UnionHallScene:removeUnionMemberLayer()
    self.unionHallLayer.listView:setTouchEnabled(true)
    if self.unionMemberLayer then
        self.unionMemberLayer:removeFromParent()
        self.unionMemberLayer = nil
    end
end

-- 入会申请
function UnionHallScene:createUnionApplyLayer()
    self.unionApplyLayer = UnionApplyLayer.new()
    self.unionApplyLayer:addTo(self, 10)
    self.unionApplyLayer.delegate = self
end
function UnionHallScene:removeUnionApplyLayer()
    if self.unionApplyLayer then
        self.unionApplyLayer:removeFromParent()
        self.unionApplyLayer = nil
    end
    -- self:updateData()
    self:updateView()
    self.unionManageLayer:updateView()
end

-- 申请设置
function UnionHallScene:createUnionSetLayer()
    self.unionSetLayer = UnionSetLayer.new()
    self.unionSetLayer:addTo(self, 10)
    self.unionSetLayer.delegate = self
    self.unionSetLayer:updateData()
    self.unionSetLayer:updateView()
end
function UnionHallScene:removeUnionSetLayer()
    if self.unionSetLayer then
        self.unionSetLayer:removeFromParent()
        self.unionSetLayer = nil
    end
end

-- 全员邮件
function UnionHallScene:createUnionMailLayer()
    self.unionMailLayer = UnionMailLayer.new()
    self.unionMailLayer:addTo(self, 10)
    self.unionMailLayer.delegate = self
    self.unionMailLayer:updateData()
    self.unionMailLayer:updateView()
end
function UnionHallScene:removeUnionMailLayer()
    if self.unionMailLayer then
        self.unionMailLayer:removeFromParent()
        self.unionMailLayer = nil
    end
end

-- 成员管理按钮事件
function UnionHallScene:createUnionFucLayer(data)
    self.unionFucLayer = UnionFucLayer.new(data)
    self.unionFucLayer:addTo(self, 10)
    self.unionFucLayer.delegate = self
end
function UnionHallScene:removeUnionFucLayer()
    if self.unionFucLayer then
        self.unionFucLayer:removeFromParent()
        self.unionFucLayer = nil
    end
end

-- 输入框
function UnionHallScene:createUnionEditBox(options)
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
            if options.changeType then
               if options.msg ~= msg_ and options.msg ~= "" then
                    NetHandler.gameRequest("ModifyUnionInfo", {param1 = options.changeType, param2 = options.msg})
                else
                    self:removeUnionEditBox()
                end
            else
                self.unionMailLayer.sendMSg = options.msg
                self.unionMailLayer:updateView()
                self:removeUnionEditBox()
            end

        end
    end)
end
function UnionHallScene:removeUnionEditBox()
    if self.layer then
        self.layer:removeFromParent()
        self.layer = nil
    end
end

function UnionHallScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.ShowUnionLogProcess then           -- 公会日志
        self:createUnionLogLayer()
    elseif order == OperationCode.SecedeUnionProcess then        -- 解散公会
        NetHandler.gameRequest("ShowUnionInfo")
    elseif order == OperationCode.ShowUnionInfoProcess then
        app:popToScene()
        app:enterToScene("JoinUnionScene")
    elseif order == OperationCode.ApproveJoinProcess then
        self.unionApplyLayer:updateData()
        self.unionApplyLayer:updateView()
        if data.result == 1 and data.param1 == 1 then
            self:updateData()
            self:updateView()
        end
    elseif order == OperationCode.UnionEliminateProcess then     -- 踢出公会
        self:updateData()
        self:updateView()
        self:removeUnionFucLayer()
    elseif order == OperationCode.AppointUnionProcess then       -- 任命
        self:updateData()
        self:updateView()
        self:removeUnionFucLayer()
    elseif order == OperationCode.ModifyUnionSetUpProcess then   -- 申请公会设置
        showToast({text = "设置成功！"})
        self:removeUnionSetLayer()
    elseif order == OperationCode.SendUnionMailProcess then      -- 发送全员邮件
        showToast({text = "发送成功！"})
        self:removeUnionMailLayer()
    elseif order == OperationCode.ModifyUnionInfoProcess then    -- 修改公会说明 头像
        self:removeUnionEditBox()
        self:updateData()
        self:updateView()
    elseif order == OperationCode.NoticeUnionMemberProcess then  -- 主动推送的消息
        if data.param1 == 2 then
            if data.param2 == UserData.userId then
                UnionListData:cleanData()
                NetHandler.gameRequest("ShowUnionInfo")
            else
                self:updateData()
                self:updateView()
            end
        else
            if data.param1 == 1 and data.param3 == "0" then      -- 审批成员加入
                if self.unionApplyLayer then
                    self.unionApplyLayer:updateData()
                    self.unionApplyLayer:updateView()
                end
            end
            self:updateData()
            self:updateView()
        end
    end
end

function UnionHallScene:updateData()
	self.unionHallLayer:updateData()
end

function UnionHallScene:updateView()
	self.unionHallLayer:updateView()
end

function UnionHallScene:onEnter()
	self:updateData()
	self:updateView()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function UnionHallScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionHallScene
