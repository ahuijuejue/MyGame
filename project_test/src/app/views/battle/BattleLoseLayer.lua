--
-- Author: zsp
-- Date: 2014-12-18 17:30:16
--


--[[
	战斗失败结算界面
--]]
local BattleLoseLayer = class("BattleLoseLayer",function()
    return display.newColorLayer(cc.c4b(0,0,0,150))
end)

function BattleLoseLayer:ctor(params)

    AudioManage.stopMusic(true)
    
    AudioManage.playSound("Lose.mp3",false)

	--cc.SpriteFrameCache:getInstance():addSpriteFrames("texture_account.plist");
	
	self:setOpacity(200)

    local img = "Word_Lose.png"
    if params.timeOut then
       img = "Word_Timeout.png"
    end
    
	local lose = display.newSprite(img)
	lose:setPosition(display.cx,display.cy + 200)
	lose:addTo(self)

	local startBtn = cc.ui.UIPushButton.new("Account_Next.png")
	startBtn:setPosition(display.cx + 400,100)
	startBtn:addTo(self)
	startBtn:onButtonClicked(function(event)
		printInfo("退出战斗")
        --app:enterScene("MainScene")
        --app:failedFunction()
        params:failedFunction()
    end)

    -- local wordPowerup = display.newSprite("Word_Powerup.png")
    -- wordPowerup:setAnchorPoint(0,0.5)
    -- wordPowerup:setPosition(display.cx - 440,400)
    -- wordPowerup:addTo(self)

    local wordPowerup =  display.newTTFLabel({
        text  = "你可以通过以下方式提高战斗力：",
        size  = 30,
        align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
    })
    wordPowerup:setAnchorPoint(0,0.5)
    wordPowerup:setPosition(display.cx - 440,380)
    wordPowerup:addTo(self)


    

    local image1 = cc.ui.UIPushButton.new("Image_1.png") --display.newSprite("Image_1.png")
    image1:setAnchorPoint(0,0.5)
    image1:setPosition(display.cx - 440,200)
    image1:addTo(self)
    image1:onButtonClicked(function(event)
        app:enterToScene("HeroExpScene")
    end)

    local image2 = cc.ui.UIPushButton.new("Image_2.png") --display.newSprite("Image_2.png")
    image2:setAnchorPoint(0,0.5)
    image2:setPosition(display.cx - 240,200)
    image2:addTo(self)
    image2:onButtonClicked(function(event)
       app:enterToScene("HeroListScene")
    end)

    local image3 = cc.ui.UIPushButton.new("Image_3.png") --display.newSprite("Image_3.png")
    image3:setAnchorPoint(0,0.5)
    image3:setPosition(display.cx - 40,200)
    image3:addTo(self)
    image3:onButtonClicked(function(event)
       app:enterToScene("HeroListScene")
    end)

    local image4 = cc.ui.UIPushButton.new("Image_4.png") --display.newSprite("Image_4.png")
    image4:setAnchorPoint(0,0.5)
    image4:setPosition(display.cx + 160,200)
    image4:addTo(self)
    image4:onButtonClicked(function(event)
       app:enterToScene("HeroListScene")
    end)

end

return BattleLoseLayer