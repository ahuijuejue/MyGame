module("GameExp", package.seeall)

--英雄经验相关

--获取英雄上限等级
function getLimitLevel()
	local key = tostring(UserData:getUserLevel())
	local limitLevel = math.min(GameConfig.user_exp[key].HeroLvLimit,getMaxLevel())
	return limitLevel
end

--获取英雄最大等级
function getMaxLevel()
	return getUserMaxLevel()
end

--根据经验获取英雄等级
function getLevel(exp)
	local level = 1
	local limitLevel = getLimitLevel()

	local key = tostring(limitLevel)
	if exp >= GameConfig.hero_exp[key].TotalExp then
		level = limitLevel
		return level
	end

	for i=1,getLimitLevel() do
		local key = tostring(i)
		if exp < GameConfig.hero_exp[key].TotalExp then
			level = i - 1
			return level
		end
	end

	return level
end

--增加经验值
function getFinalExp(exp,value)
	local limitLevel = getLimitLevel() + 1
	local limitExp = GameConfig.hero_exp[tostring(limitLevel)].TotalExp - 1
	local finalExp = exp + value
	if finalExp > limitExp then
		finalExp = limitExp
	end
	return finalExp
end

--英雄是否达到等级上限
function isLimitLevel(level)
	if level == getLimitLevel() then
		return true
	end
	return false
end

--英雄是否达到经验上限
function isLimitExp(exp)
	local limitLevel = getLimitLevel() + 1
	local limitExp = GameConfig.hero_exp[tostring(limitLevel)].TotalExp - 1
	if exp >= limitExp then
		return true
	end
	return false
end

--获取英雄当前等级经验
function getCurrentExp(exp)
	local finalExp = getFinalExp(exp,0)
	local currentKey = tostring(getLevel(exp))
	local currentLevelTotalExp = GameConfig.hero_exp[currentKey].TotalExp
	local currentExp = finalExp - currentLevelTotalExp

	return currentExp
end

--获取英雄升级所需总经验
function getUpgradeExp(exp)
	local currentKey = tostring(getLevel(exp))
	local currentLevelTotalExp = GameConfig.hero_exp[currentKey].TotalExp

	local nextKey = tostring(getLevel(exp)+1)
	local nextLevelTotalExp = GameConfig.hero_exp[nextKey].TotalExp

	local upgradeExp = nextLevelTotalExp - currentLevelTotalExp
	return upgradeExp
end

--用户经验相关

--获取用户最大等级
function getUserMaxLevel()
	local maxLv = tonumber(GameConfig.Global["1"].PlayerLevelLimit)
	return maxLv
end

--根据经验获取用户等级
function getUserLevel(exp)
	local level = 1

	if exp >= GameConfig.user_exp[tostring(getUserMaxLevel())].PlayerTotalExp then
		level = getUserMaxLevel()
		return level
	end

	for i=1,getUserMaxLevel() do
		local key = tostring(i)
		if exp < GameConfig.user_exp[key].PlayerTotalExp then
			level = i - 1
			return level
		end
	end

	return level
end

--根据经验值获取用户体力上限
function getLimitPower(exp)
	local key = tostring(getUserLevel(exp))
	local value = GameConfig.user_exp[key].EnergyLimit
	return value
end

--根据经验值获取用户英雄等级上限
function getHeroLimitLv(exp)
	local key = tostring(getUserLevel(exp))
	local value = GameConfig.user_exp[key].HeroLvLimit
	return value
end

--增加用户经验值
function getUserFinalExp(exp,value)
	local maxLevel = getUserMaxLevel() + 1
	local maxExp = GameConfig.user_exp[tostring(maxLevel)].PlayerTotalExp - 1
	local finalExp = exp + value
	if finalExp > maxExp then
		finalExp = maxExp
	end
	return finalExp
end

--获取用户当前等级经验
function getUserCurrentExp(exp)
	local finalExp = getUserFinalExp(exp,0)
	local currentKey = tostring(getUserLevel(exp))
	local currentLevelTotalExp = GameConfig.user_exp[currentKey].PlayerTotalExp
	local currentExp = finalExp - currentLevelTotalExp

	return currentExp
end

--获取用户升级所需总经验
function getUserUpgradeExp(exp)
	local currentKey = tostring(getUserLevel(exp))
	local currentLevelTotalExp = GameConfig.user_exp[currentKey].PlayerTotalExp

	local nextKey = tostring(getUserLevel(exp)+1)
	local nextLevelTotalExp = GameConfig.user_exp[nextKey].PlayerTotalExp

	local upgradeExp = nextLevelTotalExp - currentLevelTotalExp

	return upgradeExp
end

-- 当前公会经验
function getUnionExp(exp)  -- exp 总经验
	local unionlevel = UnionListData:getLevel(exp)
	local preExp = 0
	for i,v in ipairs(UnionListData.arr) do
		if unionlevel == v.level then
			preExp = v.exp
			break
		end
	end
	return exp - preExp
end
