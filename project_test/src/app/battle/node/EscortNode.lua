--
-- Author: zsp
-- Date: 2015-04-08 10:46:32
--
local RoleNode        = import(".RoleNode")
local EnemyModel      = import("..model.EnemyModel")
local StateManager    = import("..state.StateManager")
local EscortState     = import("..state.EscortState")
local EscortNode       = class("EscortNode", RoleNode)

--[[
	被护送的角色，出现在护送关卡中
--]]
function EscortNode:ctor(params)
	
	params.camp      = GameCampType.left
	params.enemyCamp = GameCampType.right
	params.auto      = true
	params.hpBarFixed = true

	params.model = EnemyModel.new({
		roleId = params.roleId,
		level  = params.level
	})

	EscortNode.super.ctor(self,params)

	self.state    = EscortState
	self.stateMgr = StateManager.new(self,self.state.idle)

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self:update(dt)
	end)

	
	self:scheduleUpdate()

	self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
		
		local tip = display.newSprite("protect.png")
		tip:setAnchorPoint(0.5,0.5)
		tip:setPosition(cc.p(0,self.model.nodeSize.height + 80))
		tip:addTo(self)

		self:showHpBar()
	end)))
	
end

function EscortNode:update( dt )
	
	if self.isPaused then
		return
	end

	self.stateMgr:update(dt)
	self.buffMgr:update(dt)
end

return EscortNode