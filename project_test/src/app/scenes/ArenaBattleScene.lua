--
-- Author: zsp
-- Date: 2015-01-07 14:24:35
--

local BattleManager      = require("app.battle.BattleManager")
local BattleEvent        = require("app.battle.BattleEvent")
local CharacterNode      = require("app.battle.node.CharacterNode")
local ArenaHubLayer      = require("app.views.arena.ArenaHubLayer")
local BattleLoadingLayer = require("app.views.battle.BattleLoadingLayer")
local TailSkillManager   = require("app.battle.skill.TailSkillManager")
local HeroFlashLayer     = require("app.views.battle.HeroFlashLayer")
local scheduler = require("framework.scheduler")

require("app.battle.GafAssetCache")

--战斗角色被放置的垂直位置
local BattlePosition = {}
BattlePosition.left  = {cc.p(80,120),cc.p(80,150),cc.p(130,190),cc.p(80,230),cc.p(80,270)}
BattlePosition.right = BattlePosition.left


local ArenaBattleScene = class("ArenaBattleScene", function()
    return display.newScene("ArenaBattleScene")
end)

--[[
  竞技场战斗
--]]
function ArenaBattleScene:ctor(params)
    AudioManage.stopMusic(true)
    self.MAX_Z = 1000
    self.params = params
    self:load()
end

function ArenaBattleScene:load()
    local loading = BattleLoadingLayer.new()
    loading:addTo(self)

    if self.params.left.tailSkill and #self.params.left.tailSkill.skill == 0 then
        self.params.left.tailSkill = nil
    end

    if self.params.right.tailSkill and #self.params.right.tailSkill.skill == 0 then
        self.params.right.tailSkill = nil
    end
      
    local assetNames =  GafAssetCache.addTeamAssetName(self.params.left.team)
    .addTeamAssetName(self.params.right.team)
    .addTailSkillAssetName(self.params.left.tailSkill)
    .addTailSkillAssetName(self.params.right.tailSkill)
    .addAttackEffect()
    .getAssetNames()

    loading:load(assetNames,handler(self, self.init))
end

function ArenaBattleScene:init()
    AudioManage.playMusic("Arena.mp3", true)
    AudioManage.playSound("ArenaStart.mp3", false)

    self.over = false
    self.isWin = 0
    self.leftDeadCount = 0
    self.rightDeadCount = 0
    self.mapWidth = display.width
    BattleManager.setSceneWidth(self.mapWidth)

    self:createMap()
    self:createMaskLayer()
    
    self.leftTeam  = self:createLeftTeam()
    self.rightTeam = self:createRightTeam()

    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
    self:scheduleUpdate()

    self.hubLayer = ArenaHubLayer.new(self.leftTeam,self.rightTeam)
    self.hubLayer:addTo(self)

    BattleEvent:addEventListener(BattleEvent.HERO_FALSH, handler(self, self.showHeroFlash))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_BEGIN, handler(self, self.onEvolutionBegin))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_END, handler(self, self.onEvolutionEnd))
    BattleEvent:addEventListener(BattleEvent.EVOLVE_EFFECT_END, handler(self, self.onEvolutionEffectEnd))
    BattleEvent:addEventListener(BattleEvent.KILL_CHARACTER, handler(self, self.onCharacterKill))
    BattleEvent:addEventListener(BattleEvent.GAME_TIMEOUT, handler(self, self.onGameTimeOut))
end

function ArenaBattleScene:onUpdate(dt)
    --更新战斗节点
	BattleManager.update(dt)
end

function ArenaBattleScene:showHeroFlash(event)
    local role = event.role
    role.model.anger = 0
    role:showEvolutionEffect()

    local param = {image = role.model.battleImage, dir = role.camp, callback = function (flash)
        flash:removeFromParent(true)
        flash = nil
    end}
    local heroFlashLayer = HeroFlashLayer.new(param)
    self:addChild(heroFlashLayer,9999)

    BattleSound.playEvolve(role.roleId)
end

--[[
    角色变身开始
--]]
function ArenaBattleScene:onEvolutionBegin(event)
    self:pause()
    
    local sender = event.sender
    sender.buffMgr:clean()
    sender:setVisible(false)
    sender:pauseAll()

    sender.evolveNode:setVisible(true)
    sender.evolveNode:setPosition(999999,999999)

    self:pauseRoles(sender)
    self:showMaskLayer()
end

--[[
    角色变身动画效果结束
--]]
function ArenaBattleScene:onEvolutionEffectEnd( event )
    self:resume()

    local sender = event.sender

    if sender.dead then
        return
    end

    --变身角色上场时是否开启全部技能,由6段觉醒触发
    if sender.evolveNode.isSkillCooldownEnable then
        sender.evolveNode.skillMgr:setCooldownFinish()
    end

    self:resumeRoles(sender.evolveNode)
    self:hideMaskLayer()

    local hp = Formula[18](sender.model,sender.evolveNode.model)
    sender.evolveNode.auto = sender.auto
    sender.evolveNode:setHp(hp)
    sender.evolveNode:setAnger(sender.model.maxAnger)
    sender.evolveNode:updateHpBar()
    sender.evolveNode:setPosition(sender:getPosition())
    sender.evolveNode:startSubAngerTimer()
    sender.evolveNode:resumeAll()
    sender.evolveNode:setVisible(true)
end

--[[
    角色变身结束
--]]
function ArenaBattleScene:onEvolutionEnd( event )
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
end

--[[
    角色技能屏幕特效开始
--]]
function ArenaBattleScene:onSkillBegin( event )
    local sender = event.sender
    --暂停技能冷却
    sender:pauseSkill()
    self:pause()
     
    --todo 除了角色 其他的子弹之类的动画还没做暂停处理
    self:pauseRoles(sender)
    self:showMaskLayer()
end

--[[
    角色技能屏幕特效结束
--]]
function ArenaBattleScene:onSkillEnd(event)
    local sender = event.sender
    --恢复暂停技能冷却
    sender:resumeSkill()
    self:resume()
    self:resumeRoles(sender)
    self:hideMaskLayer()
end

function ArenaBattleScene:pauseGame()
    if self.hubLayer then
        self.hubLayer:stopCountdown()
    end
    BattleManager.pauseAll()
end

function ArenaBattleScene:resumeGame()
    if self.hubLayer then
        self.hubLayer:startCountdown()
    end
    BattleManager.resumeAll()
end

function ArenaBattleScene:connectEvent(event)
    local data = event.data
    if data.name == cc.net.SocketTCP.EVENT_CONNECTED then
        if data.tag == "Game" then
            app:gameSeverConnected()
            if self.over then
                self:battleEndRequest()
            end
        end
    elseif data.name == cc.net.SocketTCP.EVENT_CONNECT_FAILURE then
        if data.tag == "Game" then
            app:gameSeverFailure()
        end
    end
end

function ArenaBattleScene:onEnter()    
    app:removeNetEvent()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
    self.connect = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_STATUS,handler(self,self.connectEvent))
end

function ArenaBattleScene:onExit()
    app:addNetEvent()

    GameDispatcher:removeEventListener(self.netEvent)
    GameDispatcher:removeEventListener(self.connect)

    BattleEvent:removeAllEventListeners()
    BattleManager.reset()
    GafAssetCache.reset()
end

--[[
	创建场景地图
--]]
function ArenaBattleScene:createMap()
	  self.bgLayer = display.newLayer()
    self.bgLayer:addTo(self)

    self.mainLayer = display.newLayer()
    self.mainLayer:addTo(self)

	  local bg = display.newSprite("map_arena_1.jpg")--self.customId))
	  bg:setAnchorPoint(cc.p(0.5, 0))
	  bg:setPosition(display.cx,0)
	  bg:addTo(self.bgLayer)

    local fg = display.newSprite("map_arena_1_f.png")--self.customId))
    fg:setAnchorPoint(cc.p(0.5, 0))
    fg:setPosition(display.cx,0)
    fg:addTo(self.bgLayer)
end

--[[
    创建玩家角色
--]]
function ArenaBattleScene:createLeftTeam()
    local team = {}
    for i=1,#self.params.left.team do
        self.params.left.team[i]:setHeroConfig()
        local role = nil

        if i == 1 then
            role = CharacterNode.new({
                isLeader = true,
                auto     = true,
                model    = self.params.left.team[i]
            })

           role:setLocalZOrder(self.MAX_Z - BattlePosition.left[i].y)
           role:setPosition( 0 - role.model.attackSize.width,BattlePosition.left[i].y)
        else
            role = CharacterNode.new({
                auto               = true,
                isLeader           = false,
                followDistance     = 50, 
                model =  self.params.left.team[i],
            })
            local x,y = team[1]:getPosition()
            role:setLocalZOrder(self.MAX_Z - BattlePosition.left[i].y)
            role:setPosition( x - role.leaderDistance, BattlePosition.left[i].y)
        end

        role:addTo(self.mainLayer)
        table.insert(team,role)

        if role.model.evolve then
            local evolveNode = role:createEvolve()
            evolveNode:setVisible(false)
            evolveNode:pauseAll()
            evolveNode:addTo(self.mainLayer)
        end
    end
    
    local leader = team[1]
        --todo尾兽技能
    if self.params.left.tailSkill then
         -- 队长变身前 变身后共用的尾兽技能管理 
        local tailSkillMgr = TailSkillManager.new(leader.camp)
        local tailLv = self.params.left.tailSkill.level

        for k,v in pairs(self.params.left.tailSkill.skill) do
            tailSkillMgr:addSkill(v,tailLv)
        end
        leader.tailSkillMgr = tailSkillMgr
        if leader.evolveNode then
            leader.evolveNode.tailSkillMgr = tailSkillMgr
        end
    end

    return team
end

function ArenaBattleScene:createRightTeam()
	  --队长
    local team = {}
    for i=1,#self.params.right.team do
        self.params.right.team[i]:setHeroConfig()
        local role = nil
        if i == 1 then
            role = CharacterNode.new({
                camp      = GameCampType.right,
                enemyCamp = GameCampType.left,
                isLeader  = true,
                auto      = true,
                model     = self.params.right.team[i]
            })
            role:setLocalZOrder(self.MAX_Z - BattlePosition.right[i].y)
            role:setPosition(display.width + role.model.attackSize.width,BattlePosition.left[i].y)
       else
            role = CharacterNode.new({
                camp = GameCampType.right,
                enemyCamp = GameCampType.left,
                auto               = true,
                isLeader           = false,
                followDistance     = 50,  
                model = self.params.right.team[i],
            })
            local x,y = team[1]:getPosition()
            role:setLocalZOrder(self.MAX_Z - BattlePosition.right[i].y)
            role:setPosition( x + role.leaderDistance, BattlePosition.right[i].y)
        end

        role:addTo(self.mainLayer)
        table.insert(team,role)

        if role.model.evolve then
            local evolveNode = role:createEvolve()
            evolveNode:setVisible(false)
            evolveNode:pauseAll()
            evolveNode:addTo(self.mainLayer)
        end
    end

    local leader = team[1]
    if self.params.right.tailSkill then
        -- 队长变身前 变身后共用的尾兽技能管理 
        local tailSkillMgr = TailSkillManager.new(leader.camp)
        local tailLv = self.params.right.tailSkill.level

        for k,v in pairs(self.params.right.tailSkill.skill) do
            tailSkillMgr:addSkill(v,tailLv)
        end

        leader.tailSkillMgr = tailSkillMgr
        if leader.evolveNode then
            leader.evolveNode.tailSkillMgr = tailSkillMgr
        end
    end

    return team
end

--[[
    创建特效遮罩层
--]]
function ArenaBattleScene:createMaskLayer()
    self.maskLayer= cc.LayerColor:create(cc.c4b(0,0,0,0))
    self.maskLayer:setVisible(false)
    self.maskLayer:setContentSize(5000,display.height)
    self.maskLayer:setPosition(0,0)
    self.maskLayer:addTo(self.mainLayer)
end

--[[
  显示特写背景
--]]
function ArenaBattleScene:showMaskLayer()
    self.maskLayer:runAction(cc.Sequence:create(cc.Show:create(),cc.FadeTo:create(0.2,160)))
end

--[[
  隐藏特写背景
--]]
function ArenaBattleScene:hideMaskLayer()
   self.maskLayer:runAction(cc.Sequence:create(cc.FadeOut:create(0.1),cc.Hide:create()))
end



--[[
    暂停战场上的角色 除了exRole角色外
--]]
function ArenaBattleScene:pauseRoles(exRole)
    local roles = self:getRoles(exRole)
    table.walk(roles,function(v,k)
        v:pauseAll()
    end)

    BattleManager.missilesIterator(function (v,k)
        v:pauseAll()
    end)
end

--[[
    恢复战场上的角色 除了exRole角色外
--]]
function ArenaBattleScene:resumeRoles(exRole)
    local roles = self:getRoles(exRole)
    table.walk(roles,function(v,k)
        v:resumeAll()
    end)

    BattleManager.missilesIterator(function (v,k)
        v:resumeAll()
    end)
end

--[[
    获取除了exRole之外的角色
--]]
function ArenaBattleScene:getRoles(exRole)
    local roles = BattleManager.find(function(v,k)
        if exRole then
            if v.roleId == exRole.roleId and v.camp == exRole.camp then
                return false
            end
        end
        if not v:isActive() then
            return false
        end
        return true
    end)
    return roles
end

--[[
    角色死亡时触发
--]]
function ArenaBattleScene:onCharacterKill(event)
    local dead = event.dead
    if dead.camp == GameCampType.left then
        self.leftDeadCount = self.leftDeadCount + 1
    else
        self.rightDeadCount = self.rightDeadCount + 1
    end
    if self.leftDeadCount == #self.leftTeam then
        self:onGameLose()
    end
    if self.rightDeadCount == #self.rightTeam then
        self:onGameWin()
    end
end

--[[
    游戏结束时候调用
--]]
function ArenaBattleScene:onGameOver()
    self.over = true
    self.hubLayer:stopCountdown()
    self.hubLayer:setVisible(false)
end

function ArenaBattleScene:onGameTimeOut()
    self.params.timeOut = true
    self:onGameOver()
    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            if v.camp == GameCampType.right then
                v:doWin()
            else
                v:doIdle()
                v.stateMgr.lockState = true
            end
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

--[[
    战斗胜利
--]]
function ArenaBattleScene:onGameWin()
    self.isWin = 1
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
function ArenaBattleScene:onGameLose()
    self:onGameOver()
    BattleManager.roleIterator(function(v,k)
        if v:isActive() then
            v:doWin()
        end
    end)
    scheduler.performWithDelayGlobal(handler(self,self.battleEndRequest),3)
end

function ArenaBattleScene:battleEndRequest()
    if self.params.battleType == 1 or self.params.battleType == 2 then
        if self.isWin == 1 then
            showLoading()
            local params = {
                param1 = self.params.heroIds,
                param2 = self.params.battleType,
            }
            NetHandler.gameRequest("SaveZhuijiResult",params)
        else
            local layer = require("app.views.battle.BattleLoseLayer").new(self.params)
            layer:addTo(self)
        end
    elseif self.params.battleType == 3 then
        showLoading()
        local params = {
            param1 = self.params.right.userId,
            param2 = self.isWin
        }
        NetHandler.gameRequest("UnionCombatResult",params)
    else
        showLoading()
        local params = {
            param1 = self.isWin,
            param2 = self.params.right.userId,
            param3 = self.params.right.teamId
        }
        NetHandler.gameRequest("SaveJingjiResult",params)
    end
end

function ArenaBattleScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.SaveJingjiResultProcess then
        if tonumber(data.param1) == 1 then
            self.params.rank = tonumber(data.param4)
            self.params.rankOld = tonumber(data.param3)
            self.params.diamond = tonumber(data.param5)
            hideLoading()
            local layer = require("app.views.arena.ArenaWinLayer").new(self.params)
            layer:addTo(self)
        elseif tonumber(data.param1) == 0 then
            hideLoading()
            local layer = require("app.views.battle.BattleLoseLayer").new(self.params)
            layer:addTo(self)
        end
    elseif order == OperationCode.SaveZhuijiResultProcess then
        hideLoading()
        local showItems = UserData:parseItems(data.a_param1)
        UserData:showReward(showItems, function()
            self.params:winFunction()
        end) 
    elseif order == OperationCode.UnionCombatResultProcess then
        hideLoading()
        local showItems = UserData:parseItems(data.a_param1)
        UserData:showReward(showItems, function()
            self.params:winFunction()
        end) 
    end
end

return ArenaBattleScene
