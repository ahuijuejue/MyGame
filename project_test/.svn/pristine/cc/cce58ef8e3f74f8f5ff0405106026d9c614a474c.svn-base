
--[[
修炼圣地选择英雄界面
]]
local SelectLayer = import(".SelectLayer")
local HolyLandSelectLayer = class("HolyLandSelectLayer", SelectLayer)


function HolyLandSelectLayer:initData(options)
	-- 位置上限
	self.maxGet_ = 4
	HolyLandSelectLayer.super.initData(self)
end 

function HolyLandSelectLayer:initView()	
	HolyLandSelectLayer.super.initView(self)
	
	-- 已选取区域
	local heroLabel = {"Word_Leader","Word_Member1","Word_Member2","Word_Member3"}
	
	self:addHeroPos(self.heroIndexes.leader, 800, 385, 2)
	self:addHeroPos(self.heroIndexes.member1, 520, 360, 2)
	self:addHeroPos(self.heroIndexes.member2, 320, 360, 2)
	self:addHeroPos(self.heroIndexes.member3, 120, 360, 2)

	self:addHeroPos(self.heroIndexes.bench1, 610, 490, 1)
	self:addHeroPos(self.heroIndexes.bench2, 410, 490, 1)
	self:addHeroPos(self.heroIndexes.bench3, 210, 490, 1)

	self:setSuperCount(1)
	
end 

function HolyLandSelectLayer:showGridEx(grid, data)
	self:gridAddName(grid, data)
end 

return HolyLandSelectLayer