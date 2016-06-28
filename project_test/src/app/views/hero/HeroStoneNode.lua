local HeroStoneNode = class("HeroStoneNode",function ()
	return display.newNode()
end)

local btnImage = "AwakeStone%d.png"
local upImage = "AwakeStone_Up.png"
local tipImage = "AwakeStone_Up2.png"

function HeroStoneNode:ctor()
	self.button = cc.ui.UIPushButton.new()
	self:addChild(self.button)

	self.upArrow = display.newSprite(upImage)
	self.upArrow:setVisible(false)
	self.upArrow:setScale(1.5)
	self.button:addChild(self.upArrow,2)

	self.tipArrow = display.newSprite(tipImage)
	self.tipArrow:setVisible(false)
	self.tipArrow:setScale(1.5)
	self.button:addChild(self.tipArrow,2)

	self.stone = nil
end

function HeroStoneNode:setUpVisible(visible)
	self.upArrow:setVisible(visible)
	if visible then
		self:showTwinkleEffect(self.upArrow)
	end
end

function HeroStoneNode:setTipVisible(visible)
	self.tipArrow:setVisible(visible)
	if visible then
		self:showTwinkleEffect(self.tipArrow)
	end
end

function HeroStoneNode:showTwinkleEffect(params)
	params:setOpacity(0)
	params:stopAllActions()
	local act = transition.sequence({
        cc.FadeIn:create(0.5),
        cc.DelayTime:create(0.5),
        cc.FadeOut:create(0.5),
        })
    params:runAction(cc.RepeatForever:create(act))
end

function HeroStoneNode:setStoneFilter()
	if self.stone then
		local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
		self.stone:setFilter(filters)
	end
end

function HeroStoneNode:setBtnCallback(callback)
	self.button:onButtonClicked(callback)
end

function HeroStoneNode:setBtnTag(tag)
	self.button:setTag(tag)
end

function HeroStoneNode:setBtnImage(quality)
	local image = string.format(btnImage,quality)
	self.button:setButtonImage("normal",image)
	self.button:setButtonImage("pressed",image)
end

function HeroStoneNode:updateStone(stone,isExist)
	if self.stone then
		self.stone:removeFromParent(true)
		self.stone = nil
	end

	self.stone = display.newSprite(stone.imageName,nil,nil,{class=cc.FilteredSpriteWithOne})
	self.button:addChild(self.stone)


	local type_ = stone.content.Type
	local value_ = stone.content.Value
	local text = GET_ABILITY_TEXT(type_).."+"..math.ceil(value_)
	self.label = createOutlineLabel({text = text,size = 24,color = cc.c3b(80,239,0)})
	self.label:pos(55,-30)
	self.label:addTo(self.stone)
end

--融合灵石特效
function HeroStoneNode:showAddEffect()
	local aniSprite3 = display.newSprite()
	aniSprite3:setScale(1.5)
    aniSprite3:addTo(self,3)
    local animation = createAnimation("equip_2_%02d.png",19,0.06)
    transition.playAnimationOnce(aniSprite3,animation,true)
end

return HeroStoneNode