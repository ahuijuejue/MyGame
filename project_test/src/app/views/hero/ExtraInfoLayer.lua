local ExtraInfoLayer = class("ExtraInfoLayer",function ()
	return display.newNode()
end)

local boxImage = "Friends_Tips.png"
local closeImage = "Close.png"
local infoImage = "Gear_Info.png"
local extraImage1 = "GearPlus_Award1.png"
local extraImage2 = "GearPlus_Award2.png"
local lvImage = "GearLv_Banner.png"
local titleImage = "Box_Title.png"

function ExtraInfoLayer:ctor()
	local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self:createBackView()
    self:createLabels()
    self:extraInfoView()

    local closeBtn = cc.ui.UIPushButton.new({normal = closeImage, pressed = closeImage})
	:onButtonClicked(function ()
		AudioManage.playSound("Close.mp3")
		self:removeFromParent(true)
	end)
	closeBtn:setPosition(500,390)
	self.backSprite:addChild(closeBtn)
end

function ExtraInfoLayer:createBackView()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

    self.backSprite = display.newSprite(boxImage)
    self.backSprite:setPosition(display.cx,display.cy)
    self:addChild(self.backSprite,2)

    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(264,385)
    self.backSprite:addChild(titleSprite)

    local  param = {text = "",size = 26}
	self.titleLabel = createOutlineLabel(param)
	self.titleLabel:setPosition(140,25)
	self.titleLabel:setColor(cc.c3b(255,97,0))
	titleSprite:addChild(self.titleLabel)
end

function ExtraInfoLayer:createLabels()
	local param = {text = "", color = display.COLOR_RED}
	self.desLabel = createOutlineLabel(param)
	self.desLabel:setPosition(257,90)
	self.backSprite:addChild(self.desLabel)
end

function ExtraInfoLayer:extraInfoView()
	self.info1 = display.newSprite(extraImage1)
	self.info1:setPosition(190,220)
	self.backSprite:addChild(self.info1,2)

	self.info2 = display.newSprite(extraImage2)
	self.info2:setPosition(350,220)
	self.backSprite:addChild(self.info2)
end

function ExtraInfoLayer:setTitle(text)
	self.titleLabel:setString(text)
end

function ExtraInfoLayer:setDes(text)
	self.desLabel:setString(text)
end

function ExtraInfoLayer:setInfo(hero,tag)
	local title = ""
	local des = ""
	local lv = 0
	local nextLv = 0
	local equipInfo = GameConfig.hero_equip[hero.roleId]

	if tag == 1 then
		lv = HeroAbility.getStrenLv(hero)
		nextLv = lv + 1
		title = GET_TEXT_DATA("TEXT_STREN_EXTRA")
		if lv == 0 then
			local  param = {text = GET_TEXT_DATA("TEXT_NO_EXTRA"), color = display.COLOR_WHITE, size = 20}
			local label = display.newTTFLabel(param)
			label:setPosition(80,63)
			self.info1:addChild(label)
		else
			local sprite = self:createLvSprite("Lv."..tostring(lv*10))
			self.info1:addChild(sprite)

			local types = equipInfo.Strengthen_type
			for i=1,#types do
				local value = equipInfo.Strengthen_value[i]*lv
				local label = self:createExtraLabel(types[i],value)
				label:setPosition(82,60+(1-i)*20)
				self.info1:addChild(label)
			end
		end
		if nextLv*10 > GameExp.getMaxLevel() then
			des = GET_TEXT_DATA("TEXT_STR_MAX")

			local  param = {text = GET_TEXT_DATA("TEXT_MAX"), color = display.COLOR_WHITE, size = 20}
			local label = display.newTTFLabel(param)
			label:setPosition(80,63)
			self.info1:addChild(label)
		else
			des = string.format(GET_TEXT_DATA("TEXT_STREN_DES"),nextLv*10)

			local nextSprite = self:createLvSprite("Lv."..tostring(nextLv*10))
			self.info2:addChild(nextSprite)

			local types = equipInfo.Strengthen_type
			for i=1,#types do
				local value = equipInfo.Strengthen_value[i]*nextLv
				local label = self:createExtraLabel(types[i],value)
				label:setPosition(82,60+(1-i)*20)
				label:setColor(display.COLOR_RED)
				self.info2:addChild(label)
			end
		end
	elseif tag == 2 then
		lv = HeroAbility.getAdvLv(hero)
		nextLv = lv + 1
		title = GET_TEXT_DATA("TEXT_ADV_EXTRA")

		if lv == 0 then
			local  param = {text = GET_TEXT_DATA("TEXT_NO_EXTRA"), color = display.COLOR_WHITE, size = 20}
			local label = display.newTTFLabel(param)
			label:setPosition(80,63)
			self.info1:addChild(label)
		else
			local nextSprite = self:createLvSprite(self:getFix(lv))
			self.info1:addChild(nextSprite)

			local types = string.split(equipInfo["Quality_type"][lv],":")
			local values = string.split(equipInfo["Quality_value"][lv],":")
			for i=1,#types do
				local label = self:createExtraLabel(types[i],values[i])
				label:setPosition(82,60+(1-i)*20)
				self.info1:addChild(label)
			end
		end

		if nextLv > 12 then
			des = GET_TEXT_DATA("TEXT_UP_MAX")

			local  param = {text = GET_TEXT_DATA("TEXT_MAX"), color = display.COLOR_WHITE, size = 20}
			local label = display.newTTFLabel(param)
			label:setPosition(80,63)
			self.info2:addChild(label)
		else	
			des = string.format(GET_TEXT_DATA("TEXT_ADV_DES"),self:getFix(nextLv))

			local nextSprite = self:createLvSprite(self:getFix(nextLv))
			self.info2:addChild(nextSprite)

			local types = string.split(equipInfo["Quality_type"][nextLv],":")
			local values = string.split(equipInfo["Quality_value"][nextLv],":")
			for i=1,#types do
				local label = self:createExtraLabel(types[i],values[i])
				label:setPosition(82,60+(1-i)*20)
				label:setColor(display.COLOR_RED)
				self.info2:addChild(label)
			end
		end
	elseif tag == 3 then
		lv = HeroAbility.getPlusLv(hero)
		nextLv = lv + 1
		title = GET_TEXT_DATA("TEXT_HOLD_EXTRA")
		if lv == 0 then
			local  param = {text = GET_TEXT_DATA("TEXT_NO_EXTRA"), color = display.COLOR_WHITE, size = 20}
			local label = display.newTTFLabel(param)
			label:setPosition(80,63)
			self.info1:addChild(label)
		else
			local sprite = self:createLvSprite(tostring(lv*5).."星")
			self.info1:addChild(sprite)

			local types = equipInfo.Equip_up_type
			for i=1,#types do
				local value = equipInfo.Equip_up_value[i]*lv
				local label = self:createExtraLabel(types[i],value)
				label:setPosition(82,60+(1-i)*20)
				self.info1:addChild(label)
			end
		end
		if nextLv > 6 then
			des = "已加护至最大"
			local  param = {text = GET_TEXT_DATA("TEXT_MAX"), color = display.COLOR_WHITE, size = 20}
			local label = display.newTTFLabel(param)
			label:setPosition(80,63)
			self.info2:addChild(label)
		else
			des = string.format("装备总星数到%d可增加额外属性",nextLv*5)

			local nextSprite = self:createLvSprite(tostring(nextLv*5).."星")
			self.info2:addChild(nextSprite)

			local types = equipInfo.Equip_up_type
			for i=1,#types do
				local value = equipInfo.Equip_up_value[i]*nextLv
				local label = self:createExtraLabel(types[i],value)
				label:setPosition(82,60+(1-i)*20)
				label:setColor(display.COLOR_RED)
				self.info2:addChild(label)
			end
		end
	end
	self:setTitle(title)
	self:setDes(des)
end

function ExtraInfoLayer:createLvSprite(text)
	local sprite = display.newSprite(lvImage)
	sprite:setPosition(82,95)

	local  param = {text = text, size = 20}
	local label = display.newTTFLabel(param)
	label:setPosition(57,18)
	sprite:addChild(label)

	return sprite
end

function ExtraInfoLayer:createExtraLabel(_type,value)
	_type = tonumber(_type)
	local text = GET_ABILITY_TEXT(_type).."+"..value
	local param = {text = text, size = 18}
	local label = display.newTTFLabel(param)
	return label
end

function ExtraInfoLayer:getFix(lv)
	local fix = ""
	local num = getQualityLevel(lv)[2]
	lv = getQualityLevel(lv)[1]
	if lv == 1 then
		fix = GET_TEXT_DATA("TEXT_WHITE")
	elseif lv == 2 then
		fix = GET_TEXT_DATA("TEXT_GREEN")
	elseif lv == 3 then
		fix = GET_TEXT_DATA("TEXT_BLUE")
	elseif lv == 4 then
		fix = GET_TEXT_DATA("TEXT_PURPLE")
	elseif lv == 5 then
		fix = GET_TEXT_DATA("TEXT_ORANGE")
	end
	if num>0 then
		fix = fix.."+"..num
	end
	return fix
end

return ExtraInfoLayer