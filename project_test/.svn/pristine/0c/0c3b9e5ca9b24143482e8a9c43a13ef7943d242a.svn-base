--[[
引导进入3-2-1 护送玩法
]]

local GuideFightTipsBase = import(".GuideFightTipsBase")
local GuideClass = class("GuideClass", GuideFightTipsBase)

-- overwrite
function GuideClass:guideReadyScene(targetScene, params, outparams)
	local stage = params.stageData
	outparams.escort = true 
	outparams.escortId = stage.escortId 
	outparams.escortLevel = stage.escortLevel 
end 

return GuideClass
