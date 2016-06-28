local StoneDropLayer = class("StoneDropLayer",function ()
	return display.newNode()
end)

local ItemDropLayer = import(".ItemDropLayer")

local boardImage = "Stone_Board.png"
local closeImage = "Close.png"
local stoneBarBg = "Stone_Board_Bar.png"
local stoneImage = "Stone_Board_Slip.png"
local coinImage = "HeroStone.png"
local iconImage = "AwakeStone%d.png"
local summonImage = "summon_hero.png"

function StoneDropLayer:ctor(item,hero)
	self._item = item
	self.hero = hero
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.itemBoard = self:createBoard()
	self.itemBoard:setPosition(display.cx,display.cy)
	self:addChild(self.itemBoard)

	self:createItemBoard()

    self.dropLayer = ItemDropLayer.new(item)
    self.dropLayer:setPosition(display.cx,display.cy)
    self:addChild(self.dropLayer,1)

    transition.moveBy(self.itemBoard, {x = 0, y = 105 ,time = 0.2})   
    transition.moveBy(self.dropLayer, {x = 0, y = -125 ,time = 0.2})   
end

function StoneDropLayer:createBoard()
	local boardSprite = display.newSprite(boardImage)

    local titleSprite = display.newSprite(summonImage)
    titleSprite:setPosition(263,230)
    boardSprite:addChild(titleSprite)

	local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
		AudioManage.playSound("Close.mp3")
		if self.delegate then
			self.delegate:removeDropLayer()
		end
	end)
	closeBtn:setPosition(500,230)
	boardSprite:addChild(closeBtn)

	return boardSprite
end

function StoneDropLayer:createItemBoard()
	local nameLabel = createOutlineLabel({text = self._item.itemName})
	nameLabel:setAnchorPoint(0,0.5)
	nameLabel:setPosition(200,135)
	nameLabel:setColor(COLOR_RANGE[self._item.quality])
	self.itemBoard:addChild(nameLabel)

	self:createStoneView()

	local itemIcon = self:createItemIcon()
	itemIcon:setPosition(130,113)
	self.itemBoard:addChild(itemIcon)
end

function StoneDropLayer:createStoneView()
    local bgSprite = display.newSprite(stoneBarBg)
    bgSprite:setPosition(320,90)
    self.itemBoard:addChild(bgSprite)

    local needNum = self.hero.stoneNum
    local stoneNum = self._item.count
    local stoneText = string.format("%d/%d",stoneNum,needNum)
    local percent = stoneNum/needNum

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    self.stoneProgress = cc.ProgressTimer:create(display.newSprite(stoneImage))
    self.stoneProgress:setType(1)
    self.stoneProgress:setPosition(offsetX,offsetY)
    self.stoneProgress:setMidpoint(cc.p(0,1))
    self.stoneProgress:setBarChangeRate(cc.p(1, 0))
    self.stoneProgress:setPercentage(100*percent)
    bgSprite:addChild(self.stoneProgress,1)

	local param = {text = stoneText ,color = display.COLOR_WHITE, size = 24,x = offsetX, y = offsetY}
    self.stoneLabel = createOutlineLabel(param)
    bgSprite:addChild(self.stoneLabel,2)
end

function StoneDropLayer:updateStoneView()
	local needNum = self.hero.stoneNum
    local stoneNum = ItemData:getItemCountWithId(self.hero.stoneId)
    local stoneText = nil
    local percent = 0
    if stoneNum >= needNum then
    	stoneText = GET_TEXT_DATA("CLICK_SUMMON")
    	percent = 1
	else
		stoneText = string.format("%d/%d",stoneNum,needNum)
		percent = stoneNum/needNum
    end
    self.stoneProgress:setPercentage(100*percent)
    self.stoneLabel:setString(stoneText)
end

function StoneDropLayer:createItemIcon()
	local image = string.format(iconImage,self._item.configQuality)
	local bgSprite = display.newSprite(image)

	local offsetX = bgSprite:getContentSize().width/2
	local offsetY = bgSprite:getContentSize().height/2

	local itemSprite = display.newSprite(self._item.imageName)
	itemSprite:setPosition(offsetX,offsetY)
	bgSprite:addChild(itemSprite)

	local stone = display.newSprite(coinImage)
	stone:setPosition(12,90)

	bgSprite:addChild(stone)

	return bgSprite
end

return StoneDropLayer