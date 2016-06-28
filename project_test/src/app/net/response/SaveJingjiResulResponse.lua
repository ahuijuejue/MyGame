local SaveJingjiResulResponse = class("SaveJingjiResulResponse")
function SaveJingjiResulResponse:SaveJingjiResulResponse(data)
	if data.result == 1 then 
		local arenaScore 	= checknumber(data.param2) 		-- 拥有竞技积分 
		local win 			= checknumber(data.param1) == 1	-- 战斗结果 
		local diamond 		= checknumber(data.param5) 		-- 获得宝石 
		local rank 			= checknumber(data.param4) 		-- 排名 
		local rankOld 		= checknumber(data.param3) 		-- 历史最高排名 
		local addScore 	 	= checknumber(data.param6) 		-- 获得竞技场积分
		UserData:setArenaScore(arenaScore)

		-- 活动数据
		ActivityUtil.addParams("arenaScore", addScore)		
		ActivityUtil.addParams("arenaBattle", 1)
		if win then 
			ActivityUtil.addParams("arenaWin", 1)
		end 

		-- 战斗力
		local battle = checknumber(data.param2) 
		ArenaData.battle = battle
		
		if win then 		
			ArenaData.rank = rank 			-- 当前排名变动
			ArenaData.rankMax = rankOld 	-- 历史最高排名变动
			if diamond > 0 then 
				UserData.haveMail = true
			end 			
		end 
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function SaveJingjiResulResponse:ctor()
	--响应消息号
	self.order = 10059
	--返回结果,1 成功;
	self.result =  ""
	--当前竞技场积分
	self.param2 =  ""
	--比赛结果
	self.param1 =  ""	
end

return SaveJingjiResulResponse