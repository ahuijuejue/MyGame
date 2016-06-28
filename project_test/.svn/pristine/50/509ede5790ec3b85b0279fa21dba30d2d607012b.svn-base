--[[
引导进入2-1
]]

local GuideFightBase = import(".GuideFightBase")
local GuideClass = class("GuideClass", GuideFightBase)

-- overwrite

function GuideClass:guideReadyScene(targetScene, params, outparams)
	outparams.param100 = self.data.name
	targetScene.selectLayer_:setCanUnselected(false)
	local heroList = targetScene.selectLayer_.heroList_
	if #heroList > 3 then 
		local list = {}
		for i=1,3 do
			table.insert(list, heroList[i])
		end
		targetScene.selectLayer_:setHeroList(list)
	end 

	self:showSelectIndex(targetScene, 4, "24", function()
		self:showStartButton(targetScene)
	end)
end 

return GuideClass
