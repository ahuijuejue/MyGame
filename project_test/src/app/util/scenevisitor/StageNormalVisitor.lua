--[[
进入普通关卡选择界面
]]
local StageNormalVisitor = class("StageNormalVisitor", base.SceneVisitor)

function StageNormalVisitor:toScene(totype)
	self:toScene_("MissionScene", {latestType = 1}, totype)
end

return StageNormalVisitor