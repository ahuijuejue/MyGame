--
-- Author: zsp
-- Date: 2014-12-18 17:29:51
--

local TeamLevelUpLayer = import(".TeamLevelUpLayer")
local HeroExpBar = import("..widget.HeroExpBar")

--[[
	战斗场景胜利结算界面
--]]
local BattleWinLayer = class("BattleWinLayer",function()
    return display.newColorLayer(cc.c4b(0,0,0,180))
end)

function BattleWinLayer:ctor(params)
	AudioManage.stopMusic(true)

	AudioManage.playSound("Win.mp3",false)

	self:createWinAnim()

	self:createStarAnim(params)

	self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function()
		self:createPanel(params)
	end)))
end

function BattleWinLayer:createPanel(params)
	local act = transition.sequence({
            cc.ScaleTo:create(0.1,1.2),
            cc.ScaleTo:create(0.1, 1),
            cc.DelayTime:create(0.5)
        })
	local startBtn = cc.ui.UIPushButton.new("Account_Next.png")
	startBtn:setPosition(display.cx + 410,80)
	startBtn:addTo(self)
	startBtn:runAction(cc.RepeatForever:create(act))
	startBtn:onButtonClicked(function(event)
		 params:winFunction()
    end)

	local bgLine = display.newSprite("Account_Banner.png")
	bgLine:setAnchorPoint(cc.p(0,0.5))
	bgLine:setPosition(60, 350)
	bgLine:addTo(self)

	--战队禁言等级进度
	self.teamLevelUpProgress = cc.ProgressTimer:create(display.newSprite("Account_Exp.png"))
    self.teamLevelUpProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.teamLevelUpProgress:setMidpoint(cc.p(0, 0))
    self.teamLevelUpProgress:setBarChangeRate(cc.p(1, 0))

    --战队经验
    local loading_back = display.newSprite("Loading_Slip.png")
    loading_back:pos(200, 44)
    loading_back:addTo(bgLine)
    local teamExp = GameExp.getUserCurrentExp(params.teamTotalExp + params.teamAppendExp) / GameExp.getUserUpgradeExp(params.teamTotalExp + params.teamAppendExp)
    self.teamLevelUpProgress:setPercentage(teamExp * 100)
    self.teamLevelUpProgress:setPosition(186, 17)
    loading_back:setScaleX(self.teamLevelUpProgress:getContentSize().width/loading_back:getContentSize().width)
    self.teamLevelUpProgress:addTo(loading_back,3)

    --战队等级
    self.teamLevelLabel =  display.newTTFLabel({
		text  = string.format("LV.%d", GameExp.getUserLevel(params.teamTotalExp + params.teamAppendExp)),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.teamLevelLabel:setAnchorPoint(0,0.5)
	self.teamLevelLabel:setPosition(20,72)
	self.teamLevelLabel:setColor(cc.c3b(255,255,0))
	self.teamLevelLabel:addTo(bgLine)

	--战队增加经验
	self.teamExpLabel = display.newTTFLabel({
		text  = string.format("+%d", params.teamAppendExp),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.teamExpLabel:setAnchorPoint(0,0.5)
	self.teamExpLabel:setPosition(190,72)
	self.teamExpLabel:setColor(cc.c3b(0,255,0))
	self.teamExpLabel:addTo(bgLine)

	--活的金币数量
	self.goldLabel = display.newTTFLabel({
		text  = string.format("+%d", params.gold),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.goldLabel:setAnchorPoint(0,0.5)
	self.goldLabel:setPosition(550,45)
	self.goldLabel:addTo(bgLine)

	--活的灵能石数量
	self.skillLabel = display.newTTFLabel({
		text  = string.format("+%d", params.skillValue),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.skillLabel:setAnchorPoint(0,0.5)
	self.skillLabel:setPosition(680,45)
	self.skillLabel:addTo(bgLine)

	--获得工会币
	if params.stageType == 3 then
		local uIcon = display.newSprite("UnionGold.png")
		uIcon:setScale(0.7)
		uIcon:setPosition(780,45)
		uIcon:addTo(bgLine)

		local uCoinLabel = display.newTTFLabel({
			text = string.format("+%d", params.uCoin),
			size = 24,
			align = cc.TEXT_ALIGNMENT_CENTER
		})
		uCoinLabel:setAnchorPoint(0,0.5)
		uCoinLabel:setPosition(810,45)
		uCoinLabel:addTo(bgLine)
	end

	--队员展示
	local tempTeam = {}
    for i,v in ipairs(params.team.team1) do
        table.insert(tempTeam,v)
    end
    for i,v in ipairs(params.team.team2) do
        table.insert(tempTeam,v)
    end
	for k,v in pairs(tempTeam) do
		local border = display.newSprite(UserData:getHeroBorder(v.roleId))
		border:setPosition(k * 120 - 30, 230)
		border:setScale(0)
		border:addTo(self)
		border:runAction(cc.Sequence:create(cc.DelayTime:create(0.2 * (k - 1)),cc.ScaleTo:create(0.1,0.85)))

		local head = display.newSprite(string.format("head_%s.png",v.roleId))
		head:setPosition(border:getContentSize().width * 0.5,border:getContentSize().height * 0.5)
		head:addTo(border)

	 	local heroExpBar = HeroExpBar.new(v.exp)
	 	heroExpBar:setPosition(border:getContentSize().width * 0.5, -20)
	 	heroExpBar:addTo(border)
	 	heroExpBar:addExp(params.heroAppendExp,0.08 * (k - 1))

	    local expLabel = display.newTTFLabel({
			text  = string.format("EXP+%d", params.heroAppendExp),
			size  = 16,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		expLabel:setPosition(border:getContentSize().width * 0.5, -20)
		expLabel:setColor(cc.c3b(255,255,255))
		expLabel:addTo(border)

		local levelBg = display.newSprite("level_bg.png")
		levelBg:setPosition(20, 110)
		levelBg:addTo(border)
		local levelLabel = display.newTTFLabel({
			text  = string.format("%d", GameExp.getLevel(v.exp + params.heroAppendExp)),
			size  = 20,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		})
		levelLabel:setAnchorPoint(0.5,0.5)
		levelLabel:setPosition(levelBg:getContentSize().width * 0.5,levelBg:getContentSize().height * 0.5)
		levelLabel:setColor(cc.c3b(255,255,0))
		levelLabel:addTo(levelBg)

		--英雄升级了
		if GameExp.getLevel(v.exp + params.heroAppendExp) >  GameExp.getLevel(v.exp) then
			--todo
			local uplevelTip = display.newSprite("Word_HeroLevelup.png")
			uplevelTip:setPosition(border:getContentSize().width * 0.5, 10)
			uplevelTip:addTo(border)
			uplevelTip:runAction(cc.Sequence:create(cc.DelayTime:create(0.3 * (k - 1)),cc.MoveBy:create(0.2,cc.p(0,135))))
			--英雄升级特效
			local aniSprite = display.newSprite()
			aniSprite:pos(73,70)
			aniSprite:setScale(0.8)
			aniSprite:addTo(head,3)
		    local animation = createAnimation("up%d.png",13,0.1)
		    transition.playAnimationOnce(aniSprite,animation,true)

		end
	end

	local line = display.newSprite("Account_Line.png")
	line:setAnchorPoint(cc.p(0,0.5))
	line:setPosition(60, 135)
	line:addTo(self)

	--奖励道具展示
	local i = 1
	for k,v in pairs(params.item) do

		UserData:createItemView(k)
		:pos(i * 100, 70)
		:addTo(self)
		:setScale(0.8)

		display.newTTFLabel({
			text  = string.format("x%d", v),
			size  = 18,
			align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
		}):pos(i * 100 + 30, 40):addTo(self):setColor(cc.c3b(0,255,0))

		i = i + 1

	end

	--队伍又升级
	if GameExp.getUserLevel(params.teamTotalExp + params.teamAppendExp) > GameExp.getUserLevel(params.teamTotalExp) then
		TeamLevelUpLayer.new(params):addTo(self)
	end

end


function BattleWinLayer:createWinAnim()
	local node = display:newNode()
	node:setPosition(display.cx,display.cy + 210)
	node:addTo(self)

	local light = display.newSprite("Account_light.png")
	light:setVisible(false)
	light:setScale(2)
	light:addTo(node)
	light:runAction(cc.Sequence:create(cc.DelayTime:create(0.8),cc.Show:create()))
	light:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.FadeOut:create(1),cc.FadeIn:create(1))))

	--左边翅膀
	local a4l = display.newSprite("Account_4.png")
	a4l:setAnchorPoint(cc.p(1,0))
	a4l:setPosition(-50,0)
	a4l:setRotation(-90)
	a4l:setVisible(false)
	a4l:addTo(node)
	a4l:runAction(cc.Sequence:create(cc.DelayTime:create(0.4),cc.Show:create(),cc.RotateTo:create(0.08,0)))

	--右边翅膀
	local a4r = display.newSprite("Account_4.png")
	a4r:setAnchorPoint(cc.p(1,0))
	a4r:setScaleX(-1)
	a4r:setRotation(90)
	a4r:setPosition(50,0)
	a4r:setVisible(false)
	a4r:addTo(node)
	a4r:runAction(cc.Sequence:create(cc.DelayTime:create(0.4),cc.Show:create(),cc.RotateTo:create(0.08,0)))

	--条幅
	local a3 = display.newSprite("Account_3.png")
	a3:setPosition(0,-50)
	a3:setScaleX(0)
	a3:addTo(node)
	a3:runAction(cc.Sequence:create(cc.DelayTime:create(0.35),cc.ScaleTo:create(0.3,1)))


	--盾牌
	local a1 = display.newSprite("Account_1.png")
	a1:setPosition(0,0)
	a1:addTo(node)
	a1:setOpacity(0)
	a1:runAction(cc.Sequence:create(cc.FadeOut:create(1),cc.FadeIn:create(1)))

	--剑
	local a5 = display.newSprite("Account_5.png")
	a5:setPosition(0,200)
	a5:addTo(node)
	a5:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.MoveTo:create(0.05,cc.p(0,0))))

	--胜利
	local a2 = display.newSprite("Account_2.png")
	a2:setPosition(0,-15)
	a2:addTo(node)
	a2:setScale(0)
	a2:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.ScaleTo:create(0.06,10),cc.ScaleTo:create(0.05,1)))

end

function BattleWinLayer:createStarAnim(params)
	for i=1,params.starNum do
		local star = display.newSprite("star.png")
		star:setScale(0)

        local aniSprite1 = display.newSprite()
		aniSprite1:setScale(2)
		aniSprite1:pos(30,60)
	    aniSprite1:addTo(star,-1)
	    local animation = createAnimation("equip_2_%02d.png",19,0.06)

		if i == 1 then
			star:setRotation(45)
			star:setPosition((display.cx-80),display.cy + 130)
			star:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.ScaleTo:create(0.05,10),cc.ScaleTo:create(0.04,0.8)))

		    transition.playAnimationOnce(aniSprite1,animation,true,nil,1.09)
		end

		if i == 2 then
			star:setPosition((display.cx),display.cy + 110)
			star:runAction(cc.Sequence:create(cc.DelayTime:create(1.2),cc.ScaleTo:create(0.05,10),cc.ScaleTo:create(0.04,0.8)))

		    transition.playAnimationOnce(aniSprite1,animation,true,nil,1.29)
		end

		if i == 3 then
			star:setRotation(-45)
			star:setPosition((display.cx + 80),display.cy + 130)
			star:runAction(cc.Sequence:create(cc.DelayTime:create(1.4),cc.ScaleTo:create(0.05,10),cc.ScaleTo:create(0.04,0.8)))

		    transition.playAnimationOnce(aniSprite1,animation,true,nil,1.49)
		end

		star:addTo(self)
	end
end

return BattleWinLayer