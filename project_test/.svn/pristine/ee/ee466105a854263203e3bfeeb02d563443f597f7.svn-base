local SellItemLayer = class("SellItemLayer",function ()
	return display.newLayer()
end)

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

function SellItemLayer:ctor(item)
	self.item = item
	self.count = 0
	self.price = 0
	self:createBackView()
	self:createItemIcon()
	self:createBtns()
	self:createSellView()
	self:createPriceView()
end

function SellItemLayer:createBackView()
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)

    self.bgSprite = display.newSprite(bgImage)
    self.bgSprite:setPosition(display.cx,display.cy)
    self:addChild(self.bgSprite)
    self.bgSprite:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    self.bgSprite:runAction(seq)

    self.numBg = display.newSprite(shadowImage)
    self.numBg:setPosition(263,155)
    self.bgSprite:addChild(self.numBg)
end

function SellItemLayer:createItemIcon()
	local boardSprite = display.newSprite(infoImage)
    boardSprite:setPosition(263,275)
    self.bgSprite:addChild(boardSprite)

    local itemSprite = createItemIcon(self.item.itemId,false,0.7)
    itemSprite:setPosition(15,42)
    boardSprite:addChild(itemSprite)

    local  param = {text = self.item.itemName,size = 20}
    local label = createOutlineLabel(param)
    label:setColor(COLOR_RANGE[self.item.quality])
    label:setAnchorPoint(0,0.5)
    label:setPosition(65,43)
    boardSprite:addChild(label)

    local text = string.format(GET_TEXT_DATA("TEXT_HAVE_NUM"),self.item.count)
    local param = {text = text, size = 18, color = cc.c3b(255,240,70)}
    local countLabel = createOutlineLabel(param)
    countLabel:setAnchorPoint(1,0.5)
    countLabel:setPosition(300,19)
    boardSprite:addChild(countLabel)
end

function SellItemLayer:createBtns()
	local param1 = {normal = redImage1, pressed = redImage2}
	local param2 = {text = GET_TEXT_DATA("TEXT_CANCEL")}
	local cancelBtn = createButtonWithLabel(param1,param2)
	:onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
		if self.delegate then
			self.delegate:removeSellLayer()
		end
	end)
    cancelBtn:setPosition(153,50)
    self.bgSprite:addChild(cancelBtn)


    local param1 = {normal = greenImage1, pressed = greenImage2}
	local param2 = {text = GET_TEXT_DATA("TEXT_SURE")}
	local sureBtn = createButtonWithLabel(param1,param2)
	:onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
        if self.count <= 0 then
            return
        end
		if self.delegate then
            local uIds = {}
            local config = GameConfig.item[self.item.itemId]
            if config.Type == 2 then
                for i=1,self.count do
                    table.insert(uIds,self.item.uniqueId[i])
                end
            end
            self.delegate:sellItem(self.count,self.item.itemId,uIds)
			self.delegate:removeSellLayer()
		end
	end)
    sureBtn:setPosition(373,50)
    self.bgSprite:addChild(sureBtn)
end

function SellItemLayer:createSellView()
	local  param = {text = GET_TEXT_DATA("SELL_COUNT"),size = 22}
    local label = createOutlineLabel(param)
    label:setPosition(65,85)
    self.numBg:addChild(label)

    local button1 = cc.ui.UIPushButton.new({normal = reduceImage})
    :onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
    	if self.count > 0 then
    		self.count = self.count - 1
    		self.price = self.count * self.item.value
    		self.countLabel:setString(self.count)
    		self.costLabel:setString(self.price)
    	end
    end)
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
    :onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
    	if self.count < self.item.count then
    		self.count = self.count + 1
    		self.price = self.count * self.item.value
    		self.countLabel:setString(self.count)
    		self.costLabel:setString(self.price)
    	end
    end)
    button2:setPosition(320,85)
    self.numBg:addChild(button2)

    local param1 = {normal = moreImage}
	local param2 = {text = GET_TEXT_DATA("TEXT_MAX"), color = cc.c3b(255,184,92), size = 22}
    local button3 = createButtonWithLabel(param1,param2)
    :onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
    	self.count = self.item.count
    	self.price = self.count * self.item.value
    	self.countLabel:setString(self.count)
		self.costLabel:setString(self.price)
    end)
    button3:setPosition(385,85)
    self.numBg:addChild(button3)
end

function SellItemLayer:createPriceView()
    local  param = {text = GET_TEXT_DATA("SELL_PRICE"),size = 22}
    local label = createOutlineLabel(param)
    label:setPosition(65,40)
    self.numBg:addChild(label)

    local countBg = display.newSprite(numImage)
    countBg:setPosition(230,40)
    self.numBg:addChild(countBg)

    local param = {text = tostring(self.price), size = 22}
    self.costLabel = createOutlineLabel(param)
    self.costLabel:setPosition(62,16)
    countBg:addChild(self.costLabel)

    local icon = display.newSprite(cashImage)
    icon:setPosition(320,40)
    self.numBg:addChild(icon)
end

return SellItemLayer