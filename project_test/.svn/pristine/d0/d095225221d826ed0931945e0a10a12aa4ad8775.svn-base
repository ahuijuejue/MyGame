--[[
城建数据
]]

local CityData = class("CityData")
local GameCity = import(".GameCity")
local TowerModel   = require("app.battle.model.TowerModel")

function CityData:ctor()
	self.dict = {} -- 各级建筑数据 
	self.cityData = {} 	-- 当前建筑
	self.skillDict = {} -- 建筑技能

	local cityData = GameConfig["Castle"]
	for k,v in pairs(cityData) do
		self.dict[k] = GameCity.new({id=k, cfg=v})
	end

	local cityInfo = GameConfig["CastleInfo"]	

	for k,v in pairs(cityInfo) do
		self.cityData[k] = {
			id 		= k,
			name 	= v.Name,
			icon 	= v.CastleImg,
			level 	= 1,
			costRatio = checknumber(v.consum_ratio) * 0.01, -- 升级花费比例
			data 	= self.dict[v.InitialID],
			skillList = v.InitialSkill or {},
		}
	end

	for k,v in pairs(GameConfig["CastleSkillInfo"] or {}) do
		self.skillDict[k] = {
			id = k,
			name = v.Name,
			desc = v.SkillInfo,
			icon = v.SkillIcon,
		}
	end

end
-- cityId 建筑类型id， levelId 各等级建筑id
function CityData:setCity(cityId, levelId)
	if levelId == "0" then return self end 
	self.cityData[cityId].data = self.dict[levelId]
	
	return self
end 

-- 获得建筑数据， @param cityId 建筑类型id
function CityData:getCity(cityId)
	return self.cityData[cityId]
end 

-- 获得 具体星级的建筑数据， @param levelId 各等级建筑id
function CityData:getCityConfig(levelId)
	return self.dict[levelId]
end 

-- 设置建筑强化等级
-- cityId 建筑类型id， 
function CityData:setCityLevel(cityId, level)
	if level < 1 then level = 1 end  
	self.cityData[cityId].level = level
	
	return self
end 

---------------------------
-- 强化消耗的金币
function CityData:getStrongCost(cityId, toStrongLevel)
	local cfg = GameConfig["consume"]
	local key = tostring(toStrongLevel)
	local castle = cfg[key]["CastleConsume"]
	local city = self:getCity(cityId)

	local cost = checknumber(castle) * city.costRatio 
	return math.floor(cost)
end 

-- @获取塔的属性model
function CityData:getTowerModel(levelId, strongLevel)
	print("id:", levelId)
	local data = TowerModel.new(strongLevel,GameConfig.tower[levelId])
	return data 
end 

-- @获取技能信息
function CityData:getSkill(skillId)	
	return self.skillDict[skillId] 
end 

---------------------------
-- 是否可以升星
function CityData:canStarUp(cityId)
	local cityData = self:getCity(cityId)

	if not cityData.data.nextCityId then 
		return false 
	end 
	
	for i,v in ipairs(cityData.data.items) do
		local item = ItemData:getItem(v.id)
		if item and item.count >= v.num then 
		else 
			return false 
		end 
	end

	return true  
end 
-- 升星消耗掉材料 
function CityData:didCostStarUpItems(cityId)
	local cityData = self:getCity(cityId)
	
	for i,v in ipairs(cityData.data.items) do		
		ItemData:reduceItem(v.id, v.num)
	end
end

-- 是否可以强化升级
function CityData:canStrongUp(cityId)
	local cityData = self:getCity(cityId)
	if cityData.level < UserData:getUserLevel() then 
		local cost = self:getStrongCost(cityId, cityData.level + 1)
		if cost > UserData.gold then 
			return false		
		end 
	else 
		return false 
	end 
	return true 
end 

-- 传输给战斗场景的建筑数据
function CityData:getBuilding()
	local isOpen = UserData:getUserLevel() >= OpenLvData.city.openLv
	local building = {}
	for k,v in pairs(self.cityData) do
		if isOpen or v.id == "1" then 
			table.insert(building, {
				type = v.id, -- 塔类型
				id = v.data.id, -- 具体塔 
				level = v.level,
				starLv = v.data.star,
			})
		end 
	end
	return building
end
----------------------

----------------------

return CityData
