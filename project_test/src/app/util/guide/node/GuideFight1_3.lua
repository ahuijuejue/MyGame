--[[
引导进入1-3
]]

local GuideFightBase = import(".GuideFightBase")
local GuideClass = class("GuideClass", GuideFightBase)

-- overwrite
function GuideClass:guideReadyScene(targetScene, params, outparams)
	targetScene.selectLayer_:setCanUnselected(false)
	outparams.param100 = self.data.name
	self:showStartButton(targetScene)
end 

return GuideClass
