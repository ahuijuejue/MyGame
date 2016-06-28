local ExpNode = class("ExpNode",function ()
	return display.newNode()
end)

local scheduler = require("framework.scheduler")

local boardImage = "Hero_Banner.png"
local dpsImage = "Job_Dps.png"
local tankImage = "Job_T.png"
local aidImage = "Job_Assistant.png"
local barBg = "Stone_Bar.png"
local expImage = "ExpMode_Slip.png"
local avatarBgImage = "HeroCircle%d.png"
local jobImage = "Job_Circle.png"

function ExpNode:ctor(hero)
	self.hero = clone(hero)
	self.useCount = 0
	self.expQueue = {}
	self.heroQueue = {}
	self.isLongTouch = false
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

function ExpNode:createHeroNode()
	local boardSprite = display.newSprite(boardImage)
	boardSprite:setAnchorPoint(0,0)

	local nameView = self:createNameView()
	nameView:setPosition(90,190)
	boardSprite:addChild(nameView,2)
	nameView:setColor(HERO_COLOR_RANGE[self.hero.strongLv+1])

	self.avatar = self:createAvatar()
	self.avatar:setPosition(90,110)
	boardSprite:addChild(self.avatar)

	self.expView = self:createExpView()
	self.expView:setPosition(94,27)
	boardSprite:addChild(self.expView)

	self:addChild(boardSprite)
	self:setContentSize(boardSprite:getContentSize())
end

function ExpNode:createAvatar()
	local bgSprite = createHeroCircle(self.hero.awakeLevel+1)
	local posX = bgSprite:getContentSize().width/2
	local posY = bgSprite:getContentSize().height/2

	local avatarSprite = display.newSprite(self.hero.avatarImage,nil,nil,{class=cc.FilteredSpriteWithOne})
	avatarSprite:setPosition(posX,posY)
	bgSprite:addChild(avatarSprite)

	local starView = createStarIcon(self.hero.starLv)
	starView:setPosition(15,15)
	bgSprite:addChild(starView)

	local typeSprite = self:createHeroTypeView()
	typeSprite:setPosition(10,100)
	bgSprite:addChild(typeSprite,2)

	return bgSprite
end

function ExpNode:createNameView()
	local param = {text = self.hero:getHeroName(), size = 24}
    local nameLabel = createOutlineLabel(param)
    return nameLabel
end

function ExpNode:createHeroTypeView()
	local imageName = self.hero.jobImage
	local sprite = display.newSprite(imageName)
	sprite:setPosition(23,23)

	local typeSprite = display.newSprite(jobImage)
	typeSprite:addChild(sprite)

	return typeSprite
end

function ExpNode:createExpView()
    local bgSprite = display.newSprite(barBg)

    local currentExp = GameExp.getCurrentExp(self.hero.exp)
	local totalExp = GameExp.getUpgradeExp(self.hero.exp)
    local percent = currentExp/totalExp

    local offsetX = bgSprite:getContentSize().width/2
    local offsetY = bgSprite:getContentSize().height/2

    self.expProgress = cc.ProgressTimer:create(display.newSprite(expImage))
    self.expProgress:setType(1)
    self.expProgress:setPosition(offsetX,offsetY)
    self.expProgress:setMidpoint(cc.p(0,1))
    self.expProgress:setBarChangeRate(cc.p(1, 0))

    self.expProgress:setPercentage(100*percent)
    bgSprite:addChild(self.expProgress)

	local param = {text = "", color = display.COLOR_WHITE, size = 22,x = offsetX, y = offsetY}
    self.lvLabel = createOutlineLabel(param)
    bgSprite:addChild(self.lvLabel,2)

    local param = {text = "", size = 22, color = cc.c3b(255,240,70)}
    self.limitLabel = createOutlineLabel(param)
    bgSprite:addChild(self.limitLabel,2)

    return bgSprite
end

function ExpNode:updateLvLabel(level)
	local text1 = "Lv."..level.."/"
	self.lvLabel:setString(text1)

	local text2 = GameExp.getLimitLevel()
	self.limitLabel:setString(text2)

	local offsetX = self.expView:getContentSize().width/2
    local offsetY = self.expView:getContentSize().height/2

    local width1 = self.lvLabel:getContentSize().width
    local width2 = self.limitLabel:getContentSize().width

    self.lvLabel:setPosition(offsetX-width2/2,offsetY)
    self.limitLabel:setPosition(offsetX+width1/2,offsetY)
end

function ExpNode:updateHeroExp()
	local lastExp = self.heroQueue[1]
	local tempLv = GameExp.getLevel(lastExp)
	local tempExp = lastExp

	local key = self.useItemId
	local exp = GameConfig.item[key].Content.exp
	lastExp = GameExp.getFinalExp(lastExp,exp)
	local lastLv = GameExp.getLevel(lastExp)

	local count = 0
	local unit = 5
	local times = lastLv - tempLv
	--经验前
	local percent1 = GameExp.getCurrentExp(tempExp)/GameExp.getUpgradeExp(tempExp)*100

	--经验后
	local percent2 = GameExp.getCurrentExp(lastExp)/GameExp.getUpgradeExp(lastExp)*100

	self.expHandle = scheduler.scheduleGlobal(function ()
		percent1 = percent1+unit
		if times > 0 then
			if count == times then
				if percent1 >= percent2 then
					percent1 = percent2
					scheduler.unscheduleGlobal(self.expHandle)
					self.expHandle = nil
					if #self.expQueue > 0 then
						self:executeExpQueue()
					end
				end
			else
				if percent1 >= 100 then
					percent1 = 0
					tempLv = tempLv + 1
					count = count + 1
					self:updateLvLabel(tempLv)
					AudioManage.playSound("LevelUp.mp3")
				end
			end
		else
			if percent1 >= percent2 then
				percent1 = percent2
				scheduler.unscheduleGlobal(self.expHandle)
				self.expHandle = nil
				if #self.expQueue > 0 then
					self:executeExpQueue()
				end
			end
		end
		self.expProgress:setPercentage(percent1)
	end,0)
end

function ExpNode:nodeOnTouch(event)
	local  point = {x = event.x, y =event.y}
	if event.name == "began" then
		if self:getSelectId() == -1 then
			return false
		end
		self.beganX = point.x
		self.beganY = point.y
		if self:touchInNode(point) then
			self.isTouchInNode = true
		    self.longTouchHandle = scheduler.performWithDelayGlobal(function ()
		    	self.isLongTouch = true
		    	self.delegate:setListTouchEnabled(false)
		    	self.longExpHandle = scheduler.scheduleGlobal(function ()
		    		if self:getSelectId() ~= -1 then
		    			if GameExp.isLimitExp(self.hero.exp) then
			    			self:removeLongExpTimer()
					        showToast({text = "已达最大等级", color = display.COLOR_RED, size = 28})
						else
							AudioManage.playSound("UseExpDrug.mp3")
							self.useCount = self.useCount + 1
							self:useExpItem()
						end
					end
		    	end,0.05)
		    end,0.5)
		end
		return self.isTouchInNode
	elseif event.name == "moved" then
		local moveX = point.x
		local moveY = point.y
		if math.abs(self.beganX - moveX) > 10 or math.abs(self.beganY - moveY) > 10 then
			self.isMoved = true
			self:removeLongTouchTimer()
		end
	elseif event.name == "ended" then
		if self.isLongTouch then
			if self.useCount > 0 then
				local heroId = self.hero.roleId
				local param = {param1 = heroId , param2 = self.useItemId, param3 = self.useCount}
				NetHandler.gameRequest("UseItem",param)
			end
			self.useCount = 0
			self.isLongTouch = false
			self:removeLongExpTimer()
			self.delegate:setListTouchEnabled(true)
		else
			if self.isTouchInNode and self:touchInNode(point) and not self.isMoved then
				AudioManage.playSound("UseExpDrug.mp3")
				if GameExp.isLimitExp(self.hero.exp) then
		       		showToast({text = "已达最大等级",color = display.COLOR_RED, size = 28})
				else
					self:useExpItem()
					local heroId = self.hero.roleId
					local param = {param1 = heroId , param2 = self.useItemId, param3 = 1}
					NetHandler.gameRequest("UseItem",param)
				end
			end
		end
		self:removeLongTouchTimer()
		self.isTouchInNode = false
		self.isMoved = false
	end
end

function ExpNode:getSelectId()
	return self.delegate.delegate.selectId
end

--使用经验物品
function ExpNode:useExpItem()
	self.useItemId = self:getSelectId()
	local key = tostring(self.useItemId)
	local exp = GameConfig.item[key].Content.exp

	showToast({text = GET_TEXT_DATA("TEXT_EXP")..exp,
						time = 0.3,
						x = self.avatar:getCascadeBoundingBox().x + 80,
						y = self.avatar:getCascadeBoundingBox().y + 170,
						})

	self:insertExpQueue()

	if self.expHandle == nil then
		self:executeExpQueue()
	end
	--更新英雄数据
	self.hero.exp = GameExp.getFinalExp(self.hero.exp,exp)
	self.hero:setLevel(GameExp.getLevel(self.hero.exp))
	self.delegate.delegate.expItemView:reduceExpItem()
end

--保存当前经验队列
function ExpNode:insertExpQueue()
	local heroExp = self.hero.exp
	--copy经验改变前英雄
	table.insert(self.heroQueue,heroExp)
	table.insert(self.expQueue,handler(self,self.updateHeroExp))
end

--执行经验队列 移除队列首位
function ExpNode:executeExpQueue()
	self.expQueue[1]()
	table.remove(self.heroQueue,1)
	table.remove(self.expQueue,1)
end

function ExpNode:removeLongExpTimer()
	if self.longExpHandle then
		scheduler.unscheduleGlobal(self.longExpHandle)
		self.longExpHandle = nil
	end
end

function ExpNode:removeLongTouchTimer()
	if self.longTouchHandle then
		scheduler.unscheduleGlobal(self.longTouchHandle)
		self.longTouchHandle = nil
	end
end

function ExpNode:touchInNode(point)
	return self.avatar:getCascadeBoundingBox():containsPoint(point)
end

function ExpNode:onEnter()
	self:updateLvLabel(self.hero.level)
end

function ExpNode:onExit()
	if self.expHandle then
		scheduler.unscheduleGlobal(self.expHandle)
		self.expHandle = nil
	end
end

return ExpNode