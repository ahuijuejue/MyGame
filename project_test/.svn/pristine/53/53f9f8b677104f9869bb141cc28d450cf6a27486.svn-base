--[[
引导移动，释放技能
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_()	
	if GuideData:isNotCompleted("Fight") then         
		self:enterGuide()
       	return true 
    end 
	return false
end

function GuideClass:enterGuide()		
	local role = HeroListData:getRole(CreateInfoData.heroId[1])
	local list = {
		team1={clone(role)},
		team2={}
	}
	local param = {
		team 			= 	list, 
		customId 		= 	"10001", 
		item 			= 	{},
		gold 			= 	0,
		skillValue 		= 	0,
		heroAppendExp 	= 	0,
		teamTotalExp 	= 	UserData.totalExp,
		teamAppendExp 	= 	0,
		guide 			= 	{
								move 	= true, 
								skill 	= true 
							},
		building 		= 	CityData:getBuilding()
	}

	app:enterScene("BattleGuide1Scene", {param})

end

return GuideClass
