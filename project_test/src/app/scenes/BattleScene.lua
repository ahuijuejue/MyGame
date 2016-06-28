--
-- Author: zsp
-- Date: 2014-11-18 18:02:57
--

local BattleLogic        = require("app.battle.BattleLogic")
local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local EnemyNode          = require("app.battle.node.EnemyNode")
local EscortNode         = require("app.battle.node.EscortNode")
local TrapNode           = require("app.battle.node.TrapNode")
local TowerNode          = require("app.battle.node.TowerNode")
local LootNode           = require("app.battle.node.LootNode")
local TailSkillManager   = require("app.battle.skill.TailSkillManager")
local BattleHubLayer     = require("app.views.battle.BattleHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local BossAppearLayer    = require("app.views.battle.BossAppearLayer")
local BattleWarnLayer    = require("app.views.battle.BattleWarnLayer")
local PreviewLayer       = require("app.views.battle.PreviewLayer")
local CtrlLayer          = require("app.views.battle.CtrlLayer")
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

local HeroFlashLayer     = import("app.views.battle.HeroFlashLayer")
local CharacterModel     = import("app.battle.model.CharacterModel")

--队伍的队形站位
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,150),cc.p(80,170),cc.p(130,190),cc.p(40,190),cc.p(80,220),cc.p(130,220)}
BattlePosition.right = {cc.p(0,140),cc.p(40,180),cc.p(80,220)}

local BattleScene = class("BattleScene", function()
    return display.newScene("BattleScene")
end)

--[[
  pve关卡战斗
  todo 是其他试炼关卡的父类 有些函数被子类覆盖过 以后需要解耦，去掉依赖 提取公共方法
--]]
function BattleScene:ctor(params)

    self.totalFrame = 0

    --战场上最大的zorder
    self.MAX_Z = 1000
    self.params = params

    -- 1、普通
    -- 2、守塔P
    -- 3、护送
    -- 4、逃跑
    -- 5、单骑
    -- EndTime 通关时长

    self.team = {}
    self.over = false
    self.isWin = false
    self.passTime = 0

    self.isAuto = cc.UserDefault:getInstance():getBoolForKey(UserData.userId)

    self.starCondition = {
        [1]  = true, -- 塔不倒
        [2]  = true, -- 队员不死
        [3]  = true, -- 不使用变身
        [4]  = true, -- 不召唤替补
        [5]  = true, -- 单人通关
        [6]  = true, -- 基地血量大于等于50%
        [7]  = true, -- 基地不受到伤害
        [8]  = true, -- 出场人数小于等于3人
        [9]  = true, -- 出场人数小于等于5人
        [10] = true, -- 60秒过关
    }

    --单人通关条件没有达成
    if #self.params.team.team1 > 1 then
        self.starCondition[5] = false
    end

    if #self.params.team.team1 > 3 then
        self.starCondition[8] = false
    end

    if #self.params.team.team1 > 5 then
        self.starCondition[9] = false
    end

    self.mapNum = 4
    --塔防类型关卡 地图是2屏
    if self.params.type == 2 then
        self.mapNum = 2
    end

    local npcConfig = GameConfig.npc[self.params.customId]
    local len = #self.params.team.team1 + #self.params.team.team2
    if npcConfig and len < 7 and self.params.star < 3 then
        for i=1,#npcConfig.NpcID do
            local npc = CharacterModel.new({roleId = npcConfig.NpcID[i],strongLv = npcConfig.Quality})
            if #self.params.team.team1 < 4 then
                table.insert(self.params.team.team1,npc)
            else
                table.insert(self.params.team.team2,npc)
            end
        end
    end

    if GuideData:isNotCompleted("Fight2-3") and self.params.customId == "10203" then
        self.params.guide.member = true
    end

    self:load()
end

function BattleScene:load()
    --队长是否能变身
    if self.params.team.team1[1]:checkEvolve() then
        self.params.team.team1[1].evolve = true
    end

    self.params.team.team1[1].evolve = true

    if self.params.tailSkill and #self.params.tailSkill.skill == 0 then
        self.params.tailSkill = nil
    end

    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    --获取本关卡的全部敌人不同种类的的资源名
    local wave = self.params.wave or GameConfig.custom[self.params.customId].wave
    GafAssetCache.addTeamAssetName(self.params.team.team1)
    .addTeamAssetName(self.params.team.team2)
    .addEnterSkillAssetName(self.params.team.team1)
    .addEnterSkillAssetName(self.params.team.team2)
    .addTailSkillAssetName(self.params.tailSkill)
    .addCustomAssetName(self.params.customId)
    .addWaveAssetName(wave)
    .addBuildingAssetName(self.params.building)
    .addEscortAssetName(self.params.escortId)
    .addTowerAssetName(self.params.customId)
    .addAttackEffect()
    .addEnterEffect()
    .addAssetName("Tower5")

    loading:load(GafAssetCache.getAssetNames(),handler(self, self.init))
end

function BattleScene:init()
    --是否显示创建角色时的登场特效
    self.isCreateRoleEffect = true
    self.entryPosition =   display.cx
    self.mapWidth = 1136 * self.mapNum
    BattleManager.setSceneWidth(self.mapWidth - 130)

    local map = GameConfig.custom[self.params.customId].map
    self:createMap(map)
    self:createTrap()
    self:createTower()
    self:createMaskLayer()
    self:createBuilding()
    self:createTeam()
    self:createAutoBtn()

    self.logic = BattleLogic.new({
        ["customId"] = self.params.customId,
        ["gold"]     = self.params.gold,
        ["item"]     = self.params.item,
        ["play"]     = self.params.type,
        ["parent"]   = self.mainLayer,
        ["triggerRole"] = self.leader
    })

    self.ctrlLayer = CtrlLayer.new({
        ["guide"] = self.params.guide
    }):addTo(self)
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
        ["timeOut"]    = self.params.endTime
    }):addTo(self):addPauseButton()

    -- 护送玩法
    if self.params.type == 3 then
        local escortNode = self:createEscort()
        local preview = PreviewLayer.new({
            ["endPoint"] = BattleManager.sceneWidth - 150
         })

        preview:setPosition(display.width - 230 ,display.height - 120)
        preview:addTo(self.hubLayer)
        preview:addFollow(escortNode)

        self.door =  GafAssetCache.makeAnimatedObject("door")
        local frameSize = self.door:getFrameSize()
        self.door:setPosition(frameSize.width * - 0.5 + BattleManager.targetWidth,frameSize.height - 440 + escortNode:getPositionY())
        self.door:addTo(self.mainLayer)
        self.door:start()
        self.door:playSequence("door",true)

        self.logic.triggerRole = escortNode
    end

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
    BattleEvent:addEventListener(BattleEvent.KILL_TOWER, handler(self, self.onTowerKill))
    BattleEvent:addEventListener(BattleEvent.CALL_MEMBER, handler(self, self.onCallMember))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_BEGIN, handler(self, self.onEnterSkillBegin))
    BattleEvent:addEventListener(BattleEvent.ENTER_SKILL_EFFECT_END, handler(self, self.onEnterSkillEnd))
    BattleEvent:addEventListener(BattleEvent.CAMERA_SWAY, handler(self, self.onCameraSway))
    BattleEvent:addEventListener(BattleEvent.SLOW_BEGIN, handler(self, self.onSlowBegin))
    BattleEvent:addEventListener(BattleEvent.SLOW_END, handler(self, self.onSlowEnd))
    BattleEvent:addEventListener(BattleEvent.KILL_ESCORT, handler(self, self.onEscortKill))
    BattleEvent:addEventListener(BattleEvent.ESCORT_END, handler(self, self.onEscortEnd))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_BEGIN, handler(self, self.onTailSkillBegin))
    BattleEvent:addEventListener(BattleEvent.TAIL_SKILL_EFFECT_END, handler(self, self.onTailSkillEnd))

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()
    self:doTalkStart()
end

--[[
   添加己方城建
--]]
function BattleScene:createBuilding()
    if not self.params.building then
        return
    end

    for k,v in pairs(self.params.building) do
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
    end
end

function BattleScene:doTalkStart()
    if self.params.customId then
        self.BattlePlotTalkLayer = require("app.views.battle.BattlePlotTalkLayer").new(self.params.customId):addTo(self,3)
        self:pauseGame()
        self.BattlePlotTalkLayer:onBattleStart(function()
            self:resumeGame()
            self:doGuide()
        end)
    end
end

function BattleScene:doTalkBoss()
    if self.BattlePlotTalkLayer then
        self:pauseGame()
        self.BattlePlotTalkLayer:onBoss(function()
            self:resumeGame()
            if self.params.guide.evolve then
                self.hubLayer.angerButton:onUpdateAnger1(self.leader,400,400)
            end
        end)
    end
end

function BattleScene:doTalkEnd(callback)
    if self.BattlePlotTalkLayer then
        self:pauseGame()
        self.BattlePlotTalkLayer:onBattleEnd(function()
            self:resumeGame()
            callback()
        end)
    else
        callback()
    end
end

--[[
  新手引导提示
--]]
function BattleScene:doGuide()
    if self.over then
        return
    end

    if self.params.guide.skill or self.params.guide.member or self.params.guide.evolve then
       BattleEvent:addEventListener(BattleEvent.GUIDE_BUTTON, handler(self, self.onGuideButton))
    end

    --护送玩法提示
    if self.params.guide.escort or self.params.guide.tower then
        local msg = ""
        if self.params.guide.escort then
           msg = "\n此关卡为护送模式，\n护送人中途死亡失败！\n护送人送到终点则胜利！"
        elseif self.params.guide.tower then
           msg = "\n此关卡为防守模式，\n消灭所有敌人和塔即胜利！"
        end

        self:pauseGame()
        local dialog = require("app.views.battle.BattlePauseDialog").new()
        dialog:addTo(self)
        dialog.exitButton:setVisible(false)
        dialog:setContent(msg)
        local x,y = dialog.resumeButton:getPosition()
        dialog.resumeButton:setPosition(cc.p(dialog:getDialogSize().width * 0.5,y))
        dialog.resumeButton:onButtonClicked(function(event)
            self:resumeGame()
            dialog:removeFromParent()
        end)
    end

    if GuideData:isNotCompleted("Fight2-1") and OpenLvData:isOpen("auto") then
        self:pauseGame()
        local rect = {x = display.width-110, y = display.height-160, width = 120, height = 80}
        local posX = rect.x - 235
        local posY = rect.y + rect.height/2
        local text = GameConfig.tutor_talk["25"].talk
        local param = {rect = rect, text = text , x = posX , y = posY, callback = function (tutor)
            self.isAuto = true
            self.leader.auto = true
            self.leader.evolveNode.auto = true
            self.autonBtn:setButtonImage("normal","Auto_Off.png")
            self.autonBtn:setButtonImage("pressed","Auto_Off.png")
            cc.UserDefault:getInstance():setBoolForKey(UserData.userId,true)
            cc.UserDefault:getInstance():flush()

            self:resumeGame()
            tutor:removeFromParent(true)
            tutor = nil
        end}
        showTutorial(param)
    end
end

--[[
  新手引导战斗操作按钮提示事件
--]]
function BattleScene:onGuideButton(event)
    if self.over then
        return
    end
    self:pauseGame()

    local sender = event.sender
    local width = sender:getContentSize().width
    local height = sender:getContentSize().height
    local d = width * sender:getScaleX() + 10
    local p = sender:convertToWorldSpace(cc.p(0,0))
    local guide = require("app.views.widget.GuideLayer").new()
    guide:showCicle(d,p.x,p.y,sender)
    :showTip(event.text,p.x-width/2+15,p.y+height)
    :addTo(self,3)
end

function BattleScene:onUpdate(dt)
    if self.over then
        return
    end

  	if self.fllowRoleEnable then
        local x,y = self.followRole:getPositionX()
        self:setScenePosition(x, y)
  	end

    --更新战斗节点
  	BattleManager.update(dt,self.totalFrame)

    --关卡出兵
    if self.logic then
        self.logic:update(dt,self.totalFrame)
    end

    self:checkSceneOut(dt,self.totalFrame)

    self.totalFrame = self.totalFrame + 1
end

--[[
  检测屏幕外的敌人
--]]
function BattleScene:checkSceneOut(dt,totalFrame)
    if totalFrame % 60 ~= 0 then
        return
    end

    local out = false

    local tb = BattleManager.roles[GameCampType.right]
    for k,v in pairs(tb) do
       local rect = v:getNodeRect()
       if rect.x < 0 and v:isActive() then
           out = true
       end
    end

    self:setSceneOutVisible(out)
end

--[[
    设置显示屏幕外敌人警告提示
--]]
function BattleScene:setSceneOutVisible(visible)
    if self.outTip == nil then
        self.outTip = display.newSprite("scene_tip.png")
        self.outTip:setAnchorPoint(0,0.5)
        self.outTip:setPosition(0,display.cy)
        self.outTip:addTo(self.hubLayer)
    end
    self.outTip:setVisible(visible)
end

--[[
      变身插画
--]]
function BattleScene:showHeroFlash()
    self.leader.model.anger = 0
    self.leader:showEvolutionEffect()

    --立即开启1技能
    local skills = self.leader.evolveNode.model.skillids
    self.leader.evolveNode.skillMgr:getSkillByNum(1):setCooldownFinish()

    local param = {image = self.leader.model.battleImage,callback = function (flash)
        flash:removeFromParent(true)
        flash = nil
    end}
    local heroFlashLayer = HeroFlashLayer.new(param)
    self:addChild(heroFlashLayer,9999)

    BattleSound.playEvolve(self.leader.roleId)
end

--[[
    角色变身开始
--]]
function BattleScene:onEvolutionBegin(event)
    --没有变身条件没有达成
    self.starCondition[3] = false

    local sender = event.sender
    self.ctrlLayer:setVisible(false)

    sender.buffMgr:clean()
    sender:setVisible(false)
    sender:pauseAll()

    sender.evolveNode:setVisible(true)
    sender.evolveNode:setGlobalZOrder(-999)
    sender.evolveNode:setPosition(cc.p(99999,99999))
    self:pauseGame(sender)
    self:setTempLayerVisible(false)

    self:showMaskLayer()
end

--[[
    角色变身动画效果结束
--]]
function BattleScene:onEvolutionEffectEnd( event )
    local sender = event.sender
    --变身角色上场时是否开启全部技能,由6段觉醒触发
    if sender.evolveNode.isSkillCooldownEnable then
        sender.evolveNode.skillMgr:setCooldownFinish()
    end

    self.ctrlLayer:setVisible(true)

    self:resumeGame(sender.evolveNode)
    self:setTempLayerVisible(true)
    self:hideMaskLayer()

    local hp = Formula[18](sender.model,sender.evolveNode.model)
    sender.evolveNode.auto = sender.auto
    sender.evolveNode:setHp(hp)
    sender.evolveNode:setAnger(sender.model.maxAnger)
    sender.evolveNode:updateHpBar()
    sender.evolveNode:setPosition(sender:getPosition())
    sender.evolveNode:startSubAngerTimer()
    sender.evolveNode:resumeAll()
    -- sender.evolveNode:doEvolve()
    sender.evolveNode:setVisible(true)
    sender.evolveNode:setGlobalZOrder(0)

    --改变控制对象和相机跟随对象为变身后的角色
    if sender.camp == GameCampType.left then
        self.ctrlLayer.ctrlNode = sender.evolveNode
        self.followRole = self.ctrlLayer.ctrlNode
    end
end

--[[
    角色变身结束
--]]
function BattleScene:onEvolutionEnd( event )
    local sender = event.sender
    local hp = (sender.evolveNode.model.hp/sender.evolveNode.model.maxHp)*sender.model.maxHp
    sender.auto = sender.evolveNode.auto
    sender:setPosition(sender.evolveNode:getPosition())
    sender:resumeAll()
    sender:setHp(math.ceil(hp))
    sender:updateHpBar()
    sender:setVisible(true)

    sender.evolveNode.model:setProperty()
    sender.evolveNode:setVisible(false)
    sender.evolveNode:stopSubAngerTimer()
    sender.evolveNode:pauseAll()
    sender.evolveNode:doIdle()
    sender.evolveNode.buffMgr:clean()
    sender.evolveNode.skillMgr:resetCooldown()

    --改变控制对象和相机跟随对象为变身后的角色
    if sender.camp == GameCampType.left  then
        self.ctrlLayer.ctrlNode = sender
        self.followRole = self.ctrlLayer.ctrlNode
    end
end

--[[
    角色技能屏幕特效开始
--]]
function BattleScene:onSkillBegin( event )
    local sender = event.sender
    --暂停技能冷却
    sender:pauseSkill()

    self.ctrlLayer:setVisible(false)
    --todo 除了角色 其他的子弹之类的动画还没做暂停处理
    self:pauseGame(sender)
    self:setTempLayerVisible(false)
    self:showMaskLayer()
end

--[[
    角色技能屏幕特效结束
--]]
function BattleScene:onSkillEnd(event)
    local sender = event.sender
    print(string.format("roleId = %s,技能特效结束", sender.roleId))
    --todo 变身的角色不处理下边的恢复暂停逻辑

    --恢复暂停技能冷却
    sender:resumeSkill()

    self.ctrlLayer:setVisible(true)

    self:resumeGame(sender)
    self:setTempLayerVisible(true)
    self:hideMaskLayer()
end

--[[
  尾兽技能释放开始
--]]
function BattleScene:onTailSkillBegin(event)
    self.ctrlLayer:setVisible(false)

    --todo 除了角色 其他的子弹之类的动画还没做暂停处理
    self:pauseGame(sender)
    self:setTempLayerVisible(false)
    self:showMaskLayer()
end

--[[
  尾兽技能释放结束
--]]
function BattleScene:onTailSkillEnd(event)
   self.ctrlLayer:setVisible(true)

   self:resumeGame(sender)
   self:setTempLayerVisible(true)
   self:hideMaskLayer()
end

--[[
    出现一波敌人
--]]
function BattleScene:onWaveBegin(event)
    local waveTotal = event.waveTotal
    local currWave  = event.currWave
    local count      = event.count
    local hasBoss   = event.hasBoss

    if currWave then
        self.hubLayer:updateWave(currWave, waveTotal)
    else
    end

    if hasBoss then
        if not self.bossLayer then
            self.bossLayer =  BossAppearLayer.new()
            self.bossLayer:addTo(self)
        end
        self.bossLayer:startRun()
    end

    self.hubLayer:showGo()
end

--[[
    创建一个敌人
--]]
function BattleScene:onCreateEnemy(event)
    local enemyId    = event.enemyId
    local enemyLv    = event.enemyLv
    --todo 敌人技能等级还没做
    local skillLv    = event.skillLv
    local createdNum = event.createdNum
    local createX   = event.createX
    local enemy  = EnemyNode.new({
        roleId = enemyId,
        level = enemyLv,
        skillLevel = skillLv
    })

    newrandomseed()
    local rdm =  createdNum % 3
    if rdm == 0 then
        rdm = 3
    end
    local y = BattlePosition.right[rdm].y
    enemy:setLocalZOrder(self.MAX_Z - y)
    enemy:setPosition(cc.p(createX,y))
    enemy:addTo(self.mainLayer)

    --boss 出场时击退效果
    if enemy.model.boss then
        AudioManage.playMusic("Battle2.mp3", true)
        --boss 固定在第一排出场
        enemy:setPositionY(BattlePosition.right[1].y)

        self:pauseGame()
        self:showMaskLayer()
        local anim = enemy:showEffect("enter_effect_3",function()
            local tb = BattleManager.roles[enemy.enemyCamp]
            for k,v in pairs(tb) do
                if v:isActive() and
                    v.nodeType == GameNodeType.ROLE and
                    v:getPositionX() > BattleManager.sceneWidth - 300 then
                    v.buffMgr:addBuff("40001", 1, enemy)
                end
            end
            self:resumeGame()
            self:hideMaskLayer()
            self:doTalkBoss()
        end)
        local frameSize = anim:getFrameSize()
        anim:setPositionY(frameSize.height - 500)
    end

    return enemy
end

--[[
    关卡内敌人全部创建完
--]]
function BattleScene:onCreateEnemyEnd(event)
	 print("创建敌人结束")
end

--[[
    设置场景镜头中心点
--]]
function BattleScene:setScenePosition(x,y)
    local sceneX = display.width * 0.5 - self.cameraOffset
	local x = math.max(x,sceneX)

	if self.mapWidth > display.width then
		  x = math.min(x,self.mapWidth - (display.width - sceneX))
	end

	local offset = cc.p(sceneX - x, 0)
	self.bgLayer:setPosition(offset.x * 0.4, offset.y)
	self.mainLayer:setPosition(offset)
	self.fgLayer:setPosition(offset)
end

--[[
	创建场景地图
--]]
function BattleScene:createMap(map)
    self.bgLayer     = display.newLayer()
    self.bgLayer:addTo(self)

    self.battleLayer = display.newLayer()
    self.battleLayer:addTo(self)

    self.mainLayer   = display.newLayer()
    self.mainLayer:addTo(self.battleLayer)

    self.fgLayer     = display.newLayer()
    self.fgLayer:addTo(self.battleLayer)

	local w = 0
    for i=1,3 do
    	local bg = display.newSprite(string.format("map_%s_bg_%d.jpg",map,i)) --self.customId))
        bg:setAnchorPoint(cc.p(0, 0))
    	w = bg:getContentSize().width
    	bg:setPosition((i-1)*w,0)
    	bg:addTo(self.bgLayer)
    end

    for i=1, self.mapNum do
    	local bg = display.newSprite(string.format("map_%s_m_%d.png",map,i)) --self.customId))
    	bg:setAnchorPoint(cc.p(0, 0))
    	w = bg:getContentSize().width
    	bg:setPosition((i-1)*w,0)
    	bg:addTo(self.mainLayer)
    end

    self.md2 = display.newSprite(string.format("map_%s_d_2.png",map)) --self.customId))
    self.md2:setAnchorPoint(cc.p(1,0))
    self.md2:setPosition(1136 * self.mapNum,0)
    self.md2:addTo(self.mainLayer)

    self.md1 = display.newSprite(string.format("map_%s_d_1.png",map)) --self.customId))
    self.md1:setAnchorPoint(cc.p(1,0))
    self.md1:setPosition(1136 * self.mapNum,0)
    self.md1:setLocalZOrder(999)
    self.md1:addTo(self.mainLayer)

    for i=1, self.mapNum do
        local bg = display.newSprite(string.format("map_%s_f_%d.png",map,i)) --self.customId))
        bg:setAnchorPoint(cc.p(0, 0))
        w = bg:getContentSize().width
        bg:setPosition((i-1)*w,0)
        bg:addTo(self.fgLayer)
    end
end

--[[
  创建关卡中的塔
--]]
function BattleScene:createTower()
    local cfg = GameConfig.custom[self.params.customId].tower
    if not cfg then
      return
    end

    local table = string.split(cfg, ":")

    for k,v in pairs(table) do
        local data = string.split(v, ",")
        local tower = TowerNode.new({
          towerId = data[1],
          camp = GameCampType.right,
          enemyCamp = GameCampType.left,
          level = checkint(data[2])
        })
        tower:setPosition(checkint(data[3]),checkint(data[4]))
        tower:addTo(self.mainLayer)
        tower:createAnimNode()
    end
end

--[[
  创建关卡中得陷阱
--]]
function BattleScene:createTrap()
    local cfg = GameConfig.custom[self.params.customId].trap
    if not cfg then
      return
    end

    local table = string.split(cfg, ":")
      for k,v in pairs(table) do
          local data = string.split(v, ",")
          local trap1 = TrapNode.new({
              trapId = data[1],
              level = checkint(data[2])
          })
          trap1:setPosition(checkint(data[3]),checkint(data[4]))
          trap1:addTo(self.mainLayer)
          trap1:createAnimNode()
    end
end

--[[
    创建玩家队伍
--]]
function BattleScene:createTeam()
    self:createLeader()
    self:createMember()
end

--[[
  创建队长
--]]
function BattleScene:createLeader()
    if not self.warnLayer then
        self.warnLayer = BattleWarnLayer.new()
        self.warnLayer:setPosition(display.cx,display.cy)
        self.warnLayer:addTo(self)
    end

    local onUpdateHp = function(role,hp,maxHp)
        if hp == 0 then
            self.warnLayer:stopRun()
        else
          if hp / maxHp < 0.5 then
              self.warnLayer:startRun()
          else
              self.warnLayer:stopRun()
          end
        end
    end

    self.leader = CharacterNode.new({
        isLeader = true,
        auto = false,
        model = self.params.team.team1[1]
    })

    local y = BattlePosition.left[1].y
    self.leader:setPosition( self.entryPosition - self.leader.model.attackSize.width * 0.5,y)
    self.leader:setLocalZOrder(self.MAX_Z - y)
    self.leader:addTo(self.mainLayer)
    self.leader.onUpdateHp = onUpdateHp

    self.team[1] = self.leader

    -- body
    if self.leader.model.evolve then
       local evolveNode = self.leader:createEvolve()
       evolveNode:setVisible(false)
       evolveNode:pauseAll()
       evolveNode:addTo(self.mainLayer)
       evolveNode.onUpdateHp = onUpdateHp
    end

    --todo尾兽技能
    if self.params.tailSkill then
         -- 队长变身前 变身后共用的尾兽技能管理
        local tailSkillMgr = TailSkillManager.new(self.leader.camp)
        local tailLv = self.params.tailSkill.level
        for k,v in pairs(self.params.tailSkill.skill) do
            tailSkillMgr:addSkill(v,tailLv)
        end
        self.leader.tailSkillMgr = tailSkillMgr
        if self.leader.evolveNode then
            self.leader.evolveNode.tailSkillMgr = tailSkillMgr
        end
    end

    if self.isCreateRoleEffect then
        self.leader:showCreateEffect(0,function ()
            BattleSound.playEnter(self.leader.roleId)
            if self.params.guide and self.params.guide.move then
                if self.params.guide.move then
                    self:showMoveGuide()
                end
            end
        end)
    end
end

--[[
  创建队员
--]]
function BattleScene:createMember()
    --创建替补队员
    local len = #self.params.team.team1
    for i=1,#self.params.team.team2 do
        local member = CharacterNode.new({
            isLeader       = false,
            followDistance = 50,
            auto = true,
            model = self.params.team.team2[i]
        })

        member:setLocalZOrder(self.MAX_Z - BattlePosition.left[i+1].y)
        member:setVisible(false)
        member:pauseAll()
        member:addTo(self.mainLayer)

        self.team[len+i] = member
    end

    --创建上阵队员
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

        if self.isCreateRoleEffect then
            member:showCreateEffect(i * 0.3)
        end
        self.team[i] = member
    end
end

--[[
  创建守护目标
--]]
function BattleScene:createEscort()
  local escort  = EscortNode.new({
     roleId = self.params.escortId,
     level  = self.params.escortLevel
  })

  local y = BattlePosition.left[3].y
  escort:setLocalZOrder(self.MAX_Z - y)
  escort:setPosition(cc.p(0,y))
  escort:addTo(self.mainLayer)

  return escort

end

--[[
    创建特效遮罩层
--]]
function BattleScene:createMaskLayer()
	self.maskLayer= cc.LayerColor:create(cc.c4b(0,0,0,0))
  self.maskLayer:setVisible(false)
  self.maskLayer:setContentSize(50000,display.height)
  self.maskLayer:setPosition(0,0)
  self.maskLayer:addTo(self.mainLayer)
end

--创建自动战斗按钮
function BattleScene:createAutoBtn()
    if OpenLvData:isOpen("auto") then
        self.autonBtn = cc.ui.UIPushButton.new({normal = "Auto_On.png", pressed = "Auto_On.png"})
        :onButtonClicked(function ()
            self.isAuto = not self.isAuto
            self:updateAutoStatus()
            cc.UserDefault:getInstance():setBoolForKey(UserData.userId,self.isAuto)
            cc.UserDefault:getInstance():flush()
        end)
        self.autonBtn:setPosition(display.width-50,display.height-120)
        self:addChild(self.autonBtn,2)

        self:updateAutoStatus()
    end
end

function BattleScene:updateAutoStatus()
    if self.isAuto then
        self.leader.auto = true
        if self.leader.evolveNode then
            self.leader.evolveNode.auto = true
        end
        self.autonBtn:setButtonImage("normal","Auto_Off.png")
        self.autonBtn:setButtonImage("pressed","Auto_Off.png")
    else
        self.leader.auto = false
        if self.leader:isActive() then
            self.leader:doIdle()
        end
        if self.leader.evolveNode then
            self.leader.evolveNode.auto = false
            if self.leader.evolveNode:isActive() then
                self.leader.evolveNode:doIdle()
            end
        end
        self.autonBtn:setButtonImage("normal","Auto_On.png")
        self.autonBtn:setButtonImage("pressed","Auto_On.png")
    end
end

--移除自动战斗按钮
function BattleScene:removeAutoBtn()
    if self.autonBtn then
        self.autonBtn:removeFromParent(true)
        self.autonBtn = nil
    end
end

--[[
    释放技能时候 临时显示隐藏的层
--]]
function BattleScene:setTempLayerVisible(visible)
    if self.autonBtn then
        self.autonBtn:setVisible(visible)
    end

    if self.md1 then
        self.md1:setVisible(visible)
    end

    if self.md2 then
        self.md2:setVisible(visible)
    end

    self.fgLayer:setVisible(visible)
    self.hubLayer:setVisible(visible)
end

--[[
    敌人死亡时触发
--]]
function BattleScene:onEnemyKill(event)
   local dead = event.dead
    if self.logic then
        self.logic:addKill(GameCampType.right, dead)
    end

    if dead.model.boss then
        AudioManage.playMusic("Battle1.mp3", true)
    end

    if self.logic:isKillEnemyies() then
        self:onGameWin()
    end

    local dropTable = self.logic:drop(dead)
    if dropTable then
        for i=1,dropTable.itemNum do
            local loot = LootNode.new(1)
            loot:setPosition(dead:getPositionX(),dead:getPositionY() + dead.model.nodeSize.height)
            loot:addTo(dead:getParent())
            loot:setLocalZOrder(2)

            newrandomseed()
            local dropAction = DropAction:create(0.5, 80 + 90 * i, 50,  dead.model.nodeSize.height + dead:getPositionY() - math.random(80,100), BattleManager.sceneWidth)
            loot:runAction(
                cc.Sequence:create(
                    dropAction,
                    cc.DelayTime:create(1+i*0.2),
                    cc.CallFunc:create(function()
                        loot:pickup()
                    end),
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function()
                        self.hubLayer:addChest(1)
                    end),
                    cc.RemoveSelf:create()
            ))
        end

        local value = math.floor(dropTable.goldValue / dropTable.goldNum)
        for i=1,dropTable.goldNum do
            local loot = LootNode.new(2)
            loot:setPosition(dead:getPositionX(),dead:getPositionY() + dead.model.nodeSize.height)
            loot:addTo(dead:getParent())
            local dropAction = DropAction:create(0.5, 70 + 60 * i, 50, dead.model.nodeSize.height + dead:getPositionY() - math.random(80,100), BattleManager.sceneWidth)
            loot:runAction(
                cc.Sequence:create(
                    dropAction,
                    cc.DelayTime:create(1+i*0.2),
                    cc.CallFunc:create(function()
                        loot:pickup()
                    end),
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function()
                        self.hubLayer:addGold(value)
                    end),
                    cc.RemoveSelf:create()
            ))
        end

        self:runAction(cc.Sequence:create(
            cc.CallFunc:create(function()
                local scheduler = cc.Director:getInstance():getScheduler()
                scheduler:setTimeScale(0.3)
            end),
            cc.DelayTime:create(0.2),
            cc.CallFunc:create(function()
                local scheduler = cc.Director:getInstance():getScheduler()
                scheduler:setTimeScale(1)
            end)
        ))        
    end
end

--[[
    角色死亡时触发
--]]
function BattleScene:onCharacterKill(event)
    local dead = event.dead
    if self.logic then
        self.logic:addKill(GameCampType.left, dead)
    end

    if dead.isLeader then
        self:onGameLose()
    else
        --队员不死条件没有达成
        self.starCondition[2] = false
        --开启队员上场计时
        local index = table.indexof(self.team,dead)
        self.hubLayer.memberButtonGroup:onMemderDead(index)
    end
end

--[[
  塔销毁  暂时接收到得都是己方的塔事件
--]]
function BattleScene:onTowerKill(event)
    local dead = event.dead

    --己方塔不碎条件没有达成
    if dead.camp == GameCampType.left then
        self.starCondition[1] = false
    elseif self.params.type == 2  and self.logic then
       self.logic:addKill(GameCampType.right, dead)
    end

    if dead.camp == GameCampType.left and dead.model.type == 1 then
        self:onGameLose()
        return
    end

    if self.logic and self.logic:isKillEnemyies() then
        self:onGameWin()
        return
    end
end

--[[
  护送模式下 被护送的目标死亡了
--]]
function BattleScene:onEscortKill(event)
   self:onGameLose()
end

--[[
  护送模式下 护送目标到终点位置
--]]
function BattleScene:onEscortEnd(event)
  -- body
   self:onGameWin()
end

--[[
    召唤替补上场 当前队员下场
--]]
function BattleScene:onCallMember(event)
    --不召唤替补条件没有达成
    self.starCondition[4] = false

    --新上场队员
    local inTeam = #self.params.team.team1
    local newIndex = event.index
    local newMember = self.team[newIndex]

    --下场队员
    local oldIndex
    if newIndex > inTeam then
        oldIndex = newIndex - inTeam + 1
    else
        oldIndex = newIndex + inTeam - 1
    end
    local oldMember = self.team[oldIndex]

    if oldMember and oldMember:isActive() then
        oldMember.buffMgr:clean()
        oldMember:doIdle()
        oldMember:pauseAll()
        oldMember:setVisible(false)
    end

    newMember.model:setProperty()
    
    local leader =  BattleManager.getLeader(newMember.camp)
    if not leader then
        return
    end
    if oldMember then
        if oldMember.dead then
            local x,y = leader:getPosition()
            local index
            if newIndex > inTeam then
                index = newIndex - inTeam + 1
            else
                index = newIndex
            end
            newMember:setPosition( x - 50 - newMember.leaderDistance, BattlePosition.left[index].y)
      else
            newMember:setPosition(oldMember:getPosition())
      end
    else
        local x,y = leader:getPosition()
        local index
        if newIndex > inTeam then
            index = newIndex - inTeam + 1
        else
            index = newIndex
        end
        newMember:setPosition( x - 50 - newMember.leaderDistance, BattlePosition.left[index].y)
    end
    newMember.dead = false
    newMember.stateMgr.lockState = false
    newMember:doIdle()
    newMember:showHpBar()
    newMember:showEnterEffect()
    --登场音效
    BattleSound.playEnter(newMember.roleId)
end

--[[
  替补队员登场技开始
--]]
function BattleScene:onEnterSkillBegin(event)
   self.hubLayer:setVisible(false)
   self.ctrlLayer:setVisible(false)
   self:showMaskLayer()
   self:pauseGame()
end

--[[
  替补队员登场技结束
--]]
function BattleScene:onEnterSkillEnd(event)
    self.hubLayer:setVisible(true)
    self.ctrlLayer:setVisible(true)
    self:hideMaskLayer()
    self:resumeGame()
end

--[[
  显示特写背景
--]]
function BattleScene:showMaskLayer()
  self.maskLayer:runAction(cc.Sequence:create(cc.Show:create(),cc.FadeTo:create(0.2,160)))
end

--[[
  隐藏特写背景
--]]
function BattleScene:hideMaskLayer()
   self.maskLayer:runAction(cc.Sequence:create(cc.FadeOut:create(0.1),cc.Hide:create()))
end

--[[
  场景镜头晃动
--]]
function BattleScene:onCameraSway(event)
   self.battleLayer:runAction(cc.Sequence:create(
        cc.MoveBy:create(0.01,cc.p(40,0)),
        cc.MoveBy:create(0.01,cc.p(-40,0))
   ));
end

--[[
  慢镜头开始
--]]
function BattleScene:onSlowBegin(event)

end

--[[
  慢镜头结束
--]]
function BattleScene:onSlowEnd(event)

end


--[[
    暂停战场上的角色 除了exRole角色外
--]]
function BattleScene:pauseGame(exRole)
    if self.hubLayer then
        self.hubLayer:pauseAll()
    end

    if self.logic then
        self.logic:setPause(true)
    end

    if self.charser then
        self.charser:pauseAll()
    end

    BattleManager.pauseAll(exRole)

    self:pause()
end

--[[
    恢复战场上的角色 除了exRole角色外
--]]
function BattleScene:resumeGame(exRole)
    BattleManager.resumeAll(exRole)
    if self.hubLayer then
        self.hubLayer:resumeAll()
    end
    if self.logic then
        self.logic:setPause(false)
    end

    if self.charser then
        self.charser:resumeAll()
    end
    self:resume()
end

--[[
  隐藏战场上的角色
--]]
function BattleScene:hideRoles(exRole)
    local roles = BattleManager.getRoles(exRole)
    table.walk(roles,function(v,k)
        v:setVisible(false)
    end)
end

function BattleScene:removeRoles()
    BattleManager.nodeIterator(function(v,k)
        if v:isActive() then
            v:setVisible(false)
            v:pauseAll()
            v:stopAllSchedule()
            v.dead = true
            v.remove = true
        end
    end)
end

--[[
    游戏结束时候调用
--]]
function BattleScene:onGameOver()
    self.over = true
    self.passTime = self.hubLayer.timer
    self:pause()
    self:stopAllActions()
    self:removeAutoBtn()
    self.hubLayer:pauseAll()
    self.hubLayer:setVisible(false)
    self.hubLayer:setButtonVisible(false)
    self.ctrlLayer:setVisible(false)
    self.ctrlLayer.isLock = true
    self.fllowRoleEnable = false

    if self.passTime > 60 then
        self.starCondition[10] = false
    end

    if self.warnLayer then
        self.warnLayer:stopRun()
    end

    if self.bossLayer then
        self.bossLayer:stopRun()
    end

    if self.door then
        self.door:removeFromParent(true)
        self.door = nil
    end
end

--[[
    战斗超时
--]]
function BattleScene:onGameTimeOut()
    if self.over then
        return
    end
    self.params.timeOut = true
    self:onGameLose()
end

--[[
    战斗胜利
--]]
function BattleScene:onGameWin()
    if self.over then
        return
    end
    self:onGameOver()
    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

--[[
    战斗失败
--]]
function BattleScene:onGameLose()
    if self.over then
        return
    end
    self:onGameOver()
    self:removeRoles()
    local layer = require("app.views.battle.BattleLoseLayer").new(self.params)
    layer:addTo(self)
end

function BattleScene:battleEndRequest()
    --通关加1星
    self.params.starNum = 1

    --没有超过战斗时长加1星
    if self.passTime <=  self.params.secondStarTime  then
        self.params.starNum =  self.params.starNum + 1
    end
    --达到条件加一星
    if self.starCondition[self.params.thirdStarCondition] then
        self.params.starNum =  self.params.starNum + 1
    end

    local tempTeam = {}
    for i,v in ipairs(self.params.team.team1) do
        if self:isNpc(v.roleId) then
            table.remove(self.params.team.team1,i)
        else
            table.insert(tempTeam,v)
        end
    end
    for i,v in ipairs(self.params.team.team2) do
        if self:isNpc(v.roleId) then
            table.remove(self.params.team.team2,i)
        else
            table.insert(tempTeam,v)
        end
    end
    local ids = ""
    local len = #tempTeam
    for i=1,len do
      ids = ids..tempTeam[i].roleId
      if i < len then
        ids = ids..","
      end
    end

    if self.params.stageType == 3 then
        ids = ""
        for i,v in ipairs(self.params.team.team1) do
            if v.teamId then
                if UserData.teamId ~= v.teamId then
                    if ids == "" then
                        ids = v.userId.."-"..v.roleId
                    else
                        ids = ids..","..v.userId.."-"..v.roleId
                    end
                end
            end
        end
        for i,v in ipairs(self.params.team.team2) do
            if v.teamId then
                if UserData.teamId ~= v.teamId then
                    if ids == "" then
                        ids = v.userId.."-"..v.roleId
                    else
                        ids = ids..","..v.userId.."-"..v.roleId
                    end
                end
            end
        end
    end
    
    showLoading()
    local params = {
        param1 = self.params.customId,
        param2 = ids,
        param3 = self.params.stageType,
        param4 = self.params.starNum,
    }
    NetHandler.gameRequest("SaveBattleResult",params)
end

function BattleScene:isNpc(roleId)
    local isNpc = false
    local npcConfig = GameConfig.npc[self.params.customId]
    if npcConfig then
        for i=1,#npcConfig.NpcID do
            if npcConfig.NpcID[i] == roleId then
                isNpc = true
                break
            end
        end
    end
    return isNpc
end

--[[
  战斗胜利游戏发送请求回调
--]]
function BattleScene:gameoverCallback()
    hideLoading()
    self:doTalkEnd(function()
        local layer = require("app.views.battle.BattleWinLayer").new(self.params)
        layer:addTo(self)

        self.hubLayer:stopCountdown()
    end)
end

function BattleScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.SaveAincradBattleResultProcess then
        if tonumber(data.param1) == 1 then
            hideLoading()
            local layer = require("app.views.battle.AincradWinLayer").new(self.params)
            layer:addTo(self)
        elseif tonumber(data.param1) == 0 then
            hideLoading()
            local layer = require("app.views.battle.BattleLoseLayer").new(self.params)
            layer:addTo(self)
        end
    elseif order == OperationCode.SaveBattleResultProcess then
        self:gameoverCallback()
        if  GuideData:isNotCompleted("Fight1-1") then
            NetHandler.gameRequest("NewComerGuide",{param1 = "Fight1-1"})
        elseif GuideData:isNotCompleted("Fight1-2") then
            NetHandler.gameRequest("NewComerGuide",{param1 = "Fight1-2"})
        elseif GuideData:isNotCompleted("Fight1-3") then
            NetHandler.gameRequest("NewComerGuide",{param1 = "Fight1-3"})
        elseif GuideData:isNotCompleted("Fight2-1") then
            NetHandler.gameRequest("NewComerGuide",{param1 = "Fight2-1"})
        elseif GuideData:isNotCompleted("Fight2-2") then
            NetHandler.gameRequest("NewComerGuide",{param1 = "Fight2-2"})
        elseif GuideData:isNotCompleted("Fight2-3") then
            NetHandler.gameRequest("NewComerGuide",{param1 = "Fight2-3"})
        end
    elseif order == OperationCode.SaveTreeWorldGuankaProcess then
        self:gameoverCallback()
    elseif order == OperationCode.GetShanDuoLaRewardProcess then
        self:gameoverCallback()
    elseif order == OperationCode.GetWuLaoFengRewardProcess then
        self.params.item = dataToItem(data.param1)
        self:gameoverCallback()
    elseif order == OperationCode.GetSpiritHomeRewardProcess then
        local ids = {}
        for k,v in pairs(data.a_param1) do
          local itemId = tostring(v.param1)
          local nItem = tonumber(v.param3)
          ids[itemId] = nItem
        end
        self.params.item = ids
        self:gameoverCallback()
    elseif order == OperationCode.NewComerGuideProcess then
        if data.param1 == "Fight" then
            hideLoading()
            self:doTalkEnd(function()
                app:enterToScene("OpenScene")
            end)
        elseif data.param1 == "Fight2" then
            hideLoading()
            self:doTalkEnd(function()
                app:enterToScene("OpenScene")
            end)
        end
    end
end

function BattleScene:onEnter()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
    AudioManage.playMusic("Battle1.mp3", true)
end

function BattleScene:onExit()
    GameDispatcher:removeEventListener(self.netEvent)

    local scheduler = cc.Director:getInstance():getScheduler()
    scheduler:setTimeScale(1)

    BattleEvent:removeAllEventListeners()
    BattleManager.reset()
    GafAssetCache.reset()

    AudioManage.playMusic("Main.mp3",true)
end

return BattleScene