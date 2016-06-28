local CashSummonNode = class("CashSummonNode", function()
	return display.newNode()
end)

local BUTTON_ID = {
	BUTTON_SEE = 1,
	BUTTON_SUMMON = 2,
	BUTTON_CONTINUOUS_SUMMON = 3,
	BUTTON_BACK = 4,
}

local CashBg = "CashBg.png"
local CashBg_ = "CashBg_.png"
local Cash_Tip = "Cash_Tip.png"
local Cash_Banner = "Cash_Banner.png"
local Cash_BannerLight = "Cash_BannerLight.png"
local Cash_Banner1 = "Cash_Banner1.png"
local arrowImageName = "Cash_Back.png"
local iconImageName = "Gold.png"
local scoreImage = "CardScore.png"
local btnImage = "button_long_yellow.png"

local scheduler = require("framework.scheduler")
local RoleLayer = import("..main.RoleLayer")

function CashSummonNode:ctor()
	self:createSummonIntView()
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

--创建金币抽卡介绍界面
function CashSummonNode:createSummonIntView()
	local btnEvent = handler(self,self.buttonEvent)
    self.bgSprite = cc.ui.UIPushButton.new({normal = CashBg, pressed = CashBg})
    :onButtonClicked(btnEvent)
    self.bgSprite:setAnchorPoint(0.5,0.5)
    self.bgSprite:setTag(BUTTON_ID.BUTTON_SEE)
    self:addChild(self.bgSprite)

	local tipSprite = display.newSprite(Cash_Tip)
	tipSprite:setPosition(-108,32)
	self.bgSprite:addChild(tipSprite)

    self:createFreeView()
end

--创建金币抽卡界面
function CashSummonNode:createSummonView()
	self.summonSprite = display.newSprite(CashBg_)  --背景
	self.summonSprite:setAnchorPoint(0.5,0.5)
	self:addChild(self.summonSprite)

	local btnEvent = handler(self,self.buttonEvent)
	self.backBtn = cc.ui.UIPushButton.new({normal = arrowImageName, pressed = arrowImageName})
    :onButtonClicked(btnEvent)
    self.backBtn:setPosition(255,470)
    self.backBtn:setTag(BUTTON_ID.BUTTON_BACK)
    self.summonSprite:addChild(self.backBtn)

    --单抽按钮
    self.summonBtn = cc.ui.UIPushButton.new({normal = Cash_Banner, pressed = Cash_BannerLight})
    :onButtonClicked(btnEvent)
    self.summonBtn:setPosition(155,280)
    self.summonBtn:setTag(BUTTON_ID.BUTTON_SUMMON)
    self.summonSprite:addChild(self.summonBtn)

    local onceLabel = createOutlineLabel({text = GET_TEXT_DATA("SUMMON_ONCE"),color = cc.c3b(255, 206, 85),size = 30})
    self.summonBtn:addChild(onceLabel)

    local param = {text = "",color = cc.c3b(255, 206, 85), size = 26}
    self.intLabel = createOutlineLabel(param)
    self.intLabel:setPosition(152,400)
    self.summonSprite:addChild(self.intLabel)

    local tab2 = self:createPriceView(scoreImage,"+"..SummonData.cashScore,cc.c3b(255,240,70))
    tab2:setPosition(170,358)
    self.summonSprite:addChild(tab2)

    --连抽按钮
	self.summonsBtn = cc.ui.UIPushButton.new({normal = Cash_Banner, pressed = Cash_BannerLight})
    :onButtonClicked(btnEvent)
    self.summonsBtn:setPosition(150,54)
    self.summonsBtn:setTag(BUTTON_ID.BUTTON_CONTINUOUS_SUMMON)
    self.summonSprite:addChild(self.summonsBtn)

    local manyLabel = createOutlineLabel({text = GET_TEXT_DATA("SUMMON_MANY"),color = cc.c3b(255, 206, 85),size = 30})
    self.summonsBtn:addChild(manyLabel)

    param = {text = "购买10次必得",color = cc.c3b(255, 206, 85), size = 26}
    local intLabel = createOutlineLabel(param)
    intLabel:setPosition(150,200)
    self.summonSprite:addChild(intLabel)

	local tab3 = createOutlineLabel({text = SummonData.cashPriceEx,color = cc.c3b(255,240,70),size = 26})
	tab3:setPosition(110,103)
	self.summonSprite:addChild(tab3)

	local tab4 = self:createPriceView(scoreImage,"+"..SummonData.cashScoreEx,cc.c3b(255,240,70))
	tab4:setPosition(170,104)
	self.summonSprite:addChild(tab4)

end

--更新价格标签
function CashSummonNode:updatePriceView()
	self.intLabel:setString(string.format(GET_TEXT_DATA("SUMMON_CASH_BONUS"),SummonData.cashBonus))
	if self.priceTab then
		self.priceTab:removeFromParent(true)
		self.priceTab = nil
	end
	local text = SummonData.cashPrice
	if SummonData.freeCashTimes > 0 then
		if self.cashLeftTime <= 0 then
			text = "免费"
		end
	end
	self.priceTab = createOutlineLabel({text = text,color = cc.c3b(255,240,70),size = 26})
	self.priceTab:setPosition(115,357)
	self.summonSprite:addChild(self.priceTab)
end

--创建免费次数标签
function CashSummonNode:createFreeView()
	local freeBg = display.newSprite(Cash_Banner1)
	freeBg:setPosition(-2,-138)
	self.bgSprite:addChild(freeBg)

	local param = {text = "",size = 24}
	self.timesLabel = createOutlineLabel(param)
	self.timesLabel:setPosition(230,24)
	self.timesLabel:setAnchorPoint(1,0.5)
	freeBg:addChild(self.timesLabel)

	local priceBg_ = display.newSprite(Cash_Banner)
	priceBg_:setPosition(3,-205)
	self.bgSprite:addChild(priceBg_)

	local priceBg = self:createPriceView(iconImageName,tostring(SummonData.cashPrice),cc.c3b(255, 206, 85))
	priceBg:setPosition(40,27)
	priceBg_:addChild(priceBg)

end

function CashSummonNode:createPriceView(image,text,color)
	local cashIcon = display.newSprite(image)
	cashIcon:setAnchorPoint(0,0.5)
	cashIcon:setScale(0.9)

	local tColor = color or cc.c3b(255,240,70)
	local priceLabel = createOutlineLabel({text = text,color = tColor,size = 30})
	priceLabel:setPosition(45,19)
	priceLabel:setAnchorPoint(0,0.5)
	cashIcon:addChild(priceLabel)

	return cashIcon
end

function CashSummonNode:updateTimeLabel()
	if SummonData.freeCashTimes > 0 then
		if self.cashLeftTime > 0 then
			local timeText = string.format(GET_TEXT_DATA("SUMMON_TIME_FREE"),formatTime1(self.cashLeftTime))
			self.timesLabel:setString(timeText)
		else
			local text = GET_TEXT_DATA("SUMMON_FREE")..string.format("(%d/%d)",SummonData.freeCashTimes,SummonData.cashLimit)
			self.timesLabel:setString(text)
		end
	else
		self.timesLabel:setVisible(false)
	end
end

--更新剩余时间显示
function CashSummonNode:updateLeftTime()
	self.cashLeftTime = self.cashLeftTime - 1
	self:updateTimeLabel()
	if SummonData.freeCashTimes <= 0 or self.cashLeftTime <= 0 then
		self:removeRecTimer()
	end
end

--抽卡动画
function CashSummonNode:summonAnimation()
	showMask()
    app:pushToScene("SummonResultScene")
    hideMask()
end

--界面 过渡动画
--1为从介绍界面进入抽卡界面 -1为返回介绍界面
function CashSummonNode:playEnterAnimation(dir)
	if dir == 1 then
		self.bgSprite:hide()
		self.summonSprite:show()
		self.summonSprite:setScaleX(-1)
		transition.scaleTo(self.summonSprite, {scale = 1, time = 0.3})

	elseif dir == -1 then
		self.summonSprite:hide()
		self.bgSprite:show()

		self.bgSprite:setScaleX(-1)
		transition.scaleTo(self.bgSprite, {scale = 1, time = 0.3})
	end

	-- showMask()
	-- 	hideMask()
end

--开启定时器
function CashSummonNode:startRecTimer()
	if self.leftTimeHandle then
		return
	end
	local handler = handler(self,self.updateLeftTime)
	self.leftTimeHandle = scheduler.scheduleGlobal(handler,1)
end

--移除定时器
function CashSummonNode:removeRecTimer()
	if self.leftTimeHandle then
		scheduler.unscheduleGlobal(self.leftTimeHandle)
		self.leftTimeHandle = nil
	end
end

--按钮事件
function CashSummonNode:buttonEvent(event)
	local tag = event.target:getTag()
	if tag == BUTTON_ID.BUTTON_SEE then
		AudioManage.playSound("Click.mp3")
		self:createSummonView()
		self:updatePriceView()
		if not self.summonSprite then
			self:createSummonView()
		end
		self:playEnterAnimation(1)
    elseif tag == BUTTON_ID.BUTTON_SEE + 1 then
    	AudioManage.playSound("Click_Coin.mp3")
    	if SummonData.freeCashTimes > 0 and self.cashLeftTime <= 0 then
		    NetHandler.gameRequest("OneGoldChouka")
		else
			if UserData.gold < SummonData.cashPrice then
				local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
	    		showToast(param)
	    		return
			end
		    NetHandler.gameRequest("OneGoldChouka")
    	end
    elseif tag == BUTTON_ID.BUTTON_SEE + 2 then
    	AudioManage.playSound("Click_Coin.mp3")
    	if UserData.gold < SummonData.cashPriceEx then
    		local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
    		showToast(param)
	        return
		end
	    NetHandler.gameRequest("TenGoldChouka")
    elseif tag == BUTTON_ID.BUTTON_SEE + 3 then
    	AudioManage.playSound("Click.mp3")
    	self:playEnterAnimation(-1)
    end
end

function CashSummonNode:onEnter()
	self.cashLeftTime = SummonData.nextCashTimeStamp - UserData.curServerTime
	self:updateTimeLabel()
	self:startRecTimer()
	if self.summonSprite then
		self:updatePriceView()
	end
end

function CashSummonNode:onExit()
	self:removeRecTimer()
end

return CashSummonNode