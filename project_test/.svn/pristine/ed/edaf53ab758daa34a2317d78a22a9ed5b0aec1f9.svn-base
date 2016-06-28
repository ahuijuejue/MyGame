local SummonResultLayer = class("SummonResultLayer",function()
    return display.newLayer()
end)

local BUTTON_ID = {
	BUTTON_SUMMON = 1,
	BUTTON_BACK = 2,
}

local SummonItemNode = import(".SummonItemNode")
local NodeBox = import("app.ui.NodeBox")

local buttonImage1 = "Award_Button.png"
local buttonImage2 = "Award_Button_Light.png"
local cashImageName = "Gold.png"
local diamondImageName = "Diamond.png"

function SummonResultLayer:ctor()
    self.showIndex = 0
	self:createBtns()

	self.resultView = self:createResultView()
	self:addChild(self.resultView)

    self:updateResultView()

	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function SummonResultLayer:createBtns()
    local btnEvent = handler(self,self.buttonEvent)
    self.summonBtn = cc.ui.UIPushButton.new({normal = buttonImage1, pressed = buttonImage2})
    :onButtonClicked(btnEvent)
    self.summonBtn:setTag(BUTTON_ID.BUTTON_SUMMON)

    local imageName = nil
    local priceText = nil
    local againText = nil
    if SummonData.summonType == SUMMON_TYPE.CASH_SUMMON then
    	imageName = cashImageName
    	priceText = tostring(SummonData.cashPrice)
    	againText = GET_TEXT_DATA("SUMMON_AGAIN")
    elseif SummonData.summonType == SUMMON_TYPE.CASH_SUMMON_TEN then
    	imageName = cashImageName
    	priceText = tostring(SummonData.cashPriceEx)
    	againText = GET_TEXT_DATA("SUMMON_AGAIN_TEN")
    elseif SummonData.summonType == SUMMON_TYPE.DIAMOND_SUMMON then
    	imageName = diamondImageName
    	priceText = tostring(SummonData.diamondPrice)
    	againText = GET_TEXT_DATA("SUMMON_AGAIN")
   	elseif SummonData.summonType == SUMMON_TYPE.DIAMOND_SUMMON_TEN then
   		imageName = diamondImageName
   		priceText = tostring(SummonData.diamondPriceEx)
    	againText = GET_TEXT_DATA("SUMMON_AGAIN_TEN")
    elseif SummonData.summonType == SUMMON_TYPE.SECRET_SUMMOM then
        imageName = diamondImageName
        priceText = tostring(SummonData.secretPrice)
        againText = GET_TEXT_DATA("SUMMON_AGAIN")
    end

    local cashIcon = display.newSprite(imageName)
	cashIcon:setPosition(-35,55)
	self.summonBtn:addChild(cashIcon)

	local priceLabel = createOutlineLabel({text = priceText})
	priceLabel:setPosition(40,19)
	priceLabel:setAnchorPoint(0,0.5)
	cashIcon:addChild(priceLabel)

	local againLabel = createOutlineLabel({text = againText})
	self.summonBtn:addChild(againLabel)

	--返回按钮
    local backBtn = cc.ui.UIPushButton.new({normal = buttonImage1, pressed = buttonImage2})
    :onButtonClicked(btnEvent)
    backBtn:setTag(BUTTON_ID.BUTTON_BACK)

    local backLabel = createOutlineLabel({text = GET_TEXT_DATA("BACK")})
	backBtn:addChild(backLabel)

    self.nodeBoxBtn = NodeBox.new()
    self.nodeBoxBtn:setUnit(2)
    self.nodeBoxBtn:setCellSize(backBtn.sprite_[1]:getContentSize())
    self.nodeBoxBtn:setSpace(200,0)
    self.nodeBoxBtn:setPosition(display.cx,50)
    self.nodeBoxBtn:setVisible(false)
    self:addChild(self.nodeBoxBtn)
    self.nodeBoxBtn:addElement({self.summonBtn,backBtn})
end

function SummonResultLayer:createShowReward()
    if self.showIndex > 0 then
        return
    end

    local len = #SummonData.summonResult
    function showResult()
        if self.showIndex >= len then
            self.showIndex = 0
            self.nodeBoxBtn:setVisible(true)
            return
        end
        self.showIndex = self.showIndex + 1
        self.resultNodes[self.showIndex]:itemShowAnimation(showResult)
    end
    showResult()
end

function SummonResultLayer:createResultView()
	local resultNode = NodeBox.new()
	resultNode:setCellSize(cc.size(132,132))
	resultNode:setSpace(20,40)
	resultNode:setPosition(display.cx,display.cy+20)

	local len = #SummonData.summonResult
	if len > 1 then
        if len == 6 or len == 7 then
            resultNode:setUnit(33)
        else
            resultNode:setUnit(5)
        end
	else
		resultNode:setUnit(1)
	end
	return resultNode
end

function SummonResultLayer:showResult()
    if #SummonData.summonResult == 1 then
        self.resultNodes[1]:itemShowAnimation(function ()
            self.nodeBoxBtn:setVisible(true)
        end)
    else
        self:createShowReward()
    end
end

function SummonResultLayer:updateResultView()
    self.resultNodes = {}
    self.resultView:cleanElement()
	local len = #SummonData.summonResult
    for i=1,len do
        local item = SummonData.summonResult[i]
        local heroId = SummonData.heroId[i]
        local node = SummonItemNode.new(item,heroId,SummonData.summonType)
        table.insert(self.resultNodes,node)
    end
    self.resultView:addElement(self.resultNodes)
end

function SummonResultLayer:buttonEvent(event)
	local tag = event.target:getTag()

	if tag == BUTTON_ID.BUTTON_SUMMON then
		if SummonData.summonType == SUMMON_TYPE.CASH_SUMMON then
            AudioManage.playSound("Click_Coin.mp3")
            if UserData.gold < SummonData.cashPrice then
                local param = {text = "资金不足",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
            self.summonBtn:setButtonEnabled(false)
            NetHandler.gameRequest("OneGoldChouka")
	    elseif SummonData.summonType == SUMMON_TYPE.CASH_SUMMON_TEN then
            AudioManage.playSound("Click_Coin.mp3")
            if UserData.gold < SummonData.cashPriceEx then
                local param = {text = "资金不足",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
            NetHandler.gameRequest("TenGoldChouka")
            showMask()
        elseif SummonData.summonType == SUMMON_TYPE.DIAMOND_SUMMON then
            AudioManage.playSound("Click_Coin.mp3")
            if UserData.diamond < SummonData.diamondPrice then
                local param = {text = "资金不足",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
            self.summonBtn:setButtonEnabled(false)
            NetHandler.gameRequest("OneDiamondChouka")
        elseif SummonData.summonType == SUMMON_TYPE.DIAMOND_SUMMON_TEN then
            AudioManage.playSound("Click_Coin.mp3")
            if UserData.diamond < SummonData.diamondPriceEx then
                local param = {text = "资金不足",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
            NetHandler.gameRequest("TenDiamondChouka")
            showMask()
        elseif SummonData.summonType == SUMMON_TYPE.SECRET_SUMMOM then
            AudioManage.playSound("Click_Coin.mp3")
            if UserData.diamond < SummonData.secretPrice then
                local param = {text = "资金不足",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
            NetHandler.gameRequest("SecretChouka")
            showMask()
		end
	elseif tag == BUTTON_ID.BUTTON_BACK then
        AudioManage.playSound("Back.mp3")
        app:popToScene()
	end
end

function SummonResultLayer:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.OneGoldChoukaProcess then
        self:updateResultView()
        self.resultNodes[1]:itemShowAnimation(function ()
            self.summonBtn:setButtonEnabled(true)
        end)
    elseif order == OperationCode.TenGoldChoukaProcess then
        hideMask()
        self:updateResultView()
        self:createShowReward()
        self.nodeBoxBtn:setVisible(false)
    elseif order == OperationCode.OneDiamondChoukaProcess then
        self:updateResultView()
        self.resultNodes[1]:itemShowAnimation(function ()
            self.summonBtn:setButtonEnabled(true)
        end)
    elseif order == OperationCode.TenDiamondChoukaProcess then
        hideMask()
        self:updateResultView()
        self:createShowReward()
        self.nodeBoxBtn:setVisible(false)
    elseif order == OperationCode.SecretChoukaProcess then
        hideMask()
        self:updateResultView()
        self:createShowReward()
        self.nodeBoxBtn:setVisible(false)
    elseif order == OperationCode.NewComerGuideProcess then
        if data.param1 == "Card" then
            self.delegate:guideFinish()
        end
    end
end

function SummonResultLayer:onEnter()
    --注册监听事件
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function SummonResultLayer:onExit()
    --移除监听事件
    GameDispatcher:removeEventListener(self.netEvent)
end

return SummonResultLayer