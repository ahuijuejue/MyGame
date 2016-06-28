--[[
世界观之战
开场战斗 剧情

]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if GuideData:isNotCompleted("Firstbattle") then 
        GuideData:setCompleted("Firstbattle", function()			
			self:enterGuide()
		end)
       	return true 
    end 
	return false
end

function GuideClass:enterGuide()	
	local dict = GameConfig["new_war2"] 
	local characterInfo = GameConfig["character"]
	local member1 = {} 
	local member2 = {} 
	for k,v in pairs(dict) do
		local params = {
			heroID 	= v.id,
			lv 	= v.lv, 
			sort = checknumber(v.position)
		}
		local character = characterInfo[params.heroID]
		local skills = {}
		table.insert(skills, {
			param2 = character.skill1, 	-- key 
			param1 = v.skill__lv, 		-- value
		})
		table.insert(skills, {
			param2 = character.skill2, 	-- key 
			param1 = v.skill_2_lv, 		-- value
		})		
		table.insert(skills, {
			param2 = character.skill3, 	-- key 
			param1 = v.skill_3_lv, 		-- value
		})
		table.insert(skills, {
			param2 = character.skill4, 	-- key 
			param1 = v.skill_4_lv, 		-- value
		})
		params.skills = skills

		if v.camp == "1" then 
			table.insert(member1, params)
		elseif v.camp == "2" then 
			table.insert(member2, params)
		end 
	end

	table.sort(member1, function(a, b)
		return a.sort < b.sort
	end)

	table.sort(member2, function(a, b)
		return a.sort < b.sort
	end)

	local team1 = ArenaTeam.new({}) 
	local team2 = ArenaTeam.new({}) 
	
	self:parseTeam(team1, member1) 
	self:parseTeam(team2, member2) 

	local team1List = {
		team1={},
		team2={}
	}
	for i,v in ipairs(team1.roleList) do
		if i <= 3 then 
			table.insert(team1List.team1, v)
		else 
			table.insert(team1List.team2, v)
		end 
	end

	local param = {
		item          =   {},
	  	gold          =   0,
	  	skillValue    =   0,
	  	heroAppendExp =   0,
	  	teamTotalExp  =   0,
	  	teamAppendExp =   0,
		team 	  = team1List, 		-- 己方战队		    		
		enemy = { -- 对方
		    team 	  = team2.roleList, 	-- 对方战队		    
		},	
	}
	app:enterScene("BattleGuide3Scene", {param})

end

function GuideClass:parseTeam(team, list)	
	-- 队员 
	for k,v in pairs(list or {}) do
		local param = {
			roleId = v.heroID, 			
			level = tonumber(v.lv), 			
			skills = v.skills, 
			evolve = v.evolve,
		} 
		local hero = team:createRole(param) 
		team:addRole(hero)
	end 
end 

return GuideClass
