--[[
进入经验模式界面
]]
local ExpModeVisitor = class("ExpModeVisitor", base.SceneVisitor)

function ExpModeVisitor:toScene(totype)
	self:toScene_("HeroExpScene", totype)
end

return ExpModeVisitor