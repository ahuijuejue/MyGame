local HeroListData = class("HeroListData")
local scheduler = require("framework.scheduler")

LIST_TYPE = {
	HERO_AGENT = 0,
	HERO_TANK  = 1,
	HERO_DPS   = 2,
	HERO_AID   = 3,
	HERO_ALL   = 4,
	HERO_EXP   = 5,
}

--召唤所需灵魂石区间表
-- STONE_RANGE = {10,30,80,160,310}

local color_gray = cc.c4b(96,96,96,255)
local color_white = cc.c4b(255, 255, 255,255)
local color_green = cc.c4b(80, 239, 0,255)
local color_blue = cc.c4b(52, 152, 255,255)
local color_purple = cc.c4b(224, 111, 255,255)
local color_yellow = cc.c4b(252,189,38,255)
local color_red = cc.c4b(255, 44, 44, 255)

HERO_COLOR_RANGE = {color_white,color_green,color_blue,color_purple,color_yellow,color_red}

function HeroListData:ctor()
	--英雄列表
	self.heroList = {}
	--未激活英雄列表
	self.unActList = {}
	--英雄计时器句柄
	self.listHandle = nil
end

--获取指定类型的英雄列表
function HeroListData:getListWithType(viewType)
	local list1 = {}
	local list2 = {}
	if viewType >= LIST_TYPE.HERO_ALL then
		for i,v in ipairs(self.heroList) do
			table.insert(list1, v)
		end
		for i,v in ipairs(self.unActList) do
			table.insert(list2, v)
		end
		return list1,list2
	end

    if viewType == LIST_TYPE.HERO_AGENT then  -- 佣兵
    	-- 公会所有雇佣兵 需排除自己派出的佣兵
		for k,v in pairs(UnionListData.allAgentData) do
			if not UnionListData:isContainAgent(v) then
				table.insert(list1,v)
			end
		end
    else
    	for k,v in pairs(self.heroList) do
			if v.rangeType == viewType then
				table.insert(list1,v)
			end
		end
		for k,v in pairs(self.unActList) do
			if v.rangeType == viewType then
				table.insert(list2,v)
			end
		end
    end
	return list1,list2
end

--获取指定英雄
function HeroListData:getRoleWithId(roleId,list)
	for k,v in pairs(list or self.heroList) do
		if v.roleId == roleId then
			return v
		end
	end
	return nil
end

-- 获取所有英雄中的指定英雄
function HeroListData:getRoleWithId_(roleId)
	for k,v in pairs(self.heroList) do
		if v.roleId == roleId then
			return v
		end
	end
	for k,v in pairs(self.unActList) do
		if v.roleId == roleId then
			return v
		end
	end
	return nil
end

--激活指定英雄
function HeroListData:activateHeroWithId(heroId)
	local hero = self:getRoleWithId(heroId,self.unActList)
	if hero then
		table.insert(self.heroList,hero)
		removeObject(self.unActList,hero)
	end
	return hero
end

--英雄列表排序
function HeroListData:sortHeroList(list)
    --根据等级排序
    local sortFunc = function (a,b)
        if a.level > b.level then
            return true
        elseif a.level==b.level then
            if a.starLv > b.starLv then
                return true
            elseif a.starLv == b.starLv then
                if a.strongLv > b.strongLv then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    end
    table.sort(list,sortFunc)
end

function HeroListData:clean()
	for i,v in ipairs(self.heroList) do
		v = nil
	end
	for i,v in ipairs(self.unActList) do
		v = nil
	end
	self.heroList = {}
	self.unActList = {}
end

--获取指定英雄
function HeroListData:getRole(roleId)
	local role = self:getRoleWithId(roleId)
	if not role then
		role = self:getRoleWithId(roleId,self.unActList)
	end
	return role
end

--获取英雄总战力
function HeroListData:getAllHeroPower()
	local heroPower = 0
    for i,v in ipairs(self.heroList) do
        heroPower = heroPower + v:getHeroTotalPower()
    end
    return heroPower
end

return HeroListData
