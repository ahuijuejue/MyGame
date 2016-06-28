--[[
通用活动数据
]]

local ActivityDataBase = import(".ActivityDataBase")
local ActivityNormalData = class("ActivityNormalData", ActivityDataBase)

local ActivityGameNormal = import(".ActivityGameNormal")
local ActivityGameNormalSection = import(".ActivityGameNormalSection")

function ActivityNormalData:ctor()
	ActivityNormalData.super.ctor(self)
	self.sectionDict = {} -- 所有分区
end

-- 重置活动
function ActivityNormalData:resetDailyData()
	for i,v in ipairs(self.arr) do
		if v.okType == 2 then
			self:resetData(v.activity)
		end
	end
end

function ActivityNormalData:initDictData(cfg)
	for k,v in pairs(cfg) do
		local data = ActivityGameNormal.new({
			id  = v.id,
			cfg = v,
		})
        local key = v.id
		self.dict[key] = data
		self.activeCount = self.activeCount + 1
	end
end

function ActivityNormalData:initSectionDictData(cfg)
	for k,v in pairs(cfg) do
		local data = ActivityGameNormalSection.new({
			id = v.id,
			cfg = v,
		})

        local key = v.id
		self.sectionDict[key] = data
		table.insert(self.arr, data)
		data.activity = self:getActivityDataByIds(data.activityIds)
	end

	table.sort(self.arr, function(a, b)
		return a.sort < b.sort
	end)
end


-- 获取分区数据
function ActivityNormalData:getSectionData(sectionId)
	return self.sectionDict[activityId]
end


-- 获取开放的活动系列
function ActivityNormalData:getOpenArray()
	for i,v in ipairs(self.arr) do
		if v.openType ~= 4 then
			if v.closeSec < UserData:getServerSecond() then
				table.remove(self.arr, i)
			end
		end
	end
	return self.arr
end

-- 所有是否含有达成活动条件的区域的情况
function ActivityNormalData:getOkIndexes(sectionArr)
	local list = {
		list = {},
		oklist = {}
	}
	for i,v in ipairs(sectionArr or self.arr) do
		if self:haveOkActivityByIds(v.activityIds) then
			table.insert(list.list, true)
			table.insert(list.oklist, i)
		else
			table.insert(list.list, false)
		end
	end

	return list
end

function ActivityNormalData:haveOkActivity()
	self:updateData()
	local list = self:getOkIndexes(self:getOpenArray())
	list = list.oklist
	return #list > 0
end

-- 增加进度数据
function ActivityNormalData:addParams(okcode, value)
	local sec = UserData:getServerSecond()
	for i,v in ipairs(self.arr) do
		self:addParamsForList(v.activity ,okcode, value)
	end
end

-- 设置进度数据
function ActivityNormalData:setParams(okcode, value)
	local sec = UserData:getServerSecond()
	for i,v in ipairs(self.arr) do
		self:setParamsForList(v.activity ,okcode, value)
	end
end

function ActivityNormalData:resetData()
	for k,v in pairs(self.dict) do
		v = nil
	end
	for k,v in pairs(self.sectionDict) do
		v = nil
	end
	for i,v in ipairs(self.arr) do
		v = nil
	end
	self.dict = {}
	self.arr = {}
	self.sectionDict = {}
end


return ActivityNormalData
