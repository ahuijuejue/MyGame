--[[
开服活动 子数据
]]

local ActivityGameBase = import(".ActivityGameBase")
local ActivityGameOpen = class("ActivityGameOpen", ActivityGameBase)

function ActivityGameOpen:ctor(params)
	ActivityGameOpen.super.ctor(self, params)

	local cfg = params.cfg
	self.subName 	= cfg.name or "" -- 子分区名
	self.sectionId 	= tostring(cfg.tpye)		-- 主分区id
	self.subSectionId = tostring(cfg.label)		-- 子分区id

end



return ActivityGameOpen
