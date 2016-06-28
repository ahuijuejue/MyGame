local HeroAbilityLayer = class("HeroAbilityLayer",function ()
	return display.newLayer()
end)

local barBg = "Stone_Bar.png"
local expImage = "ExpMode_Slip.png"
local boardImage = "bg_001.png"
local desImage = "Skill_Plus_Banner.png"
local extraImage = "GearPlus_Award_Banner.png"
local ablImage = "Attr_Banner.png"
local desWord = "Word_HeroInfo.png"
local abilityWord = "Word_Attr.png"
local infoBgImage = "hero_info_bg.png"

function HeroAbilityLayer:ctor(hero)
	self.abilitys = {}
	self.hero = hero
	self:createBoard()
	self:createDesView()
	self:createExpView()
	self:createPowerView()
	self:createAbilityView()
	self:setTouchSwallowEnabled(false)
end

function HeroAbilityLayer:createBoard()
	local board = display.newSprite(boardImage)
	board:setPosition(438,273)
	self:addChild(board)
end

function HeroAbilityLayer:createDesView()
	local desBoard = display.newSprite(desImage)
	desBoard:setPosition(453,337)
	self:addChild(desBoard)

	local title = display.newSprite(desWord)
	title:setPosition(125,315)
	desBoard:addChild(title)

	local heroData 	 = GameConfig.Hero[self.hero.roleId]
	local desLabel = base.TalkLabel.new({
	    		text  = heroData.Description,
				size  = 20,
				dimensions = cc.size(210, 0),
				color = cc.c3b(255,234,177),
				height = -3
	    	})
	desLabel:setPosition(30,250-20*desLabel:getLines())
	desBoard:addChild(desLabel,3)
end

function HeroAbilityLayer:createExpView()
	local bgSprite = display.newSprite(infoBgImage)
	bgSprite:setPosition(170,100)
	self:addChild(bgSprite)

    local sprite = display.newSprite(extraImage)
    sprite:setPosition(122,83)
    bgSprite:addChild(sprite)

	local param = {text = GET_TEXT_DATA("TEXT_HERO_EXP"), size = 24}
    local titleLabel = createOutlineLabel(param)
    titleLabel:setPosition(118,16)
    sprite:addChild(titleLabel)

    local barSprite = display.newSprite(barBg)
    barSprite:setPosition(122,25)
    bgSprite:addChild(barSprite)

    local offsetX = barSprite:getContentSize().width/2
    local offsetY = barSprite:getContentSize().height/2

    local currentExp = GameExp.getCurrentExp(self.hero.exp)
	local totalExp = GameExp.getUpgradeExp(self.hero.exp)
    local _text = string.format("%d/%d",currentExp,totalExp)
    local percent = currentExp/totalExp

    local expProgress = cc.ProgressTimer:create(display.newSprite(expImage))
    expProgress:setType(1)
    expProgress:setPosition(offsetX,offsetY)
    expProgress:setMidpoint(cc.p(0,1))
    expProgress:setBarChangeRate(cc.p(1, 0))

    expProgress:setPercentage(100*percent)
    barSprite:addChild(expProgress)

	local param = {text = _text ,color = display.COLOR_WHITE, size = 20,x = 157/2, y = 35}
    local expLabel = createOutlineLabel(param)
    barSprite:addChild(expLabel,2)

	local param = {text = "Lv."..self.hero.level ,color = display.COLOR_WHITE, size = 20,x = 157/2, y = 23/2}
    local lvLabel = createOutlineLabel(param)
    barSprite:addChild(lvLabel,2)
end

function HeroAbilityLayer:createPowerView()
	local bgSprite = display.newSprite(infoBgImage)
	bgSprite:setPosition(450,100)
	self:addChild(bgSprite)

	local sprite = display.newSprite(extraImage)
    sprite:setPosition(122,83)
    bgSprite:addChild(sprite)

	local _text = GET_TEXT_DATA("TEXT_HERO_POWER")
	local param = {text = _text, size = 24}
	local powerLabel = createOutlineLabel(param)
	powerLabel:setPosition(118,16)
	sprite:addChild(powerLabel)

	self.powerLabel = createOutlineLabel({text = self.hero:getHeroTotalPower(),size = 30})
    self.powerLabel:setColor(cc.c3b(255,180,0))
    self.powerLabel:setPosition(122,40)
    bgSprite:addChild(self.powerLabel)
end

function HeroAbilityLayer:createAbilityView()
	self.ablBoard = display.newSprite(ablImage)
	self.ablBoard:setPosition(710,272)
	self:addChild(self.ablBoard)

	local title = display.newSprite(abilityWord)
	title:setPosition(128,449)
	self.ablBoard:addChild(title)

	self:updateAbilityView()
end

function HeroAbilityLayer:updateAbilityView()
	for i=1,#self.abilitys do
		local node = self.abilitys[i]
		node:removeFromParent()
		node = nil
	end
	self.abilitys = {}
	local types = {}
	local values = {}
	if self.hero.property.maxHp > 0 then
		table.insert(types,1)
		table.insert(values,self.hero.property.maxHp)
	end
	if self.hero.property.atk > 0 then
		table.insert(types,2)
		table.insert(values,self.hero.property.atk)
	end
	if self.hero.property.magicAtk > 0 then
		table.insert(types,3)
		table.insert(values,self.hero.property.magicAtk)
	end
	if self.hero.property.defense > 0 then
		table.insert(types,4)
		table.insert(values,self.hero.property.defense)
	end
	if self.hero.property.magicDefense > 0 then
		table.insert(types,5)
		table.insert(values,self.hero.property.magicDefense)
	end
	if self.hero.property.acp > 0 then
		table.insert(types,6)
		table.insert(values,self.hero.property.acp)
	end
	if self.hero.property.magicAcp > 0 then
		table.insert(types,7)
		table.insert(values,self.hero.property.magicAcp)
	end
	if self.hero.property.rate > 0 then
		table.insert(types,8)
		table.insert(values,self.hero.property.rate)
	end
	if self.hero.property.dodge > 0 then
		table.insert(types,9)
		table.insert(values,self.hero.property.dodge)
	end
	if self.hero.property.crit > 0 then
		table.insert(types,10)
		table.insert(values,self.hero.property.crit)
	end
	if self.hero.property.blood > 0 then
		table.insert(types,11)
		table.insert(values,self.hero.property.blood)
	end
	if self.hero.property.breakValue > 0 then
		table.insert(types,12)
		table.insert(values,self.hero.property.breakValue)
	end
	if self.hero.property.tumble > 0 then
		table.insert(types,13)
		table.insert(values,self.hero.property.tumble)
	end
	for i=1,#types do
		local stoneValue = HeroAbility.getStoneValue(self.hero,types[i])
		local equipValue = HeroAbility.getEquipValue(self.hero,types[i])
		local strValue = HeroAbility.getStrenValue(self.hero,types[i])
		local advValue = HeroAbility.getAdvanceValue(self.hero,types[i])
		local plusValue = HeroAbility.getPlusValue(self.hero,types[i])
		local totalValue = stoneValue+equipValue+strValue+advValue+plusValue
		local value = values[i] - totalValue

		local node = self:createAbilityLabel(types[i],value,totalValue)
		node:setPosition(40,(1-i)*25+414)
		self.ablBoard:addChild(node)
		table.insert(self.abilitys,node)
	end
	self.powerLabel:setString(self.hero:getHeroTotalPower())
end

function HeroAbilityLayer:createAbilityLabel(type_,value1,value2)
	value1 = math.ceil(value1)
	value2 = math.ceil(value2)
	local node = display.newNode()
	local text_ = ""
	if type_ == 1 then
		text_ = GET_TEXT_DATA("TEXT_HP")..":"..value1
	elseif type_ == 2 then
		text_ = GET_TEXT_DATA("TEXT_ATK")..":"..value1
	elseif type_ == 3 then
		text_ = GET_TEXT_DATA("TEXT_M_ATK")..":"..value1
	elseif type_ == 4 then
		text_ = GET_TEXT_DATA("TEXT_DEF")..":"..value1
	elseif type_ == 5 then
		text_ = GET_TEXT_DATA("TEXT_M_DEF")..":"..value1
	elseif type_ == 6 then
		text_ = GET_TEXT_DATA("TEXT_ACP")..":"..value1
	elseif type_ == 7 then
		text_ = GET_TEXT_DATA("TEXT_M_ACP")..":"..value1
	elseif type_ == 8 then
		text_ = GET_TEXT_DATA("TEXT_RATE")..":"..value1
	elseif type_ == 9 then
		text_ = GET_TEXT_DATA("TEXT_DODGE")..":"..value1
	elseif type_ == 10 then
		text_ = GET_TEXT_DATA("TEXT_CRIT")..":"..value1
	elseif type_ == 11 then
		text_ = GET_TEXT_DATA("TEXT_BLOOD")..":"..value1
	elseif type_ == 12 then
		text_ = GET_TEXT_DATA("TEXT_BREAKS")..":"..value1
	elseif type_ == 13 then
		text_ = GET_TEXT_DATA("TEXT_TUMBLE")..":"..value1
	end
	local param = {text = text_, size = 20, color = cc.c3b(255,234,177)}
	local label1 = display.newTTFLabel(param) -------去描边
	label1:pos(-15,0)
	label1:setAnchorPoint(0,0.5)
	node:addChild(label1)

	param = {text = " + "..value2, color = cc.c3b(15,164,0), size = 20}
	local label2 = display.newTTFLabel(param)
	label2:setPosition(label1:getContentSize().width,0)-------去描边
	label2:setAnchorPoint(0,0.5)
	node:addChild(label2)

	return node
end

return HeroAbilityLayer