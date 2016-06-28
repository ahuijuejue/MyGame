--英雄觉醒界面
local HeroAwakeLayer = class("HeroAwakeLayer",function ()
	return display.newNode()
end)

local HeroStoneNode = import(".HeroStoneNode")
local UseWaterLayer = import(".UseWaterLayer")
local SkillDesLayer = import(".SkillDesLayer")
local StoneLayer = import("..item.StoneLayer")
local StoneMergeLayer = import("..item.StoneMergeLayer")
local GafNode = import("app.ui.GafNode")

local magicImage = "Awake_Stone_Banner.png"
local arrowImage = "tip_arrow_green.png"
local iconImage = "Awake_Level_%d.png"
local rightImage = "Awake_Right_Arrow.png"
local infoImage = "Awake_Info_Button.png"
local lineImage = "Awake_Line.png"
local btnImage = "Awake_button.png"
local btnPressImage = "Awake_button.png"
local boardImage = "bg_001.png"
local leftBg = "Awake_BannerLeft.png"
local rightBg = "Awake_BannerRight.png"

local BUTTON_ID = {
    BUTTON_STONE_1 = 1,
    BUTTON_STONE_2 = 2,
    BUTTON_STONE_3 = 3,
    BUTTON_STONE_4 = 4,
    BUTTON_STONE_5 = 5,
    BUTTON_AWAKE = 6,
    BUTTON_ONE_CLICK = 7,
    BUTTON_DETAIL = 8,
}

function HeroAwakeLayer:ctor(hero)
	self.hero = hero
	self:createBoard()
	self:createStoneView()
	self:createDesView()
end

function HeroAwakeLayer:createBoard()
	local board = display.newSprite(boardImage)
	board:setPosition(438,273)
	self:addChild(board)

	--分割线
	local lineSprite = display.newSprite(lineImage)
	lineSprite:setPosition(580,170)
	self:addChild(lineSprite)
end

--创建镶嵌界面
function HeroAwakeLayer:createStoneView()
	self.backSprite = display.newSprite(magicImage)
	self.backSprite:setPosition(570,360)
	self:addChild(self.backSprite)

	self:createAwakeBtn()
	self:createStoneHole()
	self:createOneClickBtn()
end

--创建宝石孔
function HeroAwakeLayer:createStoneHole()
	self.stoneHoles = {}

	local x = self.backSprite:getContentSize().width/2
	local y = self.backSprite:getContentSize().height+5

	for i=1,STONE_INSERT_COUNT do
		local stoneNode = HeroStoneNode.new()
		stoneNode:setBtnTag(i)
		stoneNode:setBtnCallback(handler(self,self.buttonEvent))
		stoneNode:setScale(0.7)
		self.backSprite:addChild(stoneNode)
		table.insert(self.stoneHoles,stoneNode)

		if i == 1 then
			stoneNode:setPosition(x,y-35)
		elseif i == 2 then
			stoneNode:setPosition(x+182,y-110)
		elseif i == 3 then
			stoneNode:setPosition(x+100,y-247)
		elseif i == 4 then
			stoneNode:setPosition(x-112,y-245)
		elseif i == 5 then
			stoneNode:setPosition(x-182,y-110)
		end
	end
end

--创建觉醒按钮
function HeroAwakeLayer:createAwakeBtn()
	local x = self.backSprite:getContentSize().width/2
	local y = self.backSprite:getContentSize().height/2

	self.awakeBtn = cc.ui.UIPushButton.new()
	:onButtonClicked(handler(self,self.buttonEvent))
    self.awakeBtn:setTag(BUTTON_ID.BUTTON_AWAKE)
    self.awakeBtn:setPosition(x,y)
    self.backSprite:addChild(self.awakeBtn)

	local awakeInfo = GameConfig.hero_awake[self.hero.roleId]
    self.awakeIcon = display.newSprite(awakeInfo.AwakeIcon,nil,nil,{class=cc.FilteredSpriteWithOne})
    self.awakeBtn:addChild(self.awakeIcon)
end

--创建一键融合按钮
function HeroAwakeLayer:createOneClickBtn()
	local param1 = {normal = btnImage, pressed = btnPressImage}
	local param2 = {text = "",size = 20}
	self.oneClickBtn = createButtonWithLabel(param1,param2)
	self.oneClickBtn:onButtonClicked(handler(self,self.buttonEvent))
	self.oneClickBtn:setTag(BUTTON_ID.BUTTON_ONE_CLICK)
	self.oneClickBtn:setPosition(488,40)
	self.backSprite:addChild(self.oneClickBtn)
end

--创建觉醒描述
function HeroAwakeLayer:createDesView()
    local leftBack = display.newSprite(leftBg)
    leftBack:pos(178,99)
    leftBack:addTo(self)

	local arrowSprite = display.newSprite(rightImage)
	arrowSprite:setPosition(177,100)
	self:addChild(arrowSprite,2)

	self:createDesLabel()
end

function HeroAwakeLayer:createDesLabel()
    local desBack = display.newSprite(rightBg)
    desBack:setAnchorPoint(0,0.5)
    desBack:pos(317,99)
    desBack:addTo(self)

    local tip = base.Label.new({text = "每提升觉醒1级增加变身生命回复5%，并永久增加符石属性",size = 19,color = display.COLOR_RED,border = false})
    tip:setAnchorPoint(0,0.5)
    tip:pos(330,185)
    tip:addTo(self)

	local awakeInfo = GameConfig.hero_awake[self.hero.roleId]

	local leaderSkillName = GET_TEXT_DATA("LEADER_SKILL")..awakeInfo.LeaderSkillName
	local param = {text = leaderSkillName, size = 22, color = cc.c3b(255,240,70)}
	local lTitleLabel = createOutlineLabel(param)
	lTitleLabel:setAnchorPoint(0,0.5)
	lTitleLabel:setPosition(340,145)
	self:addChild(lTitleLabel,2)

	self.lSkillLabel = createOutlineLabel({text = "",size = 20})
	self.lSkillLabel:setAnchorPoint(0,0.5)
	self.lSkillLabel:setPosition(415,115)
	self:addChild(self.lSkillLabel,2)

    local MemberSkillIcon = display.newSprite(awakeInfo.MemberSkillIcon)
    MemberSkillIcon:setAnchorPoint(0,0.5)
    MemberSkillIcon:pos(350,72)
    MemberSkillIcon:addTo(self,2)

	local memberSkillName = GET_TEXT_DATA("MEMBER_SKILL")..awakeInfo.MemberSkillName
	local param = {text = memberSkillName, size = 22, color = cc.c3b(255,180,0)}
	local mTitleLabel = createOutlineLabel(param)
	mTitleLabel:setAnchorPoint(0,0.5)
	mTitleLabel:setPosition(415,85)
	self:addChild(mTitleLabel,2)

	self.mSkillLabel = createOutlineLabel({text = "",size = 20})
	self.mSkillLabel:setAnchorPoint(0,0.5)
	self.mSkillLabel:setPosition(485,55)
	self:addChild(self.mSkillLabel,2)

	local desBtn = cc.ui.UIPushButton.new({normal = infoImage, pressed = infoImage})
	desBtn:setTag(BUTTON_ID.BUTTON_DETAIL)
	desBtn:setPosition(788,70)
	desBtn:onButtonClicked(handler(self,self.buttonEvent))
	self:addChild(desBtn,2)
end

function HeroAwakeLayer:updateDesLabel()
	if self.hero.strongLv == 0 then
		self.lSkillLabel:setString(GET_TEXT_DATA("NOT_ACTIVATE"))
		self.mSkillLabel:setString(GET_TEXT_DATA("NOT_ACTIVATE"))
	else
		local awakeInfo = GameConfig.hero_awake[self.hero.roleId]
		local key = string.format("Awake%d",self.hero.strongLv)
		local lDes = awakeInfo[key].LeaderDes.Description
		self.lSkillLabel:setString(lDes)

		local mDes = awakeInfo[key].MemberDes.Description
		self.mSkillLabel:setString(mDes)
	end
end

function HeroAwakeLayer:updateAwakeIcon()
	if self.awakeIcon1 then
		self.awakeIcon1:removeFromParent(true)
		self.awakeIcon1 = nil
	end

	if self.awakeIcon2 then
		self.awakeIcon2:removeFromParent(true)
		self.awakeIcon2 = nil
	end

	local image1 = string.format(iconImage,self.hero.strongLv)
	self.awakeIcon1 = display.newSprite(image1)
	self.awakeIcon1:setPosition(95,100)
	self:addChild(self.awakeIcon1,2)

	local image2 = string.format(iconImage,self.hero.strongLv+1)
	self.awakeIcon2 = display.newSprite(image2)
	self.awakeIcon2:setPosition(260,100)
	self:addChild(self.awakeIcon2,2)
end

function HeroAwakeLayer:updateAwakeBtn()
	local image = string.format("HeroCircle%d.png",self.hero.awakeLevel+1)
	self.awakeBtn:setButtonImage("normal",image)
	self.awakeBtn:setButtonImage("pressed",image)

	if GamePoint.heroCanAwake(self.hero) then  --添加觉醒按钮特效
		if not self.aniSprite then
			local x = self.backSprite:getContentSize().width/2
			local y = self.backSprite:getContentSize().height/2-20
			local param = {gaf = "equip_awke"}
			self.aniSprite = GafNode.new(param)
			self.aniSprite:playAction("1",true)
			self.aniSprite:setGafPosition(x,y)
			self.backSprite:addChild(self.aniSprite,1)
		end
    else
    	if self.aniSprite then
    	    self.aniSprite:removeFromParent(true)
    	    self.aniSprite = nil
    	end
    end

	if self.hero.strongLv >= 1 then
		self.awakeIcon:clearFilter()
	else
		local filters = filter.newFilter("GRAY",{0.2, 0.3, 0.5, 0.1})
   		self.awakeIcon:setFilter(filters)
	end
end

function HeroAwakeLayer:updateStoneHole()
	for i,v in ipairs(self.hero.stones) do
		self.stoneHoles[i]:setUpVisible(GamePoint.holeCanMerge(self.hero,i))
		self.stoneHoles[i]:setTipVisible(GamePoint.holeCanTip(self.hero,i))

		local awakeInfo = GameConfig.hero_awake[self.hero.roleId]
		local key = string.format("ItemID%d",self.hero.awakeLevel+1)
		local item = ItemData:getItemConfig(awakeInfo[key][i])
		self.stoneHoles[i]:updateStone(item)

		if v == 0 then
			self.stoneHoles[i]:setBtnImage(0)
			self.stoneHoles[i]:setStoneFilter()
			self.stoneHoles[i].label:setVisible(false)
		else
			self.stoneHoles[i]:setBtnImage(item.configQuality)
			self.stoneHoles[i].label:setVisible(true)
		end
	end
end

--刷新界面
function HeroAwakeLayer:updateView()
	self:updateAwakeBtn()
	self:updateStoneHole()
	self:updateAwakeIcon()
	self:updateDesLabel()

	if self.delegate then
		self.delegate:updatePoint(1,GamePoint.heroCanUpdate(self.hero))
		self.delegate:updateHeroPic()
	end

	if self.mergeLayer then
		self.mergeLayer:updateView()
	end

	if self.waterLayer then
		self.waterLayer:updateView()
	end
end

--创建宝石融合界面
function HeroAwakeLayer:createStoneMergeView(index)
	self.holeIndex = index
	local currentId = self.hero.stones[index]
	if currentId == 0 then
		local key = string.format("ItemID%d",self.hero.awakeLevel+1)
		local awakeInfo = GameConfig.hero_awake[self.hero.roleId]
		local targetId = awakeInfo[key][index]
		self.mergeLayer = StoneMergeLayer.new(targetId,self.hero)
		self.mergeLayer:updateView()
		self.mergeLayer.delegate = self
		display.getRunningScene():addChild(self.mergeLayer,5)
	else
		self:createStoneLayer(currentId)
	end
end

function HeroAwakeLayer:removeMergeLayer()
	self.mergeLayer:removeFromParent(true)
	self.mergeLayer = nil
end

function HeroAwakeLayer:stoneMerge()
	local heroId = self.hero.roleId
	local pos = self.holeIndex
	local param = {param1 = heroId, param2 = pos}
	NetHandler.gameRequest("JuexingRongHeBaoshi",param)
end

--创建药水使用界面
function HeroAwakeLayer:createWaterView()
	self.waterLayer = UseWaterLayer.new(self.hero)
	self.waterLayer.delegate = self
	display.getRunningScene():addChild(self.waterLayer,5)
end

function HeroAwakeLayer:removeWaterView()
	self.waterLayer:removeFromParent(true)
	self.waterLayer = nil
end

--创建技能描述界面
function HeroAwakeLayer:createSkillDesView()
	self.sDesLayer = SkillDesLayer.new(self.hero)
	self.sDesLayer.delegate = self
	display.getRunningScene():addChild(self.sDesLayer,5)
end

function HeroAwakeLayer:removeSkillDesView()
	self.sDesLayer:removeFromParent(true)
	self.sDesLayer = nil
end

--创建宝石属性界面
function HeroAwakeLayer:createStoneLayer(stoneId)
	self.stoneLayer = StoneLayer.new(stoneId)
	self.stoneLayer.delegate = self
	display.getRunningScene():addChild(self.stoneLayer,5)
end

function HeroAwakeLayer:removeStoneLayer()
	self.stoneLayer:removeFromParent(true)
	self.stoneLayer = nil
end

function HeroAwakeLayer:showAwakeSuccess(callback)
	if self.aniSprite then
		self.aniSprite:playAction("2",false)
		self.aniSprite:setActCallback(function (name)
    		if name == "2" then
    			callback()
    		end
        end)
	end
end

function HeroAwakeLayer:buttonEvent(event)
	AudioManage.playSound("Click.mp3")
    local tag = event.target:getTag()
    if tag == BUTTON_ID.BUTTON_STONE_1 then
    	self:createStoneMergeView(tag)
    elseif tag == BUTTON_ID.BUTTON_STONE_2 then
    	self:createStoneMergeView(tag)
	elseif tag == BUTTON_ID.BUTTON_STONE_3 then
    	self:createStoneMergeView(tag)
	elseif tag == BUTTON_ID.BUTTON_STONE_4 then
		self:createStoneMergeView(tag)
	elseif tag == BUTTON_ID.BUTTON_STONE_5 then
		self:createStoneMergeView(tag)
	elseif tag == BUTTON_ID.BUTTON_AWAKE then
		if GamePoint.heroCanAwake(self.hero) then
        	local heroId = self.hero.roleId
			local param = {param1 = heroId}
			NetHandler.gameRequest("JueXingHero",param)
		else
			self:createWaterView()
		end
	elseif tag == BUTTON_ID.BUTTON_ONE_CLICK then
		if GamePoint.heroCanMerge(self.hero) then
			local heroId = self.hero.roleId
			local param = {param1 = heroId}
			NetHandler.gameRequest("OneKeyJuexingRongHeBaoshi",param)
		else
			local param = {text = "没有可融合的圣灵",size = 30,color = display.COLOR_RED}
			showToast(param)
		end
	elseif tag == BUTTON_ID.BUTTON_DETAIL then
		self:createSkillDesView()
	end
end

return HeroAwakeLayer