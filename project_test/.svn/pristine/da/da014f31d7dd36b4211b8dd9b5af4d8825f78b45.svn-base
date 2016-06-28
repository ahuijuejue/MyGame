local StarUpLayer = class("StarUpLayer",function ()
	return display.newColorLayer(cc.c4b(0,0,0,180))
end)
local GafNode = import("app.ui.GafNode")

local labelBg = "Mail_ItemBar2.png"
local wordImage = "Skill_Plus%d.png"
local starBg = "Hero_Star_Circle.png"
local powerBg = "Word_Awake_Power.png"
local jBg1 = "Word_Star_1.png"
local jBg2 = "Word_Star_2.png"
local arrowImage = "Right_Arrow.png"
local skillCircle = "Skill_Circle.png"

function StarUpLayer:ctor(hero)
	self.hero = hero

	local heroEnterSound = GameConfig.HeroSound[self.hero.roleId].enter_sound
    AudioManage.playSound(heroEnterSound)

	local labelSprite = display.newSprite(labelBg)
	labelSprite:setScale(2)
	labelSprite:setPosition(display.cx,display.cy-205)
	self:addChild(labelSprite)
	transition.scaleTo(labelSprite, {scale = 1, time = 0.3 , easing = "elasticOut"})

	--名字
    local name1 = createOutlineLabel({text = self.hero:getHeroName(),size = 22,color = HERO_COLOR_RANGE[getAwakeLevel(self.hero.awakeLevel)[1]+1]})
	name1:pos(display.cx-150,display.cy-100)
	name1:addTo(self)

    local name2 = createOutlineLabel({text = self.hero:getHeroName(),size = 22,color = HERO_COLOR_RANGE[getAwakeLevel(self.hero.awakeLevel)[1]+1]})
	name2:pos(display.cx+150,display.cy-100)
	name2:addTo(self)

    --战斗力
    local powerArrow = display.newSprite(arrowImage)
    powerArrow:pos(330,120)
    powerArrow:setScaleY(0.6)
    powerArrow:addTo(labelSprite)

    local pSprite = display.newSprite(powerBg)
	pSprite:setPosition(90,120)
	labelSprite:addChild(pSprite)

	local power1 = base.Label.new({text = self.hero:getHeroTotalPower(self.hero.level,self.hero.starLv-1,self.hero.strongLv),size = 28,color = cc.c3b(80, 239, 0)})
	power1:pos(180,120)
	power1:addTo(labelSprite)

    local power2 = base.Label.new({text = self.hero:getHeroTotalPower(),size = 28,color = cc.c3b(80, 239, 0)})
	power2:pos(410,120)
	power2:addTo(labelSprite)

	--技能
	local sSprite = display.newSprite()
	sSprite:setPosition(107,60)
	labelSprite:addChild(sSprite)

    local node = display.newNode():pos(0,0):addTo(labelSprite)

	if self.hero.starLv <= 3 then
		sSprite:setTexture(jBg1)

        local posX = sSprite:getContentSize().width
		local skill1 = createOutlineLabel({text = "",size = 24,color = cc.c3b(252,189,38)})
		skill1:pos(posX+245,70)
		skill1:addTo(node)
		local skill2 = createOutlineLabel({text = "",size = 24,color = cc.c3b(252,189,38)})
		skill2:pos(posX+265,40)
		skill2:addTo(node)

        local spr1 = display.newSprite()
        spr1:pos(240,70)
        spr1:setScale(0.5)
        spr1:addTo(node,1)
        local spr2 = display.newSprite()
        spr2:pos(265,40)
        spr2:setScale(0.5)
        spr2:addTo(node,2)

        local circle1 = display.newSprite(skillCircle)
        circle1:pos(240,70)
        circle1:setScale(0.5)
        circle1:setVisible(false)
        circle1:addTo(node)
        local circle2 = display.newSprite(skillCircle)
        circle2:pos(265,40)
        circle2:setScale(0.5)
        circle2:setVisible(false)
        circle2:addTo(node,1)

        local tempHeroId = tostring(tonumber(self.hero.roleId)+1)
		local config = GameConfig.character[tempHeroId]

        if self.hero.starLv == 1 then
        	local skillId = self.hero.skills[3]
        	local skillId1 = config[string.format("skill%d",3)]
        	local info1 = GameConfig.skill[skillId]
			local info2 = GameConfig.skill[skillId1]
	        skill1:setString(info1.name)
	        skill2:setString(info2.name)
	        circle1:setVisible(true)
	        circle2:setVisible(true)
	        spr1:setTexture(info1.image..".png")
	        spr2:setTexture(info2.image..".png")
        elseif self.hero.starLv == 2 then
        	local skillId = self.hero.skills[2]
        	local skillId1 = config[string.format("skill%d",2)]
        	local info1 = GameConfig.skill[skillId]
			local info2 = GameConfig.skill[skillId1]
		    skill1:setString(info1.name)
		    skill2:setString(info2.name)
		    circle1:setVisible(true)
	        circle2:setVisible(true)
		    spr1:setTexture(info1.image..".png")
	        spr2:setTexture(info2.image..".png")
        elseif self.hero.starLv == 3 then
        	local skillId = self.hero.skills[4]
        	local skillId1 = config[string.format("skill%d",4)]
        	local info1 = GameConfig.skill_4[skillId]
			local info2 = GameConfig.skill_4[skillId1]
		    skill1:setString(info1.name)
		    skill2:setString(info2.name)
		    circle1:setVisible(true)
	        circle2:setVisible(true)
		    spr1:setTexture(info1.image..".png")
	        spr2:setTexture(info2.image..".png")
        end
	else
		sSprite:setTexture(jBg2)
		node:removeAllChildren()
		local skill = base.Label.new({text = "此功能未开放",size = 28,color = cc.c3b(80, 239, 0)})
		skill:pos(240,60)
		skill:addTo(node)
	end

    --hero
	local arrowSprite = display.newSprite(arrowImage)
	arrowSprite:setPosition(display.cx,display.cy-20)
	arrowSprite:setOpacity(0)
	local seq_ = transition.sequence({
		cc.DelayTime:create(0.6),
		cc.FadeIn:create(0.3)
	})
    arrowSprite:runAction(seq_)
	self:addChild(arrowSprite,1)

	local avatar1 = self:createAvatar(self.hero.awakeLevel+1)
	avatar1:setPosition(display.cx-150,display.cy-20)
	avatar1:setScale(0)
	local seq1 = transition.sequence({
		cc.ScaleTo:create(0.2,2.5),
        cc.ScaleTo:create(0.1,1),
		})
    avatar1:runAction(seq1)
    local aniSprite1 = display.newSprite()
    aniSprite1:setScale(1.5)
    aniSprite1:pos(60,75)
    aniSprite1:addTo(avatar1,3)
    local animation = createAnimation("equip_2_%02d.png",19,0.06)
    transition.playAnimationOnce(aniSprite1,animation,true,nil,0.2)
	self:addChild(avatar1,1)

	local avatar2 = self:createAvatar(self.hero.awakeLevel+1)
	avatar2:setPosition(display.cx+150,display.cy-20)
	avatar2:setScale(0)
	local seq = transition.sequence({
		cc.DelayTime:create(0.15),
		cc.ScaleTo:create(0.2,2.5),
        cc.ScaleTo:create(0.1,1)
		})
    avatar2:runAction(seq)
    local aniSprite1 = display.newSprite()
    aniSprite1:setScale(1.5)
    aniSprite1:pos(60,75)
    aniSprite1:addTo(avatar2,3)
    local animation = createAnimation("equip_2_%02d.png",19,0.06)
    transition.playAnimationOnce(aniSprite1,animation,true,nil,0.35)
	self:addChild(avatar2,1)

    local starBg1 = display.newSprite(starBg)
    starBg1:pos(20,25)
    starBg1:addTo(avatar1,4)
	local file = "Skill%d.png"
	local image = string.format(file,self.hero.starLv-1)
	if self.word1 then
		self.word1:removeFromParent(true)
		self.word1 = nil
	end
	self.word1 = display.newSprite(string.format(wordImage,self.hero.starLv-1))
	self.word1:pos(20,25)
	self.word1:setScale(0.5)
	self.word1:addTo(avatar1,5)

    local starBg2 = display.newSprite(starBg)
    starBg2:pos(20,25)
    starBg2:addTo(avatar2,4)
	local file = "Skill%d_Half.png"
	local image = string.format(file,self.hero.starLv)
	if self.word2 then
		self.word2:removeFromParent(true)
		self.word2 = nil
	end
	self.word2 = display.newSprite(string.format(wordImage,self.hero.starLv))
	self.word2:pos(20,25)
	self.word2:setScale(0.5)
	self.word2:addTo(avatar2,5)

	-- gaf动画特效
	local isFinished = false
	local param = {gaf = "star_gaf"}
    local effectNode = GafNode.new(param)
    effectNode:playAction("1",false)
    effectNode:setActCallback(function (name)
    		if name == "1" then
    			isFinished = true
    			effectNode:playAction("2",false)
    		elseif name == "2" then
    			effectNode:playAction("2",false)
    		end
        end)
    effectNode:setTouchEnabled(false)
    effectNode:setPosition(display.cx-80,display.cy-150)
    self:addChild(effectNode)

	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			return true
		elseif event.name == "ended" then
			if isFinished then
				if self.callback then
					self.callback()
				end
			end
		end
    end)
end

function StarUpLayer:createAvatar(level)
	local bgSprite = createHeroCircle(level)
	local posX = bgSprite:getContentSize().width/2
	local posY = bgSprite:getContentSize().height/2
	local avatarSprite = display.newSprite(self.hero.avatarImage)
	avatarSprite:setPosition(posX,posY)
	bgSprite:addChild(avatarSprite)
	return bgSprite
end

function StarUpLayer:setCallback(callback)
	self.callback = callback
end

return StarUpLayer