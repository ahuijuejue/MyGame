--
-- Author: zsp
-- Date: 2014-12-19 17:16:04
--
local BattleEvent = require("app.battle.BattleEvent")

--[[
    召唤队员登场按钮
--]]
local MemberButton = class("MemberButton",function()
    return display.newNode()
end)

function MemberButton:ctor(roles,index)
    self.guide      = false
    self.guideBegin = false
    self.guideEnd   = false

    if index > 4 then
        self.oldRole = roles[index-3]
    else
        self.oldRole = roles[index+3]
    end
    self.role   = roles[index] 
    self.roleId = self.role.roleId
    self.awakeLevel = self.role.model.awakeLevel
    self.index  = index --在队伍中的站位编号 

    local bg = display.newSprite(string.format("HeroCircle%d.png",self.awakeLevel+1))
  	bg:addTo(self)
    bg:setTouchEnabled(false)

  	self:setContentSize(bg:getContentSize())

    local image = self.role.model.head .. ".png"
  	self.btn = cc.ui.UIPushButton.new(image)
  	self.btn:addTo(self)
    
    local pack = {"GRAY",{0.1, 0.1, 0.1, 0.1}}
    local __filters, __params = unpack(pack)
    if __params and #__params == 0 then
      __params = nil
    end
   
    local mask =  display.newFilteredSprite(image,__filters, __params)
    mask:setAnchorPoint(0,0)
    local render = cc.RenderTexture:create(mask:getContentSize().width,mask:getContentSize().height);
    render:begin();
    mask:visit();
    render:endToLua();
    render:setPosition(mask:getContentSize().width * 0.5,mask:getContentSize().height * 0.5)

    self.progress = cc.ProgressTimer:create(render:getSprite())
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.progress:addTo(self)
   
    self.effect = display.newSprite("btn_member_effect.png")
    self.effect:setScale(1.1)
    self.effect:addTo(self)
end

--[[
  设置启用/禁用按钮
--]]
function MemberButton:setButtonEnabled(enabled)
    self.btn:setButtonEnabled(enabled)
    self.effect:stopAllActions()
    if enabled then
        local action = cc.RepeatForever:create(
           cc.RotateBy:create(3,360))
        self.effect:runAction(action)
        self.effect:setVisible(enabled)
        self.progress:setPercentage(0);
    else
        self.effect:setVisible(enabled)
        self.progress:setPercentage(100);
    end
end

--[[
  开启冷却记时
--]]
function MemberButton:startCooldown()
    self.progress:setPercentage(100)
    self.progress:runAction(
        cc.Sequence:create(
          cc.ProgressFromTo:create(self:getCooldownTime(),self.progress:getPercentage(),0),
          cc.CallFunc:create(handler(self,self.cooldownEnd)) 
    )) 
end

--[[
  冷却时间结束
--]]
function MemberButton:cooldownEnd()
    self:setButtonEnabled(true)

    if self.guide then
        self:onGuideBegin()
        return
    end

    --如果队长活着并是自动控制，则cd满了 模拟按钮点击事件 自动切换队员
    local leader =  BattleManager.getLeader(self.role.camp)

    if ( leader and leader.auto )then
        self:doClick()
        return
    end

    if leader and not self.oldRole then
        self:doClick()
        return
    end

    if (leader and self.oldRole and self.oldRole.dead )  then
        self:doClick()
        return
    end  
end

--[[
   触发按钮click事件
--]]
function MemberButton:doClick()
    local pt = self.btn:convertToWorldSpace(cc.p(0,0))
    self.btn:dispatchEvent({
        name = self.btn.CLICKED_EVENT,
        touchInTarget = true,
        target = self.btn,
        x = pt.x + 5,
        y = pt.y + 5,
    })
end

--[[
    判断cd是否满了
--]]
function MemberButton:isCooldownEnd()
    if self.progress:getPercentage() == 0 then
        return true
    else
        return false
    end
end

--[[
    获取英雄上场的cd时间
--]]
function MemberButton:getCooldownTime()
    local hp = self.role.model.hp
    local maxHp = self.role.model.maxHp
    local enterCd = self.role.model.enterCd
    local hpCd  = self.role.model.hpCd
    local time = Formula[1](enterCd, hpCd, maxHp - hp,maxHp)
    return time
end

function MemberButton:onButtonClicked(callback)
    self.btn:onButtonClicked(callback)
end

--[[
  暂停cd
--]]
function MemberButton:pauseCooldown()
    self.btn:pause()
    self.progress:pause()
end

--[[
  恢复cd
--]]
function MemberButton:resumeCooldown()
    self.btn:resume()
    self.progress:resume()
end

function MemberButton:onGuideBegin()
    if self.guideBegin or self.guideEnd then
        return
    end
    
    self.guideBegin = true

   --发送技能特效开启事件
    BattleEvent:dispatchEvent({
        name   = BattleEvent.GUIDE_BUTTON,
        sender = self,
        text   = GameConfig.tutor_talk["82"].talk
    })
end

function MemberButton:setGuideEnd()
    if not self.guide then
      return
    end
  
    if self.guideEnd then
      return
    end

    self.guideBegin = true
    self.guideEnd = true
end

return MemberButton