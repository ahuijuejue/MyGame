--[[
进入精英关卡选择界面
]]
local StageEliteVisitor = class("StageEliteVisitor", base.SceneVisitor)

function StageEliteVisitor:toScene(totype)
	local chapterData = ChapterData:getLatestChapter(true)
	if UserData:getUserLevel() < OpenLvData.elite.openLv then 
		showToast({text="玩家精英章节未解锁"})
	elseif chapterData and ChapterData:isChapterOpen(chapterData.id) then 
		self:toScene_("MissionScene", {latestType = 2}, totype)				
	else 
		showToast({text="精英章节未解锁"})
	end 
end

return StageEliteVisitor