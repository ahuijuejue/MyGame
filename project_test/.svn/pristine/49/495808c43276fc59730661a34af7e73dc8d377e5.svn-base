local UseItemLayer = class("UseItemLayer", function ()
	return display.newNode()
end)

local bgImage = "PopUp_Box.png"
local redImage1 = "Button_Cancel.png"
local redImage2 = "Button_Cancel_Light.png"
local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"
local greenImage3 = "Button_Gray.png"
local numImage = "Number_Bar.png"
local infoImage = "Item_Use_Info.png"
local shadowImage = "Item_Use_Shading.png"
local addImage = "Add.png"
local reduceImage = "Reduce.png"
local moreImage = "Max.png"

function UseItemLayer:ctor(item)
	self.item = item
	self.count = 0
	self:createBackView()
	self:createItemIcon()
	self:createBtns()
	self:createUseView()
end

function UseItemLayer:createBackView()
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,170))
    self:addChild(colorLayer)

    self.bgSprite = display.newSprite(bgImage)
    self.bgSprite:setPosition(display.cx,display.cy)
    self:addChild(self.bgSprite)

    self.numBg = display.newSprite(shadowImage)
    self.numBg:setPosition(263,155)
    self.bgSprite:addChild(self.numBg)
end

function UseItemLayer:createItemIcon()
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

function UseItemLayer:createBtns()
	local param1 = {normal = redImage1, pressed = redImage2}
	local param2 = {text = GET_TEXT_DATA("TEXT_CANCEL"),size = 26}
	local cancelBtn = createButtonWithLabel(param1,param2)
	:onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
		if self.delegate then
			self.delegate:removeUseLayer()
		end
	end)
    cancelBtn:setPosition(153,50)
    self.bgSprite:addChild(cancelBtn)


    local param1 = {normal = greenImage1, pressed = greenImage2}
	local param2 = {text = GET_TEXT_DATA("TEXT_SURE"),size = 26}
	local sureBtn = createButtonWithLabel(param1,param2)
	:onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
        if self.count>0 then
            if self.delegate then
                self.delegate:useItem(self.count,self.item.itemId)
                self.delegate:removeUseLayer()
            end
        end
	end)
    sureBtn:setPosition(373,50)
    self.bgSprite:addChild(sureBtn)
end

function UseItemLayer:createUseView()
	local  param = {text = GET_TEXT_DATA("USE_COUNT"), size = 22}
    local label = createOutlineLabel(param)
    label:setPosition(65,65)
    self.numBg:addChild(label)

    local button1 = cc.ui.UIPushButton.new({normal = reduceImage})
    :onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
    	if self.count > 0 then
    		self.count = self.count - 1
    		self.countLabel:setString(self.count)
    	end
    end)
    button1:setPosition(140,65)
    self.numBg:addChild(button1)

    local countBg = display.newSprite(numImage)
    countBg:setPosition(230,65)
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
    		self.countLabel:setString(self.count)
    	end
    end)
    button2:setPosition(320,65)
    self.numBg:addChild(button2)

    local param1 = {normal = moreImage}
	local param2 = {text = GET_TEXT_DATA("TEXT_MAX"), size = 22, color = cc.c3b(255,184,92)}
    local button3 = createButtonWithLabel(param1,param2)
    :onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
    	self.count = self.item.count
    	self.countLabel:setString(self.count)
    end)
    button3:setPosition(385,65)
    self.numBg:addChild(button3)
end

return UseItemLayer