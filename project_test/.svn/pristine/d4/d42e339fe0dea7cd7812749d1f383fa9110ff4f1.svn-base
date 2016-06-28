--[[
日月追缉选择英雄界面
]]
local SelectLayer = import(".SelectLayer")
local LookingForSelectLayer = class("LookingForSelectLayer", SelectLayer)

function LookingForSelectLayer:initData(options)	
	self.maxGet_ = 5 -- 位置上限
	LookingForSelectLayer.super.initData(self)	
	
	self.sexType = options.sexType -- 排除的性别类型
end 

function LookingForSelectLayer:initView()	
	LookingForSelectLayer.super.initView(self)
	
	self:addHeroPos(self.heroIndexes.leader, 800, 435, 2)
	self:addHeroPos(self.heroIndexes.member1, 570, 360, 2)
	self:addHeroPos(self.heroIndexes.member2, 460, 490, 1)
	self:addHeroPos(self.heroIndexes.member3, 320, 360, 2)
	self:addHeroPos(self.heroIndexes.member4, 210, 490, 1)
end 

function LookingForSelectLayer:updateHeroData()
	self.data_ = {}	
	local list = {LIST_TYPE.HERO_ALL, LIST_TYPE.HERO_TANK, LIST_TYPE.HERO_DPS, LIST_TYPE.HERO_AID}
	for i,v in ipairs(list) do
		local heros = HeroListData:getListWithType(v)
		heros = self:excludeHeroBySex(heros, self.sexType)
		table.insert(self.data_, heros)
	end

	self:sortHeroList(self.data_)
	
end 

-- 排除性别为sex的英雄
function LookingForSelectLayer:excludeHeroBySex(heroList, sexType)
	local list = {}
	for k,v in pairs(heroList or {}) do
		if v.sex ~= sexType then 
			table.insert(list, v)
		end 
	end
	return list 
end 

function LookingForSelectLayer:showGridEx(grid, data)
	self:gridAddName(grid, data)
end 

function LookingForSelectLayer:getHeroList()
	local list = {}
	for i,v in ipairs(self.getDataList_) do
		table.insert(list, v.roleId)
	end
	return list, self.getDataList_
end

return LookingForSelectLayer