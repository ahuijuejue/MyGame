
local VipData = class("VipData")

function VipData:ctor()

	local cfgs = GameConfig["Vip"]
	self.arr = {}
	self.desc = {}
	self.count = 0
	for k,v in pairs(cfgs) do
		table.insert(self.arr, {
			level 		= checknumber(k), 				-- vip等级
			desc        = v.Info,                       -- 说明
			exp 		= checknumber(v.VipExp), 		-- vip经验
			price 		= checknumber(v.Price), 		-- vip经验
			sale 		= checknumber(v.Sale), 		-- vip经验
			gold 		= checknumber(v.ExchangeNum), 	-- 点金上限
			power 		= checknumber(v.Energy), 		-- 购买体力上限
			elite 		= checknumber(v.BuyEliteStageNum), 		-- 购买精英关卡次数
			treeShop 	= checknumber(v.MysticalShop) == 1, 	-- 神秘商店是否开启
			vipCard 	= checknumber(v.VipCard) == 1, 			-- 至尊推币 开启
			sweep 		= checknumber(v.OneKeySweep) == 1, 		-- 多次扫荡 开启
			seal 		= checknumber(v.OneKeySeal) == 1, 		-- 宝石封印 开启
			treeReset 	= checknumber(v.WorldTreeTimes), 		-- 世界树 重置次数
			aincradReset = checknumber(v.AincradTimes), 		-- 艾恩葛朗特 重置次数
			giftItem    = v.GiftItemID,       --奖励物品
		    giftItemNum = v.GiftItemNum,      --奖励物品数量
		    unionTimes  = v.BuyConsortiachallenge,   -- 公会挑战次数
		})
		self.count = self.count + 1
	end

	table.sort(self.arr, function(a, b)
		return a.level < b.level
	end)

end
--------------------------------------------
function VipData:isMax(exp)
	local data = self.arr[self.count]
	if exp >= data.exp then
		return true
	end
	return false
end

-- 最大VIP等级
function VipData:getVipLevelMax()
    return self.arr[#self.arr].level
end

-- 最大VIP等级对应经验
function VipData:getVipExpMax()
    return self.arr[#self.arr].exp
end

function VipData:getData(exp)
	exp = exp or UserData.vip
	local preData
	for i,v in ipairs(self.arr) do
		if exp < v.exp then
			return preData, v
		else
			preData = v
		end
	end
	return preData, preData
end

function VipData:getLevel(exp)
	local data = self:getData(exp)
	return data.level
end

-- 下一级对应的经验
function VipData:getExpMax(exp)
	local _, nextData = self:getData(exp)
	return nextData.exp
end

-- 升为下一级对应的钻石数
function VipData:getNextDia(exp)
	local _, nextData = self:getData(exp)
	local nextDia = nextData.exp - exp
	return nextDia
end

---------------------------------------------
-- 点金上限
function VipData:getGoldMax()
	local data = self:getData()
	return data.gold
end

-- 购买体力上限
function VipData:getPowerMax()
	local data = self:getData()
	return data.power
end

-- 购买公会挑战上限
function VipData:getUnionPowerMax()
	local data = self:getData()
	return data.unionPower
end

-- 购买精英关卡次数
function VipData:getEliteMax()
	local data = self:getData()
	return data.elite
end

-- 神树商店是否开启
function VipData:isTreeShopOpen()
	local data = self:getData()
	return data.treeShop
end

-- 至尊推币 开启
function VipData:isVipCardOpen()
	local data = self:getData()
	return data.vipCard
end

-- 多次扫荡 开启
function VipData:isSweepOpen()
	local data = self:getData()
	return data.sweep
end

-- 宝石封印 开启
function VipData:IsSealOpen()
	local data = self:getData()
	return data.seal
end

-- 世界树 重置次数
function VipData:getTreeResetMax()
	local data = self:getData()
	return data.treeReset
end

-- 艾恩葛朗特 重置次数
function VipData:getAincradResetMax()
	local data = self:getData()
	return data.aincradReset
end

-- 公会 挑战购买次数
function VipData:getUnionArenaTimeMax()
	local data = self:getData()
	return data.unionTimes
end

-- 是否可以多次扫荡
function VipData:canSweep()
	local data = self:getData()
	return data.sweep
end

-- vip奖励物品
function VipData:getVipAwards(vipLv)
	local data = self.arr[vipLv+1]
	local items = {}
	for i,v in ipairs(data.giftItem or {}) do
		table.insert(items, {
			itemId = v,
			count = checknumber(data.giftItemNum[i])
		})
	end

	return items
end

---------------------------------------------
function VipData:getArray()
	return self.arr
end
return VipData
