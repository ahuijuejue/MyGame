--
-- Author: zsp
-- Date: 2015-04-21 14:20:20
--

local GameNode    = import(".GameNode")
local ItemNode   = class("ItemNode", GameNode)

--[[
	战场上塔掉落的buff道具
--]]

function ItemNode:ctor(params)
	ItemNode.super.ctor(self)

	self.itemId = params.itemId
	local data  = GameConfig.tower_skill[self.itemId]
	local img   = data.image
	
	local sp    = display.newSprite(string.format("%s.png", img))
	sp:setLocalZOrder(999)
	sp:addTo(self)

	self.buffId = data.buff

	self:createBoundingBox()

	BattleManager.addItem(self)
end

--[[
	创建碰撞检测的包围盒
--]]
function ItemNode:createBoundingBox()
	--self.nodeBox:addTo(self)
	self.nodeBox   = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	local size = cc.size(80,80)
	self.nodeBox:setContentSize(size)
	self.nodeBox:setPosition( size.width * -0.5 , size.height * -0.5)
	self.nodeBox:addTo(self)
	self.nodeBox:setVisible(false)
end

return ItemNode