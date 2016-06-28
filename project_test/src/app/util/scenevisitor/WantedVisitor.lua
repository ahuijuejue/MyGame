--[[
进入日月追缉界面
]]

local WantedVisitor = class("WantedVisitor", base.SceneVisitor)

function WantedVisitor:toScene(totype)
	self:sendData("OpenRiYueZhui", nil, function()
		-- if TreeData:isBattling() or TreeData:getHaveTimes() > 0 then 			
		-- 	self:toScene_("TreeReadyScene", totype)
		-- else 
		-- 	showToast({text="没有挑战次数"})
		-- end 
		self:toScene_("ArenaLookingForScene", totype)
	end)
end

return WantedVisitor
