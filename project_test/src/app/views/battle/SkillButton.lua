--
-- Author: zsp
-- Date: 2014-12-05 12:19:55
--

local BattleEvent = require("app.battle.BattleEvent")

--[[
    释放主角技能按钮
--]]
local SkillButton = class("SkillButton",function()
    return display.newNode()
end)

function SkillButton:ctor(skillId,role)
  
   self.guide      = false
   self.guideBegin = false
   self.guideEnd   = false


	 self.role = role
	 self.skillId = skillId
   local image = GameConfig.skill[self.skillId].image..".png"
   --self.buttonEnabled = false
   self.visibleEffect = false


  -- self.handle = nil

	 local bg = display.newSprite("Skill_Circle.png")
	 bg:addTo(self)
   bg:setTouchEnabled(true)

	 self:setContentSize(bg:getContentSize())

	 self.btn = cc.ui.UIPushButton.new({
       normal   = image,
       pressed  = image,
       disabled = image,
	 	})

    self.btn:onButtonClicked(function(event)
         
         self:setGuideEnd()

         if self.role.auto then
            return
         end

         --检查技能是否能可以使用
         if self.role.skillMgr:checkEnableById(self.skillId) == false then
            return
         end

        --执行角色释放技能状态
        self.role:doSkill(self.skillId)
    end)
    self.btn:addTo(self)

    --self.progress = cc.ProgressTimer:create(display.newSprite("Icon_circle_shadow.png"))
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
    self.progress:setPercentage(100);
    self.progress:addTo(self)

    self.effect = display.newSprite()
    self.effect:setVisible(false)
    self.effect:addTo(self)

    local animation = createAnimation("btn_skill_effect_%d.png",4,0.1)
    transition.playAnimationForever(self.effect,animation)
end

--[[
    更新技能冷却
--]]
function SkillButton:updateCooldown(dt,cooldown)
	self.progress:setPercentage(100 - dt / cooldown * 100)
  if self.progress:getPercentage() == 0 then
    
    self:onGuideBegin()

    self:setButtonEnabled(true)
  else
    self:setButtonEnabled(false)
  end
end

--[[
   触发按钮click事件
--]]
function SkillButton:doClick()
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
    设置按钮是否可用
--]]
function SkillButton:setButtonEnabled(enabled)
  -- body
  self.btn:setButtonEnabled(enabled)

  if enabled then
    --todo
      if self.visibleEffect then
        return
      end

      self.effect:resume()
      self.effect:setVisible(enabled)
      self.visibleEffect = true
  else
      self.effect:pause()
      self.effect:setVisible(enabled)
      self.visibleEffect = false
  end
end

--[[
  按钮新手引导开始使用
--]]
function SkillButton:onGuideBegin()
    if not self.guide then
        return
    end

    if self.guideBegin or self.guideEnd then
        return
    end
  
    self.guideBegin = true

    if not self.btnGuide then
        local text
        if GuideData:isNotCompleted("Fight") then   
            text =  GameConfig.tutor_talk["3"].talk
        elseif GuideData:isNotCompleted("Fight2") then
            text =  GameConfig.tutor_talk["5"].talk    
        end 
        local x = -70
        local y = 150
        local param = {text = text, x = x, y = y}
        self.btnGuide = showBattleGuide(param):addTo(self)
    end
end

--[[
  按钮新手引导使用结束
--]]
function SkillButton:setGuideEnd()
  if not self.guide then
    return
  end
  
  if self.guideEnd then
     return
  end

  if self.btnGuide then
      self.btnGuide:removeFromParent()
      self.btnGuide = nil
  end
  

  self.guideBegin = false
  self.guideEnd = false
  -- display.resume()
end


return SkillButton