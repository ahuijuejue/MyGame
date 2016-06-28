local HeroGetLayer = class("HeroGetLayer",function ()
	return display.newNode()
end)

local RoleLayer = import("..main.RoleLayer")
local GafNode = import("app.ui.GafNode")

local greenImage1 = "Button_Enter.png"
local greenImage2 = "Button_Enter_Light.png"
local titleImage = "Congratulation.png"
local nameImage = "Name_Bar.png"

function HeroGetLayer:ctor(hero)
    local param = {gaf = "card"}
    local effectNode = GafNode.new(param)
    effectNode:playAction("card",true)
    effectNode:setPosition(display.cx,display.cy)
    self:addChild(effectNode)

	local roleLayer = RoleLayer.new(hero.image)
	roleLayer:setPosition(display.cx,display.cy-60)
	self:addChild(roleLayer)

	local button = cc.ui.UIPushButton.new({normal = greenImage1,pressed = greenImage2})
	:onButtonClicked(function ()
        AudioManage.playSound("Click.mp3")
		app:popToScene()
	end)
	button:setPosition(display.cx,display.cy-230)
	self:addChild(button)

	local  param = {text = GET_TEXT_DATA("TEXT_SURE"),color = display.COLOR_WHITE}
    local label = display.newTTFLabel(param)
    button:setButtonLabel(label)

    local titleSprite = display.newSprite(titleImage)
    titleSprite:setPosition(display.cx,display.cy+200)
    self:addChild(titleSprite)

    local nameSprite = display.newSprite(nameImage)
    nameSprite:setPosition(display.cx,display.cy-150)
    self:addChild(nameSprite)

    local heroData   = GameConfig.Hero[hero.roleId]
    local starLv = tonumber(heroData.InitialSkillName)
    local starView = createStarIcon(starLv)
    starView:setPosition(display.cx-100,display.cy-30)
    self:addChild(starView)

    local nameLabel = createOutlineLabel({text = hero.name,size = 20})
    nameLabel:setPosition(137,48)
    nameLabel:setColor(HERO_COLOR_RANGE[1])
    nameSprite:addChild(nameLabel)

    local heroEnterSound = GameConfig.HeroSound[hero.roleId].enter_sound
    AudioManage.playSound(heroEnterSound)
end

return HeroGetLayer