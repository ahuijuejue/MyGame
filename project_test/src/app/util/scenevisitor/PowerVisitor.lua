--[[
进入购买金币界面
]]
local PowerVisitor = class("PowerVisitor", base.SceneVisitor)

function PowerVisitor:toScene(totype)
	PowerAlert:info()
end

return PowerVisitor