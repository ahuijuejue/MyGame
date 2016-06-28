local SkillUpNode = class("SkillUpNode",function ()
	return display.newNode()
end)

local CharacterModel = import("app.battle.model.CharacterModel")
local SkillDesNode = import(".SkillDesNode")
local scheduler = require("framework.scheduler")
local GafNode = import("app.ui.GafNode")

local soulImage = "Skill.png"
local numImage = "Banner_Level.png"
local greenImage1 = "Award_Button.png"
local greenImage2 = "Award_Button_Light.png"
local greenImage3 = "Button_Gray.png"
local skillCircle = "Skill_Circle.png"
local bgImage = "Skill_Bannerblue.png"
local bgImage1 = "Skill_Bannerred.png"
local lockImage = "Lock_Another.png"

function SkillUpNode:ctor(hero,index)
	self.hero = hero
	self.index = index
	self.skillId = hero.skills[index]

	local tempHeroId = tostring(tonumber(hero.roleId)+1)
	local config = GameConfig.character[tempHeroId]
	self.skillId2 = config[string.format("skill%d",index)]

	local image

	if index == 2 then
		image = bgImage1
	else
		image = bgImage
	end

	if index == 4 then
		self.info1 = GameConfig.skill_4[self.skillId]
		self.info2 = GameConfig.skill_4[self.skillId2]
	else
		self.info1 = GameConfig.skill[self.skillId]
		self.info2 = GameConfig.skill[self.skillId2]
	end

	self.boardSprite = display.newSprite(image)
	self:addChild(self.boardSprite)

	self:createSkillNode()
	self:createCostView()
	self:createLevelView()
	self:createUpBtn()

	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.nodeOnTouch))
end

function SkillUpNode:createSkillNode()
	local iconName = self.info1.image..".png"
	local icon1 = self:createSkillIcon(iconName)
	icon1:setPosition(45,328)
	self.boardSprite:addChild(icon1)


	local posX = icon1:getContentSize().width/2
	local posY = icon1:getContentSize().height/2

	self.lock1 = display.newSprite(lockImage)
	self.lock1:setPosition(posX,posY)
	icon1:addChild(self.lock1)

	local iconName = self.info2.image..".png"
	local icon2 = self:createSkillIcon(iconName)
	icon2:setPosition(83,290)
	self.boardSprite:addChild(icon2)

	local posX = icon2:getContentSize().width/2
	local posY = icon2:getContentSize().height/2

	self.lock2 = display.newSprite(lockImage)
	self.lock2:setPosition(posX,posY)
	icon2:addChild(self.lock2)

	local name = self.info1.name
	local label1 = createOutlineLabel({text = name, valign = ui.TEXT_VALIGN_TOP, dimensions = cc.size(1, 0), size = 18})
	label1:setAnchorPoint(0,1)
	label1:setPosition(25,285)
	self.boardSprite:addChild(label1)

	local name = self.info2.name
	local label2 = createOutlineLabel({text = name, valign = ui.TEXT_VALIGN_TOP, dimensions = cc.size(1, 0), size = 18})
	label2:setAnchorPoint(0,1)
	label2:setPosition(74,250)
	self.boardSprite:addChild(label2)
end

function SkillUpNode:createSkillIcon(file)
	local circle = display.newSprite(skillCircle)
	circle:setScale(0.7)

	local posX = circle:getContentSize().width/2
	local posY = circle:getContentSize().height/2

	local icon = display.newSprite(file)
	icon:setPosition(posX,posY)
	circle:addChild(icon)

	return circle
end

function SkillUpNode:createCostView()
	local level = self.hero.skillLevel[self.skillId]
	local consumeInfo = GameConfig.consume[tostring(level+1)]
	local key = string.format("SkillConsume_%d",self.index)
	local upCost = consumeInfo[key] * tonumber(self.info1.level_money)

	self.soulIcon = display.newSprite(soulImage)
	self.soulIcon:setScale(0.7)
	self.soulIcon:setPosition(20,98)
	self.boardSprite:addChild(self.soulIcon)

	self.costLabel = createOutlineLabel({text = upCost, size = 24})
	self.costLabel:setAnchorPoint(0,0.5)
	self.costLabel:setPosition(35,20)
	self.soulIcon:addChild(self.costLabel)

	self.tipLabel = display.newTTFLabel({text = "", size = 20, color = cc.c3b(93, 7, 0)})
	self.tipLabel:setPosition(67,98)
	self.boardSprite:addChild(self.tipLabel)
end

function SkillUpNode:createLevelView()
	local numBg = display.newSprite(numImage)
	numBg:setPosition(98,369)
	self.boardSprite:addChild(numBg)

	local level = self.hero.skillLevel[self.skillId]
	self.lvLabel = cc.Label:createWithCharMap("number.png",11,17,48)
	self.lvLabel:setPosition(23,24)
	self.lvLabel:setString(level)
	numBg:addChild(self.lvLabel)
end

function SkillUpNode:createUpBtn()
	self.upBtn = cc.ui.UIPushButton.new({normal = greenImage1, pressed = greenImage2, disabled = greenImage3})
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		if UserData:getSkillPoint() > 0 then
			local heroId = self.hero.roleId
			NetHandler.gameRequest("UpHeroSkillLevel",{param1 = heroId, param2 = self.skillId, param3 = self.index})
		else
			buySkillAlert()
		end
	end)
	self.upBtn:setScaleX(0.9)
	self.upBtn:setPosition(62,45)
	self.boardSprite:addChild(self.upBtn)

    self:setUpStatus()

	local label = createOutlineLabel({text = GET_TEXT_DATA("TEXT_UPGRADE"),size = 28})
	self.upBtn:setButtonLabel(label)
end

function SkillUpNode:updateView()
	local level = self.hero.skillLevel[self.skillId]
	local consumeInfo = GameConfig.consume[tostring(level+1)]
	local key = string.format("SkillConsume_%d",self.index)
	local upCost = consumeInfo[key] * tonumber(self.info1.level_money)

	self.costLabel:setString(upCost)
	self.lvLabel:setString(level)
	if self.delegate then
		self.delegate:updateUpStatus()
	end
end

function SkillUpNode:setUpStatus()
	local isLocked = false
	--判断技能开启状态
	if self.index == 2 and self.hero.starLv < 1 then
		isLocked = true
	elseif self.index == 3 and self.hero.starLv < 2 then
		isLocked = true
	elseif self.index == 4 and self.hero.starLv < 3 then
		isLocked = true
	end

	local level = self.hero.skillLevel[self.skillId]
	local consumeInfo = GameConfig.consume[tostring(level+1)]
	local key = string.format("SkillConsume_%d",self.index)
	local upCost = consumeInfo[key] * tonumber(self.info1.level_money)
	local maxLevel = tonumber(self.info1.level_max) * level + 1
	if maxLevel > self.hero.level or upCost > UserData.soul or isLocked then
		self.upBtn:setButtonEnabled(false)
		if self.effectNode then
		    self.effectNode:removeFromParent()
		    self.effectNode = nil
		end
	else
		self.lock1:setVisible(false)
		self.lock2:setVisible(false)
		self.tipLabel:setVisible(false)
		self.tipLabel:setString("")
		self.upBtn:setButtonEnabled(true)
		self.soulIcon:setVisible(true)
        if not self.effectNode then
        	local param = {gaf = "anniu_gaf"}
		    self.effectNode = GafNode.new(param)
		    self.effectNode:playAction("a1",true)
		    self.effectNode:setPosition(-5,-202)
		    self:addChild(self.effectNode)
        end
	end

	if isLocked then
		if self.index == 2 then
			self.soulIcon:setVisible(false)
			self.lock1:setVisible(false)
			self.lock2:setVisible(false)
			self.tipLabel:setVisible(true)
			self.tipLabel:setString("B级解锁升级")
		elseif self.index == 3 then
			self.soulIcon:setVisible(false)
			self.lock1:setVisible(true)
			self.lock2:setVisible(true)
			self.tipLabel:setVisible(true)
			self.tipLabel:setString("英雄B★开启")
		elseif self.index == 4 then
			self.soulIcon:setVisible(false)
			self.lock1:setVisible(true)
			self.lock2:setVisible(true)
			self.tipLabel:setVisible(true)
			self.tipLabel:setString("英雄A级开启")
		end
	else
		self.lock1:setVisible(false)
		self.lock2:setVisible(false)
		self.costLabel:setColor(display.COLOR_WHITE)
		if maxLevel > self.hero.level then
			self.soulIcon:setVisible(false)
			self.tipLabel:setVisible(true)
			self.tipLabel:setString(string.format("需要英雄%d级",maxLevel))
		elseif upCost > UserData.soul then
			self.costLabel:setColor(display.COLOR_RED)
		end
	end
end

function SkillUpNode:nodeOnTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		if self:touchInNode(point) then
			self:showSkillDes()
			self.isTouchInNode = true
		end
		return self.isTouchInNode
	elseif event.name == "ended" then
		if self.isTouchInNode then
    		self:hideSkillDes()
		end
		self.isTouchInNode = false
	end
end

function SkillUpNode:showSkillDes()
	local level = self.hero.skillLevel[self.skillId]
	self.skillDes = SkillDesNode.new(self.info1,self.info2,level)
	self.skillDes:setPosition(display.cx,display.bottom+20+self.skillDes.bgSprite:getContentSize().height/2)
	display.getRunningScene():addChild(self.skillDes)
end

function SkillUpNode:hideSkillDes()
	display.getRunningScene():removeChild(self.skillDes)
	self.skillDes = nil
end

function SkillUpNode:touchInNode(point)
	return self.boardSprite:getCascadeBoundingBox():containsPoint(point)
end

function SkillUpNode:lvUpEffect()
	local mSprite = display.newSprite("Skillback_light.png")
	self:addChild(mSprite, 99)

	local seq1 = transition.sequence({
				cc.FadeIn:create(0.1),
				cc.DelayTime:create(0.1),
				cc.FadeOut:create(0.1),
				})
	transition.execute(mSprite,seq1,{onComplete = function ()
		mSprite:removeFromParent(true)
	end})

	local fSprite = display.newSprite("Skillback_line.png")
	fSprite:setAnchorPoint(0,0)
	fSprite:setPosition(15,10)
	mSprite:addChild(fSprite)

	local moveY = mSprite:getContentSize().height- fSprite:getContentSize().height-10

	local seq2 = transition.sequence({
				cc.DelayTime:create(0.1),
				cc.MoveTo:create(0.1, cc.p(15,moveY)),
				})
	fSprite:runAction(seq2)
end

return SkillUpNode