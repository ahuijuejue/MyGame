--
-- Created by IntelliJ IDEA.
-- User: Tiny
-- Date: 14-8-4
-- Time: 下午3:33
-- To change this template use File | Settings | File Templates.
--

local animationTime = 0.05

local LoadingLayer = class("LoadingLayer", function()
    return display.newLayer()
end)

function LoadingLayer:ctor()
    local bgSprite = display.newSprite("loading_bg.png")
    bgSprite:pos(display.cx,display.cy)
    self:addChild(bgSprite)

    --创建loading动画
    newrandomseed()
    local random = math.random(1,2)
    if random == 1 then
        self.animation = createAnimation("loading1%04d.png",13,0.05)
    else
        self.animation = createAnimation("loading2%04d.png",12,0.05)
    end 
    
    self.animationSprite = display.newSprite()
    self.animationSprite:pos(96,55)
    bgSprite:addChild(self.animationSprite)

    self:addNodeEventListener(cc.NODE_EVENT,function(event)
        if event.name == "enter" then
            self:onEnter()
        elseif event.name == "exit" then
            self:onExit()
        end
    end)
end

function LoadingLayer:showAnimation()
    transition.playAnimationForever(self.animationSprite,self.animation)
end

function LoadingLayer:onTouchBegan(touch,event)
    return true
end

function LoadingLayer:onEnter()
    self.listener = cc.EventListenerTouchOneByOne:create()
    self.listener:setSwallowTouches(true)
    self.listener:registerScriptHandler(handler(self,self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN)
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.listener,self)
end

function LoadingLayer:onExit()
    self:getEventDispatcher():removeEventListener(self.listener)
    self.listener = nil
end

return LoadingLayer