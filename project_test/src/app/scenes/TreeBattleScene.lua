--
-- Author: zsp
-- Date: 2015-07-22 10:08:38
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
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,150),cc.p(80,150),cc.p(130,190),cc.p(40,190),cc.p(80,220),cc.p(130,220)}
BattlePosition.right = BattlePosition.left

local TreeBattleScene = class("TreeBattleScene",BattleScene)

--[[
   世界树 战斗场景
--]]
function TreeBattleScene:ctor(params)
	TreeBattleScene.super.ctor(self,params)
end

function TreeBattleScene:load()
    -- 己方队长是否能变身
    if self.params.team.team1[1]:checkEvolve() then
        self.params.team.team1[1].evolve = true
    end

	  if self.params.tailSkill and #self.params.tailSkill.skill == 0 then
        self.params.tailSkill = nil
  	end

  	self.treeCustomId = self:getTreeCustomId()
  	self.waveId = self:getWaveId()
  
    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    local assetNames =  GafAssetCache.reset()
    .addTeamAssetName(self.params.team.team1)
    .addTeamAssetName(self.params.team.team2)
    .addEnterSkillAssetName(self.params.team.team1)
    .addEnterSkillAssetName(self.params.team.team2)
    .addTailSkillAssetName(self.params.tailSkill)
    .addTreeCustomAssetName(self.treeCustomId)
    .addTreeWaveAssetName(self.waveId)
    .addBuildingAssetName(self.params.building)
    .addAttackEffect()
    .addEnterEffect()
    .addAssetName("Tower5")
    .getAssetNames()

    display.addSpriteFrames("texture_buff.plist","texture_buff.pvr.ccz")
    loading:load(assetNames,handler(self, self.init))
end

--[[
	--用treeweId和chapter 取 tree_custom表的当customId
--]]
function TreeBattleScene:getTreeCustomId()
	local treeCustomId = nil
  	for k,v in pairs(GameConfig.tree_custom) do
		if v.treeweId == self.params.treeweId and v.chapter == self.params.chapter then
			    treeCustomId = k
  			  break
  		end
  	end
  	return treeCustomId
end

function TreeBattleScene:getWaveId()
  	local totalWight = 0
  	local waveArr = {}
    local wightArr = {}
  	local waveType = GameConfig.tree_custom[self.treeCustomId].wave
  	for k,v in pairs(GameConfig.tree_wave) do
    		for i = 1,#waveType do
      			if waveType[i] == v.type then
      				  totalWight = totalWight + checkint(v.wight)
      				  table.insert(wightArr,totalWight)
                table.insert(waveArr,k)
      			end
    		end
  	end
    local index = 1
	  newrandomseed()
	  local wight = math.random(1,totalWight)
    for i,v in ipairs(wightArr) do
        if v > wight then
            index = i
            break
        end
    end
    return waveArr[index]
end

function TreeBattleScene:init()
    self.mapNum = 2
     --是否显示创建角色时的登场特效
    self.isCreateRoleEffect = true
    self.entryPosition =   display.cx
    self.mapWidth = 1136 * self.mapNum
    BattleManager.setSceneWidth(self.mapWidth-360)

    self:createMap(99)
    self:createMaskLayer()
    self:createBuilding()
    self:createTeam()
    self:createAutoBtn()

    self.logic = BattleLogic.new({
      	["waveTableName"] = "tree_wave",
  		  ["parent"]      = self.mainLayer,
  		  ["triggerRole"] = self.leader,
  		  ["wave"] = self.waveId,
        ["treeCustomId"] = self.treeCustomId,
  		  ["extraWave"] = {
  			["condition"] = GameConfig.tree_custom[self.treeCustomId].condition,
  			["keys"] = GameConfig.tree_custom[self.treeCustomId].keys,
  			["wave_pos"] = GameConfig.tree_custom[self.treeCustomId].wave_pos,
  			["wave_wave"] = GameConfig.tree_custom[self.treeCustomId].wave_wave,
		  }
    })
    
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
    BattleEvent:addEventListener(BattleEvent.KILL_ENEMY, handler(self, self.onEnemyKill))
    BattleEvent:addEventListener(BattleEvent.KILL_TOWER, handler(self, self.onTowerKill))
    --设置己方塔死亡记录
    BattleEvent:addEventListener(BattleEvent.KILL_TOWER, handler(self, self.onTowerKill2))

    BattleEvent:addEventListener(BattleEvent.CALL_MEMBER, handler(self, self.onCallMember))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_BEGIN, handler(self, self.onEnterSkillBegin))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_END, handler(self, self.onEnterSkillEnd))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.SLOW_BEGIN, handler(self, self.onSlowBegin))
    BattleEvent:addEventListener(BattleEvent.SLOW_END, handler(self, self.onSlowEnd))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_BEGIN, handler(self, self.onTailSkillBegin))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_END, handler(self, self.onTailSkillEnd))

    BattleEvent:addEventListener(BattleEvent.LOGIC_CREATE_WAVE, handler(self, self.onWaveBegin))
    BattleEvent:addEventListener(BattleEvent.LOGIC_CREATE_ENEMY, handler(self, self.onCreateEnemy))
    BattleEvent:addEventListener(BattleEvent.LOGIC_CREATE_END, handler(self, self.onCreateEnemyEnd))

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()
end

function TreeBattleScene:createBuilding()
  self.building = {}
	
  if self.params.building then

    local lastData = nil
    if self.params.battleInfo then
       lastData = json.decode(self.params.battleInfo).building    
    end
		for k,v in pairs(self.params.building) do
        if lastData then
            if lastData[v.type].hp > 0 then
                local castle = TowerNode.new({
                    towerId   = v.id,
                    camp      = GameCampType.left,
                    enemyCamp = GameCampType.right,
                    level     = v.level,
                    starLv    = v.starLv
                })
                local type_ = v.type
                castle:setPosition(type_*350,120)
                castle:addTo(self.mainLayer)
                castle:createAnimNode()
                castle.model.hp = lastData[v.type].hp
                self.building[v.type] = castle
            end
        else
            --第一次进入,还没有上次的保存信息
            local castle = TowerNode.new({
                towerId   = v.id,
                camp      = GameCampType.left,
                enemyCamp = GameCampType.right,
                level     = v.level,
                starLv    = v.starLv
            })
            local type_ = v.type
            castle:setPosition(type_*350,120)
            castle:addTo(self.mainLayer)
            castle:createAnimNode()
            self.building[v.type] = castle
        end
		end
	end
end

function TreeBattleScene:createMap(map)
    self.bgLayer     = display.newLayer()
    self.bgLayer:addTo(self)

    self.battleLayer = display.newLayer()
    self.battleLayer:addTo(self)

    self.mainLayer   = display.newLayer()
    self.mainLayer:addTo(self.battleLayer)

    self.fgLayer     = display.newLayer()
    self.fgLayer:addTo(self.battleLayer)

    local w = 0
    for i=1, self.mapNum do
        local bg = display.newSprite(string.format("map_%s_m_%d.png",map,i)) --self.customId))
        bg:setAnchorPoint(cc.p(0, 0))
        w = bg:getContentSize().width
        bg:setPosition((i-1)*w,0)
        bg:addTo(self.mainLayer)
    end

    for i=1, self.mapNum do
        local bg = display.newSprite(string.format("map_%s_f_%d.png",map,i)) --self.customId))
        bg:setAnchorPoint(cc.p(0, 0))
        w = bg:getContentSize().width
        bg:setPosition((i-1)*w,0)
        bg:addTo(self.fgLayer)
    end
end

function TreeBattleScene:battleEndRequest()
    showLoading()
    self.params.starNum = 3

    local data = self:getTeamJson(true)
    TreeData:setBattleData(data)
    NetHandler.gameRequest("SaveTreeWorldGuanka",{param1 = data})
end

--[[
   己方塔挂掉后 需要记录
--]]
function TreeBattleScene:onTowerKill2(event)
    local dead = event.dead
    if dead.camp == GameCampType.left then
        local key = tostring(dead.model.type)
        if self.building[key] then
          self.building[key] = nil
        end
    end
end

--[[
  生成战斗结果保存数据
  success 战斗结果
--]]
function TreeBattleScene:getTeamJson(success)
  	local tb = {}
  	tb.team  = {}
  	tb.building = {}
  	tb.buff = {}
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

        tb.team[v.roleId] = data
    end

    -- 保存当次基地塔血量
    for k,v in pairs(self.params.building) do
        tb.building[v.type] = {}
        tb.building[v.type].hp = 0
        if self.building[v.type] then
            tb.building[v.type].hp = self.building[v.type].model.hp
        end
    end

    return json.encode(tb)
end

return TreeBattleScene