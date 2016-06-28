local SummonItemNode = class("SummonItemNode",function()
    return display.newLayer()
end)

local itemBgImage = "AwakeStone%d.png"
local coinImage = "HeroStone.png"
local stuffImage = "Stuff.png"

function SummonItemNode:ctor(item,heroId,tag)
	self.isShowResult = false
	self.tag = tag
	self:updateItem(item,heroId)
end

function SummonItemNode:updateItem(item,heroId)
	self.heroId = heroId
	self.item = item
	if item ~= "nil" then
		self.image = item.imageName
		self.name = item.itemName
		self.quality = item.configQuality
		self.count = item.count
		self.type = item.type
	else
		assert(self.heroId ~= 0,"invalid heroId")
		local hero = HeroListData:getRoleWithId(self.heroId)
		self.image = hero.avatarImage
		self.name = hero.name
		self.quality = 8
		self.count = ""
	end
end

function SummonItemNode:createAwardSprite()
	local quality_ = getQualityLevel(self.quality)[1]

	local imageName = string.format(itemBgImage,self.quality)
    self.itemSprite = display.newSprite(imageName)
    self.itemSprite:setScale(0)
    self:addChild(self.itemSprite)

    local width = self.itemSprite:getContentSize().width
	local height = self.itemSprite:getContentSize().height

	self.iSprite = display.newSprite(self.image)
	self.iSprite:setPosition(width/2,height/2)
	self.itemSprite:addChild(self.iSprite)

	self.iLabel = createOutlineLabel({text = self.name,size = 18})
	self.iLabel:setPosition(60,-20)
	self.iLabel:setColor(COLOR_RANGE[quality_])
	self.itemSprite:addChild(self.iLabel)

	self.icLabel = createOutlineLabel({text = self.count,size = 18})
	self.icLabel:setPosition(110,10)
	self.itemSprite:addChild(self.icLabel)

	if self.type == 1 then
		local stone = display.newSprite(coinImage)
		stone:setPosition(20,100)
		self.itemSprite:addChild(stone)
	elseif self.type == 3 then
		local stuff = display.newSprite(stuffImage)
		stuff:setPosition(20,100)
		self.itemSprite:addChild(stuff)
	end

	if quality_ >= 3 then
		local effect = createAniEffect(quality_-2)
		effect:setPosition(width/2,height/2)
		self.itemSprite:addChild(effect,-1)
	end
end

function SummonItemNode:itemShowAnimation(callBack)
	if self.isShowResult then
		return
	end
	self.isShowResult = true
	self:createAwardSprite()
    if self.heroId ~= 0 then
    	AudioManage.playSound("Hero_Show.mp3")
    	local hero = HeroListData:getRoleWithId(self.heroId)
    	if self.item ~= "nil" then
		    self.isHave = true
		else
			self.isHave = false
		end
		local scene = app:pushToScene("HeroGetScene",false,{hero,self.isHave})
	else
		AudioManage.playSound("Item_Show.mp3")
    end
    local param = {scale =1, easing = "backOut",time = 0.3, onComplete = callBack}
	transition.scaleTo(self.itemSprite,param)
end

return SummonItemNode