--[[
竞技场选择英雄界面
]]
local SelectLayer = import(".SelectLayer")
local ArenaSelectHeroLayer = class("ArenaSelectHeroLayer", SelectLayer)

function ArenaSelectHeroLayer:initData()	
	self.maxGet_ = 5 -- 位置上限
	ArenaSelectHeroLayer.super.initData(self)	
	
end 

function ArenaSelectHeroLayer:initView()	
	ArenaSelectHeroLayer.super.initView(self)
	
	self:addHeroPos(self.heroIndexes.leader, 800, 435, 2)
	self:addHeroPos(self.heroIndexes.member1, 570, 360, 2)
	self:addHeroPos(self.heroIndexes.member2, 460, 490, 1)
	self:addHeroPos(self.heroIndexes.member3, 320, 360, 2)
	self:addHeroPos(self.heroIndexes.member4, 210, 490, 1)
end 

function ArenaSelectHeroLayer:showGridEx(grid, data)
	self:gridAddName(grid, data)
end 

function ArenaSelectHeroLayer:getHeroList()
	local list = {}
	for i,v in ipairs(self.getDataList_) do
		table.insert(list, v.roleId)
	end
	return list, self.getDataList_
end

return ArenaSelectHeroLayer