--
-- Author: zsp
-- Date: 2015-06-18 20:33:33
--


local BattleScene        = require("app.scenes.BattleScene")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local AngerButton        = require("app.views.battle.AngerButton")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local GuideLayer         = require("app.views.widget.GuideLayer")
local scheduler = require("framework.scheduler")

require("app.battle.GafAssetCache")

--战斗角色被放置的垂直位置
local BattlePosition = {}
BattlePosition.left  = {cc.p(80,120),cc.p(80,160),cc.p(130,200),cc.p(80,240),cc.p(80,280)}
BattlePosition.right = {cc.p(80,140),cc.p(80,160),cc.p(130,200),cc.p(80,240),cc.p(80,280)}

local BattleGuide3Scene = class("BattleGuide3Scene", BattleScene)

--[[
  竞技场战斗
--]]
function BattleGuide3Scene:ctor(params)
    BattleGuide3Scene.super.ctor(self,params)
end

function BattleGuide3Scene:load()

    self.params.team.team1[1].evolve = true
    self.params.enemy.team[1].evolve = true

    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    --获取本关卡的全部敌人不同种类的的资源名
    local assetNames =  GafAssetCache.reset()
    .addTeamAssetName(self.params.team.team1)
    .addTeamAssetName(self.params.team.team2)
    .addEnterSkillAssetName(self.params.team.team1)
    .addEnterSkillAssetName(self.params.team.team2)
    .addTailSkillAssetName(self.params.tailSkill)
    .addTeamAssetName(self.params.enemy.team)
    .addAssetName("atk_effect_2")
    .addAssetName("atk_effect_3")
    .addAssetName("enter_effect_3")
    .addAssetName("enter_effect_5")
    .addAssetName("Tower5")
    .getAssetNames()

    loading:load(assetNames,handler(self, self.init))
end

function BattleGuide3Scene:init()
    self.mapNum = 2
    self.entryPosition =   display.cx
    self.mapWidth = 1136 * self.mapNum
    BattleManager.setSceneWidth(self.mapWidth - 360)

    self:createMap("2")
    self:createMaskLayer()
    self:createTeam()
    self.leader.model.battleImage = "Saber_flash.png"

    self.ctrlLayer = CtrlLayer.new({
        ["guide"] = self.params.guide
    }):addTo(self):zorder(-100)
    --控制角色
    self.ctrlLayer.ctrlNode = self.leader
    --相机跟踪角色
    self.followRole = self.ctrlLayer.ctrlNode
    --启用相机跟中角色
    self.fllowRoleEnable = true
    --屏幕场景相机偏移距离
    self.cameraOffset = self.leader.model.attackSize.width * 0.5

    self.hubLayer = BattleHubLayer.new({
        ["team"]       = self.team,
        ["inTeam"]     = #self.params.team.team1,
        ["tailSkill"]  = self.params.tailSkill,
        ["guide"]      = self.params.guide,
        ["timeOut"]    = self.params.endTime,
    }):addTo(self):zorder(-100)
    
    BattleEvent:addEventListener(BattleEvent.HERO_FALSH, handler(self, self.showHeroFlash))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_BEGIN, handler(self, self.onSkillBegin))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_END, handler(self, self.onSkillEnd))
    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
    BattleEvent:addEventListener(BattleEvent.KILL_ENEMY, handler(self, self.onEnemyKill))
    BattleEvent:addEventListener(BattleEvent.KILL_CHARACTER, handler(self, self.onCharacterKill))
    BattleEvent:addEventListener(BattleEvent.CALL_MEMBER, handler(self, self.onCallMember))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_BEGIN, handler(self, self.onEnterSkillBegin))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_END, handler(self, self.onEnterSkillEnd))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.SLOW_BEGIN, handler(self, self.onSlowBegin))
    BattleEvent:addEventListener(BattleEvent.SLOW_END, handler(self, self.onSlowEnd))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_BEGIN, handler(self, self.onTailSkillBegin))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_END, handler(self, self.onTailSkillEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEndTalk))

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()

    self.leader.auto = true
    self:onCreateEnemy()

    --todo 恶心的回调
    self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function()
        self:pauseGame()
        local talkParam = {
            image = GameConfig.boss_talk["1"].icon,
            dir = 1,
            name = GameConfig.boss_talk["1"].name,
            text = GameConfig.boss_talk["1"].info,
            callback = function ()
                local talkParam1 = {
                    image = GameConfig.boss_talk["2"].icon,
                    dir = -1,
                    name = GameConfig.boss_talk["2"].name,
                    text = GameConfig.boss_talk["2"].info,
                    callback = function ()
                        self:resumeGame()
                    end
                }
                showRoleTalk(talkParam1):addTo(self)
            end
        }
        showRoleTalk(talkParam):addTo(self)
    end)))

    local skipBtn = CommonButton.green("跳过")
    skipBtn:setPosition(display.width - 100 , 80)
    skipBtn:addTo(self)
    skipBtn:onButtonClicked(function(event)
        if not self.over then
            self:removeRoles()
            app:enterScene("OpenScene")
        end
    end)
end

--[[
  替补队员登场技结束
--]]
-- function BattleGuide3Scene:onEnterSkillEnd(event)

  -- BattleGuide3Scene.super.onEnterSkillEnd(self,event)
  
  -- local roleId = event.member.roleId  
  -- print(string.format("roleId = %s,替补对话",roleId))

  -- if roleId == "61003" then
  --       self:pauseGame()
  --       local talkParam = {
  --           image = GameConfig.boss_talk["5"].icon,
  --           dir = 0,
  --           name = GameConfig.boss_talk["5"].name,
  --           text = GameConfig.boss_talk["5"].info,
  --           callback = function ()
  --               self:resumeGame()
  --           end
  --       }
  --       showRoleTalk(talkParam):addTo(self)
  --   elseif roleId == "61015" then
  --      self:pauseGame()
  --      local talkParam = {
  --           image = GameConfig.boss_talk["6"].icon,
  --           dir = 0,
  --           name = GameConfig.boss_talk["6"].name,
  --           text = GameConfig.boss_talk["6"].info,
  --           callback = function ()
  --               self:resumeGame()
  --           end
  --       }
  --       showRoleTalk(talkParam):addTo(self)
  --   elseif roleId == "61027" then
  --      self:pauseGame()
  --      local talkParam = {
  --           image = GameConfig.boss_talk["7"].icon,
  --           dir = 0,
  --           name = GameConfig.boss_talk["7"].name,
  --           text = GameConfig.boss_talk["7"].info,
  --           callback = function ()
  --               self:resumeGame()
  --           end
  --       }
  --       showRoleTalk(talkParam):addTo(self)
  --   end
-- end

function BattleGuide3Scene:onEvolutionEffectEndTalk(event)
    local sender = event.sender
    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1),cc.CallFunc:create(function()
        if sender.roleId == "61005" then
            self:pauseGame()
            local talkParam = {
              image = GameConfig.boss_talk["3"].icon,
              dir = 1,
              name = GameConfig.boss_talk["3"].name,
              text = GameConfig.boss_talk["3"].info,
              callback = function ()
                  self:resumeGame()
              end
          }
          showRoleTalk(talkParam):addTo(self)
        elseif sender.roleId == "61007" then
           self:pauseGame()
           local talkParam = {
              image = GameConfig.boss_talk["4"].icon,
              dir = -1,
              name = GameConfig.boss_talk["4"].name,
              text = GameConfig.boss_talk["4"].info,
              callback = function ()
                  self:resumeGame()
              end
          }
          showRoleTalk(talkParam):addTo(self)
        end
    end)))
end

--[[
    角色死亡时触发
--]]
function BattleGuide3Scene:onCharacterKill(event)
    local dead = event.dead

    if self.logic then
        self.logic:addKill(GameCampType.left, dead)
    end
    
    if dead.isLeader then
        self:pauseGame()
        local talkParam = {
              image = GameConfig.boss_talk["8"].icon,
              dir = 1,
              name = GameConfig.boss_talk["8"].name,
              text = GameConfig.boss_talk["8"].info,
              callback = function ()
                  local talkParam = {
                      image = GameConfig.boss_talk["9"].icon,
                      dir = -1,
                      name = GameConfig.boss_talk["9"].name,
                      text = GameConfig.boss_talk["9"].info,
                      callback = function ()
                          self:resumeGame()
                          self:onGameLose()
                      end
                  }
                  showRoleTalk(talkParam):addTo(self)
              end
          }
          showRoleTalk(talkParam):addTo(self)
    else
        -- 队员不死条件没有达成
        self.starCondition[2] = false
        -- 开启队员上场计时
        local index = table.indexof(self.team,dead)
        self.hubLayer.memberButtonGroup:onMemderDead(index)
    end
end


function BattleGuide3Scene:onCreateEnemy(event)
    
    local enemy  = CharacterNode.new({
      camp      = GameCampType.right,
      enemyCamp = GameCampType.left,
      isLeader  = true,
      auto      = true,
      model     = self.params.enemy.team[1],
      nodeScale = 1.5
    })

    local btn  = AngerButton.new(enemy)
    btn:setScale(0.8)
    btn:setPosition(display.width - 100,display.cy)
    btn:addTo(self)
    btn:setVisible(false)
    btn:onButtonClicked(function(event)
        if enemy == nil or not enemy:isActive() then
          return
        end

        btn:setButtonEnabled(false)
        enemy.model.anger = 0
        btn.progress1:setPercentage(0)
        btn:setEvolveMode(true)

        enemy:showEvolutionEffect()
    end)


    local y = BattlePosition.right[1].y
    enemy:setLocalZOrder(self.MAX_Z - y)
    enemy:setPosition(cc.p(BattleManager.sceneWidth - 100,y))
    enemy:addTo(self.mainLayer)
    
    enemy.onUpdateAnger   = handler(btn, btn.onUpdateAnger1)
      
    if enemy.model.evolve then
         local evolveNode = enemy:createEvolve()
         evolveNode:setVisible(false)
         evolveNode:pauseAll()
         evolveNode:addTo(self.mainLayer)
         evolveNode.onUpdateAnger = handler(btn, btn.onUpdateAnger2)
    end
end

--[[
    战斗胜利
--]]
function BattleGuide3Scene:onGameWin()
    AudioManage.stopMusic(true)
    
    self:onGameOver()

    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)

    scheduler.performWithDelayGlobal(function()
        app:enterScene("OpenScene")
    end, 3)
end

--[[
    战斗失败
--]]
function BattleGuide3Scene:onGameLose()
    AudioManage.stopMusic(true)
    self:onGameOver()

    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
          v:doWin()
        end
    end)

    scheduler.performWithDelayGlobal(function()
        app:enterScene("OpenScene")
    end, 3)
end

return BattleGuide3Scene