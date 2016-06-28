--[[
引导战斗提示的关卡
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene, params, outparams)
	if params.stageData:isElite() then return false end 
	if GuideData:isCompleted(self.data.name) then return false end 

	local name = self.data.name 
	name = string.sub(name, 6)
	local ids = string.split(name, "-")

	if self:isStage(params.stageData, checknumber(ids[1]), checknumber(ids[2]), checknumber(ids[3])) then 
		outparams.param100 = self.data.name
		outparams.tipsGuide = true
		self:guideReadyScene(targetScene, params, outparams)
		return true 
	end 

	return false
end

function GuideClass:guideReadyScene(targetScene, params, outparams)

end 

function GuideClass:isStage(stageData, chapterIndex, stageIndex, substageIndex)
	return stageData.chapterIndex == chapterIndex and stageData.sort == stageIndex and stageData.sort2 == substageIndex
end



return GuideClass