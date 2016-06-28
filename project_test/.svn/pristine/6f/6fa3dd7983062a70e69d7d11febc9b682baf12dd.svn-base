--
-- Author: zsp
-- Date: 2015-04-13 14:42:44
--

local BattleScene        = require("app.scenes.BattleScene")
local BattleLogic        = require("app.battle.BattleLogic")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local EnemyNode          = require("app.battle.node.EnemyNode")
local TowerNode          = require("app.battle.node.TowerNode")
local LootNode           = require("app.battle.node.LootNode")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,140),cc.p(80,180),cc.p(130,220)}
BattlePosition.right = {cc.p(40,180)}

local TrialMountBattleScene = class("TrialMountBattleScene",BattleScene )

--[[
  修炼圣地 庐山乌五老峰 战斗场景
--]]
function TrialMountBattleScene:ctor(params) 
    TrialMountBattleScene.super.ctor(self,params)
end

function TrialMountBattleScene:load()

    --队长是否能变身
    if self.params.team.team1[1]:checkEvolve() then
        self.params.team.team1[1].evolve = true
    end

    if self.params.tailSkill and #self.params.tailSkill.skill == 0 then
      -- print("没有尾兽技能")
      self.params.tailSkill = nil
    end
    
    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    GafAssetCache.reset()
    .addTeamAssetName(self.params.team.team1)
    .addTailSkillAssetName(self.params.tailSkill)
    .addAttackEffect()
    .addEnterEffect()
    .addAssetName("Dohko")
    
    for k,v in pairs(self.params.enemy) do
        local eid = v.roleId
        local image = GameConfig.enemy[eid].image

        GafAssetCache.addAssetName(GameConfig.enemy[eid].image)
        .addAssetName(GameConfig.enemy[eid].atk_effect)

        if image == "sWindranger" then
            GafAssetCache.addAssetName("sWindranger_skill_2")
        end
        if image == "sOrigami" then
            GafAssetCache.addAssetName("sOrigami_skill_2")
            GafAssetCache.addAssetName("sOrigami_skill_3")
        end
        if image == "Windranger" then
            GafAssetCache.addAssetName("Windranger_skill_2")
        end
        if image == "Origami" then
            GafAssetCache.addAssetName("Origami_skill_1")
        end
        if image == "Uryuu" then
            GafAssetCache.addAssetName("Uryuu_skill_2")
        end
        if image == "Shino" then
            GafAssetCache.addAssetName("Shino_skill_1")
            GafAssetCache.addAssetName("Shino_skill_2")
        end
        if image == "sShino" then
            GafAssetCache.addAssetName("sShino_skill_2")
        end
    end

    local assetNames =  GafAssetCache.getAssetNames()

    loading:load(assetNames,handler(self, self.init))
end

function TrialMountBattleScene:init()
    self.entryPosition = 250
    self.mapWidth = display.width
    BattleManager.setSceneWidth(self.mapWidth)

  	--初始化总的钟数量 createClock方法里计算
  	self.enemyTotal = table.nums(self.params.enemy)
  	--初始化已经打碎钟的总数
  	self.killTotal  = 0
  	--初始化灵能值数
  	self.skillTotal = 0
    
    self:createMap("2")
    self:createMaskLayer()
    self:createTeam()
    self:createAutoBtn()

    --自己的主城塔
    local castle = TowerNode.new({
        towerId = "252",
        camp = GameCampType.left,
        enemyCamp = GameCampType.right,
        level = GameExp.getUserLevel(UserData.totalExp) --获取战队等级
    })
    castle:setPosition(150,120)
    castle:addTo(self.mainLayer)
    castle:createAnimNode()

    self.ctrlLayer = CtrlLayer:new():addTo(self)
    --控制角色
    self.ctrlLayer.ctrlNode = self.leader
    --相机跟踪角色
    self.followRole = self.ctrlLayer.ctrlNode
    --启用相机跟中角色
    self.fllowRoleEnable = false
    
  
    self.hubLayer = BattleHubLayer.new({
        ["team"]       = self.team,
        ["tailSkill"]  = self.params.tailSkill,
        ["timeOut"] = 300
    }):addTo(self):addPauseButton()
    self.hubLayer:startCountdown()

    BattleEvent:addEventListener(BattleEvent.HERO_FALSH, handler(self, self.showHeroFlash))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_BEGIN, handler(self, self.onSkillBegin))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_END, handler(self, self.onSkillEnd))
    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.KILL_ENEMY, handler(self, self.onEnemyKill))
    BattleEvent:addEventListener(BattleEvent.KILL_CHARACTER, handler(self, self.onCharacterKill))
    BattleEvent:addEventListener(BattleEvent.KILL_TOWER, handler(self, self.onTowerKill))

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()

	   self:onCreateEnemy()
end

--[[
  创建场景地图
--]]
function TrialMountBattleScene:createMap(map)

   self.bgLayer = display.newLayer()
   self.bgLayer:addTo(self)

   self.battleLayer = display.newLayer()
   self.battleLayer:addTo(self)

   self.mainLayer = display.newLayer()
   self.mainLayer:addTo(self.battleLayer)

   self.fgLayer = display.newLayer()
   self.fgLayer:addTo(self.battleLayer)

   local bg = display.newSprite("map_trails_skill.jpg")
   bg:setPosition(display.cx,display.cy)
   bg:addTo(self.bgLayer)

end

function TrialMountBattleScene:onUpdate(dt)
  -- body
  if self.fllowRoleEnable then
    local x,y = self.followRole:getPositionX()
    self:setScenePosition(x, y)
  end

  --更新战斗节点
  BattleManager.update(dt)
end


--[[
    重写创建队员方法 没有替补队员
--]]
function TrialMountBattleScene:createMember()
     for i=2,#self.params.team.team1 do
       local member = CharacterNode.new({
          isLeader       = false,
          followDistance = 50,
          auto = true,
          model = self.params.team.team1[i]
      })

      member:setLocalZOrder(self.MAX_Z - BattlePosition.left[i].y)
      
      local x,y = self.leader:getPosition()
      member:setPosition( x - member.leaderDistance, BattlePosition.left[i].y)
     
      member:addTo(self.mainLayer)

    end
end

function TrialMountBattleScene:onCreateEnemy(event)
	  
	  self.hubLayer.waveLabel:setString(string.format("%d/%d", self.killTotal+1,self.enemyTotal))
	  local enemy  = EnemyNode.new({
			roleId = self.params.enemy[self.killTotal + 1].roleId,
			level  = self.params.enemy[self.killTotal + 1].level
	  })

	  local y = BattlePosition.right[1].y
	  enemy:setLocalZOrder(self.MAX_Z - y)
	  enemy:setPosition(cc.p(BattleManager.sceneWidth - 100,y))
	  enemy:addTo(self.mainLayer)

   -- if self.killTotal > 1 then
        self:pauseGame()
        self:showMaskLayer()
        local anim =  enemy:showEffect("enter_effect_3",function()
            local tb = BattleManager.roles[enemy.enemyCamp]
             for k,v in pairs(tb) do
                if v:isActive() and 
                   v.nodeType == GameNodeType.ROLE and
                   v:getPositionX() > BattleManager.sceneWidth - 300
                  then
                    v.buffMgr:addBuff("40001", 1, enemy)
                end
             end
             self:resumeGame()
             self:hideMaskLayer()
        end)
        local frameSize = anim:getFrameSize()
        anim:setPositionY(frameSize.height - 530) 
   -- end

end
--[[
    敌人死亡时触发
--]]
function TrialMountBattleScene:onEnemyKill(event)
    local dead = event.dead
    self.killTotal  =  self.killTotal + 1

    if self.enemyTotal ==  self.killTotal  then   		
        self:onGameWin()
    else
   		  self:onCreateEnemy()
    end
end

--[[
    角色死亡时触发
--]]
function TrialMountBattleScene:onCharacterKill(event)
  local dead = event.dead

  if dead.isLeader then
      self:onGameLose()
  else
      --队员不死条件没有达成
      self.starCondition[2] = false
  end
end

--[[
    战斗胜利
--]]
function TrialMountBattleScene:onGameWin()
    self:onGameOver()
    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

function TrialMountBattleScene:battleEndRequest()
    --通关加1星
    self.params.starNum = 1
    --没有超过战斗时长加1星
    if self.hubLayer.timer <=  self.params.secondStarTime  then
        self.params.starNum =  self.params.starNum + 1
    end
    --达到条件加一星
    if self.starCondition[self.params.thirdStarCondition] then
        self.params.starNum =  self.params.starNum + 1
    end
    self.params.skillValue = self.params.reward[self.killTotal] 
    showLoading()
    local params = {
        param1 = self.killTotal,
        param2 = self.params.levelId,
    }
    NetHandler.gameRequest("GetWuLaoFengReward",params)
end

--[[
    按等级获取对应数据ID
--]]
function TrialMountBattleScene:getAwardId()
    local teamLevel = GameExp.getUserLevel(self.params.teamTotalExp)
    local tid = 1
    for k,v in pairs(GameConfig.Trials_Skill) do
       if teamLevel < checkint(v.Level) then
            tid = math.max(checkint(k) - 1,1)
            return string.format("%d", tid)
       end
    end
    return string.format("%d", tid)
end


return TrialMountBattleScene