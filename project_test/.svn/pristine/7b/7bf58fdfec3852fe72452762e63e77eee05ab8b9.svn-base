local SaveBattleResultResponse = class("SaveBattleResultResponse")

function SaveBattleResultResponse:SaveBattleResultResponse(data)
	if data.result == 1 then
		if data.param1 == 3 then
			local stageModel = UnionListData.stageData[data.param2]
			if stageModel then
				if data.param4 > stageModel.star then
					stageModel.star = data.param4
				end
			else
				stageModel = require("app.model.StageModel").new()
				stageModel:addStar(data.param4)
				UnionListData.stageData[data.param2] = stageModel
			end
			stageModel:addLeftTimes(-1)

			local stage = GameConfig["Stage"][data.param2]
			local chapter = UnionListData:getChapterDataById(stage.Chapter)
			local energy = chapter:getCostPower()
			local uLv = UserData:getUserLevel()
			local gold = uLv * 50 * energy + stage.Gold
			local uCoin = math.floor(uLv/10) + 1

			UserData:addGold(gold)
			UserData:addUnionValue(uCoin)
			UserData:addUnionPower(-energy)
			PlayerData.addItem(data.a_param1)

			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
			return
		end
		-- 关卡数据
		local stage = ChapterData:getStage(tostring(data.param2))
		local chapter = ChapterData:getChapter(stage.chapterId)
		local gold = stage.gold			-- 获得金币
		local soul = stage.soul			-- 获得灵能值
		local exp  = stage:getTeamExp()	-- 获得战队经验
		local heroExp = stage.heroExp 	-- 获得英雄经验
		local power  = chapter.power 	-- 消耗体力
		local preLv = UserData:getUserLevel() -- 加经验前 战队等级
		local getGold = gold + preLv * 10 * power 				-- 计算后 获得金币
		local getHeroExp = heroExp + preLv * power 				-- 计算后 获得英雄经验
		local getSoul = soul + math.floor(preLv * 0.2 * power) 	-- 计算后 获得灵能值

		-- 增加掉落物品
		local sItems = data.a_param1 -- 物品
		UserData:rewardItems(sItems)
		-- 增加玩家 金币、灵能值、战队经验
		UserData:addGold(getGold)
		UserData:addSoul(getSoul)
		UserData:addExp(exp)
		UserData:addPower(-power)

		-- 获取神秘商店结束时间戳
		UserData:setSecretTime(data.param6)
        -- 显示神秘商店出现提示  UserData:getIsOpenSecretShop()
        if UserData:getIsOpenSecretShop() then
        	UserData:setSecretShopTip(false)
        else
        	if UserData:getSecretTime() > UserData:getServerSecond() then
        		UserData:setSecretShopTip(true)
        	else
                UserData:setSecretShopTip(false)
        	end
        end

		-- 是否开启神秘商店标识
		if data.param5 == 1 then
			UserData:setIsOpenSecretShop(true)
		else
			UserData:setIsOpenSecretShop(false)
		end

		-- 升级获得体力
		local nowLv = UserData:getUserLevel()	-- 加经验后等级
		if nowLv > preLv then
			UserData:addPower(GlobalData.addPower * (nowLv - preLv))
		end
		-- 增加英雄经验
		local heroStr = data.param3
		local heros = string.split(heroStr, ",")
		for i,v in ipairs(heros) do
			PlayerData.incHeroExp(v, getHeroExp)
		end
		-- 增加精英关卡通关次数
		if stage:isElite() then
			stage.passNum = stage.passNum + 1
		end
		-- 更新一些关卡数据
		local passLv = checknumber(data.param4) 		-- 关卡通关星级
		if stage.passLevel < passLv then
			stage.passLevel = passLv
		end
		-- 更新任务数据
		if stage:isElite() then
			TaskData:addTaskParams("stageElit", 1)
		else
			TaskData:addTaskParams("stageNormal", 1)
		end
		-- 新手引导数据
		local guideKey = data.param100
		if guideKey then
			GuideData:setCompleted_(guideKey)
		end

		-- 活动相关数据
		ActivityUtil.addParams("overStage", 1)
		if stage:isElite() then
			ActivityUtil.addParams("overEliteStage", 1)
		else
			ActivityUtil.addParams("overNoramlStage", 1)
		end
		ActivityUtil.addParams("costPower", power)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

function SaveBattleResultResponse:ctor()
	--响应消息号
	self.order = 20004
	--返回结果,1 成功;
	self.result =  ""
	--抽到的物品id
	self.a_param1 =  ""
	--关卡id
	self.param2 =  ""
	--所有参战英雄id
	self.param3 =  ""
	--量星数
	self.param4 =  ""
	--是否开启神秘商店，1：开启，0：不开启
	self.param5 =  ""
	--神秘商店关闭时间，-1:永不关闭(VIP),0：已经关闭,其他：商店关闭时间(返回关闭时间戳)
	self.param6 =  ""
	--新手引导字段
	self.param100 =  ""
end

return SaveBattleResultResponse