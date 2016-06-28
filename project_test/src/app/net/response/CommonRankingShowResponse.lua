local CommonRankingShowResponse = class("CommonRankingShowResponse")
function CommonRankingShowResponse:CommonRankingShowResponse(data)
	if data.result == 1 then
		local rank		= checknumber(data.param2) 	-- 竞技场名次
		local rankMax 	= checknumber(data.param3) 	-- 竞技场历史最高排名
		local list 		= data.a_param1 			-- 排名列表
		local rankType 	= RankData:getRankTypeName(data.param1) -- 排行榜类型

		-- 解析排名列表
		RankData:resetRank(rankType)
		for i,v in ipairs(list) do
			local team = RankData:createTeam({
				teamId  = v.teamid,
				rank 	= v.ranking,
				level 	= v.level,
				name 	= v.name,
				score 	= v.score,
				icon 	= v.headSrc,
				userId  = v.userid,
			})
			RankData:addRankTeam(team, rankType)
		end
		RankData:setRankValue(rankType, rank, rankMax)

	elseif data.result == -1 then
		showToast({text="排行榜没有数据"})
	end

end
function CommonRankingShowResponse:ctor()
	--响应消息号
	self.order = 20033
	--返回结果,1 成功,-1排行榜没有数据
	self.result =  ""
	--排行榜类型：1:竞技场排行榜2：艾恩排行榜，3：战力排行榜，4：战队等级，5：关卡得星
	self.param1 =  ""
	--我的排名
	self.param2 =  ""
	--历史排名
	self.param3 =  ""
	--战队信息
	self.a_param1 =  ""
end

return CommonRankingShowResponse
