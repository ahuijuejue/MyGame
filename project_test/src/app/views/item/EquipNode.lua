local EquipNode = class("EquipNode",function ()
	return display.newNode()
end)

local GameEquip = import("app.data.GameEquip")

local awakeImage = "AwakeStone%d.png"
local nameBg = "Gear_Name.png"
local lockImage = "Lock_Another.png"
local numImage = "num_yellow.png"
local arrowImage = "tip_arrow_green.png"
local pointImage = "Point_Red.png"
local personalImage = "Number_Circle2.png"
local maxImage = "GearLv_Max.png"
local lvImage = "GearLv.png"
local numBg = "Banner_Level.png"

function EquipNode:ctor(type_)
	if type_ == 1 then
		self.scaleNum = 0.7
	elseif type_ == 2 then
		self.scaleNum = 1.0
	end
	self:createIcon()
	self:createLevel()
end

function EquipNode:createMark()
	local markSprite = display.newSprite(personalImage)
	if self.scaleNum == 1.0 then
		markSprite:setPosition(0,0)
	else
		markSprite:setPosition(50,28)
	end
	self:addChild(markSprite,-1)

	local param = {text = GET_TEXT_DATA("TEXT_EXCLUSIVE"),size = 18}
	local label = display.newTTFLabel(param)
	label:setPosition(33,15)
	markSprite:addChild(label)
end

function EquipNode:createLock()
	self.lockSprite = display.newSprite(lockImage)
	self.equipBtn:addChild(self.lockSprite)
end

function EquipNode:removeLock()
	if self.lockSprite then
		self.lockSprite:removeFromParent(true)
		self.lockSprite = nil
	end
end

function EquipNode:createArrow()
	self.arrowSprite = display.newSprite(arrowImage)
	self.arrowSprite:setPosition(35,-15)
	local seq = transition.sequence({
		cc.MoveBy:create(0.3, cc.p(0,20)),
        cc.MoveBy:create(0.3, cc.p(0,-20))
		})
	local rep = cc.RepeatForever:create(seq)
	self.arrowSprite:runAction(rep)
	self.arrowSprite:setVisible(false)
	self:addChild(self.arrowSprite,2)
end

function EquipNode:setCallBack(func)
	self.callBack = func or function() print("no func") end
end

function EquipNode:createNameView()
	self.nameBackSprite	= display.newSprite(nameBg)
	if self.scaleNum == 1.0 then
		self.nameBackSprite:setPosition(0,-80)
	else
		self.nameBackSprite:setPosition(0,-65)
	end
	self:addChild(self.nameBackSprite)

	self.nameLabel = createOutlineLabel({text = "",size = 20})
	self.nameLabel:setPosition(81,19)
	self.nameBackSprite:addChild(self.nameLabel)
end

function EquipNode:createIcon()
	self.point = display.newSprite(pointImage)
	self.point:setVisible(false)
	if self.scaleNum == 1.0 then
		self.point:setPosition(40,40)
	else
		self.point:setPosition(30,30)
	end
	self:addChild(self.point,2)

	self.equipBtn = cc.ui.UIPushButton.new()
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		if self.callBack then
			self.callBack()
		end
	end)
	self.equipBtn:setScale(self.scaleNum)
	self.equipBtn:setTouchSwallowEnabled(true)
	self:addChild(self.equipBtn)
end

function EquipNode:createEquipIcon(image)
	if self.icon then
		self.icon:removeFromParent(true)
		self.icon = nil
	end
	self.icon = display.newSprite(image,nil,nil,{class=cc.FilteredSpriteWithOne})
	self.equipBtn:addChild(self.icon)
end

function EquipNode:createLevel()
	self.lvSprite = display.newSprite(numBg)
	if self.scaleNum == 1.0 then
		self.lvSprite:setPosition(-45,-35)
	else
		self.lvSprite:setPosition(-40,-23)
	end
	self:addChild(self.lvSprite,2)
	
	self.numSprite = cc.Label:createWithCharMap("number.png",11,17,48)
	self.numSprite:setPosition(23,23)
	self.lvSprite:addChild(self.numSprite)

	self.maxSprite = display.newSprite(maxImage)
	self.maxSprite:setPosition(23,23)
	self.lvSprite:addChild(self.maxSprite)
end

function EquipNode:updateNode(equip)
	self:createEquipIcon(equip.imageName)
	local color
	if equip.count == 0 then
		color = cc.c3b(96,96,96)
		self.lvSprite:setVisible(false)
		local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
   		self.icon:setFilter(filters)
		self.equipBtn:setButtonImage("normal",string.format(awakeImage,0))
   		self.equipBtn:setButtonImage("pressed",string.format(awakeImage,0))
	else
		color = COLOR_RANGE[equip.quality]
		if equip.strLevel > 0 then
			self.lvSprite:setVisible(true)
		else
			self.lvSprite:setVisible(false)
		end
		if equip.strLevel < equip.levelLimit then			
			self.numSprite:setString(equip.strLevel)
			self.numSprite:setVisible(true)
			self.maxSprite:setVisible(false)
		else
			self.numSprite:setVisible(false)
			self.maxSprite:setVisible(true)
		end
		self.equipBtn:setButtonImage("normal",string.format(awakeImage,equip.configQuality))
   		self.equipBtn:setButtonImage("pressed",string.format(awakeImage,equip.configQuality))	
	end

	if self.nameLabel then
		self.nameLabel:setColor(color)
		self.nameLabel:setString(equip.itemName)
	end
end

function EquipNode:showStrEffect(type_)
	if type_ == 1 then
		local aniSprite1 = display.newSprite()
		aniSprite1:pos(-2,2)
		aniSprite1:setScale(0.7)
	    aniSprite1:addTo(self)
	    local animation = createAnimation("equip_1_%02d.png",13,0.03)
	    transition.playAnimationOnce(aniSprite1,animation,true)
	elseif type_ == 2 then
		local aniSprite1 = display.newSprite()
	    aniSprite1:addTo(self,3)
	    local animation = createAnimation("equip_2_%02d.png",19,0.06)
	    transition.playAnimationOnce(aniSprite1,animation,true)
	end	
end

return EquipNode