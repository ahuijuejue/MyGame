local FlopModel = class("FlopModel")

function FlopModel:ctor()
	self.price     = 100
	self.freshCost = 100
	self.useTimes  = 0
	self.costMoney = 0
	self.closeTime = 0
	--获得物品数据
	self.getItems  = {}
	--全部开启必获得物品数据
	self.hopeItems = {}
	--已开启位置
	self.poses     = {}
	--剩余翻牌位置
	self.leftPos   = {}
	self.iconImage = "flip_icon.png"
	self.bgImage   = "board_flip_Huke.png"

	self.rankData  = {}		  -- 排名信息
	self.rankRewardData = {}  -- 排名奖励
	self.rankNum   = 0        -- User排名
    self.flopTimes = 0        -- User次数
end

function FlopModel:addRankData(param)
	table.insert(self.rankData, {
		rankNum = param.param,
		name    = param.param,
		flopTimes = param.param
		})
end

function FlopModel:addRewardData(param)
	table.insert(self.rankRewardData, {
		rankNum = param.param,
		rewardItems = param.param
		})
end

function FlopModel:setCostMoney(costMoney)
	self.costMoney = costMoney
end

function FlopModel:setUseTimes(times)
	self.useTimes = times
end

function FlopModel:setLeftPos(poses)
	self.leftPos = {}
	local len = math.min(#poses,self:getLeftTimes())
	for i=1,len do
		self.leftPos[i] = poses[i]
	end
end

function FlopModel:insertPos(pos)
	table.insert(self.poses,pos)
end

function FlopModel:insertGetItem(key,value)
	self.getItems[key] = value
end

function FlopModel:getNowMoney()
	local nowMoney = math.mod(self.costMoney,self.price)
	return nowMoney
end

function FlopModel:getNeedMoney()
	local needMoney = self.price - self:getNowMoney()
	return needMoney
end

function FlopModel:getLeftTimes()
	local times = math.floor(self.costMoney/self.price) - self.useTimes
	return times
end

function FlopModel:getLeftPos()
	local leftPos = {}
	for i=1,10 do
		local isLeft = true
		for j,v in ipairs(self.poses) do
			if tostring(i) == v then
				isLeft = false
				break
			end
		end
		if isLeft then
			table.insert(leftPos,tostring(i))
		end
	end
	return leftPos
end

function FlopModel:isCanFlop()
	if self:getLeftTimes() > 0 then
		return true
	end
	return false
end

function FlopModel:update(data)
	self:setCostMoney(data.param3)
	self:setUseTimes(data.param2)
	self.hopeItems = data.a_param1
	self.closeTime = data.param5
	self.iconImage = data.param10
	self.bgImage = data.param11
	if data.param4 then
		self.poses = string.split(data.param4,",")
	end
	for i,v in ipairs(data.a_param2) do
		local key = self.poses[i]
		self.getItems[key] = v
	end
end

function FlopModel:isOpen()
	if UserData.curServerTime < self.closeTime then
		return true
	end
	return false
end

function FlopModel:clean()
	self.useTimes = 0
	self.costMoney = 0
	self.closeTime = 0
	self.getItems = {}
	self.hopeItems = {}
	self.poses = {}
	self.leftPos = {}
	self.iconImage = "flip_icon.png"
	self.bgImage = "board_flip_Huke.png"
end

return FlopModel