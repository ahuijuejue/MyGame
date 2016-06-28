--
-- Author: zsp
-- Date: 2014-11-20 11:25:30
--

--[[
	todo 战斗对象类型暂时没用到
--]]
GameNodeType = {
	UNKNOWN = 0,	--未知
	ROLE    = 1,	--角色
	TOWER   = 2,	--塔
	CLOCK   = 3,    --试炼钟
	MISSILE = 4,	--飞行道具
	LOOT    = 5,	--掉落战利品
	ITEM    = 6,    --掉落的buff道具
	SKILL   = 7,    --技能特效动画
}

--[[
	战斗对象阵营方向
--]]
GameCampType = 
{
	left  = 1,
	right = 2,
}

--[[
	战斗系统中 战场上的对象基类 
--]]
local GameNode = class("GameNode", function()
	return display.newNode()
end)

function GameNode:ctor()
	
	--对象死亡标记 ，被标记后 不在被检测碰撞
	self.dead     = false
	
	--对象删除标记 ，被标记后 将由battleManager管理类统一删除
	self.remove   = false
	
	--对象节点类型
	self.nodeType  = GameNodeType.unknown
	
	--节点的检测范围 子类要重设置rect
	self.nodeRect = cc.rect(0,0,0,0)
	
end

function GameNode:getNodeRect()
	-- body
	-- self.nodeRect.width  = self.model.nodeSize.width
	-- self.nodeRect.height = self.model.nodeSize.height
	-- local x,y = self:getPosition()
	-- self.nodeRect.x = x - self.nodeRect.width * 0.5
	-- self.nodeRect.y = y - self.nodeRect.height * 0.5

	local pt = self.nodeBox:convertToWorldSpace(cc.p(0,0))
	self.nodeRect.width  = self.nodeBox:getContentSize().width
	self.nodeRect.height = self.nodeBox:getContentSize().height
	self.nodeRect.x      = pt.x
	self.nodeRect.y      = pt.y
	return self.nodeRect
end

--[[
	判断是否激活 用于battleManager各种判断
--]]
function GameNode:isActive()

	if self:isVisible() == false or self.dead == true or self.remove == true then
	--if self:isVisible() == false or self.remove == true then
		return false
	end

	return true
end

function GameNode:stopAllSchedule()
	
end

--受BattleManager管理的对象才会自动调用
function GameNode:destory()
	-- 子类重写
end

return GameNode