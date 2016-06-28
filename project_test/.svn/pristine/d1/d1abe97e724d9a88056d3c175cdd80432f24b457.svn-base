--[[
进入关卡界面
]]
local StageVisitor = class("StageVisitor", base.SceneVisitor)

function StageVisitor:toScene(totype)
	if ChapterData:isStageOpen(self.params.stageId) then 
		self:toScene_("MissionScene", self.params, totype)				
	else 
		-- showToast({text="关卡未解锁"})
		local stageData = ChapterData:getStage(self.params.stageId)
		if ChapterData:isChapterOpen(stageData.chapterId) then 
			self:toScene_("MissionScene", {chapterId=stageData.chapterId}, totype)
		else 
			showToast({text="关卡章节未解锁"})
		end 
	end 
end

return StageVisitor