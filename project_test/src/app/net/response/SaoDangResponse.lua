local SaoDangResponse = class("SaoDangResponse")
function SaoDangResponse:SaoDangResponse(data)
	if data.result == 1 then
		if data.param1 == 3 then
			for i,v in ipairs(data.a_param1) do
				PlayerData.addItem(v)
			end
			
			local stage = GameConfig["Stage"][data.param2]
			local chapter = UnionListData:getChapterDataById(stage.Chapter)
			local energy = chapter:getCostPower()
			local userLv = UserData:getUserLevel()
			local gold = stage.Gold + userLv * 50 * energy
			local uCoin = math.floor(userLv/10) + 1
			
			UserData:addGold(gold)
			UserData:addUnionValue(uCoin)
			UserData:addUnionPower(-energy)
			UnionListData:setStageLeftTimes(data.param2,-1)

			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
			return
		end

		-- 正常物品
		local arrItems = data.a_param1 or {}
		local arrShow = {}
		for i,v in ipairs(arrItems) do
			UserData:rewardItems(v)
			local showItem = UserData:parseItems(v)
			table.insert(arrShow, showItem)
		end

		-- 补偿药水
		local arrDrugs = data.a_param2 or {}
		local drugShow = {}
		for i,v in ipairs(arrDrugs) do
			UserData:rewardItems(v)
			local drugs = UserData:parseItems(v)
			table.insert(drugShow, drugs)
		end

		-- 关卡数据
		local stageId = tostring(data.param2)
		local stage = ChapterData:getStage(stageId)
		local chapter = ChapterData:getChapter(stage.chapterId)
		local count = table.nums(arrItems) 				-- 扫荡次数
		local gold = stage.gold 		 				-- 获得金币 基础
		local soul = stage.soul 		 				-- 获得灵能值 基础
		local exp  = stage:getTeamExp() 		 		-- 获得战队经验 基础
		local power  = chapter.power 					-- 消耗体力

		local preLv = UserData:getUserLevel()
		local exp1 = UserData.totalExp  				-- 之前 经验值

		local haveExp = UserData.totalExp
		local costPower = power * count
		local getGold = 0
		local getSoul = 0
		local golds = {}
		local souls = {}

		for i=1,count do
			local level = GameExp.getUserLevel(haveExp)
			local oneGold = gold + level * 10 * power 				-- 计算 一次获得金币
			local oneSoul = soul + math.floor(level * 0.2 * power) 	-- 计算 获得灵能值
			getGold = getGold + oneGold
			getSoul = getSoul + oneSoul

			haveExp = haveExp + exp

			table.insert(golds, oneGold)
			table.insert(souls, oneSoul)
		end

		-- 获取神秘商店结束时间戳
		UserData:setSecretTime(data.param5)

		-- 判断是否出现神秘商店开启提示
		local isSecretTalk
        if not UserData:getIsOpenSecretShop() then
        	if UserData:getSecretTime() > UserData:getServerSecond() then
        		isSecretTalk = {
	        		isOpen_ = true
	        	}
        		isSecretTalk.isOpen = true
        	end
        end

		-- 增加玩家 金币、灵能值、战队经验 是否开启神秘商店标识
		UserData:addGold(getGold)
		UserData:addSoul(getSoul)
		UserData:setExp(haveExp)
		UserData:addPower(-costPower)
		if data.param4 == 1 then
			UserData:setIsOpenSecretShop(true)
		else
			UserData:setIsOpenSecretShop(false)
		end

		local power1 = UserData.power 	-- 当前体力值

		-- 升级获得体力
		local nowLv = UserData:getUserLevel()	-- 加经验后等级
		if nowLv > preLv then
			UserData:addPower(GlobalData.addPower * (nowLv - preLv))
		end


		-- 增加精英关卡通关次数
		if stage:isElite() then
			stage.passNum = stage.passNum + count
		end

		-- 更新任务数据
		if stage:isElite() then
			TaskData:addTaskParams("stageElit", count)
		else
			TaskData:addTaskParams("stageNormal", count)
		end

		-- 活动相关数据
		ActivityUtil.addParams("overStage", count)
		if stage:isElite() then
			ActivityUtil.addParams("overEliteStage", count)
		else
			ActivityUtil.addParams("overNoramlStage", count)
		end
		ActivityUtil.addParams("costPower", costPower)

		local levelUpData
		if nowLv > preLv then  -- 升级了
			levelUpData = {
				teamTotalExp 	= 	exp1,
				teamAppendExp 	= 	haveExp - exp1,
			}

			-- 显示升级数据
			levelUpData.levelUp = {
				power1 = power1, 				-- 升级前 体力
				power2 = UserData.power, 		-- 升级后 体力
				powerMax1 = GameExp.getLimitPower(exp1), 		-- 升级前 体力上限
				powerMax2 = GameExp.getLimitPower(haveExp),			-- 升级后 体力上限
				levelMax1 = GameExp.getHeroLimitLv(exp1), 			-- 升级前 英雄等级上限
				levelMax2 = GameExp.getHeroLimitLv(haveExp), 			-- 升级后 英雄等级上限
			}
		end

		local params = {
			items=arrShow,
			items2=drugShow,
			stageId=stageId,
			gold=golds,
			soul=souls
		}

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

		return {items=params, levelUp=levelUpData,isSecret = isSecretTalk}

	elseif data.result == -1 then -- 扫荡次数错误
		showToast({text="扫荡次数错误"})
	elseif data.result == -2 then
		print("星星数不足")
		ResponseEvent.lackStar()
	elseif data.result == -3 then
		ResponseEvent.lackPower()
	elseif data.result == -4 then
		print("已达最大挑战次数")
		ResponseEvent.lackBattle()
	end

end
function SaoDangResponse:ctor()
	--响应消息号
	self.order = 20005
	--返回结果,1 成功;-1 扫荡次数错误；-2，星星数不足; -3 体力不足；-4 已达最大挑战次数,-17 vip等级不足
	self.result =  ""
	--null
	self.a_param1 =  ""
	--null
	self.param2 =  ""
	--null
	self.a_param1 =  ""
	--null
	self.a_param2 =  ""
	--是否开启神秘商店，1：开启，0：不开启
	self.param4 =  ""
	--神秘商店关闭时间，-1:永不关闭(VIP),0：已经关闭,其他：商店关闭时间(返回关闭时间戳)
	self.param5 =  ""
end

return SaoDangResponse