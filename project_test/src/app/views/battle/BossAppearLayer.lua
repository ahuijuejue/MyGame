--
-- Author: zsp
-- Date: 2015-05-06 15:40:29
--

--[[
	战斗场景 关卡boss出现特效提示层
--]]
local BossAppearLayer = class("BossAppearLayer",function()
     return display.newNode()
end)

function BossAppearLayer:ctor()
	    
    self.upBg = display.newSprite("boss_appear_bg.png")
    self.upBg:setAnchorPoint(cc.p(0.5,1))
    self.upBg:setPosition(display.cx,display.top)
    self.upBg:setFlippedY(true);
    self.upBg:setOpacity(0);
    self.upBg:addTo(self);
    
    self.downBg = display.newSprite("boss_appear_bg.png");
    self.downBg:setAnchorPoint(cc.p(0.5,0))
    self.downBg:setPosition(display.cx,display.bottom)
    self.downBg:setOpacity(0)
    self.downBg:addTo(self)
    
    local winSize = display.size

    self.w = 454;
    local count = 4;

    self.upLayer = cc.LayerColor:create(cc.c4b(0, 0, 255, 0)) 
    self.upLayer:setContentSize(self.w*4,97)
    self.upLayer:ignoreAnchorPointForPosition(false);
    self.upLayer:setAnchorPoint(cc.p(0,1))
    self.upLayer:setPosition(display.left,display.top);
    self.upLayer:addTo(self)
    
    for i = 1,count do
    	local sp = display.newSprite("boss_appear.png")
    	sp:setAnchorPoint(cc.p(0,0));
        sp:setPosition((i-1)*self.w,0);
        sp:setOpacity(0);
        sp:addTo(self.upLayer)
        --sp->runAction(CCRepeat::create(CCSequence::create(CCFadeIn::create(0.5),CCFadeOut::create(0.5),NULL), 3));
        --sp:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5)), 3))
    end

    self.downLayer = cc.LayerColor:create(cc.c4b(0, 0, 255, 0))
    self.downLayer:setContentSize(self.w*4,97)
    self.downLayer:ignoreAnchorPointForPosition(false);
    self.downLayer:setAnchorPoint(cc.p(1,0));
    self.downLayer:setPosition(display.right,display.bottom);
    self.downLayer:addTo(self)

    for i = 1,count do
    	local sp = display.newSprite("boss_appear.png")
    	sp:setAnchorPoint(cc.p(0,0));
        sp:setPosition((i-1)*self.w,0);
        sp:setOpacity(0);
        sp:addTo(self.downLayer)
        --sp:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5)), 3))
    end
    
   
    -- upBg->runAction(CCRepeat::create(CCSequence::create(CCFadeIn::create(1),CCFadeOut::create(1),NULL), 3));
    -- downBg->runAction(CCRepeat::create(CCSequence::create(CCFadeIn::create(1),CCFadeOut::create(1),NULL), 3));
    
    -- upLayer->runAction(CCMoveBy::create(3, ccp(-(4*w-winSize.width), 0)));
    -- downLayer->runAction(CCMoveBy::create(3, ccp(4*w-winSize.width, 0)));
    	
    
    -- runAction(CCSequence::create(CCDelayTime::create(3),CCRemoveSelf::create(),NULL));
    
    -- SimpleAudioEngine::sharedEngine()->playEffect("boss_coming.mp3");

    --self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.RemoveSelf:create()))
end

--[[
    开始运行动画
--]]
function BossAppearLayer:startRun()
    local winSize = display.size
    self:setVisible(true)

    local c1 = self.upLayer:getChildren()
    for k,v in pairs(c1) do
        v:setOpacity(255)
        v:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5)), 3))
    end

    local c2 = self.downLayer:getChildren()
    for k,v in pairs(c2) do
        v:setOpacity(255)
        v:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(0.5),cc.FadeOut:create(0.5)), 3))
    end

    self.upBg:setOpacity(255)
    self.downBg:setOpacity(255)

    self.upBg:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(1),cc.FadeOut:create(1)), 3))
    self.downBg:runAction(cc.Repeat:create(cc.Sequence:create(cc.FadeIn:create(1),cc.FadeOut:create(1)), 3))

    self.upLayer:setPosition(display.left,display.top);
    self.downLayer:setPosition(display.right,display.bottom);

    self.upLayer:runAction(cc.MoveBy:create(3,cc.p(-(4 * self.w - winSize.width),0)))
    self.downLayer:runAction(cc.MoveBy:create(3,cc.p((4 * self.w - winSize.width),0)))

     self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.Hide:create()))
end

--[[
    停止运行动画
--]]
function BossAppearLayer:stopRun()
    self:stopAllActions()
    self:setVisible(false)
end

return BossAppearLayer