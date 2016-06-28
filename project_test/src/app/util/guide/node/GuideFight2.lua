--[[
引导移动，释放技能
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- 引导操作
function GuideClass:makeGuide_()	
	if GuideData:isNotCompleted("Fight2") then         
		self:enterGuide()
       	return true 
    end 
	return false
end

function GuideClass:enterGuide()		
	local role1 = HeroListData:getRole(CreateInfoData.heroId[1])
	local role2 = HeroListData:getRole(CreateInfoData.heroId[2])
	local list = {
		team1={clone(role1),clone(role2)},
		team2={}
	}
	local param = {
		team 			= 	list, 
		customId 		= 	"10002", 
		item 			= 	{},
		gold 			= 	0,
		skillValue 		= 	0,
		heroAppendExp 	= 	0,
		teamTotalExp 	= 	UserData.totalExp,
		teamAppendExp 	= 	0,
		guide 			= 	{
								evolve 	= true,
							},
		building 		= 	CityData:getBuilding()
	}

	app:enterScene("BattleGuide2Scene", {param})
end


return GuideClass
