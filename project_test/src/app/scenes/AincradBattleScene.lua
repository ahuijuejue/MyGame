--
-- Author: zsp
-- Date: 2015-05-18 12:07:11
--

local BattleScene        = require("app.scenes.BattleScene")
local BattleLogic        = require("app.battle.BattleLogic")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local EnemyNode          = require("app.battle.node.EnemyNode")
local TowerNode          = require("app.battle.node.TowerNode")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local TailSkillManager   = require("app.battle.skill.TailSkillManager")
local AngerButton        = require("app.views.battle.AngerButton")
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,150),cc.p(80,150),cc.p(130,190),cc.p(40,190),cc.p(80,220),cc.p(130,220)}
BattlePosition.right = BattlePosition.left

local AincradBattleScene = class("AincradBattleScene",BattleScene)

--[[
   艾恩格朗特 战斗场景
--]]
function AincradBattleScene:ctor(params)
	AincradBattleScene.super.ctor(self,params)
end

function AincradBattleScene:load()
    -- 己方队长是否能变身
    if self.params.team.team1[1]:checkEvolve() then
        self.params.team.team1[1].evolve = true
    end

    --敌方队长变身
    if self.params.enemy.team[1]:checkEvolve() then
        self.params.enemy.team[1].evolve = true
    end

	  if self.params.tailSkill and #self.params.tailSkill.skill == 0 then
        self.params.tailSkill = nil
  	end

  	if self.params.enemy.tailSkill and #self.params.enemy.tailSkill.skill == 0 then
        self.params.enemy.tailSkill = nil
  	end

    self.deadCount = 0

    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    local assetNames =  GafAssetCache.reset()
    .addTeamAssetName(self.params.team.team1)
    .addTeamAssetName(self.params.team.team2)
    .addTeamAssetName(self.params.enemy.team)
    .addEnterSkillAssetName(self.params.team.team1)
    .addEnterSkillAssetName(self.params.team.team2)
    .addEnterSkillAssetName(self.params.enemy.team)
    .addTailSkillAssetName(self.params.tailSkill)
    .addTailSkillAssetName(self.params.enemy.tailSkill)
    .addAttackEffect()
    .addEnterEffect()
    .addAssetName("Tower5")
    .getAssetNames()

    loading:load(assetNames,handler(self, self.init))
end

function AincradBattleScene:init()
    --设置buff的角色附加属性值
    for i,j in pairs(self.params.buff) do   
        for k,v in pairs(self.params.team.team1) do
          local data =  j
          if data.mothod == "0" then
              data.process = data.process / 100
              if data.type == "hp" then
                 v.hp = math.min(v.hp + data.process * v.maxHp, v.maxHp)
              elseif data.type == "anger" then
                  v.anger = math.min(v.anger + data.process * v.maxAnger, v.maxAnger)
              else
                  v.property[data.type] = v.property[data.type] + data.process * v.property[data.type]
                  v[data.type] = v.property[data.type]
              end
          else
              if data.type == "hp" then
                 v.hp = math.min(v.hp + data.process, v.maxHp)
              elseif data.type == "anger" then
                 v.anger = math.min(v.anger + data.process, v.maxAnger)
              else
                 v.property[data.type] = v.property[data.type] + data.process
                 v[data.type] = v.property[data.type]
              end  
          end
      end
      for k,v in pairs(self.params.team.team2) do
          local data =  j
          if data.mothod == "0" then
              data.process = data.process / 100
              if data.type == "hp" then
                 v.hp = math.min(v.hp + data.process * v.maxHp, v.maxHp)
              elseif data.type == "anger" then
                 v.anger = math.min(v.anger + data.process * v.maxAnger, v.maxAnger)
              else
                 v.property[data.type] = v.property[data.type] + data.process * v.property[data.type]
                 v[data.type] = v.property[data.type]
              end
             
          else
              if data.type == "hp" then
                 v.hp = math.min(v.hp + data.process, v.maxHp)
              elseif data.type == "anger" then
                 v.anger = math.min(v.anger + data.process, v.maxAnger)
              else
                 v.property[data.type] = v.property[data.type] + data.process
                 v[data.type] = v.property[data.type]
              end  
          end
      end
    end

    self.mapNum = 2
     --是否显示创建角色时的登场特效
    self.isCreateRoleEffect = true
    self.entryPosition =   display.cx
    self.mapWidth = 1136 * self.mapNum
    BattleManager.setSceneWidth(self.mapWidth-360)

    newrandomseed()
    local map = math.random(1,MAP_BATTLE_NUM)
    self:createMap(map)
    self:createMaskLayer()
    self:createTeam()
    self:createEnemyTeam()
    self:createAutoBtn()

    --自己的主城塔
    local castle = TowerNode.new({
        towerId = "231",
        camp = GameCampType.left,
        enemyCamp = GameCampType.right,
        level = GameExp.getUserLevel(UserData.totalExp) --获取战队等级
    })
 
    castle:setPosition(350,120)
    castle:addTo(self.mainLayer)
    castle:createAnimNode()
    
    self.ctrlLayer = CtrlLayer:new():addTo(self)
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
    }):addTo(self):addPauseButton()
    self.hubLayer:startCountdown()
    
    BattleEvent:addEventListener(BattleEvent.HERO_FALSH, handler(self, self.showHeroFlash))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_BEGIN, handler(self, self.onSkillBegin))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_END, handler(self, self.onSkillEnd))
    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
    BattleEvent:addEventListener(BattleEvent.KILL_CHARACTER, handler(self, self.onCharacterKill))
    BattleEvent:addEventListener(BattleEvent.CALL_MEMBER, handler(self, self.onCallMember))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_BEGIN, handler(self, self.onEnterSkillBegin))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_END, handler(self, self.onEnterSkillEnd))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.SLOW_BEGIN, handler(self, self.onSlowBegin))
    BattleEvent:addEventListener(BattleEvent.SLOW_END, handler(self, self.onSlowEnd))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_BEGIN, handler(self, self.onTailSkillBegin))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_END, handler(self, self.onTailSkillEnd))
    BattleEvent:addEventListener(BattleEvent.KILL_TOWER, handler(self, self.onTowerKill))

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()
end

function AincradBattleScene:createEnemyTeam()
	  self.enemyTeam = {}

    local leader = CharacterNode.new({
        camp      = GameCampType.right,
        enemyCamp = GameCampType.left,
        isLeader = true,
        auto = true,
        model = self.params.enemy.team[1]
    })

    local y = BattlePosition.right[1].y
    leader:setPosition( self.mapWidth - leader.model.attackSize.width * 0.5,y)
    leader:setLocalZOrder(self.MAX_Z - y)
    leader:addTo(self.mainLayer)

    self.enemyTeam[1] = leader

    if leader.model.evolve then
        local evolveNode = leader:createEvolve()
        evolveNode:setVisible(false)
        evolveNode:pauseAll()
        evolveNode:addTo(self.mainLayer)

        local btn  = AngerButton.new(leader)
        btn:addTo(self)
        btn:setVisible(false)
        btn:onButtonClicked(function(event)
            if leader == nil or not leader:isActive() then
              return
            end
            btn:setButtonEnabled(false)
            btn.progress1:setPercentage(0)
            btn:setEvolveMode(true)

            leader.model.anger = 0
            leader:showEvolutionEffect()
        end)

        leader.onUpdateAnger   = handler(btn, btn.onUpdateAnger1)
        evolveNode.onUpdateAnger = handler(btn, btn.onUpdateAnger2)
    end
   
    --敌方尾兽技能
    if self.params.enemy.tailSkill then
         -- 队长变身前 变身后共用的尾兽技能管理 
        local tailSkillMgr = TailSkillManager.new(leader.camp)
        local tailLv = self.params.enemy.tailSkill.level

        for k,v in pairs(self.params.enemy.tailSkill.skill) do
            tailSkillMgr:addSkill(v,tailLv)
        end
        leader.tailSkillMgr = tailSkillMgr
        if leader.evolveNode then
          leader.evolveNode.tailSkillMgr = tailSkillMgr
        end
    end

    --敌方队员
      for i=2,#self.params.enemy.team do
	        local member = CharacterNode.new({
				  auto = true,
				  isLeader       = false,
				  followDistance = 50,
				  model = self.params.enemy.team[i],
				  camp      = GameCampType.right,
				  enemyCamp = GameCampType.left
	      })

	      member:setLocalZOrder(self.MAX_Z - BattlePosition.right[i].y)
	      local x,y = leader:getPosition()
	      member:setPosition( x + member.leaderDistance, BattlePosition.right[i].y)
	      -- end
	      member:addTo(self.mainLayer)
	      self.enemyTeam[i] = member
    end
end

--[[
    重写 角色死亡时触发
--]]
function AincradBattleScene:onCharacterKill(event)
    local dead = event.dead
    if dead.camp == GameCampType.left then
    	  if dead.isLeader then
  	        self:onGameLose()
  	    else
  	        --队员不死条件没有达成
  	        self.starCondition[2] = false
            local index = table.indexof(self.team,dead)
            self.hubLayer.memberButtonGroup:onMemderDead(index)
  	    end
    else
        self.deadCount = self.deadCount + 1
        if self.deadCount == #self.enemyTeam then
            self:onGameWin()
        end
    end
end

--[[
  重写 战斗胜利
--]]
function AincradBattleScene:onGameWin()
    self.isWin = true
    self:onGameOver()
    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

--[[
    重写 战斗失败
--]]
function AincradBattleScene:onGameLose()
    self:onGameOver()
    self:removeRoles()
    self.hubLayer:setVisible(false)
    self:battleEndRequest()    
end


--[[
    重写 战斗超时 
--]]
function AincradBattleScene:onGameTimeOut()
    self.params.timeOut = true
    self:onGameLose()
end

function AincradBattleScene:battleEndRequest()
    showLoading()
    if self.isWin then
        self.params.starNum = 1
        local conditionTime = GameConfig.AincradInfo["1"].TwoStarTime
        if self.hubLayer.timer < tonumber(conditionTime) then
            self.params.starNum = self.params.starNum + 1
        end

        conditionTime = GameConfig.AincradInfo["1"].ThreeStarTime
        if self.hubLayer.timer < tonumber(conditionTime) then
            self.params.starNum = self.params.starNum + 1
        end

        local data = self:getTeamJson(true)
        local params = {param1 = 1, param2 = data, param3 = self.params.starNum}
        NetHandler.gameRequest("SaveAincradBattleResult",params)
    else
        local data = self:getTeamJson(false)
        local params = {param1 = 0, param2 = data}
        NetHandler.gameRequest("SaveAincradBattleResult",params)
    end    
end

--[[
  生成战斗结果保存数据
  success 战斗结果
--]]
function AincradBattleScene:getTeamJson(success)
  	local tb = {}
  	tb.left  = {}
  	tb.right = {}
  	tb.success = success
    for k,v in pairs(self.team) do
   		  local data = {}
        data["roleId"] = v.roleId
        data["hp"]     = v.model.hp
        data["anger"]  = v.model.anger
        --战斗胜利 恢复队长怒气和全队血量
        if tb.success then
            if v.isLeader then
                data["anger"] =  math.min(data["anger"] + v.model.maxAnger * 0.3, v.model.maxAnger)
            end
            data["hp"] = math.min(data["hp"] + v.model.maxHp * 0.3, v.model.maxHp)
        else
            data["hp"] = 0
        end

        data["hp"] =  data["hp"] / v.model.maxHp
        AincradData:setOldHero(data.roleId, data.hp, data.anger)
    end

    tb.left = AincradData:getOldHeros()
    for k,v in pairs(self.enemyTeam) do
   		  local data = {}
  		  data["roleId"] = v.roleId
  		  data["hp"]     = v.model.hp / v.model.maxHp
  		  data["anger"]  = v.model.anger
  		  table.insert(tb.right,data)
    end

    return json.encode(tb)
end

return AincradBattleScene