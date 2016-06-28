local SlotModel = class("SlotModel")

function SlotModel:ctor()
	self.pos       = 0
	self.times     = 0
	self.closeTime = 0
	self.itemsData = {}
	self.itemsGet  = {}
	self.price1    = 200
	self.price2    = 900
	self.gold      = 10000
	self.scale     = {0.5,0.6,0.7,0.8,0.9}
	self.iconImage = "tiger_icon_akame.png"
	self.bgImage   = "Tiger_Board_akame.png"

    self.rankData  = {}       -- 排名信息
    self.rankRewardData = {}  -- 排名奖励
    self.rankNum   = 0        -- User排名
    self.slotTimes = 0        -- User次数
end

function SlotModel:addRankData(param)
	table.insert(self.rankData, {
		rankNum = param.param,
		name    = param.param,
		slotTimes = param.param
		})
end

function SlotModel:addRewardData(param)
	table.insert(self.rankRewardData, {
		rankNum = param.param,
		rewardItems = param.param
		})
end


function SlotModel:update(data)
	self.times = data.param2
	self.itemsData = data.a_param1
	self.closeTime = data.param5
	self.iconImage = data.param10
	self.bgImage = data.param11
end

function SlotModel:getCost(type_)
	if type_ == 1 then
		local scale = 1
		if self.times < 5 then
			scale = self.scale[self.times+1]
		end
		local cost = self.price1 * scale
		return cost
	else
		return self.price2
	end
end

function SlotModel:getGold(type_)
	if type_ == 1 then
		return self.gold
	else
		return self.gold * 5
	end
end

function SlotModel:isCanSlot()
	if UserData.diamond < self:getCost() then
		return false
	end
	return true
end

function SlotModel:isOpen()
	if UserData.curServerTime < self.closeTime then
		return true
	end
	return false
end

function SlotModel:clean()
	self.pos = 0
	self.times = 0
	self.closeTime = 0
	self.itemsData = {}
	self.itemsGet = {}
	self.iconImage = "tiger_icon_akame.png"
	self.bgImage = "Tiger_Board_akame.png"
end

return SlotModel
