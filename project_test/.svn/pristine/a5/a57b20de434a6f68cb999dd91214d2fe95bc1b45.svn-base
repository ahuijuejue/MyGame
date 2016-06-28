--[[
任务区列表
]]

local TaskList = class("TaskList")
local TaskData = import(".TaskData")

function TaskList:ctor()
	self.lists = {}
end

-- 重置任务区
function TaskList:resetTask(type)
	self.lists[type] = {}
	return self 
end

-- 获取类型为type的任务区
function TaskList:getTask(type)	
	return self.lists[type]
end

-- 添加任务区
function TaskList:addTask(taskData, taskType)	
	if type(taskData) == "table" then 
		taskData.type = taskType		
		taskData = TaskData.new(taskData)
	end 
	taskData.type = taskType 
	self.lists[taskType] = taskData	

	return taskData
end

return TaskList