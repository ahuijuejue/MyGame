local BasicScene = import("..ui.BasicScene")
local SummonResultScene = class("SummonResultScene", BasicScene)

local SummonResultLayer = import("..views.summon.SummonResultLayer")
local UserResLayer = import("..views.main.UserResLayer")

local TAG = "SummonResultScene"
local skyImage = "Sky_Left.png"
local bgImageName = "Background_gray.jpg"

function SummonResultScene:ctor()
	SummonResultScene.super.ctor(self,TAG)
	self:createBackground()

	local resLayer = UserResLayer.new(3)
    resLayer:setPosition((display.width-760)/2,display.height-55)
	self:addChild(resLayer)

	self.resultLayer = SummonResultLayer.new()
    self.resultLayer.delegate = self
	self:addChild(self.resultLayer)
end

function SummonResultScene:createBackground()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

	local bgSprite = display.newSprite("Background_1.jpg")
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)

    local skySprite = display.newSprite(skyImage)
    skySprite:setPosition(display.cx,bgSprite:getContentSize().height - skySprite:getContentSize().height/2)
    self:addChild(skySprite,-1)
end

function SummonResultScene:onEnter()
    self:onGuide()
    self.resultLayer:showResult()
	SummonResultScene.super.onEnter(self)
end

function SummonResultScene:onExit()
	SummonResultScene.super.onExit(self)
end

function SummonResultScene:onGuide()
    if self.isExit then
        if not GuideData:isCompleted("Card") then
            local rect = {x = display.cx + 55, y = 30, width = 220 ,height = 60}
            local posX = rect.x - 140
            local posY = rect.y + rect.height/2 + 50
            local text = GameConfig.tutor_talk["19"].talk
            local param = {rect = rect, text = text,x = posX+10,y = posY+85, callback = function (tutor)
                self.tutor = tutor
                NetHandler.gameRequest("NewComerGuide",{param1 = "Card"})
            end}
            showTutorial(param)
        end
    end
end

function SummonResultScene:guideFinish()
    self.tutor:removeFromParent(true)
    self.tutor = nil
    app:enterToScene("MainScene")
end

return SummonResultScene