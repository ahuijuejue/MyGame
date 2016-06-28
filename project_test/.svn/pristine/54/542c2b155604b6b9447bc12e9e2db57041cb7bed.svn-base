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

local BattleGuide2Scene = class("BattleGuide2Scene",BattleScene )

--[[
  新手引导
--]]
function BattleGuide2Scene:ctor(params) 
    BattleGuide2Scene.super.ctor(self,params)
end

function BattleGuide2Scene:init()
    self.mapNum = 2
    self.params.type = 2 -- 必须得有个玩法类型，才能像关卡一样出兵
    BattleGuide2Scene.super.init(self)
    self.hubLayer.pauseBtn:setVisible(false)
end

--[[
    战斗超时
--]]
function BattleGuide2Scene:onGameTimeOut()
    AudioManage.stopMusic(true)
    self:onGameOver()
    self:removeRoles()
    self:battleEndRequest()
end

--[[
    战斗胜利
--]]
function BattleGuide2Scene:onGameWin()
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
function BattleGuide2Scene:onGameLose()
    AudioManage.stopMusic(true)
    self:onGameOver()
    self:removeRoles()
    self:battleEndRequest()
end

function BattleGuide2Scene:battleEndRequest()
    showLoading()
    NetHandler.gameRequest("NewComerGuide",{param1 = "Fight2"})
end

return BattleGuide2Scene