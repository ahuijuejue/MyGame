--[[
进入邮箱
]]
local MailVisitor = class("MailVisitor", base.SceneVisitor)

function MailVisitor:toScene(totype)
	self:sendData("MaillGetList", nil, function()
		self:toScene_("MailboxScene", totype)
	end)
end

return MailVisitor