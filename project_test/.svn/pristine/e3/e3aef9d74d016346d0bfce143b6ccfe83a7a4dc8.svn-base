--
-- Author: zsp
-- Date: 2014-11-26 10:34:55
--

local RoleNode        = import(".RoleNode")
local EnemyModel      = import("..model.EnemyModel")
local StateManager    = import("..state.StateManager")
local EnemyState      = import("..state.EnemyState")
local EnemyNode       = class("EnemyNode", RoleNode)

--[[
	战场上的敌人类 包括普通敌人和boss boss的逻辑多的话，在可以单独分开
--]]
function EnemyNode:ctor(params)
	
	params.camp      = params.camp or GameCampType.right
	params.enemyCamp = params.enemyCamp or GameCampType.left
	params.auto      = true

	local skillLevel = params.skillLevel

	params.model = EnemyModel.new({
		roleId     = params.roleId,
		level      = params.level,
		skillLevel = skillLevel
	})

	if params.nodeScale == nil then
		params.nodeScale = params.model.nodeScale
	end

	EnemyNode.super.ctor(self,params)

	self.state    = EnemyState
	self.stateMgr = StateManager.new(self,self.state.idle)

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self:update(dt)
	end)

	self:scheduleUpdate()

	--自爆怪
	if self.model.type == 1 then
		local time = self.model.parameter.time or 10
		local damage = self.model.parameter.damage or 500
		self:setTimebomb(time, damage)
		local sp1 = self.model.parameter.sp1
		local sp2 = self.model.parameter.sp2
		newrandomseed()
		self.model.walkSpeed =  math.random(sp1,sp2)
	end

end

function EnemyNode:update( dt )
	
	if self.isPaused then
		return
	end

	self.stateMgr:update(dt)
	self.skillMgr:update(dt)
	self.buffMgr:update(dt)
end

--[[
	设置定时自爆
--]]
function EnemyNode:setTimebomb(time,damage)
	--printInfo("自爆类型%d=======%d", time,damage)
	local bombNode = require("app.battle.node.BombNode").new(self,time,damage)
	bombNode:setPosition(0, self.model.nodeSize.height)
	bombNode:addTo(self)
end

return EnemyNode