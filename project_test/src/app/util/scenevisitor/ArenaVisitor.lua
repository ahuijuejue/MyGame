--[[
进入竞技场
]]
local ArenaVisitor = class("ArenaVisitor", base.SceneVisitor)

function ArenaVisitor:toScene(totype)
	self:sendData("ArenaInfo", nil, function()
		self:toScene_("ArenaScene", totype)
	end)
end

return ArenaVisitor