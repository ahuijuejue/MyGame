local SummonData = class("SummonData")
local scheduler = require("framework.scheduler")
local GameItem = import(".GameItem")
local GameEquip = import(".GameEquip")

SUMMON_TYPE = {
	CASH_SUMMON = 1,
	DIAMOND_SUMMON = 2,
	CASH_SUMMON_TEN = 3,
	DIAMOND_SUMMON_TEN = 4,
	SECRET_SUMMOM = 5,
}

function SummonData:ctor()
	--金币免费抽卡冷却时间
	self.freeCashTime = 300
	--每日金币免费抽卡剩余次数
	self.freeCashTimes = 0
	--每日金币免费抽卡上限
	self.cashLimit = 5
	--下一次金币免费抽卡时间戳
	self.nextCashTimeStamp = 0

	--钻石免费抽卡冷却时间
	self.freeDiamondTime = 86400
	--下一次钻石免费抽卡时间戳
	self.nextDiamondStamp = 0

	--金币抽卡单价
	self.cashPrice = tonumber(GameConfig.Global["1"].GC)
	--连续抽卡价格
	self.cashPriceEx = tonumber(GameConfig.Global["1"].GC10)
	--钻石抽卡单价
	self.diamondPrice = tonumber(GameConfig.Global["1"].DC)
	--钻石十连价格
	self.diamondPriceEx = tonumber(GameConfig.Global["1"].DC10)
	--至尊抽卡价格
	self.secretPrice = tonumber(GameConfig.CardSecretInfo["1"].ConsumeDiamond)

	--距离金币爆发次数
	self.cashBonus = 10
	--距离钻石爆发次数
	self.diamondBonus = 10

	--当前抽卡类型
	self.summonType = SUMMON_TYPE.CASH_SUMMON

	--抽卡结果
	self.summonResult = {}

	--金币单抽积分
	self.cashScore = tonumber(GameConfig.Global["1"].GCScore)
	--金币连抽积分
	self.cashScoreEx = tonumber(GameConfig.Global["1"].GCScore10)
	--钻石单抽积分
	self.diamondScore = tonumber(GameConfig.Global["1"].DCScore)
	--钻石连抽积分
	self.diamondScoreEx = tonumber(GameConfig.Global["1"].DCScore10)
	--至尊抽卡积分
	self.secretScore = tonumber(GameConfig.CardSecretInfo["1"].CardScore)

    -- 主要热点英雄ID
    self.mainHeroId = ""
    -- 次要热点英雄ID
    self.otherHeroId = {}

end

function SummonData:update(data)
	self.freeCashTimes = self.cashLimit - data.param1
	if data.param2 == 0 then
		self.nextCashTimeStamp = UserData.curServerTime
	else
		self.nextCashTimeStamp = data.param2 + self.freeCashTime
	end
	if data.param3 == 0 then
		self.nextDiamondStamp = UserData.curServerTime
	else
		self.nextDiamondStamp = data.param3 + self.freeDiamondTime
	end
	self.cashBonus = 10 - math.mod(data.param4,10)
	self.diamondBonus = 10 - math.mod(data.param5,10)
end

--是否有免费抽奖
function SummonData:hasFreeSummon()
	local cashFree = false
	local diamondFree = false
	if self.freeCashTimes > 0 and self.nextCashTimeStamp <= UserData.curServerTime then
		cashFree = true
	end
	if self.nextDiamondStamp <= UserData.curServerTime then
		diamondFree = true
	end
	if cashFree or diamondFree then
		return true
	end
	return false
end

function SummonData:updateResultData(result)
	self.summonResult = {}
	self.heroId = {}
	for i,v in ipairs(result) do
		self.heroId[i] = 0
		local item = "nil"
		if v.param4 == 6 then
			local heroId = tostring(v.param1)
			local hero = HeroListData:getRoleWithId(heroId)
			self.heroId[i] = heroId
			if hero then
				local itemId = hero.stoneId
				local count = hero.exchangeStoneNum
		    	ItemData:addMultipleItem(itemId,count)

				local param = {itemId = itemId,count = count}
				item = GameItem.new(param)
			else
				HeroListData:activateHeroWithId(heroId)
			end
		else
			local itemId = tostring(v.param1)
			local config = GameConfig.item[itemId]
			if config.Type == 2 then
				local param = {itemId = itemId, id = v.param2}
				ItemData:superimposeEquip(param)
			else
				local param = {itemId = itemId,count = v.param3}
		    	ItemData:addMultipleItem(itemId,v.param3)
				item = GameItem.new(param)
			end
		end
		table.insert(self.summonResult,item)
	end
end

return SummonData
