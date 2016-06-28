--[[
进入艾恩葛朗特界面
]]
local AincradVisitor = class("AincradVisitor", base.SceneVisitor)

function AincradVisitor:toScene(totype)
	self:sendData("OpenAincrad", nil, function()
		self:toScene_("AincradScene", totype)
	end)
end

return AincradVisitor