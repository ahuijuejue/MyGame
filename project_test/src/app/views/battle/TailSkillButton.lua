--
-- Author: zsp
-- Date: 2015-04-14 14:24:09
--
local BattleEvent  = require("app.battle.BattleEvent")

--[[
  尾兽技能按钮 和队长关联
--]]
local TailSkillButton = class("TailSkillButton",function()
    return display.newNode()
end)

function TailSkillButton:ctor(skillId)
    self.visibleEffect = false
    self.skillId = skillId
  	 
    local bg = display.newSprite("Skill_Circle.png")
    bg:addTo(self)
    bg:setTouchEnabled(true)

    self:setContentSize(bg:getContentSize())

    local icon = GameConfig.skill_tails[skillId].icon..".png"

    self.btn = cc.ui.UIPushButton.new({
         normal   = icon,
         pressed  = icon,
         disabled = icon,
    })
    self.btn:addTo(self)
    self.btn:onButtonClicked(function(event)
        local role = BattleManager.getLeader(GameCampType.left)
        
        if not role then
            return
        end

        if role.auto then
            return
        end
         
        --执行角色释放尾兽技能状态
        role:doTailSkill(skillId)
    end)

    self.progress = cc.ProgressTimer:create(display.newSprite("Icon_circle_shadow.png"))
    self.progress:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.progress:setPercentage(100);
    self.progress:addTo(self)

    self.effect = display.newSprite()
    self.effect:addTo(self)

    local animation = createAnimation("btn_skill_effect_%d.png",4,0.1)
    transition.playAnimationForever(self.effect,animation)

    self:setScale(0.7)
end

--[[
    更新技能冷却
--]]
function TailSkillButton:updateCooldown(dt,cooldown)
  -- body
  self.progress:setPercentage(100 - dt / cooldown * 100)

  if self.progress:getPercentage() == 0 then
    self:setButtonEnabled(true)
  else
    self:setButtonEnabled(false)
  end
end

--[[
    设置按钮是否可用
--]]
function TailSkillButton:setButtonEnabled(enabled)
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

return TailSkillButton