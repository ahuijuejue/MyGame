
local SealData = class("SealData")

function SealData:ctor()
	self.totalExp = 0 -- 封印总经验

	local sealcfg = {}
	local cfg0 = {
		lv 			= 0,
		totalExp 	= 0,
		exp 		= 0,
	}
	table.insert(sealcfg, cfg0)
	for k,v in pairs(GameConfig.SealExp) do
		local tSeal = {
			lv 			= tonumber(k),					-- 封印星级
			totalExp 	= tonumber(v.SealTotalExp), 	-- 升到当前星级需要的总经验
			exp 		= tonumber(v.SealExp), 			-- 升到当前星级需要的等级经验
		}
		table.insert(sealcfg, tSeal)
	end

	table.sort(sealcfg, function(a, b)
		return a.lv < b.lv
	end)

	local lastcfg = sealcfg[#sealcfg]
	self.maxExp = lastcfg.totalExp
	self.maxStarLv = lastcfg.lv

	self.sealCfg = sealcfg

	---------------------------------
	---------------------------------
	-- 封印属性加成
	self.attrArr = {}
	for k,v in pairs(GameConfig["seal_xing"] or {}) do
		table.insert(self.attrArr, {
			level = checknumber(v.lv),
			type  = v.type,
			value = checknumber(v.value),
		})
	end
	table.sort(self.attrArr, function(a, b)
		return a.level < b.level
	end)
end

-----------------------------------------------------
--------------- 获取封印配置信息 ------------------
-- 经验对应的等级 配置封印信息
function SealData:getConfig(exp)
	local maxStar = self:getMaxStar()
	for i,v in ipairs(self.sealCfg) do
		if exp < v.totalExp or v.lv == maxStar then
			return self.sealCfg[i - 1]
		end
	end
	return self.sealCfg[#self.sealCfg]
end

-- 经验对应的下一等级 配置封印信息
function SealData:getNextConfig(exp)
	local maxStar = self:getMaxStar()
	for i,v in ipairs(self.sealCfg) do
		if exp < v.totalExp or v.lv == maxStar then
			return self.sealCfg[i]
		end
	end
	return nil
end

-- 经验对应的 封印信息
function SealData:getSealInfo_(exp)
	local cfg = self:getConfig(exp)
	local nextcfg = self:getNextConfig(exp)
	local starNum = cfg.lv

	local hasExp = exp - cfg.totalExp
	local progress = 0
	local expMax = 0
	if nextcfg then
		progress = hasExp / nextcfg.exp
		expMax = nextcfg.exp
	end
	local sealInfo = {
		lv 		= math.floor(starNum / 5),
		star 	= math.mod(starNum, 5),
		exp 	= hasExp,
		expMax 	= expMax,
		progress = progress,
	}

	return sealInfo
end

-- 当前经验对应属性
function SealData:getSealInfo()
	return self:getSealInfo_(self.totalExp)
end

-- 当前封印层级
function SealData:getSealLevel()
	return self:getSealInfo().lv
end
-------------------------------------------
------------------- 查询 -------------------
---------------------
-- 封印最高值
-- 当前玩家等级对应的最高星级配置
function SealData:getMaxStar()
	local maxStar = UserData:getUserLevel() * 5 + 5
	return math.min(maxStar, self.maxStarLv)

end

-- 当前玩家等级对应的最高 经验
function SealData:getMaxExp()
	local maxStar = self:getMaxStar()
	for i,v in ipairs(self.sealCfg) do
		if maxStar == v.lv then
			return v.totalExp
		end
	end
	return self.sealCfg[#self.sealCfg].totalExp -- 没有找到，返回最高值
end

---------------------
-- 查询封印状态

-- 当前封印是否已经达到最高
function SealData:isSealMax()
	return self.totalExp  >= self:getMaxExp()
end

-- 增加经验exp后，封印是否达到最高
function SealData:isSealMaxAddExp(exp)
	local allExp = exp + self.totalExp
	return allExp >= self:getMaxExp()
end
-----------------------------------------
-----------------------------------------
-- 设置封印经验
function SealData:setSealExp(exp)
	self.totalExp = math.min(exp, self:getMaxExp())

	return self
end

function SealData:addSealExp(exp)
	self:setSealExp(self.totalExp + exp)

	return self
end

------------------------------------------

-- 获得封印花费金币
-- @param sealValue 封印点数
function SealData:getSealCost(sealValue)
	return sealValue * GlobalData.sealBase
end

-----------------
-- 获取 可用于封印的物品列表
function SealData:getCanSealItems()
	local items = {}
    for i,v in ipairs(ItemData:getItems()) do
        if v.type == 16 and v.seal > 0 then
            items[#items + 1] = v
        end
    end

    table.sort(items, function(a, b)
        local isA = a.type == 16
        local isB = b.type == 16
        if isA and not isB then
            return true
        elseif not isA and isB then
            return false
        else
            return a.seal < b.seal
        end
    end)

    return items
end

--=========================================
-- 获得封印加成属性列表
function SealData:getAttributeList()
	return self.attrArr
end

function SealData:getAttributeInfoDict(level)
	local dict = {}

	for i,v in ipairs(self.attrArr) do
		if v.level <= level then
			if not dict[v.type] then dict[v.type] = 0 end
			dict[v.type] = dict[v.type] + v.value
		end
	end

	return dict
end

function SealData:getAttributeNextInfo(level)
	for i,v in ipairs(self.attrArr) do
		if v.level > level then
			return v
		end
	end
	return nil
end

-- 获得封印加成属性列表(字典格式 )
function SealData:getAttributeForBattle()
	local dataDict = self:getAttributeInfoDict(self:getSealLevel())
	local dict = {}
	for k,v in pairs(dataDict) do
		dict[GlobalData:convertHeroType(k).info] = v
	end
	return dict
end

--=========================================

return SealData
