local BuyBattleTimesResponse = class("BuyBattleTimesResponse")
function BuyBattleTimesResponse:BuyBattleTimesResponse(data)
	if data.result == 1 then 
		local data2 	= 	ElitAlert 
		local stageId 	=  	data2.id 
		local elitTimes =  	data2.elitTimes 
		local gems 		= 	data2.gems 
		local stageData = ChapterData:getStage(stageId)
		local addElit = stageData.passLimit

		stageData.passNum = stageData.passNum - addElit 	-- 增加精英关卡次数	
		UserData:addDiamond(-gems) 		-- 消耗宝石
		
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	elseif data.result == -1 then 
		print("钻石不足")
		ResponseEvent.lackGems()		
	end 

end
function BuyBattleTimesResponse:ctor()
	--响应消息号
	self.order = 20006
	--返回结果,1 成功;-1 钻石不足
	self.result =  ""	
end

return BuyBattleTimesResponse