--
-- Author: zsp
-- Date: 2015-04-09 16:50:19
--

local BattleScene        = require("app.scenes.BattleScene")
local BattleLogic        = require("app.battle.BattleLogic")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local ClockNode          = require("app.battle.node.ClockNode")
local LootNode           = require("app.battle.node.LootNode")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,140),cc.p(80,180),cc.p(130,220)}

local TrialLightBattleScene = class("TrialLightBattleScene",BattleScene )

--[[
  修炼圣地 山多拉的灯 战斗场景
--]]
function TrialLightBattleScene:ctor(params) 
    TrialLightBattleScene.super.ctor(self,params)
end

function TrialLightBattleScene:load()

    self.params.team.team1[1].evolve = true

    if self.params.tailSkill and #self.params.tailSkill.skill == 0 then
        self.params.tailSkill = nil
    end
    
    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    local assetNames = GafAssetCache.reset()
    .addTeamAssetName(self.params.team.team1)
    .addTailSkillAssetName(self.params.tailSkill)
    .addClockAsset()
    .addAttackEffect()
    .addEnterEffect()
    .getAssetNames()

    loading:load(assetNames,handler(self, self.init))
end

function TrialLightBattleScene:init()
    self.entryPosition =  self.params.entryPosition or 250
    self.mapWidth = display.width
    BattleManager.setSceneWidth(self.mapWidth)

  
    --初始化总的钟数量 createClock方法里计算
    self.clockTotal = 0
    --初始化已经打碎钟的总数
    --self.killTotal = 0
    --初始化获得的金币数量
    self.goldTotal = 0
    --打碎的种id
    self.killIds = {}
    
    self:createMap("2")
    self:createMaskLayer()
    self:createTeam()
    self:createClock()
    self:createAutoBtn()

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
       -- ["timeOut"] = 300
    }):addTo(self):addPauseButton()
    
    self.hubLayer.waveLabel:setVisible(false)
    self.hubLayer.timeOut = self.params.time --checkint(self.cfg.Time)
    self.hubLayer:startCountdown()

    BattleEvent:addEventListener(BattleEvent.HERO_FALSH, handler(self, self.showHeroFlash))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_BEGIN, handler(self, self.onSkillBegin))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_END, handler(self, self.onSkillEnd))
    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.KILL_CLOCK, handler(self, self.onClockKill))
    
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()

end

--[[
  创建场景地图
--]]
function TrialLightBattleScene:createMap(map)

   self.bgLayer = display.newLayer()
   self.bgLayer:addTo(self)

   self.battleLayer = display.newLayer()
   self.battleLayer:addTo(self)

   self.mainLayer = display.newLayer()
   self.mainLayer:addTo(self.battleLayer)

   self.fgLayer = display.newLayer()
   self.fgLayer:addTo(self.battleLayer)

  -- body
   
   local bg = display.newSprite("map_trails_gold.jpg")
   --bg:setAnchorPoint(cc.p(0, 0))
   --w = bg:getContentSize().width
   bg:setPosition(display.cx,display.cy)
   bg:addTo(self.bgLayer)

   local fg = display.newSprite("map_trails_gold_f.png")
   fg:setAnchorPoint(cc.p(0.5,0))
   fg:setPosition(display.cx,display.bottom)
   fg:addTo(self.fgLayer)
end

--[[
    重写创建队员方法 没有替补队员
--]]
function TrialLightBattleScene:createMember()
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

--[[
  按阵型创建钟
--]]
function TrialLightBattleScene:createClock()

  local x = display.cx + 20
  local addX = 70
  local addY = 67
  local baseY = 270 

  function createItem(data)
      local clock = ClockNode.new({
          clockId = data.id,
          level   = self.params.clockLevel
      })
      self.clockTotal = self.clockTotal + 1
      return clock 
  end

	local moveX = function(data)
    if data.size == 4 then 
      return addX * 2
    else 
      return addX 
    end
  end

  function moveSingle(data) 
      --print("single move")
      x = x + moveX(data)
      createItem(data)
      :addTo(self.mainLayer)
      :pos(x, baseY - addY * 2)
      x = x + moveX(data)
  end

  function moveTable(arr)
      --print("table move")
      x = x + moveX(arr[1])
      local y = baseY
      for i,v in ipairs(arr) do
        y = y - addY 
        createItem(v)
        :addTo(self.mainLayer)
        :pos(x, y)
        y = y - addY
      end
      x = x + moveX(arr[1])
  end

 -- dump(self.items_, "formation")
  for i,v in ipairs(self.params.clock) do   
      if v.id then  
        moveSingle(v)     
      else 
        moveTable(v)
      end 
  end

end

--[[
  打碎钟回调
--]]
function TrialLightBattleScene:onClockKill(event)
  -- body
  --self.killTotal = self.killTotal + 1
  
  local dead = event.dead

  table.insert(self.killIds,dead.clockId)

  if dead.model.type == "1" or dead.model.type == "4" then
    self.goldTotal = self.goldTotal + self.params.smallGold
  elseif dead.model.type == "2" or dead.model.type == "5" then
     self.goldTotal = self.goldTotal + self.params.middleGold
  elseif dead.model.type == "3" or dead.model.type == "6" then
     self.goldTotal = self.goldTotal + self.params.largeGold
  end
  
  print(string.format("打碎了%d/%d个", #self.killIds,self.clockTotal))
  if #self.killIds == self.clockTotal then
    self.goldTotal = self.goldTotal + self.params.totalGold
    self:onGameWin()
  end

end

--[[
    战斗超时
--]]
function TrialLightBattleScene:onGameTimeOut()
    self.params.timeOut = true
    self:onGameOver()
    self.hubLayer:setVisible(false)

    if #self.killIds == 0 then
        self:removeRoles()
        local layer = require("app.views.battle.BattleLoseLayer").new(self.params)
        layer:addTo(self)
    else
        BattleManager.roleIterator(function(v,k)
            if v:isActive() then
                v:doWin()
            end
        end)
        scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
    end
end

--[[
    战斗胜利
--]]
function TrialLightBattleScene:onGameWin()
    self:onGameOver()
    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

function TrialLightBattleScene:battleEndRequest()
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
    self.params.gold = self.goldTotal
    showLoading()
    local params = {
        param1 = table.concat(self.killIds,","),
        param2 = self.params.id,
        param3 = self.params.type,
    }
    NetHandler.gameRequest("GetShanDuoLaReward",params)
end

--[[
    按等级获取对应数据ID
--]]
function TrialLightBattleScene:getAwardId()
   
   local teamLevel = GameExp.getUserLevel(self.params.teamTotalExp)
   local tid = 1
   for k,v in pairs(GameConfig.Trials_Gold) do
        --print(v.Level)
       if teamLevel < checkint(v.Level) then
            tid = math.max(checkint(k) - 1,1)
            return string.format("%d", tid)
       end
   end

   return string.format("%d", tid)
end


return TrialLightBattleScene