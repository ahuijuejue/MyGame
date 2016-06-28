local HeroInsertLayer = class("HeroInsertLayer",function ()
	return display.newNode()
end)

local ItemDropLayer = import("..item.ItemDropLayer")

local boardImage = "Stone_Board.png"
local closeImage = "Close.png"
local stoneBarBg = "Stone_Board_Bar.png"
local stoneImage = "Stone_Board_Slip.png"
local coinImage = "HeroStone.png"
local iconImage = "AwakeStone%d.png"
local greenImage1 = "GearPlusAll_Button.png"
local greenImage2 = "GearPlusAll_Button_Light.png"
local greenImage3 = "GearPlusAll_Button_Gray.png"

function HeroInsertLayer:ctor(hero,index)
	local awakeInfo = GameConfig.skill_awake[hero.roleId]
	local key = string.format("SkillNameItemID%d",math.min(hero.starLv+1,NAME_MAX_LEVEL))

	self.hero = hero
	self.index = index
	self.item = ItemData:getItemConfig(awakeInfo[key][index])

	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.itemBoard = self:createBoard()
	self.itemBoard:setPosition(display.cx,display.cy)
	self:addChild(self.itemBoard)

	self:createItemBoard()
	self:updateView()

    self.dropLayer = ItemDropLayer.new(self.item)
    self.dropLayer:setPosition(display.cx,display.cy)
    self:addChild(self.dropLayer,1)

    transition.moveBy(self.itemBoard, {x = 0, y = 105 ,time = 0.3})   
    transition.moveBy(self.dropLayer, {x = 0, y = -125 ,time = 0.3})   
end

function HeroInsertLayer:createBoard()
	local boardSprite = display.newSprite(boardImage)

    local titleLabel = display.newTTFLabel({text = GET_TEXT_DATA("INSERT_COIN"),color = cc.c3b(255,97,0)})
    titleLabel:setPosition(263,230)
    boardSprite:addChild(titleLabel)

	local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
	    AudioManage.playSound("Close.mp3")
		if self.delegate then
			self.delegate:removeInsertView()
		end
	end)
	closeBtn:setPosition(500,230)
	boardSprite:addChild(closeBtn)

	self.insertBtn = cc.ui.UIPushButton.new({normal = greenImage1, pressed = greenImage2, disabled = greenImage3})
	:onButtonClicked(function ()
	    AudioManage.playSound("SetGems.mp3")
		self:insertCoin(1)
	end)
	self.insertBtn:setPosition(160,45)
	self.insertBtn:setButtonEnabled(GamePoint.holeCanInsert(self.hero,self.index))
	boardSprite:addChild(self.insertBtn)

	local param = {text = GET_TEXT_DATA("TEXT_INSERT"),size = 20}
	local label = createOutlineLabel(param)
	self.insertBtn:setButtonLabel(label)

	self.insert5Btn = cc.ui.UIPushButton.new({normal = greenImage1, pressed = greenImage2, disabled = greenImage3})
	:onButtonClicked(function ()
		AudioManage.playSound("SetGems.mp3")
		local insertCount = self:getInsertCount()
		self:insertCoin(insertCount)
	end)
	self.insert5Btn:setPosition(355,45)
	self.insert5Btn:setButtonEnabled(GamePoint.holeCanInsert(self.hero,self.index))
	boardSprite:addChild(self.insert5Btn)

	local param = {text = GET_TEXT_DATA("TEXT_INSERT5"),size = 20}
	local label5 = createOutlineLabel(param)
	self.insert5Btn:setButtonLabel(label5)

	return boardSprite
end

function HeroInsertLayer:createItemBoard()
	local nameLabel = createOutlineLabel({text = self.item.itemName})
	nameLabel:setAnchorPoint(0,0.5)
	nameLabel:setPosition(190,150)
	nameLabel:setColor(COLOR_RANGE[self.item.quality])
	self.itemBoard:addChild(nameLabel)

	local proress = self:createStoneView()
	proress:setPosition(310,110)
	self.itemBoard:addChild(proress)

	local itemIcon = self:createItemIcon()
	itemIcon:setPosition(120,135)
	self.itemBoard:addChild(itemIcon)
end

function HeroInsertLayer:createStoneView()
    local bgSprite = display.newSprite(stoneBarBg)

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    local awakeInfo = GameConfig.skill_awake[self.hero.roleId]
	local key = string.format("SkillNameNum%d",math.min(self.hero.starLv+1,NAME_MAX_LEVEL))
	local needNum = awakeInfo[key][self.index]
	local nowNum = self.hero.coinNums[self.index]
    local percent = nowNum/needNum

    self.stoneProgress = cc.ProgressTimer:create(display.newSprite(stoneImage))
    self.stoneProgress:setType(1)
    self.stoneProgress:setPosition(offsetX,offsetY)
    self.stoneProgress:setMidpoint(cc.p(0,1))
    self.stoneProgress:setBarChangeRate(cc.p(1, 0))
    self.stoneProgress:setPercentage(percent*100)
    bgSprite:addChild(self.stoneProgress,1)

	local param = {text = "" ,color = display.COLOR_WHITE, size = 24,x = offsetX, y = offsetY}
    self.stoneLabel = display.newTTFLabel(param)
    bgSprite:addChild(self.stoneLabel,2)

    return bgSprite
end

function HeroInsertLayer:createItemIcon()
	local image = string.format(iconImage,self.item.configQuality)
	local bgSprite = display.newSprite(image)

	local offsetX = bgSprite:getContentSize().width/2
	local offsetY = bgSprite:getContentSize().height/2

	local itemSprite = display.newSprite(self.item.imageName)
	itemSprite:setPosition(offsetX,offsetY)
	bgSprite:addChild(itemSprite)

	local stone = display.newSprite(coinImage)
	stone:setPosition(12,90)
	bgSprite:addChild(stone)

	local param = {text = ItemData:getItemCountWithId(self.item.itemId),size = 24}
	self.numLabel = createOutlineLabel(param)
	self.numLabel:setPosition(100,15)
    bgSprite:addChild(self.numLabel)

	return bgSprite
end

function HeroInsertLayer:insertCoin(count)
	local pos = self.index
	local heroId = self.hero.roleId

	local param = {param1 = heroId, param2 = pos, param3 = count}
	NetHandler.gameRequest("XiangQianHeroNameChip",param)
end

function HeroInsertLayer:getInsertCount()
	local awakeInfo = GameConfig.skill_awake[self.hero.roleId]
	local key = string.format("SkillNameNum%d",math.min(self.hero.starLv+1,NAME_MAX_LEVEL))
	local needNum = awakeInfo[key][self.index]
	local nowNum = self.hero.coinNums[self.index]
	local leftNum = needNum - nowNum
	local itemCount = ItemData:getItemCountWithId(self.item.itemId)
	local insertCount = math.min(leftNum,itemCount)

	return insertCount
end

function HeroInsertLayer:updateView()
	local hero = self.hero
	local awakeInfo = GameConfig.skill_awake[hero.roleId]
	local key = string.format("SkillNameNum%d",math.min(hero.starLv+1,NAME_MAX_LEVEL))
	local needNum = awakeInfo[key][self.index]
	local nowNum = self.hero.coinNums[self.index]
	local itemCount = ItemData:getItemCountWithId(self.item.itemId)

	local percent = nowNum/needNum
    local stoneText = string.format("%d/%d",nowNum,needNum)

    local pro = cc.ProgressTo:create(0.3,100*percent)
    self.stoneProgress:runAction(pro)

    self.stoneLabel:setString(stoneText)

    self.numLabel:setString(itemCount)
	self.insertBtn:setButtonEnabled(GamePoint.holeCanInsert(self.hero,self.index))
	self.insert5Btn:setButtonEnabled(GamePoint.holeCanInsert(self.hero,self.index))
end

return HeroInsertLayer