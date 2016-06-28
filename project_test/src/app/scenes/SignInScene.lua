--[[
签到场景
]]
local SignInScene = class("SignInScene", base.Scene)
local SignInDailyLayer = import("..views.signin.SignInDailyLayer")
local SignInVipLayer = import("..views.signin.SignInVipLayer")
local GafNode = import("app.ui.GafNode")

local tabPressImage = "EveryDay_Normal.png"
local tabNormalImage = "EveryDay_Selected.png"
local tabPressImage_ = "RegisterVip_Normal.png"
local tabNormalImage_ = "RegisterVip_Selected.png"
local pointImage = "Point_Red.png"

local VIEW_ID = {
    VIEW_SIGNEVERY = 1,
    VIEW_SIGNVIP = 2,
}

function SignInScene:initData()

    self.tabNodes = {}
    self.points = {}

    self.viewTag = 1
    self:createTabButton()

end

function SignInScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer"):addTo(self)
	:onBack(function(layer)
		self:pop()
	end)

--------------------------------------------------------------------

	display.newSprite("Register_Total_Board.png")
	:addTo(self.layer_)
	:pos(95, 280)

	-- 累计签到数量
	self.labelTotal = base.Label.new({size=24})
	:addTo(self.layer_)
	:align(display.CENTER)
	:pos(95, 440)

	-- 列表 累计
	self.listViewTotal_ = base.GridView.new({
		rows = 1,
		viewRect = cc.rect(0, 0, 110, 390),
		itemSize = cc.size(110, 130),
	}):addTo(self.layer_)
	:pos(40, 30)
	:onTouch(function(event)
		if event.name == "clicked" then
			self:selectedTotalIndex(event.index)
		end
	end)

end

function SignInScene:createTabButton()

    local btn1 = CommonButton.sidebar_():addTo(self)
    local normal = display.newSprite(tabPressImage)
    local selected = display.newSprite(tabNormalImage)
    btn1:setNormalImage(normal)
    btn1:setSelectedImage(selected)
    self:addPoint("dailySign", 30, 80, btn1)
    table.insert(self.tabNodes, btn1)

    local btn2 = CommonButton.sidebar_():addTo(self)
    local normal = display.newSprite(tabPressImage_)
    local selected = display.newSprite(tabNormalImage_)
    btn2:setNormalImage(normal)
    btn2:setSelectedImage(selected)
    self:addPoint("vipSign", 30, 80, btn2)
    table.insert(self.tabNodes, btn2)

    -- 侧边 按钮
    self.btnGroup_ = base.ButtonGroup.new({
        zorder1 = 1,
        zorder2 = 5,
    })
    :addButtons(self.tabNodes)
    :selectedButtonAtIndex_(1)
    :walk(function(index, button)
        button:pos(display.cx+422, display.cy - math.pow(-1, index) * 100)
    end)
    :onEvent(function(event)
		self:showView(event.selected)
    end)

end

-- 更新显示提示点
function SignInScene:updateDot()
    self:showPoint("dailySign", not SignInData:isSigned()) -- 签到
	self:showPoint("vipSign", not SignInData:isVipSigned())
end

--显示提示点
function SignInScene:showPoint(key,visible)
    local point = self.points[key]
    if point then
        point:setVisible(visible)
    end
end

--添加提示点
function SignInScene:addPoint(key, x, y, target)
    local point = self.points[key]
    if not point then
        point = display.newSprite(pointImage):addTo(target or self):zorder(11)
        self.points[key] = point
    end
    point:pos(x, y)

end

-- 每日签到
function SignInScene:createSignDaily()
    local layer = SignInDailyLayer.new()
    layer:setTag(VIEW_ID.VIEW_SIGNEVERY)
    layer.delegate = self
    return layer
end

--至尊签到
function SignInScene:createSignVip()
    local layer = SignInVipLayer.new()
    layer:setTag(VIEW_ID.VIEW_SIGNVIP)
    layer.delegate = self
    return layer
end

function SignInScene:showView(tag)
    if self.viewTag ~= tag then
        self:hideViews()
        self.viewTag = tag
        self:updateView()
    end
end

function SignInScene:hideViews()
    if self.viewTag == 1 then
        self.signEveryView:setVisible(false)
    elseif self.viewTag == 2 then
        self.signVipView:setVisible(false)
    end
end

-- 选择累计签到
function SignInScene:selectedTotalIndex(index)
	print("选择累计签到", index)
	local isAchieve = self.totalSignIn >= self.totalData.totalNum
	if isAchieve then
		self:netToSignInTotal(self.totalData.id)
	end

	CommonSound.click() -- 音效
end

-- 可以签到的动画
function SignInScene:getSignAni()

	local param = {gaf = "quan_gaf"}
    local effectNode = GafNode.new(param)
    effectNode:playAction("1",true)
    effectNode:setGafPosition(0,-85)
    effectNode:setTouchEnabled(false)
    return effectNode
end

----------------------------------------------------

function SignInScene:updateData()

	-- 累计签到
	self.totalData = SignInData:getShowTotalInfo() -- 累计签到一条奖励数据
	self.totalSignIn = SignInData.totalSignIn -- 累计签到次数

end

function SignInScene:updateView()
	self:updateDot()
	self:updateTotalListView()
	self:updateTotalAchieve()

	if self.viewTag == VIEW_ID.VIEW_SIGNEVERY then
        if self.signEveryView then
            self.signEveryView:setVisible(true)
            self.signEveryView:updateData()
            self.signEveryView:updateView()
        else
            self.signEveryView = self:createSignDaily()
            self.signEveryView:updateData()
            self.signEveryView:updateView()
            self.layer_:addChild(self.signEveryView,2)
        end
    elseif self.viewTag == VIEW_ID.VIEW_SIGNVIP then
        if self.signVipView then
            self.signVipView:setVisible(true)
            self.signVipView:updateData()
            self.signVipView:updateView()
        else
            self.signVipView = self:createSignVip()
            self.signVipView:updateData()
            self.signVipView:updateView()
            self.layer_:addChild(self.signVipView,2)
        end
    end
end

function SignInScene:updateTotalListView()
	local items = self.totalData:getItemsArr()
	local isAchieve = self.totalSignIn >= self.totalData.totalNum
	self.listViewTotal_:removeAllItems()
	:addItems(table.nums(items), function(event)
		local index = event.index
		local data = items[index]

		local grid = UserData:createItemView(data.id)

		grid:addItem(base.Label.new({text=string.format("X%d", data.count), size=22}):pos(58, -58):align(display.RIGHT_BOTTOM))

		if isAchieve then
			if index==1 then
                if not self.effect1 then
                    self.effect1 = self:getSignAni()
                    self.effect1:addTo(self.layer_,3):pos(93,10+(index-1)*130)
                end
			elseif index==2 then
				 if not self.effect2 then
                    self.effect2 = self:getSignAni()
                    self.effect2:addTo(self.layer_,3):pos(93,10+(index-1)*130)
                end
			elseif index==3 then
				 if not self.effect3 then
                    self.effect3 = self:getSignAni()
                    self.effect3:addTo(self.layer_,3):pos(93,10+(index-1)*130)
                end
			end
        else
            if index == 1 then
                if self.effect1 then
                    self.effect1:removeFromParent()
                    self.effect1 = nil
                end
            elseif index == 2 then
                if self.effect2 then
                    self.effect2:removeFromParent()
                    self.effect2 = nil
                end
            elseif index == 3 then
                if self.effect3 then
                    self.effect3:removeFromParent()
                    self.effect3 = nil
                end
            end
		end

		return grid
	end)
	:reload()
end

--------------------------------------------
-- 向服务器申请 领取累计签到
function SignInScene:netToSignInTotal(signId)
	NetHandler.request("GetTotalSignReward", {
		data = {
			param1 = signId,
		},
		onsuccess = function(params)
			self:updateData()
			self:updateView()
			showToast({text="领取成功"})

			UserData:showReward(params.items)
		end
	}, self)
end
---------------------------------------------
-- 更新显示 累计签到次数
function SignInScene:updateTotalAchieve()
	local str = string.format("%d/%d", self.totalSignIn, self.totalData.totalNum)
	self.labelTotal:setString(str)
end

function SignInScene:onEnter()
	self:updateData()
	self:updateView()

	self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function SignInScene:netCallback(event)
    local data = event.data
    local order = event.order
    if order == OperationCode.EveryDaySignResponse then
    	self:updateData()
	    self:updateView()
    end
end

function SignInScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return SignInScene