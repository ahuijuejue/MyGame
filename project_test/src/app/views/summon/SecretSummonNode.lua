local SecretSummonNode = class("SecretSummonNode", function()
	return display.newNode()
end)

local BUTTON_ID = {
	BUTTON_SEE = 1,
	BUTTON_SUMMON = 2,
	BUTTON_BACK = 3,
}

local SecretBg_ = "SecretBg_.png"
local SecretBg = "SecretBg.png"
local SecretBack = "SecretBack.png"
local Secret_Banner = "Secret_Banner.png"
local Secret_BannerLight = "Secret_BannerLight.png"
local arrowImageName = "Secret_Back.png"
local Secret_VIP = "Secret_VIP.png"
local iconImageName = "Summon_Diamond.png"
local btnImage = "button_long_yellow.png"
local scoreImage = "CardScore.png"

local scheduler = require("framework.scheduler")
local RoleLayer = import("..main.RoleLayer")

function SecretSummonNode:ctor()
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
function SecretSummonNode:createSummonIntView()
	local btnEvent = handler(self,self.buttonEvent)
    self.bgSprite = cc.ui.UIPushButton.new({normal = SecretBg_,pressed = SecretBg})
    :onButtonClicked(btnEvent)
    self.bgSprite:setAnchorPoint(0.5,0.5)
    self.bgSprite:setTag(BUTTON_ID.BUTTON_SEE)
    self:addChild(self.bgSprite)

    self:createFreeView()
end

--创建金币抽卡界面
function SecretSummonNode:createSummonView()
	self.summonSprite = display.newSprite(SecretBack)
	self.summonSprite:setAnchorPoint(0.5,0.5)
	self:addChild(self.summonSprite)

	local btnEvent = handler(self,self.buttonEvent)
	self.backBtn = cc.ui.UIPushButton.new({normal = arrowImageName, pressed = arrowImageName})
    :onButtonClicked(btnEvent)
    self.backBtn:setPosition(253,470)
    self.backBtn:setTag(BUTTON_ID.BUTTON_BACK)
    self.summonSprite:addChild(self.backBtn)

    self.mainPot = base.Grid.new()
    self.mainPot:pos(150,343)
    self.mainPot:addTo(self.summonSprite)

    self.otherPot = base.Grid.new()
    self.otherPot:pos(60,170)
    self.otherPot:addTo(self.summonSprite)

    --购买按钮
	self.summonsBtn = cc.ui.UIPushButton.new({normal = Secret_Banner, pressed = Secret_BannerLight})
    :onButtonClicked(btnEvent)
    self.summonsBtn:setPosition(150,53)
    self.summonsBtn:setTag(BUTTON_ID.BUTTON_SUMMON)
    self.summonSprite:addChild(self.summonsBtn)

    local manyLabel = createOutlineLabel({text = GET_TEXT_DATA("SUMMON_ONCE"),color = cc.c3b(255, 203, 194),size = 30})
    self.summonsBtn:addChild(manyLabel)

    --价格标签
	local tab3 = createOutlineLabel({text = SummonData.secretPrice,color = display.COLOR_WHITE,size = 26})
	tab3:setPosition(100,98)
	self.summonSprite:addChild(tab3)

	local tab4 = self:createPriceView(scoreImage,"+"..SummonData.secretScore)
	tab4:setPosition(155,101)
	self.summonSprite:addChild(tab4)

end

--更新主要热点，次要热点
function SecretSummonNode:updatePotView()

    self.mainPot:removeItems()  -- 主要热点
    :addItem(UserData:createHeroView(SummonData.mainHeroId, {scale = 0.9,border = 8}):pos(0,0))

    self.otherPot:removeItems()  -- 次要热点

	local addX = 0
    local otherHeroNum = 0
    local otherHero = {}
    for i,v in pairs(SummonData.otherHeroId) do
    	otherHeroNum = otherHeroNum+1
    end
	if otherHeroNum == 3 then
		for i=1,3 do
			addX = (i-1) * 70
			local item = UserData:createItemView(SummonData.otherHeroId[string.format("param%d",i)], {
	            scale = 0.5,
	        })
		    self.otherPot:addItem(item:pos(addX, -8))
		end
	elseif otherHeroNum > 3 then
		local num_ = self:rand(otherHeroNum,otherHeroNum)
		for i=1,3 do
	        addX = (i-1) * 70
			local item = UserData:createItemView(SummonData.otherHeroId[string.format("param%d",num_[i])], {
	            scale = 0.5,
	        })
		    self.otherPot:addItem(item:pos(addX, -8))
	    end
	end
    self.otherPot:addItem(createOutlineLabel({text = "..."}):pos(190, -26))
end

-- 随机不重复选取
function SecretSummonNode:rand(tabNum,indexNum)
    indexNum = indexNum or tabNum
    local t = {}
    local rt = {}

    for i = 1,indexNum do
    	newrandomseed()
        local ri = math.random(1,tabNum + 1 - i)
        local v = ri
        for j = 1,tabNum do
            if not t[j] then
                ri = ri - 1
                if ri == 0 then
                    table.insert(rt,j)
                    t[j] = true
                end
            end
        end
    end
    return rt
end

--创建价格标签
function SecretSummonNode:createFreeView()
	local priceBg_ = display.newSprite(Secret_Banner)
	priceBg_:setPosition(3,-205)
	self.bgSprite:addChild(priceBg_)

	self.priceBg = self:createPriceView(Secret_VIP,"9级开启",cc.c3b(255,240,70),cc.p(65,19))
	self.priceBg:setPosition(-80,-207)
	self.bgSprite:addChild(self.priceBg,3)

end

function SecretSummonNode:createPriceView(image,text,color,pos)
	local cashIcon = display.newSprite(image)
	cashIcon:setAnchorPoint(0,0.5)
	cashIcon:setScale(0.9)

	local tColor = color or display.COLOR_WHITE
	local pos = pos or cc.p(50,19)
	local priceLabel = createOutlineLabel({text = text,color = tColor,size = 30})
	priceLabel:setPosition(pos)
	priceLabel:setAnchorPoint(0,0.5)
	cashIcon:addChild(priceLabel)

	return cashIcon
end

--抽卡动画
function SecretSummonNode:summonAnimation()
	showMask()
    app:pushToScene("SummonResultScene")
    hideMask()
end

--界面 过渡动画
--1为从介绍界面进入抽卡界面 -1为返回介绍界面
function SecretSummonNode:playEnterAnimation(dir)
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

end

--按钮事件
function SecretSummonNode:buttonEvent(event)
	local tag = event.target:getTag()
	if tag == BUTTON_ID.BUTTON_SEE then
		AudioManage.playSound("Click.mp3")
		self:createSummonView()
		self:updatePotView()
		self:playEnterAnimation(1)
    elseif tag == BUTTON_ID.BUTTON_SEE + 1 then
    	AudioManage.playSound("Click_Coin.mp3")
		if UserData.diamond < SummonData.secretPrice then
			local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
    		showToast(param)
    	else
		    NetHandler.gameRequest("SecretChouka")
		end
    elseif tag == BUTTON_ID.BUTTON_SEE + 2 then
    	AudioManage.playSound("Click.mp3")
    	self:playEnterAnimation(-1)
    end
end

function SecretSummonNode:updateView()
	if VipData:isVipCardOpen() then
		self.bgSprite:setTouchEnabled(true)
		self.bgSprite:setButtonImage("normal",SecretBg)

		if self.priceBg then
			self.priceBg:removeFromParent()
		end
		self.priceBg = self:createPriceView(iconImageName,tostring(SummonData.secretPrice))
		self.priceBg:setPosition(-65,-201)
		self.bgSprite:addChild(self.priceBg,3)

	else
		self.bgSprite:setTouchEnabled(false)
	end
end

function SecretSummonNode:onEnter()
	self:updateView()
	if self.summonSprite then
		self:updatePotView()
	end
end

function SecretSummonNode:onExit()
end

return SecretSummonNode