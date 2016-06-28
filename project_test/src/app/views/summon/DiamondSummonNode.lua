local DiamondSummonNode = class("DiamondSummonNode", function()
	return display.newNode()
end)

local BUTTON_ID = {
	BUTTON_SEE = 1,
	BUTTON_SUMMON = 2,
	BUTTON_CONTINUOUS_SUMMON = 3,
	BUTTON_BACK = 4,
}

local btnImage = "button_long_blue.png"
local DiamondBg = "DiamondBg.png"
local DiamondBg_ = "DiamondBg_.png"
local Diamond_Tip = "Diamond_Tip.png"
local Diamond_Banner = "Diamond_Banner.png"
local Diamond_BannerLight = "Diamond_BannerLight.png"
local Diamond_Banner1 = "Diamond_Banner1.png"
local arrowImageName = "Diamond_Back.png"
local iconImageName = "Summon_Diamond.png"
local scoreImage = "CardScore.png"

local scheduler = require("framework.scheduler")
local RoleLayer = import("..main.RoleLayer")
local GafNode = import("app.ui.GafNode")

function DiamondSummonNode:ctor()
	self:createSummonIntView()
	self:createSummonView()
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

--创建抽卡介绍界面
function DiamondSummonNode:createSummonIntView()
	local btnEvent = handler(self,self.buttonEvent)
    self.bgSprite = cc.ui.UIPushButton.new({normal = DiamondBg, pressed = DiamondBg})
    :onButtonClicked(btnEvent)
    self.bgSprite:setAnchorPoint(0.5,0.5)
    self.bgSprite:setTag(BUTTON_ID.BUTTON_SEE)
    self:addChild(self.bgSprite)

	local tipSprite = display.newSprite(Diamond_Tip)
	tipSprite:setPosition(-90,32)
	self.bgSprite:addChild(tipSprite)

    self:createFreeView()
end

--创建抽卡界面
function DiamondSummonNode:createSummonView()
	self.summonSprite = display.newSprite(DiamondBg_)  -- 背景
	self.summonSprite:setAnchorPoint(0.5,0.5)
	self.summonSprite:setVisible(false)
	self:addChild(self.summonSprite)

    local btnEvent = handler(self,self.buttonEvent)
	self.backBtn = cc.ui.UIPushButton.new({normal = arrowImageName, pressed = arrowImageName})
    :onButtonClicked(btnEvent)
    self.backBtn:setPosition(253,470)
    self.backBtn:setTag(BUTTON_ID.BUTTON_BACK)
    self.summonSprite:addChild(self.backBtn)

    --单抽按钮
    self.summonBtn = cc.ui.UIPushButton.new({normal = Diamond_Banner, pressed = Diamond_BannerLight})
    :onButtonClicked(btnEvent)
    self.summonBtn:setPosition(155,280)
    self.summonBtn:setTag(BUTTON_ID.BUTTON_SUMMON)
    self.summonSprite:addChild(self.summonBtn)

    local onceLabel = createOutlineLabel({text = GET_TEXT_DATA("SUMMON_ONCE"),color = cc.c3b(200, 243, 255),size = 30})
    self.summonBtn:addChild(onceLabel)

    local param = {text = "",color =cc.c3b(200, 243, 255), size = 26}
    self.intLabel = createOutlineLabel(param)
    self.intLabel:setPosition(152,400)
    self.summonSprite:addChild(self.intLabel)

    local tab2 = self:createPriceView(scoreImage,"+"..SummonData.diamondScore)
    tab2:setPosition(160,360)
    self.summonSprite:addChild(tab2)

    --连抽按钮
	self.summonsBtn = cc.ui.UIPushButton.new({normal = Diamond_Banner, pressed = Diamond_BannerLight})
    :onButtonClicked(btnEvent)
    self.summonsBtn:setPosition(150,55)
    self.summonsBtn:setTag(BUTTON_ID.BUTTON_CONTINUOUS_SUMMON)
    self.summonSprite:addChild(self.summonsBtn)

    local manyLabel = createOutlineLabel({text = GET_TEXT_DATA("SUMMON_MANY"),color = cc.c3b(200, 243, 255),size = 30})
    self.summonsBtn:addChild(manyLabel)

    --价格标签
    local tab3 = createOutlineLabel({text = SummonData.diamondPriceEx,color = display.COLOR_WHITE,size = 26})
	tab3:setPosition(110,105)
	self.summonSprite:addChild(tab3)

	local tab4 = self:createPriceView(scoreImage,"+"..SummonData.diamondScoreEx)
	tab4:setPosition(160,106)
	self.summonSprite:addChild(tab4)

	param = {text = "购买10次必得",color = cc.c3b(200, 243, 255), size = 26}
    local intLabel = createOutlineLabel(param)
    intLabel:setPosition(150,203)
    self.summonSprite:addChild(intLabel)
end

--创建免费次数标签
function DiamondSummonNode:createFreeView()
	local freeBg = display.newSprite(Diamond_Banner1)
	freeBg:setPosition(-2,-138)
	self.bgSprite:addChild(freeBg)

	local param = {text = "",size = 24}
	self.timesLabel = createOutlineLabel(param)
	self.timesLabel:setPosition(230,24)
	self.timesLabel:setAnchorPoint(1,0.5)
	freeBg:addChild(self.timesLabel)

    local priceBg_ = display.newSprite(Diamond_Banner)
	priceBg_:setPosition(3,-205)
	self.bgSprite:addChild(priceBg_)

	local priceBg = self:createPriceView(iconImageName,tostring(SummonData.diamondPrice), cc.c3b(200, 243, 255))
	priceBg:setPosition(45,30)
	priceBg_:addChild(priceBg)

end

--更新价格标签
function DiamondSummonNode:updatePriceView()
	self.intLabel:setString(string.format(GET_TEXT_DATA("SUMMON_DIAMOND_BONUS"),SummonData.diamondBonus))
	if self.priceTab then
		self.priceTab:removeFromParent(true)
		self.priceTab = nil
	end
	local text = SummonData.diamondPrice
	if self.diamondLeftTime <= 0 then
		text = "免费"
	end
	self.priceTab = createOutlineLabel({text = text,color = display.COLOR_WHITE,size = 26})
	self.priceTab:setPosition(115,360)
	self.summonSprite:addChild(self.priceTab)
end

function DiamondSummonNode:createPriceView(image,text,color)
	local cashIcon = display.newSprite(image)
	cashIcon:setAnchorPoint(0,0.5)
	cashIcon:setScale(0.9)

	local tColor = color or display.COLOR_WHITE
	local priceLabel = createOutlineLabel({text = text,color = tColor,size = 30})
	priceLabel:setPosition(50,19)
	priceLabel:setAnchorPoint(0,0.5)
	cashIcon:addChild(priceLabel)

	return cashIcon
end

--界面 过渡动画
--1为从介绍界面进入抽卡界面 -1为返回介绍界面
function DiamondSummonNode:playEnterAnimation(dir)
	local callback = function ()
		if not GuideData:isCompleted("Card") then
			self:updatePriceView()
			local rect = {x = display.cx+80, y = display.cy - 30, width = 160 ,height = 60}
			local posX = rect.x + rect.width + 130
		    local posY = rect.y + rect.height/2 + 20
    		local text = GameConfig.tutor_talk["8"].talk
			local param = {rect = rect, text = text,x = posX-450,y=posY+110, callback = function (tutor)
				SummonData.summonType = SUMMON_TYPE.DIAMOND_SUMMON
				SummonData:updateResultData({{param1 = GameConfig.Global["1"].DC1stHeroID,param4 = 6}})
				UserData:addCardValue(SummonData.diamondScore)
		        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})

		        tutor:removeFromParent()
		        tutor = nil

		        self.delegate:showCardAnimation(function (name)
		        	app:pushToScene("SummonResultScene")
		        end)
	        end}
	        showTutorial(param)
	    elseif not GuideData:isCompleted("FirstCard") then
	    	if dir == 1 then
	    		self.tipSprite:setVisible(true)
		    	self.tipSprite:setPosition(23,95)
		    else
		    	if self.tipSprite then
		    		self.tipSprite:setVisible(true)
		    		self.tipSprite:setPosition(58,-64)
		    	end
	    	end
	    end
	end

	if dir == 1 then
		self.bgSprite:hide()
		self.summonSprite:show()
		self.summonSprite:setScaleX(-1)
		transition.scaleTo(self.summonSprite, {scale = 1, time = 0.3,onComplete = callback})

	elseif dir == -1 then
		self.summonSprite:hide()
		self.bgSprite:show()

		self.bgSprite:setScaleX(-1)
		transition.scaleTo(self.bgSprite, {scale = 1, time = 0.3,onComplete = callback})
	end

end

function DiamondSummonNode:updateTimeLabel()
	if self.diamondLeftTime > 0 then
		local timeText = string.format(GET_TEXT_DATA("SUMMON_TIME_FREE"),formatTime2(self.diamondLeftTime))
		self.timesLabel:setString(timeText)
	else
		local text = GET_TEXT_DATA("SUMMON_FREE")
		self.timesLabel:setString(text)
	end
end

--更新剩余时间显示
function DiamondSummonNode:updateLeftTime()
	self.diamondLeftTime = self.diamondLeftTime - 1
	self:updateTimeLabel()
	if self.diamondLeftTime <= 0 then
		self:removeRecTimer()
	end
end

function DiamondSummonNode:createFirstTip()
	if self.tipSprite then
		return
	end
	self.tipSprite = display.newSprite("OperateBanner2.png")
	self.tipSprite:setPosition(58,-64)
	self.tipSprite:setScale(0.7)
	self:addChild(self.tipSprite,2)

	local tipLabel = createOutlineLabel({text = GameConfig.tutor_talk["83"].talk, size = 26})
    tipLabel:setPosition(110,90)
    self.tipSprite:addChild(tipLabel)
end

function DiamondSummonNode:removeFirstTip()
	if self.tipSprite then
		self.tipSprite:removeFromParent(true)
		self.tipSprite = nil
	end
end

--开启定时器
function DiamondSummonNode:startRecTimer()
	if self.leftTimeHandle then
		return
	end
	local handler = handler(self,self.updateLeftTime)
	self.leftTimeHandle = scheduler.scheduleGlobal(handler,1)
end

--移除定时器
function DiamondSummonNode:removeRecTimer()
	if self.leftTimeHandle then
		scheduler.unscheduleGlobal(self.leftTimeHandle)
		self.leftTimeHandle = nil
	end
end

--按钮事件
function DiamondSummonNode:buttonEvent(event)
	local tag = event.target:getTag()
	if tag == BUTTON_ID.BUTTON_SEE then
		AudioManage.playSound("Click.mp3")
		self:updatePriceView()
		self:playEnterAnimation(1)
		if self.tipSprite then
			self.tipSprite:setVisible(false)
		end
    elseif tag == BUTTON_ID.BUTTON_SEE + 1 then
    	AudioManage.playSound("Click_Coin.mp3")
    	if self.diamondLeftTime <= 0 then
		    NetHandler.gameRequest("OneDiamondChouka")
		else
			if UserData.diamond < SummonData.diamondPrice then
				local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
	    		showToast(param)
	    		return
			end
		    NetHandler.gameRequest("OneDiamondChouka")
    	end
    elseif tag == BUTTON_ID.BUTTON_SEE + 2 then
    	AudioManage.playSound("Click_Coin.mp3")
    	if UserData.diamond < SummonData.diamondPriceEx then
	        local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
    		showToast(param)
	        return
		end
	    NetHandler.gameRequest("TenDiamondChouka")
    elseif tag == BUTTON_ID.BUTTON_SEE + 3 then
    	AudioManage.playSound("Click.mp3")
    	self:playEnterAnimation(-1)
    	if self.tipSprite then
    		self.tipSprite:setVisible(false)
    	end
    end
end

function DiamondSummonNode:onEnter()
	self.diamondLeftTime = SummonData.nextDiamondStamp - UserData.curServerTime
	self:updateTimeLabel()
	self:startRecTimer()
	if self.summonSprite then
		self:updatePriceView()
	end
end

function DiamondSummonNode:onExit()
	self:removeRecTimer()
end

return DiamondSummonNode
