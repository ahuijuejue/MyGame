--[[
开服活动数据
]]

local ActivityDataBase = import(".ActivityDataBase")
local ActivityOpenData = class("ActivityOpenData", ActivityDataBase)
local ActivityGameOpen = import(".ActivityGameOpen")

function ActivityOpenData:ctor()
	ActivityOpenData.super.ctor(self)

	self.startTime = 0 	-- 活动开始时间
	self.endTime = 0 	-- 活动结束时间
	self.lastTime = 0 	-- 持续时间
	self.awardItem = {} -- 总奖励
	self.ruleDesc = ""
	self.received = false -- 是否领取过总奖励

	self.subSections = {} -- 子分区所有数据
	self.activeCount = 0 	-- 总活动数

	self:initDictData()
	self:initArrData()
	self:initInfo()
end

function ActivityOpenData:initDictData()
	local cfg = GameConfig["Carnival"]

	for k,v in pairs(cfg or {}) do
		local data = ActivityGameOpen.new({
			id = k,
			cfg = v,
		})
		self.dict[k] = data
		self.activeCount = self.activeCount + 1
	end
end

function ActivityOpenData:initArrData()
	-- 主分区
	local sectionCfg = GameConfig["CarnivalInfo"]
	local sections = {}
	for k,v in pairs(sectionCfg) do
		sections[k] = {
			id = k,
			name = v.Name, -- 名称
			openDay = checknumber(v.OpenDay), -- 开启时间
			sort = checknumber(k), -- 排序
			subSections = {} -- 子分区
		}
	end

	-- 子分区
	local subSections = {}
	for k,v in pairs(self.dict) do
		if subSections[v.subSectionId] then
			table.insert(subSections[v.subSectionId].activities, v)
		else
			subSections[v.subSectionId] = {
				id = tostring(v.subSectionId),
				name = v.subName, -- 名称
				sort = checknumber(v.subSectionId),	-- 排序
				sectionId = v.sectionId, -- 主分区id
				activities = {v}, -- 活动数据
			}
		end
	end
	self.subSections = subSections

	-- 将子分区插入主分区
	for k,v in pairs(subSections) do
		-- print("id:", v.sectionId)
		table.insert(sections[v.sectionId].subSections, v)
	end

	-- 排序主分区里的子分区
	for k,v in pairs(sections) do
		table.sort(v.subSections, function(a, b)
			return a.sort < b.sort
		end)
	end

	-- 排序主分区
	self.arr = table.values(sections)
	table.sort(self.arr, function(a, b)
		return a.sort < b.sort
	end)

end

-- 初始化活动信息
function ActivityOpenData:initInfo()
	local cfg = GameConfig["CarnivalAll"] or {}
	cfg = cfg["1"] or {}
	local day = checknumber(cfg.AllDayNum)
	self.lastTime = day * 86400

	self.awardItem = {
		id = cfg.AllAwardID,
		count = checknumber(cfg.AllAwardNum)
	}

	self.ruleDesc = cfg.Info or ""

end

-- 规则说明
function ActivityOpenData:getRule()
	return self.ruleDesc
end

-- 是否已经领取了总奖励
function ActivityOpenData:isReceived()
	return self.received
end

----------------------------------------------------------
--[[
	时间
]]
-- 获取活动开始时间
function ActivityOpenData:getStartTime()
	return self.startTime
end

-- 设置活动开始时间
function ActivityOpenData:setStartTime(t)
	self.startTime = t
	self.endTime = t + self.lastTime
end

-- 剩余时间 秒
function ActivityOpenData:getRemainingTime()
	local t = self.endTime - UserData:getServerSecond()
	t = math.floor(t)
	if t < 0 then
		t = 0
	end
	return t
end

-- 剩余时间
function ActivityOpenData:getRemainingDate()
	local t = self:getRemainingTime()

	return convertSecToDate(t)
end

-- 开启天数
function ActivityOpenData:getOpenDay()
	local t = UserData:getServerSecond() - self.startTime
	t = math.floor(t)
	if t < 0 then
		t = 0
	end
	t = convertSecToDate(t)

	return t.day + 1
end

-- 是否在开启时间内
function ActivityOpenData:isOpenning()
	local activityOpenTime = self:getStartTime()
    local nowTime = UserData:getServerSecond()
    if activityOpenTime > nowTime then 
    	return false 
    end 
    
    if self:getRemainingTime() == 0 then 
    	return false 
    end 

    return true
end 

----------------------------------------------------------
--[[

]]

-- 获取活动列表
function ActivityOpenData:getActiveList(subSectionId)
	return self.subSections[subSectionId]
end


-- 所有是否含有达成活动条件的区域的情况
function ActivityOpenData:getOkIndexes(arrNum)
	local list = {}
	if self:haveOkActivity() then
		if arrNum then
			local arr = {}
			for i=1,arrNum do
				arr[i] = self.arr[i]
			end
		    for i,v in ipairs(arr) do
				local subIndexes = self:getSubOkIndexes(v.subSections)
				table.insert(list, subIndexes)
			end
		else
			for i,v in ipairs(self.arr) do
				local subIndexes = self:getSubOkIndexes(v.subSections)
				table.insert(list, subIndexes)
			end
		end
	end
	return list
end

-- 某一主分区所有达成条件的子分区的情况
function ActivityOpenData:getSubOkIndexes(subSectionList)
	local list = {
		list = {},
		oklist = {}
	}
	for i,v in ipairs(subSectionList) do
		if self:haveOkActivity(v.activities) then
			table.insert(list.list, true)
			table.insert(list.oklist, i)
		else
			table.insert(list.list, false)
		end
	end
	return list
end

-- 增加进度数据
function ActivityOpenData:addParams(okcode, value)
	local sec = self:getRemainingTime()
	if sec > 0 then
		self:addParamsForList(self.dict, okcode, value)
	end

end

-- 设置进度数据
function ActivityOpenData:setParams(okcode, value)
	local sec = self:getRemainingTime()
	if sec > 0 then
		self:setParamsForList(self.dict, okcode, value)
	end
end

----------------------
-- 解锁的活动是否有完成的 
function ActivityOpenData:haveActivityOpenAndOk()
	self:updateData()

    local openIndex = self:getOpenDay()

    if openIndex < 5 then 
    	openData = self:getOkIndexes(openIndex)
    	for i,v in ipairs(openData) do
    		if #v.oklist > 0 then 
    			return true 
    		end 
    	end
    	return false
    end 

    if self:haveOkActivity() then 
    	return true 
    end 

    return self:canRequireFinishAward()     
end

-- 可以领取最终奖励
function ActivityOpenData:canRequireFinishAward()
	if self:isReceived() then
        return false        
    end

    if openIndex == 8 or self:isAllCompleted() then 
    	return true 
    end 

    return false
end 


return ActivityOpenData
