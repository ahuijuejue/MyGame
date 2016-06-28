--
-- Author: zsp
-- Date: 2015-04-27 15:53:39
--


local BattleScene        = require("app.scenes.BattleScene")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local TrapNode           = require("app.battle.node.TrapNode")
local TowerNode          = require("app.battle.node.TowerNode")
local CharserNode        = require("app.battle.node.CharserNode")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local PreviewLayer       = require("app.views.battle.PreviewLayer")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,140),cc.p(80,140),cc.p(130,180),cc.p(40,180),cc.p(80,220),cc.p(130,220)}
BattlePosition.right = {cc.p(0,140),cc.p(40,180),cc.p(80,220)}

local BattleRunAwayScene = class("BattleRunAwayScene",BattleScene )


--[[
  修炼圣地 精神时间之屋 战斗场景
--]]
function BattleRunAwayScene:ctor(params) 
     BattleRunAwayScene.super.ctor(self,params)
end

function BattleRunAwayScene:load()

    self.params.team.team1[1].evolve = true

    if self.params.tailSkill and #self.params.tailSkill.skill == 0 then
      -- print("没有尾兽技能")
      self.params.tailSkill = nil
    end

    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

     local assetNames =  GafAssetCache.reset()
    .addTeamAssetName(self.params.team.team1)
    .addTeamAssetName(self.params.team.team2)
    .addEnterSkillAssetName(self.params.team.team1)
    .addEnterSkillAssetName(self.params.team.team2)
    .addTailSkillAssetName(self.params.tailSkill)
    .addTowerAssetName(self.params.customId)
    .addAssetName("atk_effect_2")
    .addAssetName("atk_effect_3")
    .addAssetName("enter_effect_3")
    .addAssetName("run_wind")
    .addAssetName("door")
    .addAssetName(GameConfig.enemy["30001"].image)
    .getAssetNames()

    loading:load(assetNames,handler(self, self.init))
end

function BattleRunAwayScene:init()
	  --AudioManage.playMusic("Battle1.mp3", true)

	  self.over = false
    self.mapNum = 6
    self.entryPosition =  250
    self.mapWidth = display.width * self.mapNum
    BattleManager.setSceneWidth(self.mapWidth)
    
    self:createMap("2")
    self:createTower()
    self:createMaskLayer()
    self:createTeam()

    self.charser = self:createCharser()

    self.fllowRoleEnable = true
    self.cameraOffset = 0
    
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
        ["followNode"] = self.leader,
        ["timeOut"]    = self.params.endTime
    }):addTo(self):addPauseButton()
    
    self.hubLayer.waveLabel:setVisible(false)
    self.hubLayer.timeOut = 300 --checkint(self.cfg.Time)
    self.hubLayer:startCountdown()

    local preview = PreviewLayer.new({
        ["endPoint"] = BattleManager.sceneWidth - 200
    })


    -- self.run_wind =  GafAssetCache.makeAnimatedObject("run_wind")
    -- local frameSize = self.run_wind:getFrameSize()
    -- self.run_wind:setPosition(frameSize.width * - 0.5 ,frameSize.height - 440 + 300 )
    -- self.run_wind:addTo(self.mainLayer)
    -- self.run_wind:start()
    -- self.run_wind:playSequence("run_wind",true)

    self.door =  GafAssetCache.makeAnimatedObject("door")
    local frameSize = self.door:getFrameSize()
    self.door:setPosition(frameSize.width * - 0.5 + BattleManager.targetWidth,frameSize.height - 440 + self.leader:getPositionY())
    self.door:addTo(self.mainLayer)
    self.door:start()
    self.door:playSequence("door",true)

    preview:setPosition(display.width - 130 ,display.height - 120)
    preview:addTo(self.hubLayer)
    preview:addFollow(self.leader)
    preview:addCharser(self.charser)   

    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_BEGIN, handler(self, self.onSkillBegin))
    BattleEvent:addEventListener(BattleEvent.SKILL_EFFECT_END, handler(self, self.onSkillEnd))
    BattleEvent:addEventListener(BattleEvent.CALL_MEMBER, handler(self, self.onCallMember))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_BEGIN, handler(self, self.onEnterSkillBegin))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_END, handler(self, self.onEnterSkillEnd))

    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.KILL_CHARACTER, handler(self, self.onCharacterKill))
    BattleEvent:addEventListener(BattleEvent.ESCORT_END, handler(self, self.onEscortEnd))
    
    self:doGuide()
    
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()

end

--[[
	创建地图 循环的场景
--]]
function BattleRunAwayScene:createMap(map)
   
   self.bgLayer     = display.newLayer()
   self.bgLayer:addTo(self)
   
   self.battleLayer = display.newLayer()
   self.battleLayer:addTo(self)
   
   self.mainLayer   = display.newLayer()
   self.mainLayer:addTo(self.battleLayer)
   
   self.fgLayer    = display.newLayer()
   self.fgLayer:addTo(self.battleLayer)

	-- body
	for i=1, self.mapNum - 1 do
		local bg = display.newSprite("map_runaway_bg.jpg") --self.customId))
		--bg:setAnchorPoint(cc.p(0, 1))
    bg:setAnchorPoint(cc.p(0, 0))
		local w = bg:getContentSize().width
		bg:setPosition((i-1)*w,0)
		bg:addTo(self.bgLayer)
	end

  	for i=1, self.mapNum do
    		local bg = display.newSprite("map_runaway_m.png") --self.customId))
    		bg:setAnchorPoint(cc.p(0, 0))
    		local w = bg:getContentSize().width
    		bg:setPosition((i-1)*w,0)
    		bg:addTo(self.mainLayer)
  	end

    self.md2 = display.newSprite("map_runaway_d_2.png") --self.customId))
    self.md2:setAnchorPoint(cc.p(1,0))
    self.md2:setPosition(self.mapNum * display.width,0)
    self.md2:addTo(self.mainLayer)

    self.md1 = display.newSprite("map_runaway_d_1.png") --self.customId))
    self.md1:setAnchorPoint(cc.p(1,0))
    self.md1:setPosition(self.mapNum * display.width,0)
    self.md1:setLocalZOrder(999)
    self.md1:addTo(self.mainLayer)

    for i=1, self.mapNum do
      local fg = display.newSprite("map_runaway_f_1.png") --self.customId))
      fg:setAnchorPoint(cc.p(0, 0))
      local w = fg:getContentSize().width
      fg:setPosition((i-1)*w,0)
      fg:addTo(self.fgLayer)
    end
end

--[[
	创建最忌的怪物
--]]
function BattleRunAwayScene:createCharser()
	local charser = CharserNode.new({
		roleId = "30001"
	})
	local rdm = 1
	local y = BattlePosition.right[rdm].y
  	charser:setLocalZOrder(self.MAX_Z - y)
  	charser:setPosition(cc.p(-300,y))
  	charser:addTo(self.mainLayer)
  	return charser
end

--[[
    获取除了exRole之外的角色 把追击的怪物加进去 以便在释放技能 或变身时能够暂停
--]]
function BattleRunAwayScene:getRoles(exRole)
  local roles =  BattleRunAwayScene.super.getRoles(self,exRole)
  table.insert(roles,self.charser)
  return roles
end

--[[
  护送模式下 护送目标到终点位置
--]]
function BattleRunAwayScene:onEscortEnd(event)
  -- body
   self.charser:stopRun()
   self:onGameWin()
end

return BattleRunAwayScene

