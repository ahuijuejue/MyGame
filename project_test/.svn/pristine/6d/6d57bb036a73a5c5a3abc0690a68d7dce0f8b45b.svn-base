--
-- Author: zsp
-- Date: 2015-04-27 16:20:28
--

local GameNode    = import(".GameNode")
local EnemyModel  = import("..model.EnemyModel")
local BattleEvent = import("..BattleEvent")
local CharserNode   = class("CharserNode", GameNode)

--[[
	追击类型敌人，出现在逃跑关卡中
--]]

function CharserNode:ctor(params)
	
	CharserNode.super.ctor(self)

	self.nodeType  = GameNodeType.ROLE
	
	self.isPaused  = false
	self.roleId    = params.roleId
	self.level     = params.level or 1
	
	self.camp      = GameCampType.right --params.camp
	self.enemyCamp = GameCampType.left --params.enemyCamp
	
	self.model = EnemyModel.new({
		roleId = params.roleId,
		level  = params.level
	})
	
	self:createAnimNode()
	self:createBoundingBox()

	self:playIdle()

	--self:createEffectNode()
	--self:createHpBar()
	--self:setLocalZOrder(900)
	--BattleManager.addRole(self)

	self.frame = 0 

	self:runAction(cc.Sequence:create(cc.DelayTime:create(3),cc.CallFunc:create(function()
  	  self:startRun()
    end)))


end 

function CharserNode:onUpdate(dt)
	if self.isPaused then
		return
	end

	local x = self:getPositionX()
	local speed = self.model.walkSpeed * 3
	if( x + self:getNodeRect().width * 0.5 + speed * dt < BattleManager.sceneWidth) then
		x = x + (speed * dt)
		self:setPositionX(x)
	else
		self:stopRun()	
	end

	self.frame = self.frame + 1
	--优化逻辑：每隔n帧执行下边的逻辑
	if self.frame % 10 ~= 0 then
		return
	end


	-- local leader = BattleManager.getLeader(self.enemyCamp)
	-- if cc.rectIntersectsRect(leader:getNodeRect(),self:getNodeRect())  then
	-- 	self:stopRun()
	-- 	leader:doDead()
	-- end

	local enemies = BattleManager.roles[self.enemyCamp]
	
	table.walk(enemies,function(v,k)

		if v:isActive() and
			cc.rectIntersectsRect(v:getNodeRect(),self:getNodeRect()) then
			
			if v.isLeader then
				self:stopRun()
			end

			v:doDead()
		end

	end)
end

--[[
	创建角色动画
--]]
function CharserNode:createAnimNode()
	
	-- local function onFrame(frame,finish)
 --        self.stateMgr.currentState:executeAnim(self,frame,finish)
 --    end

	self.animNode = GafAssetCache.makeAnimatedObject(self.model.image)
	self.animNode:addTo(self)
	self.animNode:start()

	self.animNode:setPosition(self.animNode:getFrameSize().width * -0.5,self.animNode:getFrameSize().height - 440)
	self.animNode:setScaleX(1)

end


--[[
	创建碰撞检测的包围盒
--]]
function CharserNode:createBoundingBox()
	--self.nodeBox:addTo(self)
	self.nodeBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	self.nodeBox:setPosition(self.model.nodeOffset.x - self.model.nodeSize.width * 0.5 ,self.model.nodeOffset.y)
	self.nodeBox:addTo(self)
	self.nodeBox:setContentSize(self.model.nodeSize.width,self.model.nodeSize.height)
	self.nodeBox:setVisible(false)
end

--[[
	开始追击
--]]
function CharserNode:startRun()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.onUpdate))
	self:scheduleUpdate()
	self:playWalk()
end

--[[
	停止追击
--]]
function CharserNode:stopRun()
	self:unscheduleUpdate()
	self:playIdle()
	self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.Hide:create()))
end

function CharserNode:pauseAll()
	self.isPaused = true
	self:pause()
	self.animNode:pauseAnimation()
end

function CharserNode:resumeAll()
	self.isPaused = false
	self:resume()
	self.animNode:resumeAnimation()
end

--[[
	播放动画
--]]
function CharserNode:playAnim(name,loop)
	self.animNode:playSequence(name,loop)
end

function CharserNode:playIdle()
	self:playAnim( "idle", true)
end

function CharserNode:playWalk()
	self:playAnim( "walk", true)
end

return CharserNode