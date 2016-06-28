local CoinData = class("CoinData")
local GameItem = import(".GameItem")

COIN_TYPE = {
    COIN_TRIP = 1,
    COIN_TRIPEX = 2,
}

function CoinData:ctor()
	-- 航行一次免费冷却时间 秒
	self.freeCoinTime = GameConfig["CoinInfo"]["1"].free_time * 3600
	-- 下一次免费航行一次时间戳
	self.nextCoinTimeStamp = 0
    -- 记录指针
    self.recordCounts = 0
	-- 钻石航行一次单价
	self.coinPrice = GameConfig["CoinInfo"]["1"].price_1
	-- 钻石航行十次单价
	self.coinPriceEx = GameConfig["CoinInfo"]["1"].price_10
    -- 航行一次赠送黄金碎片
    self.coinValue = GameConfig["CoinInfo"]["1"].sent_1
    -- 航行十次曾总黄金碎片
    self.coinValueEx = GameConfig["CoinInfo"]["1"].sent_10

    --当前航行类型
    self.coinType = COIN_TYPE.COIN_TRIP

    -- 航行结果
    self.coinResult = {}

    -- 可能掉落物品
    self.items = {}
    local cfg = GameConfig["CoinInfo"]["1"].show_id
    for k,v in pairs(cfg) do
        table.insert(self.items, v)
    end

    -- 可分解的物品
    self.decomposeItems = {}

    -- 显示的可兑换物品
    self.exchangeItems = {}

    -- 累计寻宝次数
    self.coinAllCounts = 0

end

function CoinData:addExchangeItems(itemData)
    local cfg = ItemData:getItemConfig(itemData.id)
    table.insert(self.exchangeItems, {
            itemId = itemData.id,
            sellType = tonumber(itemData.type),
            price = tonumber(itemData.price),
            name = cfg.itemName,
            count = tonumber(itemData.num),
            itemCfg = cfg
        })
end

function CoinData:getSellIcon(sellType)
    if sellType == 15 then  -- 黄金碎片
        return "CoinGold.png"
    end
end

-- 永久指针数量
function CoinData:getRecordCount()
    if ItemData:getItemWithId("12103") then
        self.recordCounts = ItemData:getItemWithId("12103").count
        return self.recordCounts
    end
    return 0
end

-- 可分解物品
function CoinData:getDecomposeItems()
    self.decomposeItems = {}
    local item = ItemData:getItemWithType(0)
    for i,v in ipairs(item) do
        if v.type ~= 16 and v.seal > 0 then
            table.insert(self.decomposeItems, v)
        end
    end
    return self.decomposeItems
end

-- 更新航行冷却时间
function CoinData:update( data )
    if data == 0 then
        self.nextCoinTimeStamp = UserData.curServerTime
    else
        self.nextCoinTimeStamp = data + self.freeCoinTime
    end
end

function CoinData:hasFreeTrip()
    local openLevel = GameConfig["CoinInfo"]["1"].OpenLeve
    if UserData:getUserLevel() >= openLevel then
        if self.nextCoinTimeStamp <= UserData.curServerTime or self:getRecordCount() > 0 then
            return true
        end
    end
	return false
end

-- 更新航行结果
function CoinData:updateResultData(result)
    self.coinResult = {}
    self.heroId = {}
    for i,v in ipairs(result) do
    	self.heroId[i] = 0
    	local item = "nil"
    	if v.param4 == 6 then
    		local heroId = tostring(v.param1)
    		local hero = HeroListData:getRoleWithId_(heroId)
    		self.heroId[i] = heroId
    		if hero then
    			local itemId = hero.stoneId
    			local count = hero.exchangeStoneNum
    			ItemData:addMultopleItem(itemId, count)

    			local param = {itemId = itemId, count = count}
    			item = GameItem.new(param)
    		else
    			HeroListData:activateHeroWithId(heroId)
    		end
    	else
    		local itemId = tostring(v.param1)
    		local config = GameConfig.item[itemId]

    		if config.Type == 2 then
    			local param = {itemId = itemId, count = v.param2}
    			ItemData:superimposeEquip(param)
    		else
    			local param = {itemId = itemId, count = v.param3}
    			ItemData:addMultipleItem(itemId, v.param3)
    			item = GameItem.new(param)
    		end
    	end
    	table.insert(self.coinResult, item)
    end
end

return CoinData
