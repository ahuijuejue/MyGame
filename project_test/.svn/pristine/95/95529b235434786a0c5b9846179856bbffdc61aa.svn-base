--[[
通用活动 区域数据
]]

local ActivityGameNormalSection = class("ActivityGameNormalSection")

function ActivityGameNormalSection:ctor(params)
	local cfg = params.cfg

	self.id = params.id
	self.name 	 	= cfg.name or "" 			-- 区名
	self.title 		= cfg.title or "" 			-- 标题
	self.desc 		= cfg.info or "" 			-- 描述

	self.icon 		= cfg.icon 		-- 图标
	self.markIcon 	= cfg.mark 		-- 标记图标
	self.on 		= checknumber(cfg.onOff) == 1 -- 是否开启
	self.sort 		= checknumber(cfg.sort) 	-- 排序

	self.openType 	= checknumber(cfg.type) 		-- 开启类型
	self.openDate 	= string.time(cfg.openTime) 	-- 开启日期
	self.closeDate 	= string.time(cfg.closeTime) 	-- 关闭日期
	self.openSec 	= os.time(self.openDate) 		-- 开启时间（秒）
	self.closeSec 	= os.time(self.closeDate) 		-- 关闭时间（秒）

	self.activityIds = cfg.includeActivityID or {} 	-- 活动id
	self.activity 	= {} -- 活动数据
end

--[[
@param sec 当前格林时间
]]
function ActivityGameNormalSection:isOpen(sec)
	if not self.on then
		return false
	end

	if self.openType == 3 or self.openType == 4 then
		return true
	end

	if self.openSec < sec and self.closeSec > sec then
		return true
	end
	return false
end

return ActivityGameNormalSection
