--英雄展示

local HeroPictureLayer = class("HeroPictureLayer",function ()
	return display.newNode()
end)

local RoleLayer = import("..main.RoleLayer")
local NodeBox = import("app.ui.NodeBox")

local bgImage = "Hero_Show%d.png"
local plusImage = "hero_awake_plus.png"
local starImage = "Skill_Plus%d.png"

function HeroPictureLayer:ctor(hero)
	self.hero = hero

	self.backView = self:createBackground()
	self:addChild(self.backView)

	self.nameLabel = self:createNameView()
	self.nameLabel:setPosition(140,42)
	self.nameLabel:setColor(HERO_COLOR_RANGE[self.hero.strongLv+1])
	self.backView:addChild(self.nameLabel)

	self:createStarView()
	self:createLevelView()

	self.stoneBox = NodeBox.new()
	self.stoneBox:setCellSize(cc.size(30,30))
	self.stoneBox:setPosition(140,70)
	self.backView:addChild(self.stoneBox,10)

	local roleLayer = RoleLayer.new(hero.image)
	roleLayer:setPosition(135,90)
	self.backView:addChild(roleLayer)

	self:setTouchSwallowEnabled(false)
end

function HeroPictureLayer:createBackground()
	local image = string.format(bgImage,self.hero.strongLv)
	local bgSprite = display.newSprite(image)

	return bgSprite
end

function HeroPictureLayer:updateStoneView()
	local plusTab = {}
	local num = getAwakeLevel(self.hero.awakeLevel)[2]
	for i=1,num do
		local sprite = display.newSprite(plusImage)
		table.insert(plusTab,sprite)
	end
	self.stoneBox:cleanElement()
	self.stoneBox:setUnit(num)
	self.stoneBox:addElement(plusTab)
end

function HeroPictureLayer:createLevelView()
	local param = {text = self.hero.level.."/", size = 24}
    local lvLabel = createOutlineLabel(param)
    lvLabel:setPosition(150,360)
    lvLabel:setAnchorPoint(0,0.5)
    self.backView:addChild(lvLabel)

    local width = lvLabel:getContentSize().width
    local param = {text = GameExp.getLimitLevel(), size = 24, color = cc.c3b(255,240,70)}
    local limitLabel = createOutlineLabel(param)
    limitLabel:setPosition(150+width,360)
    limitLabel:setAnchorPoint(0,0.5)
    self.backView:addChild(limitLabel)
end

function HeroPictureLayer:createNameView()
	local param = {text = self.hero:getHeroName(), size = 22}
    local nameLabel = createOutlineLabel(param)

    return nameLabel
end

function HeroPictureLayer:createHeroTypeView()
	local imageName = nil
	if self.hero.roleType == 1 then
		imageName = tankImage
	elseif self.hero.roleType == 2 then
		imageName = dpsImage
	elseif self.hero.roleType == 3 then
		imageName = aidImage
	end
	local typeSprite = display.newSprite(imageName)
	return typeSprite
end

function HeroPictureLayer:createSwitchBtn()
    local param = {text = GET_TEXT_DATA("PIC_SPECIAL"),color = display.COLOR_WHITE, size = 30}
	local label = display.newTTFLabel(param)
	local btn = cc.ui.UIPushButton.new()
    :onButtonClicked(function ()
    	self.isNormal = not self.isNormal
    	if self.isNormal then
    		label:setString(GET_TEXT_DATA("PIC_SPECIAL"))
    	else
    		label:setString(GET_TEXT_DATA("PIC_NORMAL"))
    	end
    end)
    :setButtonLabel(label)
    return btn
end

function HeroPictureLayer:createStarView()
	if self.starView then
		self.starView:removeFromParent(true)
		self.starView = nil
	end
	local image = string.format(starImage,self.hero.starLv)
	self.starView = display.newSprite(image)
	self.starView:setPosition(45,345)
	self.backView:addChild(self.starView)
end

function HeroPictureLayer:updateHeroName()
	self.nameLabel:setString(self.hero:getHeroName())
	self.nameLabel:setColor(HERO_COLOR_RANGE[self.hero.strongLv+1])
	self:createStarView()
end

function HeroPictureLayer:updateHeroBackground()
	local image = string.format(bgImage,self.hero.strongLv)
	ResManage.loadImage(image)
	self.backView:setTexture(image)
	ResManage.removeImage(image)

	self:updateStoneView()
end

function HeroPictureLayer:awakeUpEffect(callback1,callback2)
	local aniSprite = display.newSprite()
    aniSprite:pos(140,210)
    aniSprite:setScale(2)
    aniSprite:addTo(self.backView)

    local animation1 = createAnimation("card_1_%02d.png",6,0.1)
    transition.playAnimationOnce(aniSprite,animation1,false,function ()
    	if callback1 then
    		callback1()
    	end
    	local animation2 = createAnimation("card_2_%02d.png",10,0.1)
	    transition.playAnimationOnce(aniSprite,animation2,true)
    end,0)
end

function HeroPictureLayer:addEquipEffect()
	local aniSprite = display.newSprite()
	aniSprite:pos(140,210)
	aniSprite:addTo(self.backView)  
    local animation = createAnimation("up%d.png",13,0.1)
    transition.playAnimationOnce(aniSprite,animation,true)
end

return HeroPictureLayer