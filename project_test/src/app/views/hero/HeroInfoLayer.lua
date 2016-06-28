local HeroInfoLayer = class("HeroInfoLayer",function ()
	return display.newNode()
end)

local TabNode = import("app.ui.TabNode")
local HeroAwakeLayer = import(".HeroAwakeLayer")
local HeroSkillLayer = import(".HeroSkillLayer")
local HeroEquipLayer = import(".HeroEquipLayer")
local HeroAbilityLayer = import(".HeroAbilityLayer")
local HeroPictureLayer = import(".HeroPictureLayer")
local UserResLayer = import("..main.UserResLayer")

local tabPressImage = "Label_Select.png"
local tabNormalImage = "Label_Normal.png"
local pointImage = "Point_Red.png"
local bgImage = "HeroBoard.png"
local lockImage = "Label_Lock.png"

local BUTTON_ID = {
	BUTTON_HERO = 1,
	BUTTON_EQUIP = 2,
	BUTTON_SKILL = 3,
	BUTTON_ABILITY = 4,
}

local VIEW_ID = {
    VIEW_AWAKE = 1,
    VIEW_EQUIP = 2,
    VIEW_SKILL = 3,
    VIEW_ABILITY = 4
}

function HeroInfoLayer:ctor(hero)
	self.hero = hero
    self.btnEvent = handler(self,self.buttonEvent)

    self.backView = display.newSprite(bgImage)
    self.backView:setPosition(display.cx-50,display.cy-30)
    self:addChild(self.backView,2)

    self.heroView = HeroPictureLayer.new(self.hero)
    self.heroView:setPosition(175,365)
    self.backView:addChild(self.heroView,3)

    self.viewTag = 1
    self:createTabButton()
end

function HeroInfoLayer:createResLayer()
    if self.resLayer then
        self.resLayer:removeFromParent(true)
        self.resLayer = nil
    end
    if self.viewTag == 3 then
        self.resLayer = UserResLayer.new(7)
        self.resLayer:setPosition((display.width-760)/2,display.height-55)
        self:addChild(self.resLayer,3)
    else
        self.resLayer = UserResLayer.new(2)
        self.resLayer:setPosition((display.width-760)/2,display.height-55)
        self:addChild(self.resLayer,3)
    end
end

function HeroInfoLayer:hideViews()
    if self.viewTag == 1 then
        self.awakeView:setVisible(false)
    elseif self.viewTag == 2 then
        self.equipView:setVisible(false)
    elseif self.viewTag == 3 then
        self.skillView:setVisible(false)
    elseif self.viewTag == 4 then
        self.abilityView:setVisible(false)
    end
end

function HeroInfoLayer:createMenu()
	local backBtn = cc.ui.UIPushButton.new({normal = backImage, pressed = backImage})
    :onButtonClicked(self.btnEvent)
    backBtn:setTag(BUTTON_ID.BUTTON_BACK)
    self:addChild(backBtn,4)

    local posX = display.width - 55
    local posY = display.height - 45
    backBtn:setPosition(posX,posY)
end

function HeroInfoLayer:createTabButton()
    local param = {normal = tabNormalImage, pressed = tabPressImage, event = self.btnEvent}
    local heroTab = TabNode.new(param)
    heroTab:setPosition(display.cx+402,display.cy+170)
    heroTab:setTag(BUTTON_ID.BUTTON_HERO)
    heroTab:setString(GET_TEXT_DATA("TEXT_AWAKE"))
    self:addChild(heroTab)

    heroTab:setLocalZOrder(3)
    heroTab:setPressedStatus()

    local heroPoint = display.newSprite(pointImage)
    heroPoint:setPosition(50,20)
    heroPoint:setVisible(GamePoint.heroCanUpdate(self.hero))
    heroTab:addChild(heroPoint)

    local equipTab = TabNode.new(param)
    equipTab:setPosition(display.cx+402,display.cy+90)
    equipTab:setTag(BUTTON_ID.BUTTON_EQUIP)
    equipTab:setString(GET_TEXT_DATA("TEXT_EQUIP"))
    self:addChild(equipTab)

    local equipPoint = display.newSprite(pointImage)
    equipPoint:setPosition(50,20)
    equipPoint:setVisible(GamePoint.heroEquipCanUpdate(self.hero))
    equipTab:addChild(equipPoint)

    local skillTab = TabNode.new(param)
    skillTab:setPosition(display.cx+402,display.cy+10)
    skillTab:setTag(BUTTON_ID.BUTTON_SKILL)
    skillTab:setString(GET_TEXT_DATA("TEXT_SKILL"))
    self:addChild(skillTab)

    local skillPoint = display.newSprite(pointImage)
    skillPoint:setPosition(50,20)
    skillPoint:setVisible(GamePoint.heroSkillCanUpdate(self.hero))
    skillTab:addChild(skillPoint)

    local abilityTab = TabNode.new(param)
    abilityTab:setPosition(display.cx+402,display.cy-70)
    abilityTab:setTag(BUTTON_ID.BUTTON_ABILITY)
    abilityTab:setString(GET_TEXT_DATA("TEXT_ABILITY"))
    self:addChild(abilityTab)

    self.tabNodes = {heroTab,equipTab,skillTab,abilityTab}
    self.points = {heroPoint,equipPoint,skillPoint}
end

function HeroInfoLayer:updatePoint(index,visible)
    self.points[index]:setVisible(visible)
end

function HeroInfoLayer:updateSkillTab()
    if UserData:getUserLevel() >= OpenLvData.starUp.openLv then
        if self.skillLock then
            self.skillLock:removeFromParent(true)
            self.skillLock = nil
        end
    else
        if not self.skillLock then
            self.skillLock = display.newSprite(lockImage)
            self.tabNodes[3]:addChild(self.skillLock)
        end
    end
end

function HeroInfoLayer:updateHeroPic()
    self.heroView:updateHeroBackground()
    self.heroView:updateHeroName()
end

function HeroInfoLayer:resetTabStatus()
    for k in pairs(self.tabNodes) do
        self.tabNodes[k]:setNormalStatus()
        self.tabNodes[k]:setLocalZOrder(1)
    end
end

function HeroInfoLayer:createAwakeView()
    local layer = HeroAwakeLayer.new(self.hero)
    layer:setTag(VIEW_ID.VIEW_AWAKE)
    layer.delegate = self
    return layer
end

function HeroInfoLayer:createSkillView()
    local layer = HeroSkillLayer.new(self.hero)
    layer:setTag(VIEW_ID.VIEW_SKILL)
    layer.delegate = self
    return layer
end

function HeroInfoLayer:createEquipView()
    local layer = HeroEquipLayer.new(self.hero)
    layer:setTag(VIEW_ID.VIEW_EQUIP)
    layer.delegate = self
    return layer
end

function HeroInfoLayer:createAbilityView()
    local layer = HeroAbilityLayer.new(self.hero)
    layer:setTag(VIEW_ID.VIEW_ABILITY)
    return layer
end

function HeroInfoLayer:buttonEvent(event)
    AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    if tag == BUTTON_ID.BUTTON_SKILL then
        if UserData:getUserLevel() < OpenLvData.starUp.openLv then
            event.target:setNormalStatus()
            local param = {text = "战队"..OpenLvData.starUp.openLv.."级开启",size = 30,color = display.COLOR_RED}
            showToast(param)
            return
        end
    end
    self:resetTabStatus()
    event.target:setLocalZOrder(3)
    event.target:setPressedStatus()
    if tag == BUTTON_ID.BUTTON_HERO then
        self:showView(VIEW_ID.VIEW_AWAKE)
    elseif tag == BUTTON_ID.BUTTON_EQUIP then
        self:showView(VIEW_ID.VIEW_EQUIP)
    elseif tag == BUTTON_ID.BUTTON_SKILL then
        self:showView(VIEW_ID.VIEW_SKILL)
    elseif tag == BUTTON_ID.BUTTON_ABILITY then
        self:showView(VIEW_ID.VIEW_ABILITY)
    end
end

function HeroInfoLayer:showView(tag)
    if self.viewTag ~= tag then
        self:hideViews()
        self.viewTag = tag
        self:updateView()
    end
end

function HeroInfoLayer:updateView()
     if self.viewTag == VIEW_ID.VIEW_AWAKE then
        if self.awakeView then
            self.awakeView:setVisible(true)
            self.awakeView:updateView()
        else
            self.awakeView = self:createAwakeView()
            self.awakeView:updateView()
            self.backView:addChild(self.awakeView,2)
        end
    elseif self.viewTag == VIEW_ID.VIEW_EQUIP then
        if self.equipView then
            self.equipView:setVisible(true)
            self.equipView:updateEquipView()
        else
            self.equipView = self:createEquipView()
            self.equipView:updateEquipView()
            self.backView:addChild(self.equipView,2)
        end
    elseif self.viewTag == VIEW_ID.VIEW_SKILL then
        if self.skillView then
            self.skillView:setVisible(true)
            self.skillView:updateSkillView()
        else
            self.skillView = self:createSkillView()
            self.skillView:updateSkillView()
            self.backView:addChild(self.skillView,2)
        end
    elseif self.viewTag == VIEW_ID.VIEW_ABILITY then
        if self.abilityView then
            self.abilityView:setVisible(true)
            self.abilityView:updateAbilityView()
        else
            self.abilityView = self:createAbilityView()
            self.abilityView:updateAbilityView()
            self.backView:addChild(self.abilityView,2)
        end
    end
    self:createResLayer()
    self:updateSkillTab()
end

return HeroInfoLayer