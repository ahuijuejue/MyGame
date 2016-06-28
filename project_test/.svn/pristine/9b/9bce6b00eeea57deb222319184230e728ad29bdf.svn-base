--[[
选择出战英雄层
]]
local UnionSelectLayer = import(".UnionSelectLayer")

local UnionSelectHeroLayer = class("UnionSelectHeroLayer", UnionSelectLayer)

function UnionSelectHeroLayer:initData(options)
	self.maxGet_ = 7
	UnionSelectHeroLayer.super.initData(self, options)
end

function UnionSelectHeroLayer:initView()
	UnionSelectHeroLayer.super.initView(self)

	self:addHeroPos(self.heroIndexes.leader, 800, 385, 2)
	self:addHeroPos(self.heroIndexes.member1, 520, 360, 2)
	self:addHeroPos(self.heroIndexes.member2, 320, 360, 2)
	self:addHeroPos(self.heroIndexes.member3, 120, 360, 2)
	self:addHeroPos(self.heroIndexes.bench1, 610, 490, 1)
	self:addHeroPos(self.heroIndexes.bench2, 410, 490, 1)
	self:addHeroPos(self.heroIndexes.bench3, 210, 490, 1)

	self:setSuperCount(1)

end

function UnionSelectHeroLayer:showGridEx(grid, data)
	self:gridAddName(grid, data)
end



return UnionSelectHeroLayer
