--
-- Author: zsp
-- Date: 2015-05-15 16:48:16
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
local scheduler          = require(cc.PACKAGE_NAME .. ".scheduler")
require("app.battle.GafAssetCache")

--战斗角色的的站置
local BattlePosition = {}
BattlePosition.left  = {cc.p(0,130),cc.p(40,140),cc.p(80,180),cc.p(130,220)}

local BattleGuide1Scene = class("BattleGuide1Scene",BattleScene )

--[[
  新手引导
--]]
function BattleGuide1Scene:ctor(params) 
    BattleGuide1Scene.super.ctor(self,params)
end

function BattleGuide1Scene:init()
    self.mapNum = 2
    self.params.type = 2 -- 必须得有个玩法类型，才能像关卡一样出兵
    BattleGuide1Scene.super.init(self)
    self.hubLayer.pauseBtn:setVisible(false)
    self.hubLayer.angerButton:setVisible(false)
    self.ctrlLayer.delegate = self
    self.ctrlLayer.isLock = true
end

function BattleGuide1Scene:showMoveGuide()
    self:pauseGame()
    self.ctrlLayer.isLock = false
    local text = GameConfig.tutor_talk["1"].talk
    local x = 200
    local y = 200
    local param = {text = text, x = x, y = y}
    self.moveGuide = showBattleGuide(param):addTo(self)
end

function BattleGuide1Scene:delMoveGuide()
    self:resumeGame()
    if self.moveGuide then
        self.moveGuide:removeFromParent(true)
        self.moveGuide = nil

        self:showAtkGuide()
    end
end

function BattleGuide1Scene:showAtkGuide()
    local x = -30
    local y = 320
    local guideNode = display.newSprite("OperateBanner.png")
    guideNode:setPosition(x,y)
    self.leader:addChild(guideNode)

    -- local action1 = cc.FadeTo:create(0.3, 50)
    -- local action2 = cc.FadeTo:create(0.3,255)
    -- local seq = cc.Sequence:create(action1,action2)
    -- local rep = cc.RepeatForever:create(seq)
    -- guideNode:runAction(rep)

    local text = GameConfig.tutor_talk["2"].talk
    local param = {text = text,size = 20}
    local label = createOutlineLabel(param)
    label:setPosition(140,100)
    guideNode:addChild(label)

    -- local action1 = cc.FadeTo:create(0.5, 50)
    -- local action2 = cc.FadeTo:create(0.5,255)
    -- local seq = cc.Sequence:create(action1,action2)
    -- local rep = cc.RepeatForever:create(seq)
    -- label:runAction(clone(rep))
end

--[[
    战斗超时
--]]
function BattleGuide1Scene:onGameTimeOut()
    AudioManage.stopMusic(true)
    self:onGameOver()
    self:removeRoles()
    self:battleEndRequest()
end

--[[
    战斗胜利
--]]
function BattleGuide1Scene:onGameWin()
    AudioManage.stopMusic(true)
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
function BattleGuide1Scene:onGameLose()
    AudioManage.stopMusic(true)
    self:onGameOver()
    self:removeRoles()
    self:battleEndRequest()
end

function BattleGuide1Scene:battleEndRequest()
    showLoading()
    NetHandler.gameRequest("NewComerGuide",{param1 = "Fight"})
end

return BattleGuide1Scene