local BuyPowerRequestResponse = class("BuyPowerRequestResponse")
function BuyPowerRequestResponse:BuyPowerRequestResponse(data)
	if data.result == 1 then 
		-- 请求购买体力 成功	
		
		local data2 = PowerAlert 
		data2.gems = tonumber(data.diamond) -- 花费的钻石
		data2.power =  tonumber(data.gold) -- 获得的体力
		data2.times = tonumber(data.param1) -- 已经购买体力次数
		data2.timesMax = tonumber(data.param2) -- 购买体力最大次数
						
	end 

end
function BuyPowerRequestResponse:ctor()
	--响应消息号
	self.order = 10009
	--返回结果,如果成功才会返回下面的参数：1 成功,2 钻石不足
	self.result =  ""
	--已使用过的次数
	self.param1 =  ""
	--最大次数
	self.param2 =  ""
	--花费的钻石
	self.diamond =  ""
	--获得的金币
	self.gold =  ""
end

return BuyPowerRequestResponse