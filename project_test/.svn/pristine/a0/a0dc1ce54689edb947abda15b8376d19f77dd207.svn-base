local SelectAincradOppnentListResponse = class("SelectAincradOppnentListResponse")
function SelectAincradOppnentListResponse:SelectAincradOppnentListResponse(data)
	if data.result == 1 then 
		
		--------------------------------------		
		-- 挑战对手 
		AincradData:resetTeams()
		
		for k,v in pairs(data.a_param1) do 			
			local team = PlayerData.parseArenaTeam(v)
			team:sortRoleByLevel(true)
			AincradData:addTeam(team)
			team.index = tonumber(v.enemyLevel) or 1 -- 人物难度			
		end 
		local nTeam = table.nums(AincradData.teams) 
		if nTeam == 1 then 	-- 只有一个， 是为已经选中(已经选择过)
			AincradData.selectedTeam = AincradData.teams[1]
			AincradData:resetTeams()
		else 
			AincradData.selectedTeam = nil 
		end 
		AincradData:sortTeams()

		--------------------------------------
		-- 战斗中数据 
		if data.param1 and string.len(data.param1) > 0 then 
			AincradData:resetHeros()
			local info = json.decode(data.param1) 

			for k,v in pairs(info.left) do				
				AincradData:setOldHero(v.roleId, v.hp, v.anger)
			end 

			if not info.success then 	-- 失败时，读取对手状态 
				for i,v in ipairs(info.right) do
					local hero = AincradData.selectedTeam:getRole(v.roleId) 
					hero.hp = v.hp 
					hero.anger = v.anger
				end 
			end 
		end 

	end 
end
function SelectAincradOppnentListResponse:ctor()
	--响应消息号
	self.order = 20018
	--返回结果,1 成功; 
	self.result =  ""
	--挑战对手
	self.a_param1 =  ""	
end

return SelectAincradOppnentListResponse