local BuyExpItemLayer = class("BuyExpItemLayer",function ()
	return display.newLayer()
end)

local NodeBox = import("app.ui.NodeBox")

local bgImage = "PopUp_Box.png"
local redImage1 = "Button_Cancel.png"
local redImage2 = "Button_Cancel_Light.png"
local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"
local greenImage3 = "Button_Gray.png"
local numImage = "Number_Bar.png"
local addImage = "Add.png"
local reduceImage = "Reduce.png"
local moreImage = "Max.png"
local infoImage = "Item_Use_Info.png"
local shadowImage = "Item_Use_Shading.png"
local cashImage = "Gold.png"
local diamondImage = "Diamond.png"

local BUTTON_ID = {
    BUTTON_CANCEL = 1,
    BUTTON_SURE = 2,
    BUTTON_ADD = 3,
    BUTTON_REDUCE = 4,
    BUTTON_MORE = 5,
}

function BuyExpItemLayer:ctor(itemId)
    self._itemId = itemId
    self.count = 0
    self.cost = 0
    self.unit = GameConfig.item[itemId].Content.count
    self.price = GameConfig.item[itemId].Content.price[1]
    self.symbol = GameConfig.item[itemId].Content.price[2]

    self:createBackView()
    self:createItemIcon()
    self:createCountView()
    self:createCostView()
    self:createBtns()
end

function BuyExpItemLayer:createBackView()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)

    self.bgSprite = display.newSprite(bgImage)
    self.bgSprite:setPosition(display.cx,display.cy)
    self:addChild(self.bgSprite)

    self.numBg = display.newSprite(shadowImage)
    self.numBg:setPosition(263,155)
    self.bgSprite:addChild(self.numBg)
end

function BuyExpItemLayer:createItemIcon()
    local boardSprite = display.newSprite(infoImage)
    boardSprite:setPosition(263,275)
    self.bgSprite:addChild(boardSprite)

	local itemSprite = createItemIcon(self._itemId,false,0.7)
	itemSprite:setPosition(15,42)
	boardSprite:addChild(itemSprite)

    local item = ItemData:getItemConfig(self._itemId)
	local param = {text = item.itemName, color = display.COLOR_WHITE,size = 22}
    local label = createOutlineLabel(param)
    label:setAnchorPoint(0,0.5)
    label:setPosition(65,31)
    label:setColor(COLOR_RANGE[item.quality])
    boardSprite:addChild(label)
end

function BuyExpItemLayer:createCountView()
	local  param = {text = GET_TEXT_DATA("BUY_COUNT"), size = 22}
    local label = createOutlineLabel(param)
    label:setPosition(65,85)
    self.numBg:addChild(label)

	local btnCallBack = handler(self,self.buttonEvent)
    local button1 = cc.ui.UIPushButton.new({normal = reduceImage})
    :onButtonClicked(btnCallBack)
    button1:setTag(BUTTON_ID.BUTTON_REDUCE)
    button1:setPosition(140,85)
    self.numBg:addChild(button1)

    local countBg = display.newSprite(numImage)
    countBg:setPosition(230,85)
    self.numBg:addChild(countBg)

    local param = {text = tostring(self.count), size = 22}
    self.countLabel = createOutlineLabel(param)
    self.countLabel:setPosition(62,16)
    countBg:addChild(self.countLabel)

    local button2 = cc.ui.UIPushButton.new({normal = addImage})
    :onButtonClicked(btnCallBack)
    button2:setTag(BUTTON_ID.BUTTON_ADD)
    button2:setPosition(320,85)
    self.numBg:addChild(button2)

    local button3 = cc.ui.UIPushButton.new({normal = moreImage})
    :onButtonClicked(btnCallBack)
    button3:setTag(BUTTON_ID.BUTTON_MORE)
    button3:setPosition(385,85)
    self.numBg:addChild(button3)

    local param = {text = GET_TEXT_DATA("BUY_MORE"), color = cc.c3b(255,184,92), size = 20}
    local moreLabel = createOutlineLabel(param)
    button3:addChild(moreLabel)
end

function BuyExpItemLayer:createCostView()
    local  param = {text = GET_TEXT_DATA("BUY_COST"),size = 22}
    local label = createOutlineLabel(param)
    label:setPosition(65,40)
    self.numBg:addChild(label)

    local countBg = display.newSprite(numImage)
    countBg:setPosition(230,40)
    self.numBg:addChild(countBg)

    local param = {text = tostring(self.cost), size = 22}
    self.costLabel = createOutlineLabel(param)
    self.costLabel:setPosition(62,16)
    countBg:addChild(self.costLabel)

    if self.symbol == 1 then
        local icon = display.newSprite(cashImage)
        icon:setPosition(320,40)
        self.numBg:addChild(icon)
    elseif self.symbol == 2 then
        local icon = display.newSprite(diamondImage)
        icon:setPosition(320,40)
        self.numBg:addChild(icon)
    end
end

function BuyExpItemLayer:createBtns()
	local btnCallBack = handler(self,self.buttonEvent)

	local cancelBtn = cc.ui.UIPushButton.new({normal = redImage1, pressed = redImage2})
	:onButtonClicked(btnCallBack)
    cancelBtn:setTag(BUTTON_ID.BUTTON_CANCEL)
    cancelBtn:setPosition(153,50)
    self.bgSprite:addChild(cancelBtn)

    local  param = {text = GET_TEXT_DATA("TEXT_CANCEL"),color = display.COLOR_WHITE}
    local cancelLabel = createOutlineLabel(param)
    cancelBtn:addChild(cancelLabel)

	local sureBtn = cc.ui.UIPushButton.new({normal = greenImage1, pressed = greenImage2, disabled = greenImage3})
	:onButtonClicked(btnCallBack)
    sureBtn:setTag(BUTTON_ID.BUTTON_SURE)
    sureBtn:setPosition(373,50)
    self.bgSprite:addChild(sureBtn)

    local  param = {text = GET_TEXT_DATA("TEXT_SURE"),color = display.COLOR_WHITE}
    local sureLabel = createOutlineLabel(param)
    sureBtn:addChild(sureLabel)
end

function BuyExpItemLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
	local tag = event.target:getTag()
	if tag == BUTTON_ID.BUTTON_CANCEL then
        self.delegate:removeBuyLayer()
	elseif tag == BUTTON_ID.BUTTON_SURE then
        if self.symbol == 1 then
            if UserData.gold < self.cost then
                local param = {text = "钱不够",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
        elseif self.symbol == 2 then
            if UserData.diamond < self.cost then
                local param = {text = "钱不够",size = 30,color = display.COLOR_RED}
                showToast(param)
                return
            end
        end
        if self.count > 0 then
            local param = {param1 = self._itemId, param3 = 5, param4 = self.count/self.unit}
            NetHandler.gameRequest("BuyShopGoods",param)
            self.delegate:removeBuyLayer()
        end
    elseif tag == BUTTON_ID.BUTTON_ADD then
        self.count = self.unit + self.count
        self.cost = self.price + self.cost
        self.countLabel:setString(tostring(self.count))
        self.costLabel:setString(tostring(self.cost))
    elseif tag == BUTTON_ID.BUTTON_REDUCE then
        if self.count > 0 then
            self.count = self.count - self.unit 
            self.cost = self.cost - self.price
            self.countLabel:setString(tostring(self.count))
            self.costLabel:setString(tostring(self.cost))
        end
    elseif tag == BUTTON_ID.BUTTON_MORE then
        self.count = self.unit*10 + self.count
        self.cost = self.price*10 + self.cost
        self.countLabel:setString(tostring(self.count))
        self.costLabel:setString(tostring(self.cost))
	end
end

return BuyExpItemLayer