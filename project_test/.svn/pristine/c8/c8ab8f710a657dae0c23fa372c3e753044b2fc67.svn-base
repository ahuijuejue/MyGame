
--[[
章节和关卡数据
]]

local ChapterData = class("ChapterData")
local GameChapter = import(".GameChapter")
local GameStage = import(".GameStage")

function ChapterData:ctor()	

	-- 章节部分
	self.chapterDict = {}	
	self.normal = {} 	-- 普通章节
	self.elite 	= {} 	-- 精英章节 
	self.awardDict = {} -- 星级奖励 
	self.awardNums = {} -- 领取星级奖励次数

	self:parseChapterConfig()

	-- 关卡部分
	self.stageDict = {}
	self.stageListDict = {}

	self:parseStageConfig()

end

--解析章节配置
function ChapterData:parseChapterConfig()
	local function parseItems(ids, nums)
		local items = {} 
		for i,v in ipairs(ids or {}) do
			table.insert(items, {
				id = v,
				count = checknumber(nums[i])
			})			
		end
		return items
	end

	local stageInfo = GameConfig.StageInfo["1"]
	local normalPower = tonumber(stageInfo.NormalEnergy) 	-- 消耗体力
	local normalSweep = tonumber(stageInfo.NormalSweep) 	-- 多次扫荡次数
	local elitePower = tonumber(stageInfo.EliteEnergy) 	-- 消耗体力
	local eliteSweep = tonumber(stageInfo.EliteSweep) 	-- 多次扫荡次数

	-- 存储章节数据
	for k,v in pairs(GameConfig["Chapter"]) do
		local param = {
			id = k,
			cfg = v,
		}
		local chapter = nil

		if v.Type == 2 then 
			param.elite = true
			param.power = elitePower
			param.sweep = eliteSweep

			chapter = GameChapter.new(param)
			table.insert(self.elite, chapter)
		elseif v.Type == 1 then
			param.elite = false
			param.power = normalPower
			param.sweep = normalSweep

			chapter = GameChapter.new(param)
			table.insert(self.normal, chapter)
		end 

		self.chapterDict[k] = chapter
		
		self.awardDict[k] = {
			parseItems(v.ChapterAwardItem1, v.ChapterAwardNum1),
			parseItems(v.ChapterAwardItem2, v.ChapterAwardNum2),
			parseItems(v.ChapterAwardItem3, v.ChapterAwardNum3),
		}		
	end

	table.sort(self.normal, function(a, b)
		return a.sort < b.sort
	end)

	table.sort(self.elite, function(a, b)
		return a.sort < b.sort
	end)

	-- 设置前置章节
	local preChapter = nil 
	for i,v in ipairs(self.normal) do
		v.preChapter = preChapter
		preChapter = v
	end

	preChapter = nil 
	for i,v in ipairs(self.elite) do
		v.preChapter = preChapter
		preChapter = v
	end

end

--解析关卡配置
function ChapterData:parseStageConfig()
	local stageInfo = GameConfig.StageInfo["1"]
	local normalInfoData = {
		teamExp = tonumber(stageInfo.NormalExp), -- 战队经验
	}

	local eliteInfoData = {
		passLimit = tonumber(stageInfo.EliteLimit), --精英关卡 通过次数限制
		teamExp = tonumber(stageInfo.EliteExp), -- 战队经验
	}

	for k,v in pairs(GameConfig["Stage"]) do	
		local stage = GameStage.new({
			id = k,
			cfg = v,
			chapter = GameConfig.Chapter[v.Chapter],
		})
		local chapter = self:getChapter(v.Chapter)
		if chapter then
			if chapter.type == 2 then 
				for k,v in pairs(eliteInfoData) do
					stage[k] = v
				end
			elseif chapter.type == 1 then
				for k,v in pairs(normalInfoData) do
					stage[k] = v
				end
			end 
			
			if not self.stageListDict[v.Chapter] then 
				self.stageListDict[v.Chapter] = {}
			end 

			table.insert(self.stageListDict[v.Chapter], stage)
			self.stageDict[k] = stage
		end		
	end

	for k,v in pairs(self.stageListDict) do
		self:sortStageConfig(v)
	end

end 

function ChapterData:sortStageConfig(arr)
	table.sort(arr, function(a, b)
		if a.sort < b.sort then 
			return true 
		elseif a.sort > b.sort then 
			return false 
		else 
			return a.sort2 < b.sort2
		end 
	end)
	for i,v in ipairs(arr) do
		local nextStage = self:getStage(v.nextStageId)
		if nextStage then 
			v.nextStage = nextStage 
			nextStage.preStage = v
			if v:isMainStage() and v:haveNextSubStage() then 				
				local subStage = self:getStage(v.nextSubStageId)
				v.nextSubStage = subStage 
				subStage.preStage = v
			end 
		end 
	end
end 

function ChapterData:resetAllDatas()
	for k,v in pairs(self.stageDict) do
		v.passLevel = 0		
		v.passNum = 0
		v.buyElitNum = 0
	end

	self.awardNums = {}
end 

--=============================================== 章节 ===================================================
--@param id 章节id
function ChapterData:getChapter(chapterId)
	return self.chapterDict[chapterId]		
end 

-- 获得章节所在的所有章节 
--@param id 章节id
function ChapterData:getChapters(chapterId)
	local data = self:getChapter(chapterId)
	if data:isElite() then 
		return self.elite 
	else 
		return self.normal 
	end 
end

function ChapterData:getNormalChapters()
	return self.normal
end 

function ChapterData:getEliteChapters()
	return self.elite
end 

-- 获得章节星星数
--@return 星星数，星星数最大值
function ChapterData:getChapterStar(chapterId)
	local star, starMax = 0, 0
	for i,v in ipairs(self:getChapterStages(chapterId)) do
		star = star + v:getStar()
		starMax = starMax + v:getStarMax()
	end
	return star, starMax
end 

-- 获得前面一个的章节
--@param id 章节id
function ChapterData:getPreChapter(chapterId) 
	if type(chapterId) ~= "string" then 
		chapterId = chapterId.id
	end 	
	local chapter = self:getChapter(chapterId)	
	return  chapter.preChapter
end 

-- 章节是否全通
function ChapterData:isChapterOver(chapterId) 	
	local stage = self:getLastStage(chapterId)
	return stage:isOver()
end 

-- 章节是否全通
function ChapterData:isChapterOverWithIndex(index, isElit) 	
	local chapter = self:getChapterAtIndex(index, isElit)
	return self:isChapterOver(chapter.id) 	
end 

-- 章节是否开启
--@param id 章节id
function ChapterData:isChapterOpen(chapter)
	if type(chapter) == "string" then 
		chapter = self:getChapter(chapter)
	end 
	
	if not chapter:isLevelOpen() then 
		return false 
	end 

	local firstStage = self:getFirstStage(chapterId)
	if firstStage and firstStage:isOver() then 
		return true
	end 

	-- 章节无星，等级达到
	if chapter:isElite() then 
		local normalChapterId = chapter:getNormalId() 
		if chapter.preChapter then 
			if self:isChapterOver(chapter.preChapter.id) and self:isChapterOver(normalChapterId) then 
				return true 
			else 
				return false
			end 
		else 
			return self:isChapterOver(normalChapterId)
		end 
	else 
		if chapter.preChapter then 
			return self:isChapterOver(chapter.preChapter.id) 
		else 
			return true
		end 		
	end 
		
end

-- 获得最新章节(如果没有返回空)
function ChapterData:getLatestChapter(isElite)
	local chapters
	if isElite then 
		chapters = self.elite 
	else 
		chapters = self.normal 
	end 
	
	local data 
	for i,v in ipairs(chapters) do		 
		if self:isChapterOpen(v) then
			data = v 
		else 
			break
		end
	end
	return data 
end

function ChapterData:getChapterAtIndex(index, isElit)
	local chapters
	if isElit then 
		chapters = self.elite
	else 
		chapters = self.normal 
	end 
	return chapters[index]
end 

function ChapterData:getIndexOfChapter(chapterId, isElit)
	local chapters
	if isElit then 
		chapters = self.elite
	else 
		chapters = self.normal 
	end 
	for i,v in ipairs(chapters) do
		if v.id == chapterId then 
			return i 
		end 
	end
	return 0
end 

function ChapterData:getChapterOpenCount(isElit)
	local chapters
	if isElit then 
		chapters = self.elite
	else 
		chapters = self.normal 
	end 
	local count = 0 
	for i,v in ipairs(chapters) do
		if self:isChapterOpen(v.id) then 			
			count = count + 1
		else 			
			break 
		end 
	end

	return count 
end 


------------
-- 章节已经领取星级奖励次数
function ChapterData:getAwardNum(chapterId)
	return self.awardNums[chapterId] or 0 
end

function ChapterData:setAwardNum(chapterId, num)
	self.awardNums[chapterId] = num 

	return self  
end

function ChapterData:getAwardData(chapterId, num)	
	local list = self.awardDict[chapterId] or {}
	return list[num]  
end

-- 检测章节 领取第num次奖励 需要达到的星级
function ChapterData:getAchieveAwardStar(chapterId, num)
	local star, starMax = self:getChapterStar(chapterId)
	
	return math.ceil(starMax / 3 * num)
end

-- 检测章节是否达到第 num 次领取条件
function ChapterData:checkAchieveAward(chapterId, num)
	local star, starMax = self:getChapterStar(chapterId)
	local toStar = math.ceil(starMax / 3 * num)

	return star >= toStar
end
------------

--=============================================== 关卡 ===================================================
-- 获得关卡
function ChapterData:getStage(stageId)	
	return self.stageDict[stageId]  
end
-- 获得章节的所有关卡
--@return 数组格式
function ChapterData:getChapterStages(chapterId)	
	return self.stageListDict[chapterId] or {}
end

-- 获得下一关
function ChapterData:getNextStage(chapterId, stageId)	
	local stage = self:getStage(stageId)
	return stage.nextStage
end

-- 获得章节下一关id
--@param stageId 关卡id
function ChapterData:getNextStageId(chapterId, stageId)
	local nextStage = self:getNextStage(chapterId, stageId)
	if nextStage then 
		return nextStage.id 
	end 
	return nil 
end 

-- 获得章节第一关
function ChapterData:getFirstStage(chapterId)	
	local stages = self:getChapterStages(chapterId)
	return stages[1]
end

-- 获得章节最后一关
function ChapterData:getLastStage(chapterId)	
	local chapter = self:getChapter(chapterId)
	return self:getStage(chapter.lastStageId)	
end

-- 是否是章节最后一关 
function ChapterData:isLastStage(chapterId, stageId)	
	local chapter = self:getChapter(chapterId)
	return chapter.lastStageId == stageId
end 

-- 关卡是否开放
function ChapterData:isStageOpen(stage)
	if type(stage) == "string" then 
		stage = self:getStage(stage)
	end
	
	if stage:isOver() then  	-- 已经完成过关卡
		return true 
	end 

	if not self:isChapterOpen(stage.chapterId) then -- 关卡所在章节未解锁
		return false 
	end 

	---------------------
	-- 所在章节已经解锁

	local preStage = stage.preStage
	if not preStage then  	-- 第一关
		return true 
	end 

	return preStage:isOver() -- 如果前一关通关，则本关解锁 
end 

-- 显示的关卡
function ChapterData:getShowStages(chapterId)
	if not self:isChapterOpen(chapterId) then return {} end 

	local stages = self:getChapterStages(chapterId)
	local arr = {}
	for i,v in ipairs(stages) do
		if v:isOver() then 
			table.insert(arr, v)
		elseif self:isStageOpen(v.id) then 
			table.insert(arr, v)
		else
			local preStage = v.preStage
			if not preStage or self:isStageOpen(preStage.id) then 
				table.insert(arr, v)
			end 
		end 
	end
	return arr 
end 

-- 关卡位置
function ChapterData:getIndexOfStage(chapterId, stageId)
	local stages = self:getChapterStages(chapterId)
	for i,v in ipairs(stages) do
		if v.id == stageId then 
			return i 
		end 
	end
	return 0
end

return ChapterData

