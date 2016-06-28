--[[
进入章节
]]
local ChapterVisitor = class("ChapterVisitor", base.SceneVisitor)

function ChapterVisitor:toScene(totype)
	self:toScene_("ChapterScene", self.params, totype)
end

return ChapterVisitor