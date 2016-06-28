--[[
引导进入3-6-1  塔防玩法
]]

local GuideFightTipsBase = import(".GuideFightTipsBase")
local GuideClass = class("GuideClass", GuideFightTipsBase)

-- overwrite
function GuideClass:guideReadyScene(targetScene, params, outparams)
	local stage = params.stageData
	outparams.tower = true
end 

return GuideClass
