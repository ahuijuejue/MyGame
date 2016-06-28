local EquipLayer = class("EquipLayer",function ()
	return display.newNode()
end)

local boxImage = "Friends_Tips.png"
local infoImage = "Gear_Info.png"
local abilityImage = "Gear_ Attribute.png"
local closeImage = "Close.png"
local itemImage = "AwakeStone%d.png"
local personalImage = "Number_Circle2.png"
local maxImage = "GearLv_Max.png"
local lvImage = "Banner_Level.png"
local titleImage = "Box_Title.png"

function EquipLayer:ctor(equip)
	self:createBackView()
	self:createTitleView(equip)
	self:createEquipNode(equip)
	self:createPower(equip.power)
	self:createAttrView(equip)
end

function EquipLayer:createBackView()
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.backSprite = display.newSprite(boxImage)
    self.backSprite:setPosition(display.cx,display.cy)
    self:addChild(self.backSprite,2)
    self.backSprite:setScale(0.3)
    local seq = transition.sequence({
        cc.ScaleTo:create(0.15, 1.15),
        cc.ScaleTo:create(0.05, 1)
        })
    self.backSprite:runAction(seq)

    local attrBack = display.newSprite(abilityImage)
	attrBack:setPosition(264,130)
	self.backSprite:addChild(attrBack)

	local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
		AudioManage.playSound("Close.mp3")
        if self.delegate then
            self.delegate:removeEquipLayer()
        end
	end)
	closeBtn:setPosition(500,390)
	self.backSprite:addChild(closeBtn)
end

function EquipLayer:createTitleView(equip)
    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(264,385)
    self.backSprite:addChild(titleSprite)

    local param = {text = equip.itemName,size = 26}
    local nameLabel = createOutlineLabel(param)
   	nameLabel:setPosition(140,25)
    nameLabel:setColor(COLOR_RANGE[equip.quality])
    titleSprite:addChild(nameLabel)
end

function EquipLayer:createEquipNode(equip)
    local infoBack = display.newSprite(infoImage)
    infoBack:setPosition(264,280)
    self.backSprite:addChild(infoBack)

	local iconBg = createItemIcon(equip.itemId)
	iconBg:setPosition(40,45)
	infoBack:addChild(iconBg)

	local lvSprite = display.newSprite(lvImage)
	lvSprite:setPosition(-40,-40)
	iconBg:addChild(lvSprite)

	if equip.strLevel <= 0 then
		lvSprite:setVisible(false)
	end

	local posX = lvSprite:getContentSize().width/2
	local posY = lvSprite:getContentSize().height/2

	if equip.strLevel < equip.levelLimit then
		local numSprite = cc.Label:createWithCharMap("number.png",11,17,48)
		numSprite:setPosition(posX,posY)
		numSprite:setString(equip.strLevel)
		lvSprite:addChild(numSprite)
	else
		local maxSprite = display.newSprite(maxImage)
		maxSprite:setPosition(posX,posY)
		lvSprite:addChild(maxSprite)
	end

    if equip.equipType == 1 then
    	local markSprite = display.newSprite(personalImage)
		markSprite:setPosition(115,102)
		iconBg:addChild(markSprite,-1)

		local param = {text = GET_TEXT_DATA("TEXT_EXCLUSIVE"),size = 18}
		local label = display.newTTFLabel(param)
		label:setPosition(33,15)
		markSprite:addChild(label)
    end

    local desLabel = display.newTTFLabel({text = equip.desc,
        size = 20,
        align = cc.TEXT_ALIGNMENT_LEFT, 
        dimensions = cc.size(260, 60)})
    desLabel:setPosition(120,75)
    desLabel:setAnchorPoint(0,1)
    infoBack:addChild(desLabel)
end

function EquipLayer:createPower(power)
    local powerText = GET_TEXT_DATA("TEXT_POWER")..":"..power
    local powerLabel = display.newTTFLabel({text = powerText})
	powerLabel:setColor(cc.c3b(255,97,0))
    powerLabel:setAnchorPoint(1,0.5)
    powerLabel:setPosition(450,342)
    self.backSprite:addChild(powerLabel)
end

function EquipLayer:createAttrView(equip)
	for i=1,#equip.types do
		local text = GET_ABILITY_TEXT(equip.types[i]).."+"..math.ceil(equip.abilitys[i])
		local label = display.newTTFLabel({text = text,size = 22})
		label:setAnchorPoint(0,0.5)
		self.backSprite:addChild(label)

		local x = (i-1)%2
		local y = math.floor((i-1)/2)
		local posX = x * 190 + 80
		local posY = y * -28 + 175
		label:setPosition(posX,posY)
	end
end

return EquipLayer