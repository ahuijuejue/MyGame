local SaveAincradBattleResultResponse = class("SaveAincradBattleResultResponse")

function SaveAincradBattleResultResponse:ctor()
	--响应消息号
	self.order = 20019
	--返回结果,1 成功;
	self.result =  ""
	--胜负：1 胜，0 负
	self.param1 =  ""	
end

function SaveAincradBattleResultResponse:SaveAincradBattleResultResponse(data)
	if data.result == 1 then 
		local ok = checknumber(data.param1) == 1 -- 是否胜利
		AincradData.isBattleOk = ok 

		AincradData:addCurrentScore(checknumber(data.param5))
		AincradData:addCurrentStar(checknumber(data.param4))
		AincradData:setMaxScoreIf(AincradData:getCurrentScore())

		-- 完成任务 
		TaskData:addTaskParams("aincrad", 1) 
		
		if ok then 
			AincradData:setOldFloorIf(AincradData:getFloor()) 	-- 历史最高层数
			
			-- 完成活动
			ActivityUtil.addParams("aincradLevel", 1)
		end 

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return SaveAincradBattleResultResponse