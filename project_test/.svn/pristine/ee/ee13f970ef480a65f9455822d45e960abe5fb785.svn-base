local ArenaInfoResponse = class("ArenaInfoResponse")
function ArenaInfoResponse:ArenaInfoResponse(data)
	if data.result == 1 then 
		-- 竞技场主界面 
		ArenaData.rank 		= checknumber(data.ranking) -- 竞技场排名 
		ArenaData.rankMax 	= checknumber(data.param7) 	-- 竞技场历史最高排名 
		ArenaData:setCoolTime(checknumber(data.param1)) -- 冷却时间 秒 
		ArenaData.times 	= checknumber(data.param2) 	-- 剩余挑战次数 
		ArenaData.refreshCost 	= checknumber(data.param3) 		-- 刷新冷却时间花费宝石 
		ArenaData.timesCost 	= checknumber(data.param5) 		-- 购买剩余挑战次数花费 
		ArenaData.battle 	= checknumber(data.param8) 	-- 战斗力 
		local idstr = data.param6 		-- 防守阵型 
		if idstr then 
			if string.sub(idstr, -1, -1) == "," then 
				idstr = string.sub(idstr, 1, -2)
			end 
			local arrid = string.split(idstr, ",") 
			-- 保存防守阵型 
			UserData:setArenaDefenseList(arrid) 
		else 
			local arrid = {CreateInfoData.heroId}
			-- 保存防守阵型 
			UserData:setArenaDefenseList(arrid) 
		end 

		-- 被挑战方
		ArenaData:resetTeamList()
		for k,v in pairs(data.a_param1 or {}) do 			
			local team = PlayerData.parseArenaTeam(v)
			ArenaData:addTeam(team)
		end 
		ArenaData:sortTeamList() 
	end 
end
function ArenaInfoResponse:ctor()
	--响应消息号
	self.order = 10052
	--返回结果,1 成功;
	self.result =  ""
	--玩家排名
	self.rank =  ""
	--挑战剩余次数
	self.times =  ""
	--全部恢复满需要时间秒数
	self.coolTime =  ""
	--挑战对手
	self.a_param1 =  ""	
end

return ArenaInfoResponse