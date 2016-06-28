--[[
购买 金币 宝石 等 的 数据
]]
local BuyData = class("BuyData")

function BuyData:ctor()
	self.gold = {
		times 	= 0, 		-- 购买金币次数	
		gems 	= 0, 		-- 消耗宝石
		gold 	= 0, 		-- 获得金币
		timesMax = 0, 		-- 购买最大次数
	}

	self.power = {
		times 	= 0, 		-- 购买体力次数	
		gems 	= 0, 		-- 消耗宝石
		power 	= 0, 		-- 获得体力
		timesMax = 0, 		-- 购买最大次数
	}
	
	self.elit = {
		id 		= "", 		-- 关卡id
		times 	= 0, 		-- 购买精英关卡次数 
		gems 	= 0, 		-- 消耗宝石
		elit 	= 0, 		-- 获得精英关卡次数	
	}
			

end
---------------------------------------
-- 购买金币
function BuyData:goldData() 			-- 购买金币次数
	return self.gold 
end 

function BuyData:goldTimesMax() 		-- 购买金币次数 上限
	return self.gold.timesMax 
end 

function BuyData:isGoldMax()
	return self.gold.times >= self:goldTimesMax()
end

---------------------------------------
-- 购买体力
function BuyData:powerData() 			-- 购买体力次数
	return self.power 
end 

function BuyData:powerTimesMax() 		-- 购买体力次数 上限
	return self.power.timesMax
end 

function BuyData:isPowerMax()
	return self.power.times >= self:powerTimesMax()
end

--------------------------------------

return BuyData 


