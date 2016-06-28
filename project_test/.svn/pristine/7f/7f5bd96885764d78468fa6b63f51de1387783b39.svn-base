local EquipEnhanceLayer = class("EquipEnhanceLayer",function ()
    return display.newColorLayer(cc.c4b(0,0,0,200))
end)

local GafNode = import("app.ui.GafNode")
local NodeBox = import("app.ui.NodeBox")
local TabNode = import("app.ui.TabNode")
local MaterialNode = import(".MaterialNode")

local bgImage = "equip_enhance_bg.png"
local listImage = "equip_list_bg.png"
local selectImage = "equip_select.png"
local numBg = "Banner_Level.png"
local maxImage = "GearLv_Max.png"
local numImage = "number.png"
local awakeImage = "AwakeStone%d.png"
local starImage1 = "equip_star1.png"
local starImage2 = "equip_star2.png"
local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"
local pointImage = "Point_Red.png"
local lightImage1 = "equip_light_blue.png"
local lightImage2 = "equip_light_purle.png"
local attrWordImage = "equip_attr_word.png"
local attrBgImage = "equip_attr_bg.png"
local attrBgImage2 = "equip_attr_bg2.png"
local arrowImage = "equip_arrow.png"
local matBgImage = "equip_mat_bg.png"
local btnImage1 = "Button_EnterAttr.png"
local btnImage2 = "Button_EnterAttr_Light.png"
local btnImage3 = "Button_Gray1.png"
local cashImage = "Gold.png"
local matWordImage = "equip_mat_word.png"
local matWordImage2 = "equip_mat_word2.png"

function EquipEnhanceLayer:ctor(equips,index,hero)
	self.equips = equips
	self.hero = hero
	self.heroLv = hero.level
	self.viewIndex = 1
	self.selectIndex = index
	self.isTouchInBg = false

	self.bgSprite = display.newSprite(bgImage)
	self.bgSprite:setPosition(display.cx,display.cy)
	self:addChild(self.bgSprite)


	self:createTab()
	self:createEquipList()
	self:createNameLabel()
	self:createEnhNode()
	self:createAttrView()

	self:updatePoint()
	self:updateTab()
	self:updateNameLabel()
	self:updateSelectSprite()

	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.onTouch))
end

function EquipEnhanceLayer:createEquipList()
	self.equipNodes = {}
	for i,v in ipairs(self.equips) do
		local btn = cc.ui.UIPushButton.new({normal = listImage, pressed = listImage})
		:onButtonClicked(function ()
			if i ~= self.selectIndex then
				self.selectIndex = i
				self:updateSelectSprite()
				self:updateNameLabel()
				self:updatePoint()
				if self.viewIndex == 1 then
					self:createEnhNode()
					self:removePlusNode()
				elseif self.viewIndex == 2 then
					self:createPlusNode()
					self:removeEnhNode()
				end
			end
		end)

		local equipNode = self:createEquipNode(v,0.65)
		equipNode:setTag(1)
		btn:addChild(equipNode)

		local starNode = self:createEquipStar(v.star,0.4,14,14)
		starNode:setTag(2)
		starNode:setPosition(50,0)
		btn:addChild(starNode)

		self.equipNodes[i] = btn
	end

	local equipBox = NodeBox.new()
	equipBox:setCellSize(cc.size(142,82))
	equipBox:setSpace(0,5)
	equipBox:setUnit(1)
	equipBox:addElement(self.equipNodes)
	self.bgSprite:addChild(equipBox)

	local boxSize = equipBox:getBoxSize()
	equipBox:setPosition(93,532-boxSize.height/2)
end

function EquipEnhanceLayer:createEquipNode(equip,scale)
	local equipBox = display.newSprite(string.format(awakeImage,equip.configQuality))
	equipBox:setScale(scale)

	local posX = equipBox:getContentSize().width/2
	local posY = equipBox:getContentSize().height/2

	local icon = display.newSprite(equip.imageName)
	icon:setPosition(posX,posY)
	equipBox:addChild(icon)

	local lvSprite = display.newSprite(numBg)
	lvSprite:setPosition(0,30)
	equipBox:addChild(lvSprite)

	if equip.targetItem and equip.strLevel >= equip.levelLimit then
		local maxSprite = display.newSprite(maxImage)
		maxSprite:setPosition(23,23)
		lvSprite:addChild(maxSprite)
	else
		local numSprite = cc.Label:createWithCharMap("number.png",11,17,48)
		numSprite:setString(equip.strLevel)
		numSprite:setPosition(23,23)
		lvSprite:addChild(numSprite)
	end

	return equipBox
end

function EquipEnhanceLayer:createEquipStar(number,scale,width,height)
	local starNodes = {}
	for i=1,EQUIP_STAR_MAX do
		local star = display.newSprite(starImage2)
		star:setScale(scale)
		starNodes[i] = star

		if i <= number then
			local posX = star:getContentSize().width/2
			local posY = star:getContentSize().height/2

			local star2 = display.newSprite(starImage1)
			star2:setPosition(posX,posY)
			star:addChild(star2)
		end
	end
	local starBox = NodeBox.new()
	starBox:setCellSize(cc.size(width,height))
	starBox:setSpace(0,0)
	starBox:setUnit(1)
	starBox:addElement(starNodes)

	return starBox
end

function EquipEnhanceLayer:createTab()
    self.enhBtn = cc.ui.UIPushButton.new()
    :onButtonClicked(function ()
    	if self.viewIndex ~= 1 then
    		self.viewIndex = 1
    		self:updateTab()
    		self:createEnhNode()
    		self:removePlusNode()
    	end
    end)
    self.enhBtn:setPosition(781,450)
    self.enhBtn:setButtonLabel(createOutlineLabel({text = "强化",size = 30}))
    self.bgSprite:addChild(self.enhBtn)

    self.enhPoint = display.newSprite(pointImage)
    self.enhPoint:setPosition(50,20)
    -- self.enhPoint:setVisible(false)
    self.enhBtn:addChild(self.enhPoint)

    self.advBtn = cc.ui.UIPushButton.new()
    :onButtonClicked(function ()
    	if self.viewIndex ~= 2 then
    		self.viewIndex = 2
    		self:updateTab()
    		self:createPlusNode()
    		self:removeEnhNode()
    	end
    end)
    self.advBtn:setPosition(781,370)
    self.advBtn:setButtonLabel(createOutlineLabel({text = "加护",size = 30}))
    self.bgSprite:addChild(self.advBtn)

    self.advPoint = display.newSprite(pointImage)
    self.advPoint:setPosition(50,20)
    -- self.advPoint:setPosition(false)
    self.advBtn:addChild(self.advPoint)

    self.advBtn:setLocalZOrder(-1)
end

function EquipEnhanceLayer:updateTab()
	if self.viewIndex == 1 then
		self.enhBtn:setLocalZOrder(2)
	    self.enhBtn:setButtonImage("normal",tabPressImage)
	    self.enhBtn:setButtonImage("pressed",tabPressImage)

	    self.advBtn:setLocalZOrder(-1)
	    self.advBtn:setButtonImage("normal",tabNormalImage)
	    self.advBtn:setButtonImage("pressed",tabNormalImage)
	else
		self.enhBtn:setLocalZOrder(-1)
	    self.enhBtn:setButtonImage("normal",tabNormalImage)
	    self.enhBtn:setButtonImage("pressed",tabNormalImage)

	    self.advBtn:setLocalZOrder(2)
	    self.advBtn:setButtonImage("normal",tabPressImage)
	    self.advBtn:setButtonImage("pressed",tabPressImage)
	end
end

function EquipEnhanceLayer:createNameLabel()
	local param = {text = "",size = 22}
    self.nameLabel = createOutlineLabel(param)
    self.nameLabel:setPosition(315,505)
    self.bgSprite:addChild(self.nameLabel)
end

function EquipEnhanceLayer:createEnhNode()
	self:removeEnhNode()

	self.enhNode = display.newNode()
	self.bgSprite:addChild(self.enhNode)

	local equip = self.equips[self.selectIndex]
	local lightSprite = self:createLeftEquip(equip,lightImage1)
	lightSprite:setPosition(280,360)
	self.enhNode:addChild(lightSprite)

	self:createAttrView()
	self:createMatView()
	self:createBtn()
end

function EquipEnhanceLayer:createLeftEquip(equip,image)
	local lightSprite = display.newSprite(image)

	local equipSprite = self:createEquipNode(equip,0.8)
	equipSprite:setPosition(79,110)
	lightSprite:addChild(equipSprite)

	local action = cc.RepeatForever:create(cc.Sequence:create(
        cc.MoveBy:create(1, cc.p(0, -20)),
        cc.DelayTime:create(0.1),
        cc.MoveBy:create(1, cc.p(0, 20)),
        cc.DelayTime:create(0.1)
    ))
    equipSprite:runAction(action)

	local powerText = GET_TEXT_DATA("TEXT_POWER").."："..equip.power
    local powerLabel = createOutlineLabel({text = powerText,size = 20})
	powerLabel:setColor(cc.c3b(247,180,19))
    powerLabel:setPosition(79,-15)
    lightSprite:addChild(powerLabel)

    local starNode = self:createEquipStar(equip.star,1,36,36)
    starNode:setPosition(185,80)
	lightSprite:addChild(starNode)

	return lightSprite
end

function EquipEnhanceLayer:createAttrView()
	local equip = self.equips[self.selectIndex]

	local attrBg = display.newSprite(attrBgImage)
	attrBg:setPosition(570,380)

	local title = display.newSprite(attrWordImage)
	title:setPosition(153,220)
	attrBg:addChild(title)

	local arrow = display.newSprite(arrowImage)
	arrow:setPosition(153,98)
	attrBg:addChild(arrow)

	local wordLabel1 = createOutlineLabel({text = "当前属性",size = 20})
	wordLabel1:setPosition(80,170)
	wordLabel1:setColor(cc.c3b(247,180,19))
	attrBg:addChild(wordLabel1)

	--当前属性
	for i=1,#equip.types do
        local text = GET_ABILITY_TEXT(equip.types[i]).."+"..math.ceil(equip.abilitys[i])
        local param = {text = text, color = cc.c3b(242,188,164), size = 16}
	    local label = createOutlineLabel(param)
	    label:setAnchorPoint(0,0.5)
	    label:setPosition(8,-(i-1)*20+140)
	    attrBg:addChild(label)
    end

	if equip.targetItem and equip.strLevel >= equip.levelLimit then
		local wordLabel2 = createOutlineLabel({text = "进阶属性",size = 20})
		wordLabel2:setPosition(220,170)
		wordLabel2:setColor(cc.c3b(247,180,19))
		attrBg:addChild(wordLabel2)

		local advConfig = GameConfig.item[equip.targetItem]
		local types = advConfig.Content.Types
		local upgrades = advConfig.Content.Upgrades
		local basicValues = advConfig.Content.Values
		for i=1,#types do
			local ability = equip.strLevel * upgrades[i] + basicValues[i]
			local text = GET_ABILITY_TEXT(types[i]).."+"..math.ceil(ability)
	        local param = {text = text, color = cc.c3b(35,239,166), size = 16}
		    local label = createOutlineLabel(param)
		    label:setAnchorPoint(0,0.5)
		    label:setPosition(180,-(i-1)*20+140)
		    attrBg:addChild(label)
		end
	else
		local wordLabel2 = createOutlineLabel({text = "下一等级",size = 20})
		wordLabel2:setPosition(220,170)
		wordLabel2:setColor(cc.c3b(247,180,19))
		attrBg:addChild(wordLabel2)

		local tempEquip = clone(equip)
		tempEquip:upEquipLevel(1)
		for i=1,#tempEquip.types do
	    	local text = GET_ABILITY_TEXT(tempEquip.types[i]).."+"..math.ceil(tempEquip.abilitys[i])
	        local param = {text = text, color = cc.c3b(35,239,166), size = 16}
		    local label = createOutlineLabel(param)
		    label:setAnchorPoint(0,0.5)
		    label:setPosition(180,-(i-1)*20+140)
		    attrBg:addChild(label)
	    end
	    tempEquip = nil
	end    
	self.enhNode:addChild(attrBg)
end

function EquipEnhanceLayer:createMatView()
	local equip = self.equips[self.selectIndex]

	local matBg = display.newSprite(matBgImage)
	matBg:setPosition(450,175)
	self.enhNode:addChild(matBg)

	if equip.targetItem then
        local title = display.newSprite(matWordImage)
        title:setPosition(70,115)
        matBg:addChild(title)

        local  timess = equip.levelLimit
        local param = {text = string.format(GET_TEXT_DATA("TEXT_UP_TIP"),timess),size = 20}
        local tipLabel = createOutlineLabel(param)
        tipLabel:setPosition(350,115)
        tipLabel:setColor(cc.c3b(255,97,0))
        matBg:addChild(tipLabel)

        local advConfig = GameConfig.item[equip.targetItem]
        local ids = advConfig.Content.NeedItemID
        local nums = advConfig.Content.NeedItemNum
        local matNode = MaterialNode.new(ids,nums)
        matNode:setNodeCallback(showDropLayer)
        matNode:setPosition(262,55)
        matBg:addChild(matNode)
    else
        local maxLabel = display.newTTFLabel({text = GET_TEXT_DATA("TEXT_UP_MAX")})
        maxLabel:setPosition(262,70)
        matBg:addChild(maxLabel)
    end
end

function EquipEnhanceLayer:createBtn()
	local equip = self.equips[self.selectIndex]

	if equip.strLevel < equip.levelLimit then
		local cost1 = equip:oneCost(self.heroLv)
	    local costLabel1 = createOutlineLabel({text = formatNumber(cost1),size = 18})
		costLabel1:setPosition(560,60)
		costLabel1:setAnchorPoint(1,0.5)
		self.enhNode:addChild(costLabel1)

		if cost1 > UserData.gold then
	        costLabel1:setColor(display.COLOR_RED)
	    end

		local posX = 540 - costLabel1:getContentSize().width
		local posY = 60
		local icon1 = display.newSprite(cashImage)
		icon1:setPosition(posX,posY)
		icon1:setScale(0.8)
		self.enhNode:addChild(icon1)

		local cost2 = equip:moreCost(self.heroLv)
	    local costLabel2 = createOutlineLabel({text = formatNumber(cost2),size = 18})
		costLabel2:setPosition(310,60)
		costLabel2:setAnchorPoint(1,0.5)
		self.enhNode:addChild(costLabel2)

		if cost2 > UserData.gold then
			costLabel2:setColor(display.COLOR_RED)
		end

		local posX = 290 - costLabel2:getContentSize().width
		local posY = 60
		local icon2 = display.newSprite(cashImage)
		icon2:setPosition(posX,posY)
		icon2:setScale(0.8)
		self.enhNode:addChild(icon2)

	    local btn1 = cc.ui.UIPushButton.new({normal = btnImage1, pressed = btnImage2, disabled = btnImage3})
	    :onButtonClicked(handler(self,self.upEquip))
	    btn1:setPosition(630,60)
	    btn1:setScale(0.8)
	    btn1:setTag(1)
	    self.enhNode:addChild(btn1)

	    local label = createOutlineLabel({text = GET_TEXT_DATA("TEXT_STRENTH"),color = display.COLOR_WHITE,size = 30})
	    btn1:setButtonLabel(label)

	    local btn2 = cc.ui.UIPushButton.new({normal = btnImage1, pressed = btnImage2, disabled = btnImage3})
	    :onButtonClicked(handler(self,self.upEquip))
	    btn2:setPosition(380,60)
	    btn2:setScale(0.8)
	    btn2:setTag(2)
	    self.enhNode:addChild(btn2)

	    local times = equip:getUpTimes(self.heroLv)
	    local label = createOutlineLabel({text = string.format(GET_TEXT_DATA("TEXT_STRENTH_5"),times),color = display.COLOR_WHITE,size = 30})
	    btn2:setButtonLabel(label)
	else
		if equip.targetItem then
			local btn = cc.ui.UIPushButton.new({normal = btnImage1, pressed = btnImage2, disabled = btnImage3})
		    :onButtonClicked(handler(self,self.upEquip))
		    btn:setPosition(450,60)
		    btn:setScale(0.8)
		    btn:setTag(3)
		    self.enhNode:addChild(btn)

	    	local label = createOutlineLabel({text = GET_TEXT_DATA("TEXT_UP_EQUIP"),color = display.COLOR_WHITE, size = 30})
		    btn:setButtonLabel(label)

		    if GamePoint.matEnough(equip.targetItem) then
                local param = {gaf = "anniu_gaf"}
                local effectNode = GafNode.new(param)
                effectNode:playAction("a1",true)
                effectNode:setPosition(450,8)
               	effectNode:setScaleX(1.1)
                self.enhNode:addChild(effectNode)
            end
		end
	end
end

function EquipEnhanceLayer:removeEnhNode()
	if self.enhNode then
		self.enhNode:removeFromParent(true)
		self.enhNode = nil
	end
end

function EquipEnhanceLayer:enhEquipEffect()
	local aniSprite = display.newSprite()
	aniSprite:pos(280,380)
	aniSprite:setScale(0.7)
	aniSprite:addTo(self.enhNode)

    local animation = createAnimation("up%d.png",13,0.1)
    transition.playAnimationOnce(aniSprite,animation,true)
end

function EquipEnhanceLayer:createPlusNode()
	self:removePlusNode()

	self.plusNode = display.newNode()
	self.bgSprite:addChild(self.plusNode)

	local equip = self.equips[self.selectIndex]

	local equip1 = self:createLeftEquip(equip,lightImage1)
	equip1:setPosition(280,375)
	self.plusNode:addChild(equip1)

	local arrow1 = display.newSprite(arrowImage)
	arrow1:setPosition(455,375)
	self.plusNode:addChild(arrow1)

	if equip.star < 5 then
		local tempEquip = clone(equip)
		tempEquip:upEquipStar(1)
		local equip2 = self:createLeftEquip(tempEquip,lightImage2)
		equip2:setPosition(580,375)
		self.plusNode:addChild(equip2)

		tempEquip = nil
	end

	self:createPlusAttr()
	self:createPlusMatView()
end

function EquipEnhanceLayer:createPlusAttr()
	local attrBg = display.newSprite(attrBgImage2)
	attrBg:setPosition(468,215)
	self.plusNode:addChild(attrBg)

	local equip = self.equips[self.selectIndex]
	for i=1,#equip.types do
        local text = GET_ABILITY_TEXT(equip.types[i]).."+"..math.ceil(equip.abilitys[i])
        local param = {text = text, color = cc.c3b(242,188,164), size = 16}
	    local label = createOutlineLabel(param)
	    label:setAnchorPoint(0,0.5)
	    label:setPosition(30,-(i-1)*20+120)
	    attrBg:addChild(label)
    end

	local arrow = display.newSprite(arrowImage)
	arrow:setPosition(260,72)
	attrBg:addChild(arrow)

	if equip.star < 5 then
		local tempEquip = clone(equip)
		tempEquip:upEquipStar(1)
		for i=1,#tempEquip.types do
	        local text = GET_ABILITY_TEXT(tempEquip.types[i]).."+"..math.ceil(tempEquip.abilitys[i])
	        local param = {text = text, color = cc.c3b(35,239,166), size = 16}
		    local label = createOutlineLabel(param)
		    label:setAnchorPoint(0,0.5)
		    label:setPosition(330,-(i-1)*20+120)
		    attrBg:addChild(label)
	    end
	end
end

function EquipEnhanceLayer:createPlusMatView()
	local equip = self.equips[self.selectIndex]

	if equip.star < 5 then
        local title = display.newSprite(matWordImage2)
        title:setPosition(265,125)
        self.plusNode:addChild(title)

        local equipPos = GamePoint.getEquipPos(self.hero,equip:getLastUid())
        local config = GameConfig.Hero_equip_up[tostring(equip.star+1)]
        local ids = config[string.format("GearItemID%d",equipPos)]
        local nums = config[string.format("GearItemNum%d",equipPos)]
	    local cost = config["Cost"][equipPos]

        local matNode = MaterialNode.new(ids,nums)
        matNode:setNodeCallback(showDropLayer)
        matNode:setPosition(380,65)
        self.plusNode:addChild(matNode)

        local btn = cc.ui.UIPushButton.new({normal = btnImage1, pressed = btnImage2, disabled = btnImage3})
	    :onButtonClicked(handler(self,self.upEquip))
	    btn:setPosition(630,55)
	    btn:setScale(0.8)
	    btn:setTag(4)
	    self.plusNode:addChild(btn)

	    local label = createOutlineLabel({text = "加护",color = display.COLOR_WHITE,size = 30})
	    btn:setButtonLabel(label)

	    local costLabel = createOutlineLabel({text = formatNumber(cost),size = 18})
		costLabel:setPosition(620,100)
		costLabel:setAnchorPoint(0,0.5)
		self.plusNode:addChild(costLabel)

		if cost > UserData.gold then
	        costLabel:setColor(display.COLOR_RED)
	    end

		local icon = display.newSprite(cashImage)
		icon:setPosition(600,100)
		icon:setScale(0.8)
		self.plusNode:addChild(icon)

		if GamePoint.equipCanPlus(self.hero,equip) then
            local param = {gaf = "anniu_gaf"}
            local effectNode = GafNode.new(param)
            effectNode:playAction("a1",true)
            effectNode:setPosition(630,3)
           	effectNode:setScaleX(1.1)
            self.plusNode:addChild(effectNode)
        end
    else
        local maxLabel = display.newTTFLabel({text = GET_TEXT_DATA("TEXT_PLUS_MAX")})
        maxLabel:setPosition(460,70)
        self.plusNode:addChild(maxLabel)
    end
end

function EquipEnhanceLayer:plusEquipEffect()
	local aniSprite = display.newSprite()
	aniSprite:pos(280,400)
	aniSprite:setScale(0.7)
	aniSprite:addTo(self.plusNode)

    local animation = createAnimation("up%d.png",13,0.1)
    transition.playAnimationOnce(aniSprite,animation,true)
end

function EquipEnhanceLayer:removePlusNode()
	if self.plusNode then
		self.plusNode:removeFromParent(true)
		self.plusNode = nil
	end
end

function EquipEnhanceLayer:updateInfo()
	if self.viewIndex == 1 then
		self:createEnhNode()
	else
		self:createPlusNode()
	end
	self:updateSelectEquip()
	self:updatePoint()
end

function EquipEnhanceLayer:updatePoint()
	local equip = self.equips[self.selectIndex]
	self.enhPoint:setVisible(GamePoint.equipCanAdv(equip))
	self.advPoint:setVisible(GamePoint.equipCanPlus(self.hero,equip))
end

function EquipEnhanceLayer:updateNameLabel()
	local equip = self.equips[self.selectIndex]
	self.nameLabel:setString(equip.itemName)
	self.nameLabel:setColor(COLOR_RANGE[equip.quality])
end

function EquipEnhanceLayer:updateSelectSprite()
	if self.selectSprite then
		self.selectSprite:removeFromParent(true)
		self.selectSprite = nil
	end
	self.selectSprite = display.newSprite(selectImage)
	self.equipNodes[self.selectIndex]:addChild(self.selectSprite,2)
end

function EquipEnhanceLayer:updateSelectEquip()
	self.equipNodes[self.selectIndex]:removeChildByTag(1)
	self.equipNodes[self.selectIndex]:removeChildByTag(2)

	local equip = self.equips[self.selectIndex]
	local equipNode = self:createEquipNode(equip,0.65)
	equipNode:setTag(1)
	self.equipNodes[self.selectIndex]:addChild(equipNode)

	local starNode = self:createEquipStar(equip.star,0.4,14,14)
	starNode:setPosition(50,0)
	starNode:setTag(2)
	self.equipNodes[self.selectIndex]:addChild(starNode)
end

function EquipEnhanceLayer:upEquip(event)
    AudioManage.playSound("Click.mp3")
    local equip = self.equips[self.selectIndex]

    local tag = event.target:getTag()
    if tag == 3 then
    	if not GamePoint.matEnough(equip.targetItem) then
    		local param = {text = "进阶材料不足",size = 30,color = display.COLOR_RED}
	        showToast(param)
    		return
    	end
        if self.delegate then
            self.delegate:advHeroEquip(equip)
            self.delegate:removeEquipInfo()
        end
        return
    end

    if tag == 4 then
    	local equipPos = GamePoint.getEquipPos(self.hero,equip:getLastUid())
        local config = GameConfig.Hero_equip_up[tostring(equip.star+1)]
        local ids = config[string.format("GearItemID%d",equipPos)]
        local nums = config[string.format("GearItemNum%d",equipPos)]
	    local cost = config["Cost"][equipPos]
	    if cost > UserData.gold then
	    	local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
	        showToast(param)
	        return
	    end
	    for i,v in ipairs(nums) do
            local count = ItemData:getItemCountWithId(ids[i])
            if count < v then
            	local param = {text = "加护材料不足",size = 30,color = display.COLOR_RED}
		        showToast(param)
                return
            end
        end
        if self.delegate then
        	self.delegate:plusHeroEquip(equip)
        end
        return
    end

    if equip.strLevel >= self.heroLv then
        local param = {text = GET_TEXT_DATA("TEXT_STR_TIP"),size = 30,color = display.COLOR_RED}
        showToast(param)
        return 
    end

    if tag == 1 then
    	local cost = equip:oneCost(self.heroLv)
    	if cost > UserData.gold then
    		local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
	        showToast(param)
    		return    		
		end
		if self.delegate then
			self.delegate:strenHeroEquip(equip,1)
		end
    elseif tag == 2 then
    	local cost = equip:moreCost(self.heroLv)
    	if cost > UserData.gold then
    		local param = {text = GET_TEXT_DATA("MONEY_NOT_ENOUGH"),size = 30,color = display.COLOR_RED}
	        showToast(param)
    		return
    	end
    	if self.delegate then
			self.delegate:strenHeroEquip(equip,2)
		end
    end
end

function EquipEnhanceLayer:onTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		return true
	elseif event.name == "ended" then
		if not self:touchInBg(point) then
			if self.delegate then
				self.delegate:removeEquipInfo()
			end
		end
	end
end

function EquipEnhanceLayer:touchInBg(point)
	return cc.rectContainsPoint(self.bgSprite:getBoundingBox(),point)
end

return EquipEnhanceLayer