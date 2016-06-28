--
-- Author: zsp
-- Date: 2015-04-08 12:04:23
--

local BattleScene        = require("app.scenes.BattleScene")
local BattleLogic        = require("app.battle.BattleLogic")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local EnemyNode          = require("app.battle.node.EnemyNode")
local TrapNode           = require("app.battle.node.TrapNode")
local TowerNode          = require("app.battle.node.TowerNode")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,150),cc.p(80,180),cc.p(130,220)}
BattlePosition.right = {cc.p(0,140),cc.p(40,180),cc.p(80,220)}

local TrialHouseBattleScene = class("TrialHouseBattleScene",BattleScene )

--[[
  修炼圣地 精神时间之屋 战斗场景
--]]
function TrialHouseBattleScene:ctor(params)
	TrialHouseBattleScene.super.ctor(self,params)
end

function TrialHouseBattleScene:init()
    self.entryPosition = 250
    self.mapWidth = display.width
    BattleManager.setSceneWidth(self.mapWidth)

    self:createMap("3")
    self:createMaskLayer()
    self:createTeam()
    self:createAutoBtn()

    self.ctrlLayer = CtrlLayer:new():addTo(self)
    --控制角色
    self.ctrlLayer.ctrlNode = self.leader
    --相机跟踪角色
    self.followRole = self.ctrlLayer.ctrlNode
    --启用相机跟中角色
    self.fllowRoleEnable = false
    --屏幕场景相机偏移距离
    --self.cameraOffset = self.leader.model.attackSize.width * 0.5

    self.hubLayer = BattleHubLayer.new({
        ["team"]       = self.team,
        ["tailSkill"]  = self.params.tailSkill,
        ["timeOut"] = 300
    }):addTo(self):addPauseButton()
  
    self.logic = BattleLogic.new({
        ["wave"] = self.params.wave,
        ["parent"] = self.mainLayer
    })
   
    BattleEvent:addEventListener(BattleEvent.HERO_FALSH, handler(self, self.showHeroFlash))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_BEGIN, handler(self, self.onSkillBegin))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_END, handler(self, self.onSkillEnd))
    BattleEvent:addEventListener(BattleEvent.LOGIC_CREATE_WAVE, handler(self, self.onWaveBegin))
    BattleEvent:addEventListener(BattleEvent.LOGIC_CREATE_ENEMY, handler(self, self.onCreateEnemy))
    BattleEvent:addEventListener(BattleEvent.LOGIC_CREATE_END, handler(self, self.onCreateEnemyEnd))
    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
    BattleEvent:addEventListener(BattleEvent.KILL_ENEMY, handler(self, self.onEnemyKill))
    BattleEvent:addEventListener(BattleEvent.KILL_CHARACTER, handler(self, self.onCharacterKill))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_BEGIN, handler(self, self.onEnterSkillBegin))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_END, handler(self, self.onEnterSkillEnd))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()
end

--[[
  创建场景地图
--]]
function TrialHouseBattleScene:createMap(map)
    self.bgLayer = display.newLayer()
    self.bgLayer:addTo(self)

    self.battleLayer = display.newLayer()
    self.battleLayer:addTo(self)

    self.mainLayer = display.newLayer()
    self.mainLayer:addTo(self.battleLayer)

    self.fgLayer = display.newLayer()
    self.fgLayer:addTo(self.battleLayer)

    local bg = display.newSprite("map_trails_exp.jpg")
    bg:setPosition(display.cx,display.cy)
    bg:addTo(self.bgLayer)
end

--[[
    重写创建队员方法 没有替补队员
--]]
function TrialHouseBattleScene:createMember()
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
    重写敌人死亡时触发 没又掉落
--]]
function TrialHouseBattleScene:onEnemyKill(event)
    local dead = event.dead
    self.logic:addKill(GameCampType.right, dead) 

    if self.logic:isKillEnemyies() then
        self:onGameWin()
    end
end

--[[
    角色死亡时触发
--]]
function TrialHouseBattleScene:onCharacterKill(event)
    local dead = event.dead
    self.logic:addKill(GameCampType.left, dead)

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
function TrialHouseBattleScene:onGameWin()
    self:onGameOver()
    local roles = BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

function TrialHouseBattleScene:battleEndRequest()
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
    local tid = self:getAwardId()
    --设置奖励道具
    local num = #self.params.team.team1 - self.logic.kills[GameCampType.left][GameNodeType.ROLE]
    showLoading()
    NetHandler.gameRequest("GetSpiritHomeReward",{param1 = num, param2 = self.params.levelId})
end

--[[
    按等级获取对应数据ID
--]]
function TrialHouseBattleScene:getAwardId()
    local teamLevel = GameExp.getUserLevel(self.params.teamTotalExp)
    local tid = 1
    for k,v in pairs(GameConfig.Trials_Exp) do
        if teamLevel < checkint(v.Level) then
            tid = math.max(checkint(k) - 1,1)
            return string.format("%d", tid)
        end
    end
    return string.format("%d", tid)
end

return TrialHouseBattleScene