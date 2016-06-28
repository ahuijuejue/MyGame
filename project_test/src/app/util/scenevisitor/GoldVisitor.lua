--[[
进入购买金币界面
]]
local GoldVisitor = class("GoldVisitor", base.SceneVisitor)

function GoldVisitor:toScene(totype)
	GoldAlert:info()
end

return GoldVisitor