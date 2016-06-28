local HeroUpLayer = class("HeroUpLayer",function ()
	return display.newNode()
end)

local NodeBox = import("app.ui.NodeBox")

local boxImage = "Skil_Plusl_Board.png"
local closeImage = "Close.png"
local arrowImage = "Page_Left.png"
local starImage = "Skill_Plus%d.png"
local lockImage = "Lock_Another.png"
local frameImage = "AwakeStoneCircle.png"
local attrWord = "Word_AttrUp.png"
local abilityWord = "Word_SpecialAb.png"
local upImage = "star_attr_bg.png"
local skillImage = "Skill%d.png"
local skillHalfImage = "Skill%d_Half.png"

local nodeRect = cc.rect(20,20,690,400)

function HeroUpLayer:ctor(lv,heroId,dir)
	self.level = lv
	self.dir = dir
	self.heroId = heroId

	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.boxSprite = display.newSprite(boxImage)
    self.boxSprite:setPosition(display.cx,display.cy)
    self:addChild(self.boxSprite,2)

    self.boxSprite:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    self.boxSprite:runAction(seq)

    self:createArrow()
    self:createUpView()

	local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
		AudioManage.playSound("Close.mp3")
		self:removeFromParent(true)
	end)

	closeBtn:setPosition(700,450)
	self.boxSprite:addChild(closeBtn)
end

function HeroUpLayer:createIcon(lv,dir)
	if self.icon then
		self.icon:removeFromParent(true)
		self.icon = nil
	end
	self.icon = display.newSprite(frameImage)
	self.icon:setPosition(20,440)
    self.boxSprite:addChild(self.icon)

	local image = string.format(starImage,lv)
    local star = display.newSprite(image)
    star:setPosition(55,55)
    self.icon:addChild(star,2)

    if dir == 1 then
		local image = string.format(skillImage,lv)
		local word = display.newSprite(image)
		word:setPosition(55,55)
		self.icon:addChild(word,1)
    elseif dir == -1 then
    	local image = string.format(skillHalfImage,lv)
    	local word = display.newSprite(image)
		word:setPosition(55,55)
		self.icon:addChild(word,1)

		local lockSprite = display.newSprite(lockImage)
	    lockSprite:setPosition(55,55)
	    self.icon:addChild(lockSprite,3)
    end
end

function HeroUpLayer:createUpView()
	local clipNode = cc.ClippingRegionNode:create()
	clipNode:setClippingRegion(nodeRect)
	self.boxSprite:addChild(clipNode)

	if self.level == 0 then
    	self.view1 = self:createUpNode(self.level+1,cc.c3b(96,96,96))
	    self.view1:setPosition(360,225)
	   	clipNode:addChild(self.view1)

	   	self:createIcon(self.level+1,-1)
	elseif self.level == NAME_MAX_LEVEL then
		self.view1 = self:createUpNode(self.level,cc.c3b(255,97,0))
	    self.view1:setPosition(360,225)
	    clipNode:addChild(self.view1)

	    self:createIcon(self.level,1)
	else
		local color1
		local level1
		if self.dir == 1 then
			level1 = self.level
			color1 = cc.c3b(255,97,0)
			self:createIcon(level1,1)
		elseif self.dir == -1 then
			level1 = self.level + 1
			color1 = cc.c3b(96,96,96)
			self:createIcon(level1,-1)
		end
		self.view1 = self:createUpNode(level1,color1)
		self.view1:setPosition(360,225)
		clipNode:addChild(self.view1)

		local color2
		local level2
		if self.dir == 1 then
			level2 = self.level+1
			color2 = cc.c3b(96,96,96)
		elseif self.dir == -1 then
			level2 = self.level
			color2 = cc.c3b(255,97,0)
		end
		self.view2 = self:createUpNode(level2,color2)
		self.view2:setPosition(360+self.dir*nodeRect.width,225)
		clipNode:addChild(self.view2)
    end
end

function HeroUpLayer:playEnterAnimation(dir)
	local param = {x = -nodeRect.width*dir, time = 0.3}
	transition.moveBy(self.view1,param)
	transition.moveBy(self.view2,param)
end

function HeroUpLayer:createArrow()
	self.leftArrow = cc.ui.UIPushButton.new({normal = arrowImage, pressed = arrowImage})
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		self.rightArrow:setVisible(true)
		self.leftArrow:setVisible(false)
		self:playEnterAnimation(-1)
		self:createIcon(self.level,1)
	end)
	self.leftArrow:setPosition(45,229)
	self.boxSprite:addChild(self.leftArrow,3)

	self.rightArrow = cc.ui.UIPushButton.new({normal = arrowImage, pressed = arrowImage},{flipX = true})
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		self.rightArrow:setVisible(false)
		self.leftArrow:setVisible(true)
		self:playEnterAnimation(1)
		self:createIcon(self.level+1,-1)
	end)
	self.rightArrow:setPosition(680,229)
	self.boxSprite:addChild(self.rightArrow,3)

	if self.level == 0 or self.level == NAME_MAX_LEVEL then
		self.leftArrow:setVisible(false)
		self.rightArrow:setVisible(false)
	else
		if self.dir == 1 then
			self.leftArrow:setVisible(false)
		elseif self.dir == -1 then
			self.rightArrow:setVisible(false)
		end
	end
end

function HeroUpLayer:createUpNode(lv,color)
	local nodes = {}
	local incSprite = display.newSprite(upImage)
	table.insert(nodes,incSprite)

	local title1 = display.newSprite(attrWord)
	title1:setPosition(170,330)
	incSprite:addChild(title1)

	for i=1,10 do
		local text_ = string.format(GET_TEXT_DATA("TEXT_INC_"..i),15*lv)
		local param = {text = text_, size = 20}
		local label = createOutlineLabel(param)
		label:setAnchorPoint(0,1)
		label:setColor(color)
		label:setPosition(35,(1-i)*25+285)
		incSprite:addChild(label)
	end

	local exSprite = display.newSprite(upImage)
	table.insert(nodes,exSprite)

	local title2 = display.newSprite(abilityWord)
	title2:setPosition(170,330)
	exSprite:addChild(title2)

	local awakeInfo = GameConfig.skill_awake[self.heroId]
	local key = string.format("SkillNameInfo%d",lv)
	local param = {text = awakeInfo[key], size = 20,dimensions = cc.size(260, 350)}
	local exLabel = createOutlineLabel(param)
	exLabel:setPosition(35,285)
	exLabel:setColor(color)
	exLabel:setAnchorPoint(0,1)
	exSprite:addChild(exLabel)

	local nodeBox = NodeBox.new()
	nodeBox:setCellSize(cc.size(335,360))
	nodeBox:setUnit(2)
	nodeBox:addElement(nodes)

	return nodeBox
end

function HeroUpLayer:createIconFrame(lv,dir)
	if dir == 1 then
		local file = "Skill%d.png"
		local image = string.format(file,lv)
		local frame = display.newSpriteFrame(image)
		return frame
	elseif dir == -1 then
		local file = "Skill%d_Half.png"
		local image = string.format(file,lv)
		local frame = display.newSpriteFrame(image)
		return frame
	end
end

function HeroUpLayer:createWordFrame(lv)
	local file = "Skill_Plus%d.png"
	local image = string.format(file,lv)
	local frame = display.newSpriteFrame(image)
	return frame
end

return HeroUpLayer