local AincradWinLayer = class("AincradWinLayer",function()
    return display.newColorLayer(cc.c4b(0,0,0,150))
end)

function AincradWinLayer:ctor(params)
	AudioManage.stopMusic(true)

	AudioManage.playSound("Win.mp3",false)

	self:createWinAnim()

	self:createStarAnim(params)

	self:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.CallFunc:create(function()
		self:createResultView(params)
	end)))
end

function AincradWinLayer:createWinAnim()
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

function AincradWinLayer:createStarAnim(params)
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

function AincradWinLayer:createResultView(params)
	local bgSprite = display.newSprite("aincrad_result.png")
	bgSprite:pos(display.cx,display.cy-30)
	bgSprite:addTo(self)
	bgSprite:setOpacity(0)

	local multiple = GameConfig.AincradInfo["1"].OneStarScore
    if params.starNum == 2 then
        multiple = GameConfig.AincradInfo["1"].TwoStarScore
    elseif params.starNum == 3 then
        multiple = GameConfig.AincradInfo["1"].ThreeStarScore
    end

    local baseScore = params.baseScore
    local totalScore = baseScore * tonumber(multiple)
    
    transition.execute(bgSprite,cc.FadeIn:create(1), {
	    onComplete = function()
	        local label1 = createOutlineLabel({text = baseScore,size = 30})
		    label1:pos(bgSprite:getContentSize().width/2-280,70)
		    label1:addTo(bgSprite)

		    transition.execute(label1,cc.DelayTime:create(0.1), {
			    onComplete = function()
			        local label2 = createOutlineLabel({text = multiple,size = 30})
				    label2:pos(bgSprite:getContentSize().width/2-20,70)
				    label2:addTo(bgSprite)

				    transition.execute(label2,cc.DelayTime:create(0.1), {
					    onComplete = function()
					        local label3 = createOutlineLabel({text = totalScore,size = 30})
						   	label3:pos(bgSprite:getContentSize().width/2+270,70)
						   	label3:addTo(bgSprite)
					    end,
					})
			    end,
			})
	    end,
	})

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
end

return AincradWinLayer