local RefreshOppnentListResponse = class("RefreshOppnentListResponse")
function RefreshOppnentListResponse:RefreshOppnentListResponse(data)
	if data.result == 1 then 
		-- 被挑战方
		
		ArenaData:resetTeamList()
		for k,v in pairs(data.a_param1 or {}) do 			
			local team = PlayerData.parseArenaTeam(v)		
			ArenaData:addTeam(team)
		end 
		ArenaData:sortTeamList()
		
	elseif data.result == -1 then  -- 冷却时间内不能刷新
		showToast({text="冷却时间内不能刷新"})
	end 
end
function RefreshOppnentListResponse:ctor()
	--响应消息号
	self.order = 10058
	--返回结果,1 成功; -1 冷却时间内不能刷新
	self.result =  ""
	--挑战对手
	self.a_param1 =  ""	
end

return RefreshOppnentListResponse