local HeroNode = class("HeroNode",function ()
	return display.newNode()
end)

local boardImage = "Hero_Banner.png"
local dpsImage = "Job_Dps.png"
local tankImage = "Job_T.png"
local aidImage = "Job_Assistant.png"
local stoneBarBg = "Stone_Bar.png"
local stoneImage = "Stone.png"
local expImage = "ExpMode_Slip.png"
local avatarBgImage = "HeroCircle%d.png"
local jobImage = "Job_Circle.png"
local pointImage = "Point_Red.png"

local StoneDropLayer = import("..item.StoneDropLayer")

function HeroNode:ctor(hero)
	self.hero = hero
	self:createHeroNode()
	self:setTouchEnabled(true)
	self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.nodeOnTouch))
	self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function HeroNode:createHeroNode()
	self.boardSprite = display.newSprite(boardImage)
	self.boardSprite:setAnchorPoint(0,0)

	self.nameView = self:createNameView()
	self.nameView:setPosition(90,190)
	self.boardSprite:addChild(self.nameView,2)

	self.point = display.newSprite(pointImage)
	self.point:setPosition(175,220)
	self.boardSprite:addChild(self.point,3)

	local __hero = HeroListData:getRoleWithId(self.hero.roleId)

	if __hero then
		self:createLevel()
		self.point:setVisible(GamePoint.heroSystemCanUpdate(self.hero))
	else
		self.point:setVisible(GamePoint.heroCanActive(self.hero))
		self.nameView:setColor(cc.c3b(96,96,96))

		self:createStoneView()
	end

	self:addChild(self.boardSprite)
end

function HeroNode:createAvatar()
	local __hero = HeroListData:getRoleWithId(self.hero.roleId)

	local bgImage = ""
	if __hero then
		bgImage = string.format(avatarBgImage,self.hero.awakeLevel+1)
	else
		bgImage = string.format(avatarBgImage,0)
	end

	local bgSprite = display.newSprite(bgImage)
	local posX = bgSprite:getContentSize().width/2
	local posY = bgSprite:getContentSize().height/2

	local avatarSprite = display.newSprite(self.hero.avatarImage,nil,nil,{class=cc.FilteredSpriteWithOne})
	avatarSprite:setPosition(posX,posY)
	bgSprite:addChild(avatarSprite)

	if not __hero then
		local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
   		avatarSprite:setFilter(filters)
	end

	local starView = createStarIcon(self.hero.starLv)
	starView:setPosition(15,15)
	bgSprite:addChild(starView)

	local typeSprite = self:createHeroTypeView()
	typeSprite:setPosition(10,100)
	bgSprite:addChild(typeSprite,2)

	return bgSprite
end

function HeroNode:createLevel()
	local bgSprite = display.newSprite(stoneBarBg)
	bgSprite:setPosition(94,27)

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    self.expProgress = cc.ProgressTimer:create(display.newSprite(expImage))
    self.expProgress:setType(1)
    self.expProgress:setPosition(offsetX,offsetY)
    self.expProgress:setMidpoint(cc.p(0,1))
    self.expProgress:setBarChangeRate(cc.p(1, 0))
    bgSprite:addChild(self.expProgress)

    local  param = {text = "", size = 22}
    self.lvLabel = createOutlineLabel(param)
    self.lvLabel:setPosition(offsetX,offsetY)
    bgSprite:addChild(self.lvLabel)

    self.boardSprite:addChild(bgSprite)
end

function HeroNode:createNameView()
	local param = {text = "", size = 24}
    local nameLabel = createOutlineLabel(param)
    return nameLabel
end

function HeroNode:createHeroTypeView()
	local imageName = self.hero.jobImage

	local sprite = display.newSprite(imageName)
	sprite:setPosition(23,23)

	local typeSprite = display.newSprite(jobImage)
	typeSprite:addChild(sprite)

	return typeSprite
end

function HeroNode:createStoneView()
    local bgSprite = display.newSprite(stoneBarBg)
    bgSprite:setPosition(94,27)
    self.boardSprite:addChild(bgSprite)

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    self.stoneProgress = cc.ProgressTimer:create(display.newSprite(stoneImage))
    self.stoneProgress:setType(1)
    self.stoneProgress:setPosition(offsetX,offsetY)
    self.stoneProgress:setMidpoint(cc.p(0,1))
    self.stoneProgress:setBarChangeRate(cc.p(1, 0))
    bgSprite:addChild(self.stoneProgress,1)

	local param = {text = "" ,color = display.COLOR_WHITE, size = 22,x = offsetX, y = offsetY}
    self.stoneLabel = createOutlineLabel(param)
    bgSprite:addChild(self.stoneLabel,2)
end

function HeroNode:createHeroDropView()
    local item = ItemData:getItemWithId(self.hero.stoneId)
    if not item then
    	item = ItemData:getItemConfig(self.hero.stoneId)
    end
	self.dropLayer = StoneDropLayer.new(item,self.hero)
	self.dropLayer.delegate = self
	display.getRunningScene():addChild(self.dropLayer,5)

	self.delegate:setListTouchEnabled(false)
end

function HeroNode:removeDropLayer()
	self.delegate:setListTouchEnabled(true)
	self.dropLayer:removeFromParent(true)
	self.dropLayer = nil
end

function HeroNode:update()
	local __hero = HeroListData:getRoleWithId(self.hero.roleId)
	if __hero then
	    local currentExp = GameExp.getCurrentExp(self.hero.exp)
		local totalExp = GameExp.getUpgradeExp(self.hero.exp)
	    local percent = currentExp/totalExp
	    self.expProgress:setPercentage(100*percent)
		self.lvLabel:setString("Lv."..self.hero.level)
		self.point:setVisible(GamePoint.heroSystemCanUpdate(self.hero))
		self.nameView:setColor(HERO_COLOR_RANGE[self.hero.strongLv+1])

		if self.avatar then
			self.avatar:removeFromParent(true)
			self.avatar = nil
		end
		self.avatar = self:createAvatar()
		self.avatar:setPosition(90,110)
		self.boardSprite:addChild(self.avatar)
	else
		self.point:setVisible(GamePoint.heroCanActive(self.hero))
        if GamePoint.heroCanActive(self.hero) then
            if not self.aniSprite_ then
	        	self.aniSprite_ = display.newSprite()
	        	self.aniSprite_:pos(93,107)
				self.aniSprite_:addTo(self,10)
			    local animation = createAnimation("coin%d.png",6,0.05)
			    transition.playAnimationForever(self.aniSprite_, animation)
		    end
        end
		if self.avatar then
			self.avatar:removeFromParent(true)
			self.avatar = nil
		end
		self.avatar = self:createAvatar()
		self.avatar:setPosition(90,110)
		self.boardSprite:addChild(self.avatar)

		local needNum = self.hero.stoneNum
	    local stoneNum = ItemData:getItemCountWithId(self.hero.stoneId)
	    local stoneText = nil
	    local percent = 0
	    if stoneNum >= needNum then
	    	stoneText = GET_TEXT_DATA("CLICK_SUMMON")
	    	percent = 1
		else
			stoneText = string.format("%d/%d",stoneNum,needNum)
			percent = stoneNum/needNum
	    end
	    self.stoneProgress:setPercentage(100*percent)
	    self.stoneLabel:setString(stoneText)
	    if self.dropLayer then
	    	self.dropLayer:updateStoneView()
	    end
	end
	self.nameView:setString(self.hero:getHeroName())
end

function HeroNode:nodeOnTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		self.beganX = point.x
		self.beganY = point.y
		if self:touchInNode(point) then
			self.isTouchInNode = true
		end
		return self.isTouchInNode
	elseif event.name == "moved" then
		local moveX = point.x
		local moveY = point.y
		if math.abs(self.beganX - moveX) > 10 or math.abs(self.beganY - moveY) > 10 then
			self.isTouchInNode = false
		end
	elseif event.name == "ended" then
		if self.isTouchInNode and self:touchInNode(point) then
			AudioManage.playSound("Click.mp3")
			local __hero = HeroListData:getRoleWithId(self.hero.roleId)
			local sharedDirector = cc.Director:getInstance()
			if __hero then
				app:pushToScene("HeroAwakeScene",false,{self.hero})
			else
				local needNum = self.hero.stoneNum
				local stoneNum = ItemData:getItemCountWithId(self.hero.stoneId)
    			if stoneNum >= needNum then
					NetHandler.gameRequest("SummonHero",{param1 = self.hero.roleId})
    			else
					self:createHeroDropView()
    			end
			end
		end
		self.isTouchInNode = false
	end
end

function HeroNode:touchInNode(point)
	return self.boardSprite:getCascadeBoundingBox():containsPoint(point)
end

function HeroNode:onEnter()
	self:update()
end

function HeroNode:onExit()
end

return HeroNode