--[[
签到数据
]]

local SignInData = class("SignInData")
local GameSignIn = import(".GameSignIn")
local GameSignInTotal = import(".GameSignInTotal")
local GameSignInSeven = import(".GameSignInSeven")
local GameSignInVip = import(".GameSignInVip")

function SignInData:ctor()

----------------------------------------
-- 配置数据
	-- 月签到奖励
	self.dict = {}
	self.arr  = {}
	-- 每日签到
	local cfg = GameConfig["Register"]
	for k,v in pairs(cfg) do
		local data = GameSignIn.new({
			id = k,
			cfg = v,
		})
		if not self.arr[data.month] then
			self.arr[data.month] = {}
		end
		self.dict[k] = data
		table.insert(self.arr[data.month], data)
	end

	for k,v in pairs(self.arr) do
		table.sort(v, function(a, b)
			return checknumber(a.id) < checknumber(b.id)
		end)
	end

	-- 累计签到奖励
	self.dictTotal = {}
	self.arrTotal  = {}

	local cfgTotal = GameConfig["RegisterTotal"]
	for k,v in pairs(cfgTotal) do
		local data = GameSignInTotal.new({
			id = k,
			cfg = v,
		})

		self.dictTotal[k] = data
		table.insert(self.arrTotal, data)
	end

	table.sort(self.arrTotal, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)

	-- 七日签到奖励
	self.dictSeven = {}
	self.arrSeven  = {}

	local cfgSeven = GameConfig["RegisterSeven"]
	for k,v in pairs(cfgSeven) do
		local data = GameSignInSeven.new({
			id = k,
			cfg = v,
		})

		self.dictSeven[k] = data
		table.insert(self.arrSeven, data)
	end

	table.sort(self.arrSeven, function(a, b)
		return a.totalNum < b.totalNum
	end)

	-- 至尊签到奖励
	self.dictVip = {}
	self.arrVip = {}

	local cfgSeven = GameConfig["RegisterVip"]
	for k,v in pairs(cfgSeven) do
		local data = GameSignInVip.new({
			id = k,
			cfg = v,
		})

		self.dictVip[k] = data
		table.insert(self.arrVip, data)
	end

	table.sort(self.arrVip, function(a, b)
		return a.totalNum < b.totalNum
	end)

----------------------------------------
-- 存储数据

	self.latestId 	 	= "" 			-- 最近的签到id
	self.latestDate 	= 0 			-- 最近的签到时间
	self.signVip 		= false 		-- 是否进行了vip签到

	self.totalSignIn 	= 0 			-- 累计签到总次数
	self.latestReward 	= "" 			-- 最后一次领取的累积奖励id

	self.sevenCount 	= 0 	        -- 七日签到 次数
	self.sevenDate 	    = 0 		    -- 七日签到 最近的签到时间

    self.viplatestId    = 0             -- 至尊签到 最近的签到id
    self.vipIsReward    = 0             -- 至尊签到 是否可以领取礼包 0充值 1领取 2领过
	self.vipCount       = 0             -- 至尊签到 次数

end

-- 获取对应日期奖励
function SignInData:getDailyData(dateId)
	return self.dict[dateId]
end

-- 获取当月第几天奖励
function SignInData:getReward(index)
	local date = self:getServerDate()
	month = date.month
	return self.arr[month][index]
end

-- 每日奖励列表
--@param month type string 月份
function SignInData:getDailyList(month)
	if month == nil then
		local date = self:getServerDate()
		month = date.month
	end
	month = tostring(month)
	return self.arr[month] or {}
end

-- 获取图标名, 数量
--[[
{icon="", count=1,border=""}
图标，数量，边框
]]
function SignInData:getShowInfo(data)
	if type(data) == "string" then
		data = self:getDailyData(data)
	end
	local info = {}
	if data then
		if data.itemId then
			-- print("id:", data.itemId)
			-- local item = ItemData:getItemConfig(data.itemId)
			-- info.icon = item.imageName
			-- info.border = UserData:getItemBorder(item)
			info.itemId = data.itemId
			info.count = data.itemNum

		elseif data.heroId then
			info.heroId = data.heroId
			-- info.icon = UserData:getHeroIcon(data.heroId)
			-- info.border = UserData:getHeroBorder(data.heroId)
			info.count = 1
		end
		info.vip = data.vip
		info.vipMult = data.vipMult
	end
	return info
end

--------------------------------------------
-- 累计签到
-- 累计签到显示物品列表
function SignInData:getShowTotalInfo()
	local isok = false
	local count = 0
	for i,v in ipairs(self.arrTotal) do
		if isok then
			return v
		else
			if self.latestReward == v.id then
				isok = true
			end
		end
		count = count + 1
	end
	if isok then 	-- 已经累计签到最后一条
		local num = self.totalSignIn - count + 1
		num = num * 10 	-- 增加累计次数
		local info = self.arrTotal[count]
		info = clone(info)
		info.totalNum = info.totalNum + num
		return info
	else 	-- 未找到，返回第一条
		return self.arrTotal[1]
	end
end

-----------------------------------------------
--@param sec 时间 秒

-- 签到用的日期
function SignInData:getDate(sec)
	sec = sec - 18000
	sec = math.max(sec, 0)
	return os.date("*t", sec)
end

function SignInData:getServerDate()
	local sec = UserData:getServerSecond() 	-- 当前时间
	return self:getDate(sec) 	-- 转换成签到用日期
end

-- 本月签到次数
function SignInData:getMonthSignCount()
	local date = self:getServerDate()
	local signDate = self:getDate(self.latestDate)

	if date.year ~= signDate.year or date.month ~= signDate.month then -- 不在同一个月
		return 0
	end

	for i,v in ipairs(self:getDailyList(date.month)) do
		if v.id == self.latestId then
			return i
		end
	end

	return 0
end

-- 今天是否是 每日签到记录的最后一天
function SignInData:isSigned()
	local date = self:getServerDate()
	local signDate = self:getDate(self.latestDate)

	if date.yday ~= signDate.yday then
		return false
	end

	return true
end

----------------------------------------

-- 今天是否进行了七日签到
function SignInData:isSevenSigned()
	local date = self:getServerDate()
	local signDate = self:getDate(self.sevenDate)

	if date.yday ~= signDate.yday then
		return false
	end

	if date.year ~= signDate.year then
		return false
	end

	return true
end

-- 七日签到次数
function SignInData:getSevenCount()
	return self.sevenCount
end

-- 七日签到是否结束
function SignInData:isSevenCompleted()
	local count = self:getSevenCount()
	local total = table.nums(self.arrSeven)

	return count >= total
end

-- 七日签到 奖励数据
function SignInData:getSevenList()
	return self.arrSeven
end

function SignInData:isSevenOver()
	return self:getSevenCount() >= 7
end
----------------------------------------

--充值至尊签到显示列表
function SignInData:resetSignInVip()
	self.viplatestId  = 0
    self.vipIsRewards  = false
end

-- 至尊签到 奖励数据
function SignInData:getVipList()
	return self.arrVip
end

-- 至尊签到次数
function SignInData:getVipCount()
	self.vipCount = tonumber(self.viplatestId)
	return self.vipCount
end

-- 今天是否进行了至尊签到
function SignInData:isVipSigned()

	if self.vipIsReward == 2 then
		return true
	end
	return false
end

return SignInData
