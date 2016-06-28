-- 1、hp
-- 2、atk
-- 3、m_atk
-- 4、defense
-- 5、m_defense
-- 6、acp 物理破防
-- 7、m_acp 魔法破防
-- 8、rate 命中
-- 9、dodge 闪避
-- 10、crit 暴击
-- 11、blood 吸血
-- 12、breaks 打断
-- 13、tumble 击退

local GameItem = import(".GameItem")
local GameEquip = class("GameEquip",GameItem)

function GameEquip:ctor(param)
	GameEquip.super.ctor(self,param)
	self.uniqueId = {}
	self.count = 0
	if param.id then
		self:addSameEquip(param.id)
	end
	self.equipType = self.content.GearType --是否专属
	self.levelLimit = self.content.LevelLimit --装备上限等级
	self.needItem = self.content.NeedItemID --合成材料
	self.needCount = self.content.NeedItemNum --所需材料数量
	self.targetItem = self.content.ForItemID --进阶id
	self.ratio = self.content.CosnumeRatio --强化费用系数
	self.star = param.star or 0 --装备加护等级
	self.types = self.content.Types
	self.basicValues = self.content.Values
	self.upgrades = self.content.Upgrades
	self.strLevel = tonumber(param.level) or 0 --装备强化等级
	self.power = self:getPower() --装备战斗力
	self.abilitys = {}
	self:setEquipAbility()
end

function GameEquip:getPower()
	local power = (80+(self.strLevel-1)*8)*(1+(self.configQuality-1)*0.2)*(1+0.1*self.star)
	return math.floor(power)
end

--装备等级是否达到上限
function GameEquip:isLimit()
	if self.strLevel >= self.levelLimit then
		return true
	end
	return false
end

function GameEquip:upEquipLevel(lv)
	self.strLevel = math.min(self.strLevel + lv,self.levelLimit) 
	self.power = self:getPower()
	self:setEquipAbility()
end

function GameEquip:upEquipStar(lv)
	self.star = math.min(self.star + lv, 5)
	self.power = self:getPower()
	self:setEquipAbility()
end

function GameEquip:setEquipAbility()
	for i=1,#self.types do
		self.abilitys[i] = (self.strLevel * self.upgrades[i] + self.basicValues[i]) * (1+0.1*self.star)
	end
end

--装备强化消耗
function GameEquip:getUpTimes(heroLv)
	local maxLevel = math.min(self.levelLimit,heroLv)
	local realLevel = math.min(self.strLevel+10,maxLevel)
	local times = math.max(realLevel - self.strLevel,0) 
	return times
end

function GameEquip:oneCost(heroLv)
	local consumeInfo = GameConfig.consume[tostring(self.strLevel+1)]
	local cost = consumeInfo.GearConsume * self.ratio
	local maxLevel = math.min(self.levelLimit,heroLv)
	if self.strLevel >= maxLevel then
		cost = 0
	end
	return cost
end

--多次强化消耗
function GameEquip:moreCost(heroLv)
	local count = self:getUpTimes(heroLv)
	local cost = 0
	for i=1,count do
		local consumeInfo = GameConfig.consume[tostring(self.strLevel+i)]
		cost = consumeInfo.GearConsume + cost
	end
	return cost*self.ratio
end

--叠加相同装备的uid
function GameEquip:addSameEquip(uId)
	table.insert(self.uniqueId,uId)
	self.count = #self.uniqueId
end

--移除相同装备的uid
function GameEquip:removeSameEquip(uId)
	local index = table.indexof(self.uniqueId,uId)
	table.remove(self.uniqueId,index)
	
	self.count = #self.uniqueId
end

--获取last uid
function GameEquip:getLastUid()
	return self.uniqueId[self.count]
end

return GameEquip