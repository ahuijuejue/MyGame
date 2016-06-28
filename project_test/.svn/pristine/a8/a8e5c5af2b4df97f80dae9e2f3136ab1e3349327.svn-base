
--[[
-- 活动数据基础类

]]

local ActivityDataBase = class("ActivityDataBase")

function ActivityDataBase:ctor()
	self.dict = {} -- 活动数据集合
	self.arr = {} -- 活动阵型
	self.activeCount = 0 -- 活动总数

	ActivityUtil.addCallback(function(event)
		if event.name == "set" then
			self:setParams(event.code, event.data)
		elseif event.name == "add" then
			self:addParams(event.code, event.data)
		end
	end)
end

--@for override
-- 增加进度数据
function ActivityDataBase:addParams(okcode, value)
	self:addParamsForList(self.dict ,okcode, value)
end

--@for override
-- 设置进度数据
function ActivityDataBase:setParams(okcode, value)
	self:setParamsForList(self.dict, okcode, value)
end

-- 增加进度数据
function ActivityDataBase:addParams_(okcode, value)
	self:addParamsForList(self.dict ,okcode, value)
end

-- 设置进度数据
function ActivityDataBase:setParams_(okcode, value)
	self:setParamsForList(self.dict, okcode, value)
end

-- 增加进度数据
function ActivityDataBase:addParamsForList(list ,okcode, value)
	for k,v in pairs(list) do
		if okcode == v.okCode then
			v:addProcessValue(value)
		end
	end
end

-- 设置进度数据
function ActivityDataBase:setParamsForList(list, okcode, value)
	for k,v in pairs(list) do
		if okcode == v.okCode then
			v:setProcessValue(value)
		end
	end
end

-- 重置活动
function ActivityDataBase:resetData(list)
	for k,v in pairs(list or self.dict) do
		v:resetData()
	end
end

-- 更新所有活动数据
function ActivityDataBase:updateData()
	ActivityUtil.parseActivities(self.dict)
end

-- 获取活动数据
function ActivityDataBase:getActivityData(activityId)
	return self.dict[activityId]
end

-- 获取活动阵型
function ActivityDataBase:getArray()
	return self.arr
end

-- 总活动数
function ActivityDataBase:getActivityCount()
	return self.activeCount
end

-- 已领取任务数
function ActivityDataBase:getCompletedCount()
	return ActivityUtil.getCompletedCount(self.dict)
end

-- 完成所有活动
function ActivityDataBase:isAllCompleted()
	return self:getCompletedCount() >= self:getActivityCount()
end

-- 根据id数组获得活动数据数组
function ActivityDataBase:getActivityDataByIds(ids)
	local list = {}
	for i,v in ipairs(ids) do
		table.insert(list, self:getActivityData(v))
	end

	return list
end

-- 有达成条件的活动
function ActivityDataBase:haveOkActivityByIds(activityIds)
	for k,v in pairs(activityIds or {}) do
		local data = self:getActivityData(v)
        if data then
        	if data:isOk() and not data:isCompleted() then
				print("is ok:", data.id, data.desc)
				return true
			end
        end
	end
	return false
end

-- 有达成条件的活动
function ActivityDataBase:haveOkActivity(dataList)
	return ActivityUtil.haveOkActivity(dataList or self.dict)
end

return ActivityDataBase
