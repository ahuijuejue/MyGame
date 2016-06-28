--[[
    宝藏系统 寻宝
]]
local CoinFindLayer = class("CoinFindLayer", function()
	return display.newNode()
end)

local scheduler = require("framework.scheduler")
local GafNode = import("app.ui.GafNode")

local tripBanner1 = "Coin_Find_Banner1.png"
local tripBanner2 = "Coin_Find_Banner2.png"
local buttonImg_normal1 = "Coin_Find_Normal1.png"
local buttonImg_pressed1 = "Coin_Find_Pressed1.png"
local buttonImg_normal2 = "Coin_Find_Normal2.png"
local buttonImg_pressed2 = "Coin_Find_Pressed2.png"
local getImg = "CoinGold.png"
local priceImg = "Diamond.png"
local recordImg = "CoinRecord.png"

local TRIP_ID = {
	TRIP_ONE = 1,
	TRIP_TEN = 2
}

function CoinFindLayer:ctor()
	self:initData()
	self:initView()
end

function CoinFindLayer:initData()
    self.items = {}
    self.nextFreeTrip = 0
    self.recordCount = CoinData:getRecordCount()
end

function CoinFindLayer:initView()
	self:createTripAnimation()
	self:createOneTrip()
	self:createTenTrip()

	-- 可能掉落物品
	self.listView_ = base.ListView.new({
		direction = "horizontal",
		viewRect = cc.rect(0, 0, 450, 120),
		itemSize = cc.size(110, 110),
	}):addTo(self, 20)
	:pos(150, 25)

end

function CoinFindLayer:createTripAnimation()
	self.effectNode = GafNode.new({gaf = "coin_wait"})
    self.effectNode:playAction("coin_wait",true)
    self.effectNode:setGafPosition(482, 286)
    self.effectNode:setTouchEnabled(false)
    self.effectNode:addTo(self, 3)
    self.effectNode:show()
end

-- 航行一次
function CoinFindLayer:createOneTrip()
	local posX = 692

	display.newSprite(tripBanner1):pos(posX+25, 394):addTo(self)

    self.freeTimeLabel = display.newTTFLabel({text = "祝你好运！", size = 24}):pos(posX+25, 478):addTo(self)

    -- 所得黄金碎片标签
    local tab = self:createPriceView(getImg,CoinData.coinValue,cc.c3b(255, 240, 70))
	tab:setPosition(posX+45, 356)
	self:addChild(tab)

    local btnCallBack = handler(self, self.buttonEvent)
	local image_ = {normal = buttonImg_normal1, pressed = buttonImg_pressed1, disabled = buttonImg_normal1}
	self.oneTrip = CommonButton.yellow3("航行一次", {image = image_, size = 24})
    :onButtonClicked(btnCallBack)
    :pos(posX+25, 312)
    :addTo(self,3)
    self.oneTrip:setTag(TRIP_ID.TRIP_ONE)

end

-- 价格标签
function CoinFindLayer:updatePriceTab()
	local posX = 692
	if self.onePrice then
		self.onePrice:removeFromParent()
		self.onePrice = nil
	end
	if self.nextFreeTrip <= 0 then
    	self.onePrice = display.newTTFLabel({text = "免费", size = 20}):pos(posX-10, 356):addTo(self)
    elseif self.recordCount > 0 then
    	self.onePrice = self:createPriceView(recordImg,self.recordCount,cc.c3b(255, 240, 70))
		self.onePrice:setPosition(posX-50, 356)
		self:addChild(self.onePrice)
    else
    	self.onePrice = self:createPriceView(priceImg,CoinData.coinPrice,cc.c3b(255, 240, 70))
		self.onePrice:setPosition(posX-50, 356)
		self:addChild(self.onePrice)
    end
end

-- 航行十次
function CoinFindLayer:createTenTrip()
	local posX = 692

	display.newSprite(tripBanner2):pos(posX+25, 154):addTo(self)


    -- 价格标签
	local tab = self:createPriceView(priceImg,CoinData.coinPriceEx,cc.c3b(255, 240, 70))
	tab:setPosition(posX-50, 116)
	self:addChild(tab)

    -- 所得黄金碎片标签
    local tab1 = self:createPriceView(getImg,CoinData.coinValueEx,cc.c3b(255, 240, 70))
	tab1:setPosition(posX+45, 116)
	self:addChild(tab1)

    local btnCallBack = handler(self, self.buttonEvent)
	local image_ = {normal = buttonImg_normal2, pressed = buttonImg_pressed2, disabled = buttonImg_normal2}
	self.tenTrip = CommonButton.yellow3("航行十次", {image = image_, size = 24, color = cc.c3b(255, 210, 255)})
    :onButtonClicked(btnCallBack)
    :pos(posX+25, 71)
    :addTo(self, 3)
    self.tenTrip:setTag(TRIP_ID.TRIP_TEN)

end

function CoinFindLayer:createPriceView(image,text,color)
	local cashIcon = display.newSprite(image)
	cashIcon:setAnchorPoint(0, 0.5)
	cashIcon:setScale(0.8)

	local tColor = color or cc.c3b(255, 240, 70)
	local priceLabel = display.newTTFLabel({text = text, size = 24})
	priceLabel:setPosition(40, 19)
	priceLabel:setAnchorPoint(0, 0.5)
	cashIcon:addChild(priceLabel)

	return cashIcon
end

--开启定时器
function CoinFindLayer:startRecTimer()
	if self.leftTimeHandle then
		return
	end
	local handler = handler(self,self.updateLeftTime)
	self.leftTimeHandle = scheduler.scheduleGlobal(handler,1)
end

--移除定时器
function CoinFindLayer:removeRecTimer()
	if self.leftTimeHandle then
		scheduler.unscheduleGlobal(self.leftTimeHandle)
		self.leftTimeHandle = nil
	end
	self:updatePriceTab()
end

--更新剩余时间显示
function CoinFindLayer:updateLeftTime()
	self.nextFreeTrip = self.nextFreeTrip - 1
	self:updateTimeLabel()
	if self.nextFreeTrip <= 0 then
		self:removeRecTimer()
	end
end

-- 更新顶部提示标签
function CoinFindLayer:updateTimeLabel()
	if self.nextFreeTrip > 0 then
		local timeText = string.format(GET_TEXT_DATA("SUMMON_TIME_FREE"),formatTime2(self.nextFreeTrip))
		self.freeTimeLabel:setString(timeText)
	else
		self.freeTimeLabel:setString("祝你好运！")
	end
end

function CoinFindLayer:buttonEvent(event)
	AudioManage.playSound("Click.mp3")
	local tag = event.target:getTag()
	if tag == TRIP_ID.TRIP_ONE then
		if self.nextFreeTrip <= 0 then     -- 免费航行
    		self:oneTripNet()
	    elseif self.recordCount > 0 then   -- 指针航行
	    	self:oneTripNet()
	    else                               -- 钻石航行
	    	if UserData.diamond >= CoinData.coinPrice then
				self:oneTripNet()
	    	else
	    		showToast({text = "钻石不足！"})
	    	end
	    end
	elseif tag == TRIP_ID.TRIP_TEN then
		if UserData.diamond >= CoinData.coinPriceEx then
    		self:stopCardAnimation(function()
    			NetHandler.gameRequest("Navigate", {param1 = 10})
    		end)
    	else
    		showToast({text = "钻石不足！"})
    	end
	end
end

function CoinFindLayer:oneTripNet()
	self:stopCardAnimation(function()
		NetHandler.gameRequest("Navigate", {param1 = 1})
	end)
end

-- 停止航行动画
function CoinFindLayer:stopCardAnimation(callback)
	showMask()
    callback()
    self.effectNode:removeFromParent()
    self.effectNode = nil
end

function CoinFindLayer:updateData()
	self.items = CoinData.items
	self.nextFreeTrip = CoinData.nextCoinTimeStamp - UserData.curServerTime
	self.recordCount = CoinData:getRecordCount()
end

function CoinFindLayer:updateView()
	self:updateTimeLabel()
	self:updatePriceTab()

	self.listView_
	:removeAllItems()
	:addItems(#self.items, function(event)
		local index = event.index
		local data = self.items[index]
		local item = UserData:createItemView(data, {
            scale = 0.75,
        })
		return item
	end)
	:reload()
end

return CoinFindLayer
