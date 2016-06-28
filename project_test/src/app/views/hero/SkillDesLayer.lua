local SkillDesLayer = class("SkillDesLayer",function ()
	return display.newColorLayer(cc.c4b(0,0,0,120))
end)

local NodeBox = import("app.ui.NodeBox")

local boxImage = "AwakeSkill_Banner.png"
local iconImage = "AwakeLevel%d.png"
local closeImage = "Close.png"

function SkillDesLayer:ctor(hero)
	self.hero = hero

	self.boxSprite = display.newSprite(boxImage)
	self.boxSprite:setPosition(display.cx,display.cy)
	self:addChild(self.boxSprite)

    self.boxSprite:setScale(0.3)
    local seq = transition.sequence({
    	cc.ScaleTo:create(0.15, 1.5),
    	cc.ScaleTo:create(0.05, 1.25)
    	})
    self.boxSprite:runAction(seq)

    local close = display.newSprite("Close.png")
    close:setScale(0.6)
    close:pos(self.boxSprite:getContentSize().width-15,self.boxSprite:getContentSize().height-10)
    close:addTo(self.boxSprite)

	self:createTitleView()
	self:createSkillDesBox()
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,handler(self,self.onTouch))
end

function SkillDesLayer:createTitleView()
	local awakeInfo = GameConfig.hero_awake[self.hero.roleId]

	local leaderSkillName = GET_TEXT_DATA("LEADER_SKILL")..awakeInfo.LeaderSkillName
	local param = {text = leaderSkillName, size = 22/1.25}
	local lTitleLabel = createOutlineLabel(param)
	lTitleLabel:setColor(cc.c3b(255,97,0))
	lTitleLabel:setPosition(145,335)
	self.boxSprite:addChild(lTitleLabel)

	local memberSkillName = GET_TEXT_DATA("MEMBER_SKILL")..awakeInfo.MemberSkillName
	local param = {text = memberSkillName, size = 22/1.25}
	local mTitleLabel = createOutlineLabel(param)
	mTitleLabel:setColor(cc.c3b(255,97,0))
	mTitleLabel:setPosition(400,335)
	self.boxSprite:addChild(mTitleLabel)
end

function SkillDesLayer:createSkillDesBox()
	local lNodes = {}
	local mNodes = {}
	local awakeInfo = GameConfig.hero_awake[self.hero.roleId]

	for i=1,AWAKE_EFFECT_COUNT do
		local key = string.format("Awake%d",i)
		local lDes = awakeInfo[key].LeaderDes.Description
		local mDes = awakeInfo[key].MemberDes.Description

		local lNode,lLabel = self:createSkillDes(i,lDes)
		if self.hero:lWaterTime() > 0 then
			lLabel:setColor(cc.c3b(255,97,0))
		else
			if i <= self.hero.strongLv then
				lLabel:setColor(cc.c3b(255,97,0))
			end
		end

		local mNode,mLabel = self:createSkillDes(i,mDes)
		if self.hero:mWaterTime() > 0 then
			mLabel:setColor(cc.c3b(255,97,0))
		else
			if i <= self.hero.strongLv then
				mLabel:setColor(cc.c3b(255,97,0))
			end
		end

		table.insert(lNodes,lNode)
		table.insert(mNodes,mNode)
	end

	local lBox = NodeBox.new()
	lBox:setPosition(62,175)
	lBox:setCellSize(cc.size(200,45))
	lBox:addElement(lNodes)
	self.boxSprite:addChild(lBox)

	local mBox = NodeBox.new()
	mBox:setPosition(315,175)
	mBox:setCellSize(cc.size(200,45))
	mBox:addElement(mNodes)
	self.boxSprite:addChild(mBox)
end

function SkillDesLayer:createSkillDes(index,des)
	local image = string.format(iconImage,index)
	local sprite = display.newSprite(image)
	sprite:setScale(0.8)

	local offsetX = sprite:getContentSize().width
	local offsetY = sprite:getContentSize().height

	local param = {text = des, size = 18}
	local label = createOutlineLabel(param)
	label:setAnchorPoint(0,0.5)
	label:setPosition(offsetX,offsetY/2)
    sprite:addChild(label)

    return sprite,label
end

function SkillDesLayer:onTouch(event)
	if event.name == "began" then
		return true
	elseif event.name == "ended" then
		if self.delegate then
			self.delegate:removeSkillDesView()
		end
	end
end

return SkillDesLayer