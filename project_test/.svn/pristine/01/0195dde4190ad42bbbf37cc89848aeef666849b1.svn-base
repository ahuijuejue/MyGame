--[[
开服活动数据
]]

module("ActivityUtil", package.seeall)

callbacks = {}

function resetData()
end

function addCallback(callback)
	table.insert(callbacks, callback)
end

function onEvent_(event)
	for i,v in ipairs(callbacks) do
		v(event)
	end
end

----------------------------------------------------------
--[[

]]

-- 解析任务序列完成情况
function parseActivities(activelist)
	for k,v in pairs(activelist or {}) do
		parseActivity(v)
	end
end

-- 排序任务列表
function sortActivities(activelist)
	table.sort(activelist, function(a, b)
		if a:isCompleted() or b:isCompleted() then
			if a:isCompleted() and b:isCompleted() then
				return compareActivity(a, b)
			else
				return b:isCompleted()
			end
		end
		if a:isOk() or b:isOk() then
			if a:isOk() and b:isOk() then
				return compareActivity(a, b)
			else
				return a:isOk()
			end
		end
		return compareActivity(a, b)
	end)
end

-- 跳转场景
function jumpUI(activityData, target)
	local flag = activityData.jumpUI
	local params = {}
	if flag == 19 then
		params.stageId = tostring(activityData.okParam1[1])
	end
	SceneData:JumpUI(flag, params, target)
end

-- 有达成条件的活动
function haveOkActivity(dataList)
	for k,v in pairs(dataList or {}) do
		if v:isOk() and (not v:isCompleted()) then
			return true
		end
	end
	return false
end

-- 已领取任务数
function getCompletedCount(activelist)
	local count = 0
	for k,v in pairs(activelist or {}) do
		if v:isCompleted() then
			count = count + 1
		end
	end
	return count
end

------------------------------------------------------------
-- 任务进度

local paramNames = {
	arenaScore 		= 17, 	-- 竞技场积分
	arenaRank 		= 18, 	-- 竞技场排名
	aincradLevel 	= 19, 	-- 艾恩葛朗特通关总层数
	treeLevel 		= 20, 	-- 世界树通关总层数
	rechargeDiamond = 21, 	-- 充值钻石
	getGold 		= 22, 	-- 获得金币
	costDiamond 	= 23, 	-- 消耗钻石
	costGold 		= 24, 	-- 消耗金币
	totalPlayTime 	= 31, 	-- 累计登陆时间
	totalPlayDay 	= 32, 	-- 累计登陆天数
	rechargeDays 	= 33, 	-- 连续充值天数
	overStage 		= 34, 	-- 通关副本次数
	overNoramlStage = 35, 	-- 通关普通副本次数
	overEliteStage 	= 36, 	-- 通关精英副本次数

	useExpWater 	= 37, 	-- 使用经验药水%s次
	upHeroLevel 	= 38, 	-- 提升%s次英雄等级
	upHeroSkill 	= 39, 	-- 升级%s次英雄技能
	upHeroEquip 	= 40, 	-- 强化%s次英雄装备
	buyGold 		= 41, 	-- 点金%s次
	buyCard 		= 42, 	-- 抽卡%s次
	arenaBattle 	= 43, 	-- 竞技场挑战%s次
	arenaWin 		= 44, 	-- 竞技场获胜%s次
	treeBattle 		= 45, 	-- 进行保卫世界树%s次 (领取总奖励次数)
	aincradBattle 	= 46, 	-- 进行艾恩葛朗特%s次 (重置次数)
	openMaoTimes 	= 47, 	-- 打开茅场晶彦的数据库%s次
	getAincradScore = 48, 	-- 艾恩格朗特获得多少分
	sealTimes 		= 49, 	-- 封印魔像%s次
	upCityTimes 	= 50, 	-- 强化城建%s次
	golgCoinTimes 	= 51, 	-- 黄金推币%s次
	diamondCoinTimes= 52, 	-- 钻石推币%s次
	mysticalDivination = 53, -- 神秘占卜%s次
	sunAndMoon 		= 54, 	-- 日月追缉%s次
	sunLookingFor 	= 55, 	-- 进行烈阳追缉%s次
	moonLookingFor 	= 56, 	-- 进行皎月追缉%s次
	costPower 		= 57, 	-- 57、消耗%s体力
	sumSignInDay 	= 58, 	-- 累计登陆%s天
	sumRechargeTimes= 59, 	-- 累计充值%s次
	holylandTimes 	= 60, 	-- 进行修炼圣地%s次
	lightTimes 		= 61, 	-- 进行山多拉的灯%s次
	houseTimes 		= 62, 	-- 进行精神时间屋%s次
	mountainTimes 	= 63, 	-- 进行庐山五老峰%s次
	buyPower 		= 64, 	-- 购买%s次体力
	growGift        = 65,   -- 成长基金

	coinFindTimes   = 66,   -- 寻宝%s次
}

function setParams(name, value)
	local flag = paramNames[name]
	onEvent_({name="set", code=flag, data=value})
end


function addParams(name, value)
	local flag = paramNames[name]
	value = value or 1
	print("util add param:", flag, value)
	onEvent_({name="add", code=flag, data=value})
end

-------------------------------------------------------------
-- 解析单个任务完成情况
function parseActivity(activeData)
	if activeData:isCompleted() then return nil end

	local fmts = [[
function getActiveFunc(data)
	ActivityUtil.getResult%d(data)
end
		]]

	local funcstring = string.format(fmts, activeData.okCode)
	loadstring(funcstring)()

	getActiveFunc(activeData)

end

-- 同级排序比较
function compareActivity(a, b)
	return a.sort < b.sort
end

-------------------------------------------------------
--////////////////////// 任务达成情况 ///////////////////
-- 战队等级达到%d级
function getResult1(data)
	getResult(data, UserData:getUserLevel(), checknumber(data.okParam1[1]))
end

-- VIP等级达到%d级
function getResult2(data)
	getResult(data, UserData:getVip(), checknumber(data.okParam1[1]))
end

-- 拥有%d名英雄
function getResult3(data)
	local heros = HeroListData.heroList
	getResult(data, #heros, checknumber(data.okParam1[1]))
end

-- %d名英雄进阶为%s品质（颜色品阶）
function getResult4(data)
	local oknum = checknumber(data.okParam2[1])
	local heros = HeroListData.heroList
	local count = 0
	for i,v in ipairs(heros) do
		if v.awakeLevel >= oknum then
			count = count + 1
		end
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 5、%d名英雄获得英雄名%s（1临2兵3斗4者5皆6阵7列8在9前）
function getResult5(data)
	local oknum = checknumber(data.okParam2[1])
	local heros = HeroListData.heroList
	local count = 0
	for i,v in ipairs(heros) do
		if v.starLv >= oknum then
			count = count + 1
		end
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 6、拥有%d只尾兽
function getResult6(data)
	local list = TailsData:getOpenTails()
	local count = table.nums(list)
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 7、%d只尾兽达成%D星
function getResult7(data)
	local list = TailsData:getOpenTails()
	local oknum = tonumber(data.okParam2[1])
	local count = 0
	for k,v in pairs(list) do
		if v:getLevel() >= oknum then
			count = count + 1
		end
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 8、完成普通关卡：%s-%s（关卡ID）
function getResult8(data)
	local stageId = tostring(data.okParam1[1])
	local stage = ChapterData:getStage(stageId)
	data:setOk(stage:isOver())
end

-- 9、完成精英关卡：%s-%s（关卡ID）（和上边是一样的）
function getResult9(data)
	local stage = ChapterData:getStage(tostring(data.okParam1[1]))
	data:setOk(stage:isOver())
end

-- 10、封印魔像至%d层
function getResult10(data)
	getResult(data, SealData:getSealLevel(), checknumber(data.okParam1[1]))
end

-- 11、城建到%d级
function getResult11(data)
	local level = 0
	for k,v in pairs(CityData.cityData) do
		if level < v.level then
			level = v.level
		end
	end
	getResult(data, level, checknumber(data.okParam1[1]))
end

-- 12、在竞技场商店购买一个%s（物品ID）
function getResult12(data)

end

-- 13、在积分商店购买一个%s（物品ID）
function getResult13(data)

end

-- 14、在神树商店购买一个%s（物品ID）
function getResult14(data)

end

-- 15、装备强化总等级达到%s（强化总等级）
function getResult15(data)
	local list = getAllEquips()
	local count = 0
	for k,v in pairs(list) do
		if v.strLevel >= 1 then
			count = count + v.strLevel
		end
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 16、%s件装备达到%s（件数、颜色阶数）
function getResult16(data)
	local oknum = checknumber(data.okParam2[1])
	local list = getAllEquips()
	local count = 0
	for k,v in pairs(list) do
		if v.configQuality >= oknum then
			count = count + 1
		end
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 17、竞技场总积分到达%s(分数）
function getResult17(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 18、竞技场排名小于等于%s（名次以内）
function getResult18(data)
	local value = ArenaData.rank
	local oknum = checknumber(data.okParam1[1])
	if value > 0 then
		data:setOk(value <= oknum)
	else
		data:setOk(false)
	end
end

-- 19、艾恩葛朗特通关总层数达到%s（层数）
function getResult19(data)
	getResult(data, AincradData:getOldFloor(), checknumber(data.okParam1[1]))
end

-- 20、世界树通关总层数达到%s（层数）
function getResult20(data)
	getResult(data, TreeData:getOldWin(), checknumber(data.okParam1[1]))
end

-- 21、充值%s钻石
function getResult21(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 22、获得%s金币
function getResult22(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 23、消耗%s钻石
function getResult23(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 24、消耗%s金币
function getResult24(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 25、拥有%s英雄等级%s
function getResult25(data)
	local oknum = checknumber(data.okParam2[1])
	local count = 0
	for k,v in pairs(HeroListData.heroList) do
		if v.level >= oknum then
			count = count + 1
		end
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 26、总战斗力到达%s
function getResult26(data)
	local heros = HeroListData.heroList
	local count = 0
	for i,v in ipairs(heros) do
		count = count + v:getHeroTotalPower()
	end
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 27、拥有物品%s，数量%s
function getResult27(data)
	local oknum = data.okParam1[1]
	local item = ItemData:getItemWithId(oknum)
	local count = 0
	if item then
		count = item.count
	end
	getResult(data, count, checknumber(data.okParam2[1]))
end

-- 28、兑换物品%s，数量%s（已经拥有这些物品，扣除这些物品获得奖励）
function getResult28(data)
	local oknums = data.okParam2
	local okids = data.okParam1

	data.need = {}
	local isOk = true
	for i,v in ipairs(okids) do
		local itemId = tostring(v)
		local itemCount = checknumber(oknums[i])

		if UserData:getItemCount(itemId) < itemCount then
			isOk = false
		end
		table.insert(data.need, {
			id = itemId,
			count = itemCount,
		})
	end

	data:setOk(isOk)
	data.isExchange = true-- 以物易物

end

-- 29、拥有%s英雄，品质%s（指定英雄）
function getResult29(data)
	local oknum = checknumber(data.okParam2[1])
	local okid = data.okParam1[1]
	local hero = HeroListData:getRoleWithId(okid)
	local isOk = hero and hero.awakeLevel >= oknum

	data:setOk(isOk)
end

-- 30、拥有%s英雄，星级%s（指定英雄）
function getResult30(data)
	local oknum = checknumber(data.okParam2[1])
	local okid = data.okParam1[1]
	local hero = HeroListData:getRoleWithId(tostring(okid))
	local isOk = hero and hero.starLv >= oknum

	data:setOk(isOk)
end

-- 31、累积登陆%s分钟
function getResult31(data)
	-- print("..........get 31 ——————————————————————")
	local count = data:getProcessValue() * 60
	count = count + UserData:getPlayedSecond()
	count = count / 60
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 32、连续登陆%s天
function getResult32(data)
	local count = data:getProcessValue()
	count = count + UserData:getRunningDay()
	getResult(data, count, checknumber(data.okParam1[1]))
end

-- 33、连续%s天充值
function getResult33(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 34、通关副本%s次
function getResult34(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 35、通关普通副本%s次
function getResult35(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 36、通关精英副本%s次
function getResult36(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

--*********************
-- 37、使用经验药水%s次
function getResult37(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 38、提升%s次英雄等级
function getResult38(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 39、升级%s次英雄技能
function getResult39(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 40、强化%s次英雄装备
function getResult40(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 41、点金%s次
function getResult41(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 42、抽卡%s次
function getResult42(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 43、竞技场挑战%s次
function getResult43(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 44、竞技场获胜%s次
function getResult44(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 45、进行保卫世界树%s次
function getResult45(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 46、进行艾恩葛朗特%s次
function getResult46(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 47、打开茅场晶彦的数据库%s次
function getResult47(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 48、艾恩格朗特获得多少分
function getResult48(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 49、封印魔像%s次
function getResult49(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 50、强化城建%s次
function getResult50(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 51、黄金推币%s次
function getResult51(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 52、钻石推币%s次
function getResult52(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 53、神秘占卜%s次
function getResult53(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 54、日月追缉%s次
function getResult54(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 55、进行烈阳追缉%s次
function getResult55(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 56、进行皎月追缉%s次
function getResult56(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 57、消耗%s体力
function getResult57(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 58、累计登陆%s天
function getResult58(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 59、累计充值%s次
function getResult59(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 60、进行修炼圣地%s次
function getResult60(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 61、进行山多拉的灯%s次
function getResult61(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 62、进行精神时间屋%s次
function getResult62(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 63、进行庐山五老峰%s次
function getResult63(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 64、购买%s次体力
function getResult64(data)
	getResult(data, data:getProcessValue(), checknumber(data.okParam1[1]))
end

-- 65、成长基金
function getResult65(data)
	getResult(data, UserData:getUserLevel(), checknumber(data.okParam1[1]))
end

-- 66、寻宝%s次
function getResult66(data)
	getResult(data, UserData:getProcessValue(), checknumber(data.okParam1[1]))
end

--////////////////////// 任务达成情况 ///////////////////
-------------------------------------------------------
--------------
--[[
解析任务
用物值比较的情况
]]
function getResult(data, haveValue, okValue)
	if haveValue >= okValue then
		data:setOk(true)
		:setProcessString("")

	else
		data:setOk(false)
		:setProcessString(string.format("%d/%d", haveValue, okValue))
	end
end

function getAllEquips()
	local list = ItemData:getEquips()
	local heros = HeroListData:getListWithType(LIST_TYPE.HERO_ALL)
	for i,v in ipairs(heros) do
		for i2,v2 in ipairs(v.equip) do
			if v2 ~= 0 then
				table.insert(list, v2)
			end
		end
	end
	return list
end


