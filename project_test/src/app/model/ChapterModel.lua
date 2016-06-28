local ChapterModel = class("ChapterModel")

function ChapterModel:ctor()
	--章节id
	self.id = ""
	--章节名
	self.name = ""
	--章节标题
	self.title = ""
	--对应的章节id
	self.rId = ""
	--开放等级
	self.openLv = ""
	--章节类型
	self.type = 1
	--sort
	self.sort = 0
	--星数
	self.maxStar = 0
end

function ChapterModel:setId(id)
	self.id = id
end

function ChapterModel:setConfig(cfg)
	self.name = cfg.Name
	self.title = cfg.ChapterNum
	self.rId = cfg.chapter2
	self.openLv = cfg.NeedLevel
	self.type = cfg.Type
	self.sort = cfg.Sort
	self.maxStar = cfg.StarNum
	self.lastStageId = cfg.LastStageID
end

function ChapterModel:getCostPower()
	if self.type == 1 then
		return tonumber(GameConfig["StageInfo"]["1"].NormalEnergy)
	elseif self.type == 2 then
		return tonumber(GameConfig["StageInfo"]["1"].EliteEnergy)
	elseif self.type == 3 then
		return tonumber(GameConfig["StageInfo"]["1"].ConsortiaNormalEnergy)
	end
end

function ChapterModel:getSweepTimes()
	if self.type == 1 then
		return 10
	elseif self.type == 2 then
		return 3
	elseif self.type == 3 then
		return 1
	end
end

function ChapterModel:getPassTimes()
	if self.type == 2 then
		return 3
	elseif self.type == 3 then
		return 1
	end
end

function ChapterModel:getStageIds()
	local ids = {}
	local stageTab = GameConfig["Stage"]
	for k,v in pairs(stageTab) do
		if v.Chapter == self.id then
			table.insert(ids,k)
		end
	end
	table.sort(ids,function (a,b)
		if tonumber(a) < tonumber(b) then
			return true
		else
			return false
		end
	end)
	return ids
end

return ChapterModel
