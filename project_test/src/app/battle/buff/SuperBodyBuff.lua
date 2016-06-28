--
-- Author: zsp
-- Date: 2015-01-29 14:47:58
--

--[[
	霸体 免疫各种控制技能
--]]
local BuffBase   = import(".BuffBase")
local SuperBodyBuff = class("TumbleBuff",BuffBase)

function SuperBodyBuff:doBegin()
	--printInfo("添加霸体 roleId = %s", self.owner.roleId)
	-- body
	self.owner.superBody = true
	self.owner:addBuffEffect(self)
end

function SuperBodyBuff:doBuff()
	-- body
	--printError("BuffBase:doBuff() - must override in inherited class")
end

function SuperBodyBuff:doEnd()
	-- body
	local tb = self.owner.buffMgr:getBuffByType(self.type)
	if #tb <= 1 then
		self.owner.superBody = false
	end
	--printInfo("删除霸体 roleId = %s", self.owner.roleId)
	self.owner:removeBuffEffect(self)
end

function SuperBodyBuff:doUpdate(dt)
	-- body
	--printError("BuffBase:doUpdate() - must override in inherited class")
end

return SuperBodyBuff