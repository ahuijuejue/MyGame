
--[[
	章节数据模型
]]
local GameChapter = class("GameChapter")

function GameChapter:ctor(params)
	local cfg = params.cfg

	self.id = params.id 		-- 章节id

	self.power = params.power	-- 消耗体力
	self.sweep = params.sweep 	-- 多次扫荡次数
	self.elite = params.elite 	-- 是否是精英章节

	-- local stageInfo = GameConfig.StageInfo["1"]
		
	self.name = cfg.Name					-- 名字
	self.desc = ""
	if cfg.Description then 
		self.desc = cfg.Description 		-- 描述	
	end 	
	self.type = tonumber(cfg.Type) 			-- 类型 1.普通 2.精英
	self.sort = tonumber(cfg.Sort)			-- 排序
	self.icon = cfg.Icon 					-- 图标
	self.openLevel = tonumber(cfg.NeedLevel) 	-- 解锁等级
	self.preName = cfg.ChapterNum 			-- 中文章节号
	self.lastStageId = cfg.LastStageID 	-- 最后一关id 

	self.chapter2 = cfg.chapter2 			-- 普通章节对应的精英章节 或 精英章节对应的普通章节 

	
	
	self.starMax = checknumber(cfg.starNum)						-- 章节总星级

	-- self.star = 0, 							-- 章节获得星级
	-- self.open = false, 						-- 是否解锁
	-- self.over = false, 						-- 是否通过
	
	self.preChapter = nil 
	
end

-- 玩家等级是否可以解锁本章
function GameChapter:isLevelOpen()
	return UserData:getUserLevel() >= self.openLevel 
end 

-- 获得 对应普通章节id
function GameChapter:getNormalId()
	if self:isElite() then 
		return self.chapter2
	end 

	return self.id 
end 
-- 获得 对应精英章节id
function GameChapter:getEliteId()
	if self:isElite() then 
		return self.id
	end 

	return self.chapter2
end 

-- 是否是精英章节
function GameChapter:isElite()
	return self.type == 2 
end

-- 是否是最后一关
function GameChapter:isLastStage(stageId)
	return self.lastStageId == stageId
end

return GameChapter
