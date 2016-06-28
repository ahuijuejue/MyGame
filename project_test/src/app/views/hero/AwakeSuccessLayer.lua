local AwakeSuccessLayer = class("AwakeSuccessLayer",function ()
	return display.newColorLayer(cc.c4b(0,0,0,180))
end)
local GafNode = import("app.ui.GafNode")

local leaderBg = "Word_Awake_LeaderSkill.png"
local memberBg = "Word_Awake_MemberSkill.png"
local labelBg = "Mail_ItemBar2.png"
local powerBg = "Word_Awake_Power.png"
local arrowImage = "Right_Arrow.png"
local arrowImage_ = "Star_Arrow.png"

function AwakeSuccessLayer:ctor(hero)
	self.hero = hero

	local heroEnterSound = GameConfig.HeroSound[self.hero.roleId].enter_sound
    AudioManage.playSound(heroEnterSound)

	local labelSprite = display.newSprite(labelBg)
	labelSprite:setScale(2)
	labelSprite:setPosition(display.cx,display.cy-205)
	self:addChild(labelSprite)
	transition.scaleTo(labelSprite, {scale = 1, time = 0.3 , easing = "elasticOut"})

	local lSprite = display.newSprite(leaderBg)
	lSprite:setPosition(90,85)
	labelSprite:addChild(lSprite)

	local mSprite = display.newSprite(memberBg)
	mSprite:setPosition(90,35)
	labelSprite:addChild(mSprite)

    --名字
    local name1 = createOutlineLabel({text = self.hero:getHeroName(self.hero.awakeLevel-1),size = 22,color = HERO_COLOR_RANGE[getAwakeLevel(self.hero.awakeLevel-1)[1]+1]})
	name1:pos(display.cx-150,display.cy-100)
	name1:addTo(self)

    local name2 = createOutlineLabel({text = self.hero:getHeroName(),size = 22,color = HERO_COLOR_RANGE[self.hero.strongLv+1]})
	name2:pos(display.cx+150,display.cy-100)
	name2:addTo(self)

    --战斗力
    local pSprite = display.newSprite(powerBg)
	pSprite:setPosition(90,135)
	labelSprite:addChild(pSprite)

	local powerArrow = display.newSprite(arrowImage)
    powerArrow:pos(325,135)
    powerArrow:setScaleY(0.6)
    powerArrow:addTo(labelSprite)

	local power1 = base.Label.new({text = self.hero:getHeroTotalPower(self.hero.level,self.hero.starLv,self.hero.awakeLevel-1),size = 28,color = cc.c3b(80, 239, 0)})
	power1:pos(180,135)
	power1:addTo(labelSprite)

    local power2 = base.Label.new({text = self.hero:getHeroTotalPower(),size = 28,color = cc.c3b(80, 239, 0)})
	power2:pos(390,135)
	power2:addTo(labelSprite)

	local awakeInfo = GameConfig.hero_awake[hero.roleId]
	local key = string.format("Awake%d",hero.strongLv)
	local lDes = awakeInfo[key].LeaderDes.Description
	local mDes = awakeInfo[key].MemberDes.Description

	local posX = lSprite:getContentSize().width
	local posY = lSprite:getContentSize().height/2
	local param = {text = lDes,color = cc.c3b(255, 44, 44) ,size = 28}
	local leaderLabel = createOutlineLabel(param)
	leaderLabel:setAnchorPoint(0,0.5)
	leaderLabel:setPosition(posX+10,posY)
	lSprite:addChild(leaderLabel)

	local posX = mSprite:getContentSize().width
	local posY = mSprite:getContentSize().height/2
	local param = {text = mDes,color = cc.c3b(52, 152, 255),size = 28}
	local memberLabel = createOutlineLabel(param)
	memberLabel:setAnchorPoint(0,0.5)
	memberLabel:setPosition(posX+10,posY)
	mSprite:addChild(memberLabel)

	-- gaf动画特效
	local isFinished = false
	local param = {gaf = "awke_gaf"}
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

	local arrowSprite = display.newSprite(arrowImage)
	arrowSprite:setPosition(display.cx,display.cy-20)
	arrowSprite:setOpacity(0)
	local seq_ = transition.sequence({
	cc.DelayTime:create(0.6),
	cc.FadeIn:create(0.3)
	})
    arrowSprite:runAction(seq_)
	self:addChild(arrowSprite)

	local avatar1 = self:createAvatar(hero.awakeLevel)
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
	self:addChild(avatar1)

	local avatar2 = self:createAvatar(hero.awakeLevel+1)
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
	self:addChild(avatar2)

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

function AwakeSuccessLayer:createAvatar(level)
	local bgSprite = createHeroCircle(level)
	local posX = bgSprite:getContentSize().width/2
	local posY = bgSprite:getContentSize().height/2
	local avatarSprite = display.newSprite(self.hero.avatarImage)
	avatarSprite:setPosition(posX,posY)
	bgSprite:addChild(avatarSprite)
	return bgSprite
end

function AwakeSuccessLayer:setCallback(callback)
	self.callback = callback
end

return AwakeSuccessLayer