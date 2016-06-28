local BasicScene = import("..ui.BasicScene")
local CoinResultScene = class("CoinResultScene", BasicScene)

local CoinResultLayer = import("..views.coin.CoinResultLayer")
local UserResLayer = import("..views.main.UserResLayer")

local TAG = "CoinResultScene"
local bgImageName = "Background_coin.jpg"

function CoinResultScene:ctor()
	CoinResultScene.super.ctor(self,TAG)
	self:createBackground()

	local resLayer = UserResLayer.new(10)
    resLayer:setPosition((display.width-760)/2,display.height-55)
	self:addChild(resLayer)

	self.resultLayer = CoinResultLayer.new()
    self.resultLayer.delegate = self
	self:addChild(self.resultLayer)
end

function CoinResultScene:createBackground()
    local colorLayer = display.newColorLayer(cc.c4b(0,0,0,100))
    self:addChild(colorLayer)

	local bgSprite = display.newSprite(bgImageName)
    bgSprite:setPosition(display.cx,display.cy)
    self:addChild(bgSprite)
end

function CoinResultScene:onEnter()
    self.resultLayer:showResult()
	CoinResultScene.super.onEnter(self)
end

function CoinResultScene:onExit()
	CoinResultScene.super.onExit(self)
end

return CoinResultScene
