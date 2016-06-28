local EquipInfoLayer = class("EquipInfoLayer",function ()
    return display.newColorLayer(cc.c4b(0,0,0,100))
end)

local EquipNode = import(".EquipNode")
local TabNode = import("app.ui.TabNode")
local ItemDropLayer = import(".ItemDropLayer")
local boxImage = "Friends_TipsAttr.png"
local infoImage = "Gear_ Attribute.png"
local abilityImage = "Gear_ Attribute.png"
local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"
local titleImage = "Box_Title.png"
local pointImage = "Point_Red.png"

local greenImage1 = "Button_EnterAttr.png"
local greenImage2 = "Button_EnterAttr_Light.png"
local greenImage3 = "Button_Gray1.png"

local MaterialNode = import(".MaterialNode")
local GameEquip = import("app.data.GameEquip")
local CostNode = import("app.ui.CostNode")
local GafNode = import("app.ui.GafNode")
local strenImage1 = "Button_EnterAttr.png"
local strenImage2 = "Button_EnterAttr_Light.png"
local cashImage = "Gold.png"

local BUTTON_ID = {
	BUTTON_ATTR = 1,
	BUTTON_UP = 2,
}

function EquipInfoLayer:ctor(equip,heroLv)
	self.equip = equip
    self.heroLv = heroLv
	
    self:createBackView()
    self:createTitleView()
    self:createEquipNode(equip)
    self:createPower()
    self.attrList = {}
    for i=1,#equip.types do
        local label = self:createAttrLabel("")
        table.insert(self.attrList,label)
    end

    -- self.unloadBtn = self:createBtn(580,145,GET_TEXT_DATA("TEXT_UNLOAD"))
    -- self.exchangeBtn = self:createBtn(580,75,GET_TEXT_DATA("TEXT_EXCHANGE"))
    -- self.point = display.newSprite(pointImage)
    -- self.point:setPosition(37,23)
    -- self.exchangeBtn:addChild(self.point)
    -- self:setUnloadCallback(handler(self,self.unloadEquip))
    -- self:setExchangeCallback(handler(self,self.exchangeEquip))
    self.equip = equip
    self.heroLv = heroLv
    self:createBtns()
    self:createMatNode()
    self:updateNode()
    self:updateAttrNode(equip)
    self:setMatCallback(handler(self,self.showDropLayer))
    self:setNodeCallback(handler(self,self.upEquip))
end

function EquipInfoLayer:createBackView()
    self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
        local x, y, prevX, prevY = event.x, event.y, event.prevX, event.prevY
        if event.name == "began" then
            --判断点
            if not cc.rectContainsPoint(self.backSprite:getBoundingBox(),cc.p(event.x,event.y)) then
                if self.delegate then
                    self.delegate:removeEquipInfo()
                end
            end
        end
        return false
    end)

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
    attrBack:setPosition(252,100)
    self.backSprite:addChild(attrBack)
end

function EquipInfoLayer:createTitleView()
    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(260,385)
    self.backSprite:addChild(titleSprite)

    local param = {text = self.equip.itemName,size = 26}
    self.nameLabel = createOutlineLabel(param)
    self.nameLabel:setPosition(140,25)
    self.nameLabel:setColor(COLOR_RANGE[self.equip.quality])
    titleSprite:addChild(self.nameLabel)
end

function EquipInfoLayer:createPower()
    local powerText = GET_TEXT_DATA("TEXT_POWER")..":"..self.equip.power
    self.powerLabel = createOutlineLabel({text = powerText})
	self.powerLabel:setColor(cc.c3b(255,97,0))
    self.powerLabel:setAnchorPoint(1,0.5)
    self.powerLabel:setPosition(450,342)
    self.backSprite:addChild(self.powerLabel)
end

function EquipInfoLayer:createEquipNode(equip)
    local infoBack = display.newSprite(infoImage)
    infoBack:setPosition(250,260)
    self.backSprite:addChild(infoBack)

	self.equipNode = EquipNode.new(2)
    self.equipNode:setPosition(46,130)
    self.equipNode:updateNode(equip)
    self.equipNode.equipBtn:setButtonEnabled(false)
    if equip.equipType == 1 then
    	self.equipNode:createMark()
    end
    infoBack:addChild(self.equipNode)

end

function EquipInfoLayer:showDropLayer(item)
    if self.dropLayer then
        if self.dropLayer.item.itemId == item.itemId then
            return
        else
            self.dropLayer:removeFromParent(true)
            self.dropLayer = nil

            self.dropLayer = ItemDropLayer.new(item)
            self.dropLayer:setPosition(display.cx-70,display.cy-203)
            self:addChild(self.dropLayer,1)
        end
    else
        self.dropLayer = ItemDropLayer.new(item)

        self.dropLayer:setPosition(display.cx-70,display.cy)
        self:addChild(self.dropLayer,1)

        transition.moveBy(self.dropLayer, {x = 0, y = -203 ,time = 0.3})
        transition.moveBy(self.backSprite, {x = 0, y = 90 ,time = 0.3})  
    end
end

function EquipInfoLayer:removeDropLayer()
    if self.dropLayer then
        transition.moveBy(self.backSprite,{x = 0, y = -90, time = 0.3})
        transition.moveBy(self.dropLayer, {x = 0, y = 203 ,time = 0.3, onComplete = function ()
            self.dropLayer:removeFromParent(true)
            self.dropLayer = nil
        end})
    end
end

-- function EquipInfoLayer:showAttrPoint(visible)
	-- self.point:setVisible(visible)
-- end

function EquipInfoLayer:unloadEquip()
	if self.delegate then
		self.delegate:removeHeroEquip(self.equip)
        self.delegate:removeEquipInfo()
	end
end

function EquipInfoLayer:exchangeEquip()
	if self.delegate then
		self.delegate:showEquipListView(2)
        self.delegate:removeEquipInfo()
	end
end

function EquipInfoLayer:upEquip(event)
    AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    if tag == 3 then
        if self.delegate then
            self.delegate:advHeroEquip(self.equip)
            self.delegate:removeEquipInfo()
        end
        return
    end

    local heroLv = self.heroLv
    if self.equip.strLevel >= heroLv then
        local param = {text = GET_TEXT_DATA("TEXT_STR_TIP"),size = 30,color = display.COLOR_RED}
        showToast(param)
        return 
    end

    if self.delegate then
        if tag == 1 then
            self.delegate:strenHeroEquip(self.equip,1)
        elseif tag == 2 then
            self.delegate:strenHeroEquip(self.equip,2)
        end
    end
end

function EquipInfoLayer:updateInfo()
    self.equipNode:updateNode(self.equip)
    self:updateAttrNode(self.equip)
    self:updateNode()

    local powerText = GET_TEXT_DATA("TEXT_POWER")..":"..self.equip.power
    self.powerLabel:setString(powerText)
end

function EquipInfoLayer:createBtns()
    local btnParam = {normal = strenImage1, pressed = strenImage2, disabled = greenImage3}
    local labelParam = {text = GET_TEXT_DATA("TEXT_STRENTH"),color = display.COLOR_WHITE, size = 30}
    self.btn1 = CostNode.new(btnParam,labelParam,cashImage)
    self.btn1.icon:setPosition(-35,49)
    self.btn1.icon:setScale(1.1)
    self.btn1:setPosition(580,292)
    self.btn1:setScale(0.8)
    self.btn1:setTag(1)
    self.backSprite:addChild(self.btn1)

    labelParam = {text = "",color = display.COLOR_WHITE, size = 30}
    self.btn2 = CostNode.new(btnParam,labelParam,cashImage)
    self.btn2.icon:setPosition(-35,49)
    self.btn2.icon:setScale(1.1)
    self.btn2:setPosition(430,45)
    self.btn2:setTag(2)
    self.backSprite:addChild(self.btn2)

    local btnParam = {normal = greenImage1, pressed = greenImage2, disabled = greenImage3}
    labelParam = {text = GET_TEXT_DATA("TEXT_UP_EQUIP"),color = display.COLOR_WHITE, size = 30}
    self.btn3 = createButtonWithLabel(btnParam,labelParam)
    self.btn3:setPosition(580,220)
    self.btn3:setScale(0.8)
    self.btn3:setTag(3)
    self.backSprite:addChild(self.btn3)
end

function EquipInfoLayer:createMatNode()
    if self.equip.targetItem then
        local param = {text = GET_TEXT_DATA("TEXT_NEED_MAT"),size = 22}
        local titleLabel = createOutlineLabel(param)
        titleLabel:setPosition(100,145)
        self.backSprite:addChild(titleLabel)

        local  timess = self.equip.levelLimit
        local param = {text = string.format(GET_TEXT_DATA("TEXT_UP_TIP"),timess),size = 20}

        local tipLabel = createOutlineLabel(param)
        tipLabel:setPosition(320 ,145)
        tipLabel:setColor(cc.c3b(255,97,0))
        self.backSprite:addChild(tipLabel)

        local targetEquip = GameEquip.new({itemId = self.equip.targetItem})
        self.matNode = MaterialNode.new(targetEquip.needItem,targetEquip.needCount)
        self.matNode:setPosition(260,80)
        self.backSprite:addChild(self.matNode)
    else
        local maxLabel = display.newTTFLabel({text = GET_TEXT_DATA("TEXT_UP_MAX")})
        maxLabel:setPosition(264,100)
        self.backSprite:addChild(maxLabel)
    end
end

function EquipInfoLayer:hideSelected()
    if self.matNode then
        self.backSprite.matNode:resetNode()
    end
end

function EquipInfoLayer:setNodeCallback(call)
    self.btn1:onButtonClicked(call)
    self.btn2:onButtonClicked(call)
    self.btn3:onButtonClicked(call)
end

function EquipInfoLayer:setMatCallback(call)
    if self.matNode then
        self.matNode:setNodeCallback(call)
    end
end

function EquipInfoLayer:updateNode()
    local heroLv = self.heroLv
    local cost1 = self.equip:oneCost(heroLv)
    local cost2 = self.equip:moreCost(heroLv)
    local times = self.equip:getUpTimes(heroLv)
    self.btn1:setString(cost1)
    self.btn2:setString(cost2)

    self.btn2:setButtonLabelString(string.format(GET_TEXT_DATA("TEXT_STRENTH_5"),times))
    self.btn2:setPosition(580,212)
    self.btn2:setScale(0.8)
    if cost1 > UserData.gold then
        self.btn1:setButtonEnabled(false)
        self.btn1:setColor(display.COLOR_RED)
    else
        self.btn1:setButtonEnabled(true)
        self.btn1:setColor(display.COLOR_WHITE)
    end

    if cost2 > UserData.gold then
        self.btn2:setButtonEnabled(false)
        self.btn2:setColor(display.COLOR_RED)
    else
        self.btn2:setButtonEnabled(true)
        self.btn2:setColor(display.COLOR_WHITE)
    end

    if self.equip:isLimit() then
        self.btn1:setVisible(false)
        self.btn2:setVisible(false)
        if self.equip.targetItem then
            self.btn3:setVisible(true)
            self.btn3:setButtonEnabled(GamePoint.matEnough(self.equip.targetItem))
            if GamePoint.matEnough(self.equip.targetItem) then
                if not self.effectNode then
                    local param = {gaf = "anniu_gaf"}
                    self.effectNode = GafNode.new(param)
                    self.effectNode:playAction("a1",true)
                    self.effectNode:setGafPosition(579,169)
                    self.effectNode:setScaleX(1.1)
                    self.backSprite:addChild(self.effectNode)
                    self.effectNode:setTouchSwallowEnabled(true)
                end
            else
                if self.effectNode then
                    self.effectNode:removeFromParent()
                    self.effectNode = nil
                end
            end
        else
            if self.effectNode then
                self.effectNode:removeFromParent()
                self.effectNode = nil
            end
            self.btn3:setVisible(false)
        end
    else
        self.btn1:setVisible(true)
        self.btn2:setVisible(true)
        self.btn3:setVisible(false)
    end
    if self.matNode then
        self.matNode:updateMat()
    end
end

function EquipInfoLayer:createAttrLabel(str)
    local param = {text = str, color = display.COLOR_WHITE, size = 22}
    local label = display.newTTFLabel(param)
    label:setAnchorPoint(0,0.5)
    self.backSprite:addChild(label)
    return label
end

function EquipInfoLayer:createBtn(x,y,str)
    local button = cc.ui.UIPushButton.new({normal = greenImage1, pressed = greenImage2, disabled = greenImage3})
    button:setPosition(x,y)
    self.backSprite:addChild(button)

    local  param = {text = str,color = display.COLOR_WHITE,size = 30}
    local label = display.newTTFLabel(param)
    label:enableOutline(cc.c4b(59,30,18,255), 2) 
    button:setButtonLabel(label)
    button:setScale(0.8)
    return button
end

-- function EquipInfoLayer:setUnloadCallback(call)
--     self.unloadBtn:onButtonClicked(function ()
--         AudioManage.playSound("Click.mp3")
--         call()
--     end)
-- end

-- function EquipInfoLayer:setExchangeCallback(call)
--     self.exchangeBtn:onButtonClicked(function ()
--         AudioManage.playSound("Click.mp3")
--         call()
--     end)
-- end

function EquipInfoLayer:updateAttrNode(equip)
    for i=1,#equip.types do
        local text = GET_ABILITY_TEXT(equip.types[i]).."+"..math.ceil(equip.abilitys[i])
        self.attrList[i]:setString(text)
    end
    self:updatePos()
end

function EquipInfoLayer:updatePos()
    for i=1,#self.attrList do
        local x = (i-1)%2
        local y = math.floor((i-1)/2)
        local posX = x * 160+150
        local posY = 295 - y * 28
        self.attrList[i]:setPosition(posX,posY)
    end
end

return EquipInfoLayer