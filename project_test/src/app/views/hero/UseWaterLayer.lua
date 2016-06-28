local UseWaterLayer = class("UseWaterLayer",function ()
	return display.newNode()
end)

local scheduler = require("framework.scheduler")

local boxImage = "Friends_Tips.png"
local redImage1 = "Button_Cancel.png"
local redImage2 = "Button_Cancel_Light.png"
local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"
local greenImage3 = "Button_Gray.png"
local bannerImage = "SuperDrug_Banner.png"
local materialImage = "Gear_Info.png"
local selectImage = "Exp_Select.png"
local titleImage = "Box_Title.png"

function UseWaterLayer:ctor(hero)
	self.hero = hero
	self.selectIndex = 0

	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.boxSprite = display.newSprite(boxImage)
    self.boxSprite:setPosition(display.cx,display.cy)
    self:addChild(self.boxSprite,2)

    self.boxSprite:setScale(0.3)
    local seq = transition.sequence({
    	cc.ScaleTo:create(0.15, 1.3),
    	cc.ScaleTo:create(0.05, 1)
    	})
    self.boxSprite:runAction(seq)
    
    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(264,385)
    self.boxSprite:addChild(titleSprite)

    local param = {text = GET_TEXT_DATA("AWAKE_WATER"),size = 26}
    local titleLabel = createOutlineLabel(param)
    titleLabel:setColor(cc.c3b(255,97,0))
    titleLabel:setPosition(140,25)
    titleSprite:addChild(titleLabel)

    self:createWaterView()
    self:createTimeView()
    self:createBtns()

    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function UseWaterLayer:createWaterView()
	self.itemBtns = {}
	local waterView1 = self:createItem(SUPER_ITEM[1])
	waterView1:setPosition(144,265)
	self.boxSprite:addChild(waterView1)

	local itemBtn1 = self:createItemBtn(SUPER_ITEM[1],1)
	waterView1:addChild(itemBtn1)
	table.insert(self.itemBtns,itemBtn1)

	local waterView2 = self:createItem(SUPER_ITEM[2])
	waterView2:setPosition(384,265)
	self.boxSprite:addChild(waterView2)

	local itemBtn2 = self:createItemBtn(SUPER_ITEM[2],2)
	waterView2:addChild(itemBtn2)
	table.insert(self.itemBtns,itemBtn2)
end	

function UseWaterLayer:createTimeView()
	local bgSprite = display.newSprite(materialImage)
	bgSprite:setPosition(264,128)
	self.boxSprite:addChild(bgSprite)

	self.label1 = createOutlineLabel({text = "",size = 20})
	self.label1:setAnchorPoint(0,0.5)
	self.label1:setPosition(20,60)
	bgSprite:addChild(self.label1)

	self.label2 = createOutlineLabel({text = "",size = 20})
	self.label2:setAnchorPoint(0,0.5)
	self.label2:setPosition(20,30)
	bgSprite:addChild(self.label2)
end

function UseWaterLayer:updateTimeView()
	local timeStr = string.format(GET_TEXT_DATA("TEXT_WATER_TIME_1"),formatTime2(self.lWaterTime))
	self.label1:setString(timeStr)
	
	timeStr = string.format(GET_TEXT_DATA("TEXT_WATER_TIME_2"),formatTime2(self.mWaterTime))
	self.label2:setString(timeStr)
end

function UseWaterLayer:createItem(itemId)
	local bgSprite = display.newSprite(bannerImage)

	local item = ItemData:getItemConfig(itemId)
	local nameLabel = createOutlineLabel({text = item.itemName, size = 22})
	nameLabel:setPosition(50,145)
	bgSprite:addChild(nameLabel)

	local desLabel = createOutlineLabel({text = item.desc, size = 18, dimensions = cc.size(180, 60)})
	desLabel:setPosition(108,45)
	desLabel:setAnchorPoint(0.5,1)
	bgSprite:addChild(desLabel)

	return bgSprite
end

function UseWaterLayer:createItemBtn(itemId,tag)
    local button = createItemIcon(itemId,true,0.7)
    :onButtonClicked(handler(self,self.buttonEvent))
    button:setPosition(108,90)
    button:setTag(tag)

    local count = ItemData:getItemCountWithId(itemId)
    local label = createOutlineLabel({text = count,size = 26})
    button:setButtonLabel(label)
    button:setButtonLabelOffset(45,-45)

    return button
end

function UseWaterLayer:createBtns()
	local param1 = {normal = redImage1, pressed = redImage2}
	local param2 = {text = GET_TEXT_DATA("TEXT_CANCEL"),color = display.COLOR_WHITE}
	local cancelBtn = createButtonWithLabel(param1,param2)
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		self:removeTimer()
		if self.delegate then
			self.delegate:removeWaterView()
		end
	end)
    cancelBtn:setPosition(144,45)
    self.boxSprite:addChild(cancelBtn)

    param1 = {normal = greenImage1, pressed = greenImage2, disabled = greenImage3}
    param2 = {text = GET_TEXT_DATA("TEXT_USE"),color = display.COLOR_WHITE}
	self.sureBtn = createButtonWithLabel(param1,param2)
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		local param = {param1 = self.hero.roleId, param2 = SUPER_ITEM[self.selectIndex]}
		NetHandler.gameRequest("UseYaoShui",param)
	end)
    self.sureBtn:setPosition(384,45)
    self.sureBtn:setButtonEnabled(false)
    self.boxSprite:addChild(self.sureBtn)
end

function UseWaterLayer:updateView()
	self.lWaterTime = math.max(0,self.hero:lWaterTime())
	self.mWaterTime = math.max(0,self.hero:mWaterTime())
	self:updateTimeView()
	if self.selectIndex ~= 0 then
		local count = ItemData:getItemCountWithId(SUPER_ITEM[self.selectIndex])
		self.itemBtns[self.selectIndex]:setButtonLabelString(count)
		if count <= 0 then
			self.sureBtn:setButtonEnabled(false)
		end
	end
end

function UseWaterLayer:buttonEvent(event)
	AudioManage.playSound("Click.mp3")
	local tag = event.target:getTag()

	if self.selectIndex == tag then
		return
	end

	self.selectIndex = tag

	local itemId = SUPER_ITEM[self.selectIndex]
    local count = ItemData:getItemCountWithId(itemId)
    if count > 0 then
    	self.sureBtn:setButtonEnabled(true)
    else
    	self.sureBtn:setButtonEnabled(false)
    end

	if self.selectSprite then
        self.selectSprite:removeFromParent(true)
        self.selectSprite = nil
    end

    self.selectSprite = display.newSprite(selectImage)
    event.target:addChild(self.selectSprite,-1000)
end

function UseWaterLayer:startTimer()
	if self.timeHandle then
		return
	end
    self.timeHandle = scheduler.scheduleGlobal(function ()
    	if self.lWaterTime > 0 then
			self.lWaterTime = self.lWaterTime - 1
		end
		if self.mWaterTime > 0 then
			self.mWaterTime = self.mWaterTime - 1
		end
		self:updateTimeView()
    end,1)
end

function UseWaterLayer:removeTimer()
	if self.timeHandle then
		scheduler.unscheduleGlobal(self.timeHandle)
		self.timeHandle = nil
	end
end

function UseWaterLayer:onEnter()
    self:updateView()
    self:startTimer()
end

function UseWaterLayer:onExit()
	self:removeTimer()
end

return UseWaterLayer