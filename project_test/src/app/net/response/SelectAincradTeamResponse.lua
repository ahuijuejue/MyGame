local SelectAincradTeamResponse = class("SelectAincradTeamResponse")
function SelectAincradTeamResponse:SelectAincradTeamResponse(data)
	if data.result == 1 then 
		local teamId = data.param1 		
		for i,v in ipairs(AincradData.teams) do
			if teamId == v.teamId then 
				AincradData.selectedTeam = v 
				break 
			end 
		end

		------------------------------
		-- 层级状态	 		

		if AincradData.isGetReward then 
			AincradData:addFloor(1) 			-- 当前第几层			
			AincradData:addTotalFloor(1) 		-- 通关总层数
			AincradData.isBattleOk 		= false -- 是否挑战成功 
			AincradData.isGetReward 	= false -- 是否已经领取奖励 
			AincradData.awardTimes 		= 0 	-- 茅场晶彦 抽奖次数 
			
			AincradData:resetTeams() 	-- 预选敌人队伍数组 		
			AincradData:resetWillReward()
			AincradData:resetWillBuff()
		end 

		------------------------------
	end 

end
function SelectAincradTeamResponse:ctor()
	--响应消息号
	self.order = 20012
	--返回结果,1 成功;
	self.result =  ""
	--对手teamid
	self.param1 =  ""	
end

return SelectAincradTeamResponse