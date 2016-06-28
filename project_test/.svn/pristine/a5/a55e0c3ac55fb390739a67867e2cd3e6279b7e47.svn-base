local DianJinRequestResponse = class("DianJinRequestResponse")
function DianJinRequestResponse:DianJinRequestResponse(data)
	if data.result == 1 then 
		-- 请求点金 成功
		
		local data2 = GoldAlert 
		data2.times = tonumber(data.param1) 		-- 购买次数
		data2.gold  = tonumber(data.gold) 		-- 点金获得金币
		data2.gems 	= tonumber(data.diamond) 	-- 点金花费钻石
		data2.timesMax 	= tonumber(data.param2) 	-- 购买最大次数

			
	end 

end
function DianJinRequestResponse:ctor()
	--响应消息号
	self.order = 10007
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

return DianJinRequestResponse