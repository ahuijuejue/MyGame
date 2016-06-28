local GetBuyBattleTimeCostResponse = class("GetBuyBattleTimeCostResponse")
function GetBuyBattleTimeCostResponse:GetBuyBattleTimeCostResponse(data)
	if data.result == 1 then 
		-- 成功	
				
		local times = tonumber(data.param1)
		local gems 	= tonumber(data.param2)
		
		local data2 = ElitAlert 
		data2.times = times 		-- 购买次数
		data2.gems 	= gems 			-- 花费宝石

		local stageData = ChapterData:getStage(data2.id)
		data2.elitTimes = tonumber(stageData.passLimit) -- 购买精英点数

				
	end 

end
function GetBuyBattleTimeCostResponse:ctor()
	--响应消息号
	self.order = 20007
	--返回结果,1 成功;
	self.result =  ""
	--今日已购买的次数
	self.param1 =  ""
	--下次购买的钻石花费
	self.param2 =  ""	
end

return GetBuyBattleTimeCostResponse