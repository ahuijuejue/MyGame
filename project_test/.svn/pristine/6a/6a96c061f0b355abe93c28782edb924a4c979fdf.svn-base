local StoneLayer = class("StoneLayer",function ()
	return display.newColorLayer(cc.c4b(0,0,0,120))
end)

local boxImage = "Friends_Tips.png"
local infoImage = "Gear_Info.png"
local abilityImage = "Gear_ Attribute.png"
local closeImage = "Close.png"
local titleImage = "Box_Title.png"

function StoneLayer:ctor(stoneId)
	self.stone = ItemData:getItemConfig(stoneId)
	self:createBackView()
	self:createTitleView()
	self:createStoneNode()
	self:createAttrView()
	self:createPower()
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.onTouch))
end

function StoneLayer:createBackView()
    self.backSprite = display.newSprite(boxImage)
    self.backSprite:setPosition(display.cx,display.cy)
    self:addChild(self.backSprite,2)

    self.backSprite:setScale(0.3)
    local seq = transition.sequence({
    	cc.ScaleTo:create(0.15, 1.3),
    	cc.ScaleTo:create(0.05, 1)
    	})
    self.backSprite:runAction(seq)

    local attrBack = display.newSprite(abilityImage)
	attrBack:setPosition(264,130)
	self.backSprite:addChild(attrBack)
end

function StoneLayer:createTitleView()
    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(264,385)
    self.backSprite:addChild(titleSprite)

    local param = {text = self.stone.itemName,size = 26}
    local nameLabel = createOutlineLabel(param)
   	nameLabel:setPosition(140,25)
    nameLabel:setColor(COLOR_RANGE[self.stone.quality])
    titleSprite:addChild(nameLabel)
end

function StoneLayer:createStoneNode()
    local infoBack = display.newSprite(infoImage)
    infoBack:setPosition(264,270)
    self.backSprite:addChild(infoBack)

	local icon = createItemIcon(self.stone.itemId)
	icon:setPosition(40,45)
	infoBack:addChild(icon)

    local desLabel = display.newTTFLabel({text = self.stone.desc,
        size = 20,
        align = cc.TEXT_ALIGNMENT_LEFT, 
        dimensions = cc.size(260, 60)})
    desLabel:setPosition(120,75)
    desLabel:setAnchorPoint(0,1)
    infoBack:addChild(desLabel)
end

function StoneLayer:createPower()
	local power = 50*(1+(self.stone.quality-1)*0.5)
    local powerText = GET_TEXT_DATA("TEXT_POWER")..":"..power
    local powerLabel = display.newTTFLabel({text = powerText})
	powerLabel:setColor(cc.c3b(255,97,0))
    powerLabel:setAnchorPoint(1,0.5)
    powerLabel:setPosition(450,340)
    self.backSprite:addChild(powerLabel)
end

function StoneLayer:createAttrView()
	local type_ = self.stone.content.Type
	local value_ = self.stone.content.Value
	local text = GET_ABILITY_TEXT(type_).."+"..math.ceil(value_)
	local label = display.newTTFLabel({text = text,size = 22})
	label:setPosition(80,180)
	label:setAnchorPoint(0,0.5)
	self.backSprite:addChild(label)
end

function StoneLayer:onTouch(event)
	if event.name == "began" then
		return true
	elseif event.name == "ended" then
		if self.delegate then
			self.delegate:removeStoneLayer()
		end
	end
end

return StoneLayer