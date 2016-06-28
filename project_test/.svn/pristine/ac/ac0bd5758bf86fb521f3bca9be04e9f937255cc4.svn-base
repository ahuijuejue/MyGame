--
-- Author: zsp
-- Date: 2015-03-31 19:01:51
--

local DropManager = class("DropManager")

--[[
	关卡掉落管理，
	具体可逻辑参考关卡掉落文档
--]]
function DropManager:ctor(waveTotal,goldValue,item)

	self.goldValue = goldValue
	self.goldNum =  10 --份

	if self.goldValue == 0 then
		self.goldNum = 0
	end

	self.itemNum = 0
	
	for k,v in pairs(item) do
		self.itemNum = self.itemNum + v
	end

	self.waveTotal = waveTotal
	
	self:allocDrop()

 	-- 10个金币表现）
	-- 1波 情况 
	--  有boss 爆 
	--  无boos 最后小兵

	--  2波
	--   第一波 最后死得爆 （金币4份,有箱子就爆一个）
	--   第二波 同波1规则  （金币6分，箱子爆2个）

	--  有3波和三波以上
	--   前一半（下取整）的波数 有随机一波的小兵 最后死得小兵爆两份金币 ，箱子1份
	--   后一半-1（下取整）的波数 有随机一波的小兵 最后死得小兵爆三份金币 ，箱子1份
	--   最后一波规则同波1 （金币5，箱子爆2个）
end

function DropManager:onDrop(wave,dead)

	--进入当前波 并没掉落过
	if self.dropData[wave] then
		return self.dropData[wave]
	end

	return nil
end

--[[
	分配掉落数据
--]]
function DropManager:allocDrop()
	--按波数初始化分配数据
	self.dropData = {}
	for i = 1, self.waveTotal do
		self.dropData[i] = {
			["goldNum"]   = 0,
			["goldValue"] = 0,
			["itemNum"]   = 0
		}
	end 

	if self.waveTotal == 1 then

		self.dropData[1].goldNum   = self.goldNum
		self.dropData[1].goldValue = self.goldValue
		self.dropData[1].itemNum   = self.itemNum

	elseif self.waveTotal == 2 then
		
		self.dropData[1].goldNum   = math.floor(self.goldNum * 0.5)
		self.dropData[1].goldValue = math.floor(self.goldValue * 0.5)
		self.dropData[1].itemNum   = math.floor(self.itemNum * 0.5)

		self.dropData[2].goldNum   = math.ceil(self.goldNum * 0.5)
		self.dropData[2].goldValue = math.ceil(self.goldValue * 0.5)
		self.dropData[2].itemNum   = math.ceil(self.itemNum * 0.5)

	elseif self.waveTotal > 2 then
		--todo
		newrandomseed()
		self.firstWave  = math.random(1,math.floor(self.waveTotal * 0.5))
		newrandomseed()
		self.secondWave = math.random(math.floor(self.waveTotal * 0.5) + 1,self.waveTotal - 1)
		self.lastWave   = self.waveTotal
		
		-- function test(num)
		-- {
		-- 	var t = num - Math.floor(num * 0.25) - Math.floor(num * 0.25) - Math.ceil(num * 0.5);
		-- 	console.log("1波：" + Math.floor(num * 0.25) +"\n2波：" + Math.floor(num * 0.25) + "\n3波：" + Math.ceil(num * 0.5)+"\n剩余："+t);
		-- }

		local mod = self.itemNum - math.floor(self.itemNum * 0.25) - math.floor(self.itemNum * 0.25) - math.ceil(self.itemNum * 0.5)

		self.dropData[self.firstWave].goldNum   = math.floor(self.goldNum * 0.25)
		self.dropData[self.firstWave].goldValue = math.floor(self.goldValue * 0.25)
		self.dropData[self.firstWave].itemNum   = math.floor(self.itemNum * 0.25)

		self.dropData[self.secondWave].goldNum   = math.floor(self.goldNum * 0.25)
		self.dropData[self.secondWave].goldValue = math.floor(self.goldValue * 0.25)
		self.dropData[self.secondWave].itemNum   = math.floor(self.itemNum * 0.25) + mod

		self.dropData[self.lastWave].goldNum   = math.ceil(self.goldNum * 0.5)
		self.dropData[self.lastWave].goldValue = math.ceil(self.goldValue * 0.5)
		self.dropData[self.lastWave].itemNum   = math.ceil(self.itemNum * 0.5)

	end
	
	printInfo("关卡掉落：===========关卡波数：%d 金币数：%d，宝箱数：%d",self.waveTotal,self.goldValue,self.itemNum)
	--dump(self.dropData,"掉落分配")

end

return DropManager