--[[
进入世界树界面
]]
local TreeVisitor = class("TreeVisitor", base.SceneVisitor)

function TreeVisitor:toScene(totype)
	self:sendData("OpenTreeWorld", nil, function()
		if TreeData:isBattling() or TreeData:getHaveTimes() > 0 then 			
			self:toScene_("TreeReadyScene", totype)
		else 
			showToast({text="没有挑战次数"})
		end 
	end)
end

return TreeVisitor