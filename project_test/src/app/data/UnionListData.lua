local UnionListData = class("UnionListData")

function UnionListData:ctor()
	self.unionShowList = {}  -- 加入公会列表显示
	self.unionFindList = {}  -- 查找公会结果

	self.unionData = {}   -- 已加入的公会信息
	self.unionMemberData = {}  -- 公会成员信息

	-- 是否是新创建的公会
	self.isTheNewUnion = 0
	-- 是否通过申请
	self.isApplyPass = 0
	-- 在公会中的职位
    self.unionDuty = "0"
    -- 自动退出公会后是否过一小时 即是否可以申请公会
    self.isCanApply = 1
    -- 已经发送邮件的次数
    self.mailCounts = 0
    --礼拜状态
    self.isSignIn = {"0", "0", "0"}
    -- 申请的公会列表
    self.applyUnions = {}
    -- 日志内容
    self.logMsg = {}
    -- 申请列表
    self.applyData = {}
    -- 公会等级对应功能
	self.arr = {}
    local cfgs = GameConfig["ConsortiaExp"]
	for k,v in pairs(cfgs) do
		table.insert(self.arr, {
			level 		= tonumber(k), 				-- 公会等级
			exp 		= v.ConsortiaExp, 	-- vip经验
			memberNum   = v.PlayerNumber,   -- 成员数量
			admNum      = v.AdministratorNumber,   -- 管理员数量
			vcechairmanNum = v.VicechairmanNumber, -- 副会长数量
			isOpen = v.ConsortiaInstance, -- 是否开启公会副本
		})
	end
	table.sort(self.arr, function(a, b)
		return a.level < b.level
	end)
	--------------------------------------------------

	-- 公会战争之地公会列表信息
	self.unionArenaList = {}
	-- 挑战工会的公会信息
    -- self.unionArenaId = ""
    self.unionArenaMembers = {}
    -- 剩余挑战次数
    self.times = 0
    -- 购买剩余挑战次数花费
    self.timesCost 		= 0
    -- 购买公会战争挑战的次数
    self.buyTimes 		= 0
    -- 工会副本章节数据
    self.chapterData = {}
    for k,v in pairs(GameConfig["Chapter"]) do
    	if v.Type == 3 then
    		local cModel = require("app.model.ChapterModel").new()
    		cModel:setId(k)
    		cModel:setConfig(v)
    		self.chapterData[v.Sort] = cModel
    	end
    end

	-- 关卡部分
	self.stageData = {}

    -- 公会所有佣兵信息
    self.allAgentData = {}
    -- 派出的佣兵信息
    self.ownAgentData = {}
    -- 派出佣兵之后所剩英雄
    self.heroList_ = {}

end

-- 查找公会的结果
function UnionListData:insertFindData( model )
	table.insert(self.unionFindList, model)
end

-- 显示的所有公会列表
function UnionListData:insertShowData( model )
	if not self:isContainUnion(model) then
		table.insert(self.unionShowList, model)
	end
end
function UnionListData:isContainUnion( model )
	for i,v in ipairs(self.unionShowList) do
		if model.id == v.id then
		   return true
		end
	end
	return false
end

-- 已加入的公会信息
function UnionListData:insertUnionData( model )
	if #self.unionData >= 1 then
		self:updateUnionData(model)
	else
		self.unionData = model
	end
end
function UnionListData:updateUnionData(model)
	for k,v in pairs(model) do
		self.unionData[k] = v
	end
end

-- 成员信息
function UnionListData:insertUnionMemberData( model )
	if not self:isContainUnionMember(model) then
		table.insert(self.unionMemberData, model)
	else
		print("该成员已存在！")
	end

	--根据等级排序
    local sortFunc = function (a,b)
        if a.exp > b.exp then
            return true
        elseif a.exp == b.exp then
            if a.duty < b.duty then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    table.sort(self.unionMemberData,sortFunc)
end
function UnionListData:isContainUnionMember( model )
	for i,v in ipairs(self.unionMemberData) do
		if model.id == v.id then
		   return true
		end
	end
	return false
end

-- 签到状态
function UnionListData:setIsSignIn(signInArr)
	for i=1,#signInArr do
    	self.isSignIn[i] = signInArr[i]
    end
end

-- 已申请过的公会
function UnionListData:setApplyUnions(param)
	for i=1,#param do
		self.applyUnions[i] = param[i]
	end
end

-- 在公会中的职位
function UnionListData:getUnionDuty()
	if #self.unionMemberData > 0 then
		for i,v in ipairs(self.unionMemberData) do
			if v.id == UserData.userId then
				self.unionDuty = v.duty
				return self.unionDuty
			end
		end
	else
		return self.unionDuty
	end
end

function UnionListData:setUnionExp(exp)
	local exp_ = tonumber(self.unionData.exp)
	exp_ = exp_ + exp
	self.unionData.exp = tostring(exp_)
	-- self:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_VIP})
end
---------------------------------------------------------------------
-- 最大公会等级
function UnionListData:getUnionLevelMax()
    return self.arr[#self.arr].level
end

-- 最大公会等级对应经验
function UnionListData:getUnionExpMax()
    return self.arr[#self.arr].exp
end

function UnionListData:getData(exp)
	exp = exp or tonumber(self.unionData.exp)
	local preData
	for i,v in ipairs(self.arr) do
		if exp < v.exp then
			return preData, v
		else
			preData = v
		end
	end
	return preData, preData
end

function UnionListData:getLevel(exp)
	local data = self:getData(exp)
	return data.level
end

-- 下一级对应的经验
function UnionListData:getExpMax(exp)
	local _, nextData = self:getData(exp)
	return nextData.exp
end

-- 当前公会经验
function UnionListData:getUnionExp(exp)
	local unionlevel = self:getLevel(exp)
	local preExp = 0
	for i,v in ipairs(self.arr) do
		if unionlevel == v.level then
			preExp = v.exp
			break
		end
	end
	return exp - preExp
end

---------------------------------------------------------------------

-- 更新日志
function UnionListData:reloadLogMsg(param)
	for i,v in ipairs(param) do
		self.logMsg[i] = v
	end
end

-- 申请列表
function UnionListData:insertApplyData(param)
	if not self:isContainUnionApply(param) then
		table.insert(self.applyData, param)
	end
end
function UnionListData:isContainUnionApply( param )
	for i,v in ipairs(self.applyData) do
		if param.userId == v.userId then
		   return true
		end
	end
	return false
end

---------------------------------------------------------------------
-- 等级达到35级 是否加入公会
function UnionListData:isJoinUnion()
	if UserData:getUserLevel() >= GameConfig["ConsortiaInfo"]["1"].ConsortiaOpenLeve then
		if not UserData.unionId then
			return true
		elseif UserData.unionId and UserData.unionId == "" then
			return true
		end
    end
    return false
end

-- 申请人红点
function UnionListData:isShowSignRedPoint()
    for i,v in ipairs(self.isSignIn) do
    	if UserData.unionId and UserData.unionId ~= "" then
    		if v == "0" then
	        	return true
	        end
    	end
    end
    return false
end

-- 签到红点
function UnionListData:isShowApplyRedPoint()
    if #self.applyData > 0 then
    	return true
    end
    return false
end

-- 可以派出佣兵红点
function UnionListData:isShowSendRedPoint()
	if UserData.unionId and UserData.unionId ~= "" then
	    self.ownAgentData = self:showOwnAgent()
		if #self.ownAgentData < 2 then
			return true
		end
	end
    return false
end

-- 雇佣兵雇佣收入计算
function UnionListData:getAgentGain_( heroLevel, times_) -- 雇佣兵等级  被雇佣的次数
	local cfg = GameConfig["ConsortiaMercenary"]
	local agentTimes = times_
	for k,v in pairs(cfg) do
		if v.level == tonumber(heroLevel) then
			if v.num * agentTimes >= v.numlimit then
				return true
			end
		end
	end
	return false
end
-- 雇佣兵守营收入计算
function UnionListData:getProTectGain_( heroLevel, time_ ) -- 雇佣兵等级 派出的时间
	local cfg = GameConfig["ConsortiaMercenary"]
	local time = self:getAgentTimeByHeroId__(time_)
	for k,v in pairs(cfg) do
		if v.level == tonumber(heroLevel) then
			if math.floor(time/30) * v.halfhour >= v.halfhourlimit then
				return true
			end
		end
	end
	return false
end
-- 可以召回佣兵红点  佣兵佣金达到上限
function UnionListData:isShowBackRedPoint()
	if UserData.unionId and UserData.unionId ~= "" then
		self.ownAgentData = self:showOwnAgent()
	    if #self.ownAgentData > 0 then
	    	for i,v in ipairs(self.ownAgentData) do
	    		if self:getAgentGain_(v.level, v.useTimes) or self:getProTectGain_(v.level, v.sendTime) then
	    			return true
	    		end
	    	end
	    	return false
	    end
	end
    return false
end
---------------------------------------------------------------------
-- 显示的所有公会战争之地列表
function UnionListData:insertUnionAreanList( model )
	if not self:isContainUnionArena(model) then
		table.insert(self.unionArenaList, model)
	end

	--根据等级排序
    local sortFunc = function (a,b)
        if a.exp > b.exp then
            return true
        elseif a.exp == b.exp then
            if tonumber(a.combat) > tonumber(b.combat) then
                return true
            else
                return false
            end
        else
            return false
        end
    end
    table.sort(self.unionArenaList,sortFunc)
end
function UnionListData:isContainUnionArena( model )
	for i,v in ipairs(self.unionArenaList) do
		if model.id == v.id then
		   return true
		end
	end
	return false
end

-- 显示所选公会成员信息
function UnionListData:insertUnionArenaMember( model )
	if not self:isContainUnionArenaMember(model) then
		table.insert(self.unionArenaMembers, model)
	end
end

function UnionListData:isContainUnionArenaMember( model )
	for i,v in ipairs(self.unionArenaMembers) do
		if model.userid == v.userid then
		   return true
		end
	end
	return false
end
------------------------------------------------------------------
--获取章节数
function UnionListData:getChapterCount()
	return #self.chapterData
end

--获取章节数据
function UnionListData:getChapterData(index)
	return self.chapterData[index]
end

--通过id获取章节
function UnionListData:getChapterDataById(id)
	for i,v in ipairs(self.chapterData) do
		if id == v.id then
			return v
		end
	end
	return nil
end

--工会章节所对应的普通章节是否通关
function UnionListData:isNormalPass(id)
	return ChapterData:isChapterOver(id)
end

--获取关卡数据
function UnionListData:getStageData(id)
	return self.stageData[id]
end

--增加关卡星数
function UnionListData:setStageStar(id,value)
	local stage = self:getStageData(id)
	if stage then
		stage:addStar(value)
	end
end

--增加关卡剩余次数
function UnionListData:setStageLeftTimes(id,value)
	local stage = self:getStageData(id)
	if stage then
		stage:addLeftTimes(value)
	end
end

--关卡通关星数
function UnionListData:getStageStar(id)
	local stage = self:getStageData(id)
	if stage then
		return stage.star
	end
	return 0
end

--关卡是否通关
function UnionListData:isStagePass(id)
	if self:getStageStar(id) > 0 then
		return true
	end
	return false
end

--关卡剩余次数
function UnionListData:getStageLeftTimes(id)
	local stage = self:getStageData(id)
	if stage then
		return stage.leftTimes
	end
	return tonumber(GameConfig["StageInfo"]["1"].ConsortiaLimit)
end

function UnionListData:getShowStages(chapter)
	local stages = {}
	local stageIds = chapter:getStageIds()
	local stageTable = GameConfig["Stage"]
	for i,v in ipairs(stageIds) do
		local stage = stageTable[v]
		stage.id = v
		if self:isStagePass(v) then
			table.insert(stages,stage)
		elseif self:isStageOpen(v) then
			table.insert(stages,stage)
			if stage.NextStageId then
				local nextStage = stageTable[stage.NextStageId]
				if nextStage.Chapter == chapter.id then
					nextStage.id = stage.NextStageId
					table.insert(stages,nextStage)
				end
			end
		end
	end
	return stages
end

function UnionListData:isStageOpen(id)
	local stage = GameConfig["Stage"][id]
	local chapter = self:getChapterDataById(stage.Chapter)
	local stageIds = chapter:getStageIds()
	local index
	for i,v in ipairs(stageIds) do
		if v == id then
			index = i
			break
		end
	end
	if index == 1 then
		return true
	else
		local preId = nil
		for i,v in ipairs(stageIds) do
			if GameConfig["Stage"][v].NextStageId == id then
				preId = v
			end
		end
		if preId then
			if self:isStagePass(preId) then
				return true
			end
		else
			if stage.SubStageID then
				if self:isStagePass(stage.SubStageID) then
					return true
				end
			end
		end
	end

	return false
end

function UnionListData:getChapterStar(chapter)
	local star = 0
	local stageIds = chapter:getStageIds()
	for i,v in ipairs(stageIds) do
		star = star + self:getStageStar(v)
	end
	return star
end

function UnionListData:isChapterPass(chapter)
	if self:isStagePass(chapter.lastStageId) then
		return true
	end
	return false
end
---------------------------------------------------------------------------
-- 购买次数花费
function UnionListData:getCostForBuyTimes()
	return CostDiamondData:getBuyUnionTimes(self.buyTimes+1)
end
---------------------------------------------------------------------------

-- 公会雇佣兵中是否有自己派出的英雄
function UnionListData:isContainAgent(hero)
	if UserData.teamId == hero.teamId then
		return true
	end
	return false
end

-- 公会所有佣兵
function UnionListData:insertAllAgentData( model )
	if not self:isContainAllAgent(model) then
		table.insert(self.allAgentData, model)
	end
end
function UnionListData:isContainAllAgent( model )
	for i,v in ipairs(self.allAgentData) do
		if model.roleId == v.roleId and model.name == v.name then  -- 对应id
		   return true
		end
	end
	return false
end

-- 公会我的佣兵
function UnionListData:insertOwnAgentData( model )
	if not self:isContainOwnAgent(model) then
		table.insert(self.ownAgentData, model)
	end
end
function UnionListData:isContainOwnAgent( model )
	for i,v in ipairs(self.ownAgentData) do
		if model.roleId == v.roleId then  -- 对应id
		   return true
		end
	end
	return false
end
-- 我的佣兵
function UnionListData:showOwnAgent()
	self.ownAgentData = {}
	for i,v in ipairs(self.allAgentData) do
		if UserData.teamId == v.teamId then
			self:insertOwnAgentData( v )
		end
	end
	return self.ownAgentData
end

-- 派出佣兵之后所剩英雄
function UnionListData:getHeroList_()
	for i,v in ipairs(HeroListData.heroList) do
		if not self:isContainHeroList_(v) then
			table.insert(self.heroList_, v)
		end
	end
	local heroList_ = self.heroList_
	self.heroList_ = {}
	for i,v in ipairs(heroList_) do
		if not self:isContainOwnAgent(v) then
			table.insert(self.heroList_, v)
		end
	end
	return self.heroList_
end
function UnionListData:isContainHeroList_( model )
	for i,v in ipairs(self.heroList_) do
		if model.roleId == v.roleId then
		   return true
		end
	end
	return false
end
---------------------------------------------------------------------------

-- 雇佣兵被派出时间长度  返回为小时数
function UnionListData:getAgentTimeByHeroId( time_ )
	local time = tonumber(time_)
	local nowTime = UserData:getServerSecond()
    local date = {}
    if time - nowTime > 0 then
       date = convertSecToDate(time - nowTime) -- date.hour, date.min, date.sec
    else
       date = convertSecToDate(nowTime - time) -- date.hour, date.min, date.sec
    end
    return date.day * 24 + date.hour
end
-- 雇佣兵被派出时间长度  返回为分钟数
function UnionListData:getAgentTimeByHeroId__( time_ )
    local time = tonumber(time_)
    local nowTime = UserData:getServerSecond()
    local date = {}
    if time - nowTime > 0 then
       date = convertSecToDate(time - nowTime) -- date.hour, date.min, date.sec
    else
       date = convertSecToDate(nowTime - time) -- date.hour, date.min, date.sec
    end
    return date.day * 1440 + date.hour * 60 + date.min
end
-- 雇佣兵被派出时间长度  返回为小时 分钟 string
function UnionListData:getAgentTimeByHeroId_( time_ )
    local time = tonumber(time_)
    local nowTime = UserData:getServerSecond()
    local date = {}
    if time - nowTime > 0 then
       date = convertSecToDate(time - nowTime) -- date.hour, date.min, date.sec
    else
       date = convertSecToDate(nowTime - time) -- date.hour, date.min, date.sec
    end
    return string.format("%d天%d小时%d分钟", date.day, date.hour, date.min)
end

-- 雇佣兵累计收入计算
function UnionListData:getTotalGain(heroLevel, time, times ) --  派出的时间 被雇佣的次数
	local agentGain = self:getAgentGain(heroLevel, times)
	local proGain = self:getProTectGain(heroLevel, time )
	return agentGain + proGain
end
-- 雇佣兵雇佣收入计算
function UnionListData:getAgentGain( heroLevel, times ) --   被雇佣的次数
	local cfg = GameConfig["ConsortiaMercenary"]
	local agentTimes = times
	for k,v in pairs(cfg) do
		if v.level == heroLevel then
			if v.num * agentTimes >= v.numlimit then
				return v.numlimit
			end
			return v.num * agentTimes
		end
	end
	return 0
end
-- 雇佣兵守营收入计算
function UnionListData:getProTectGain( heroLevel, time_ ) --  派出的时间
	local cfg = GameConfig["ConsortiaMercenary"]
	local time = self:getAgentTimeByHeroId__(time_)
	for k,v in pairs(cfg) do
		if v.level == heroLevel then
			if math.floor(time/30) * v.halfhour >= v.halfhourlimit then
				return v.halfhourlimit
			end
			return math.floor(time/30) * v.halfhour  -- 派出时间是否为半小时的倍数
		end
	end
	return 0
end

---------------------------------------------------------------------
--删除聊天数据
function UnionListData:cleanData()
	for i,v in ipairs(self.unionFindList) do
		v = nil
	end
	self.unionFindList = {}

	for i,v in ipairs(self.unionShowList) do
		v = nil
	end
	self.unionShowList = {}

	for i,v in ipairs(self.unionData) do
		v = nil
	end
	self.unionData = {}

	for i,v in ipairs(self.unionMemberData) do
		v = nil
	end
	self.unionMemberData = {}

	for i,v in ipairs(self.isSignIn) do
		v = nil
	end
	self.isSignIn = {}

	for i,v in ipairs(self.applyUnions) do
		v = nil
	end
	self.applyUnions = {}

	for i,v in ipairs(self.logMsg) do
		v = nil
	end
	self.logMsg = {}

	for i,v in ipairs(self.applyData) do
		v = nil
	end
	self.applyData = {}

    for i,v in ipairs(self.unionArenaList) do
		v = nil
	end
	self.unionArenaList = {}

	for i,v in ipairs(self.unionArenaMembers) do
		v = nil
	end
    self.unionArenaMembers = {}

    for i,v in ipairs(self.allAgentData) do
		v = nil
	end
    self.allAgentData = {}

    for i,v in ipairs(self.ownAgentData) do
		v = nil
	end
    self.ownAgentData = {}

    for i,v in ipairs(self.heroList_) do
		v = nil
	end
    self.heroList_ = {}

	self.unionDuty = "0"
	self.isCanApply = 1
	self.mailCounts = 0
	self.isTheNewUnion = 0
	self.isApplyPass = 0
	UserData.unionId = ""
	self.times = 0
	self.timesCost = 0
	self.buyTimes = 0
end

return UnionListData