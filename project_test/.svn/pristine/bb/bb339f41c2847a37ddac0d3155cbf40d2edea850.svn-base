local UpHeroSkillLevelResponse = class("UpHeroSkillLevelResponse")

function UpHeroSkillLevelResponse:ctor()
	--响应消息号
	self.order = 10017
	--返回结果,-1，技能不存在，-2 技能等级已最大,-3 不能大于英雄等级，-4，灵能值不足,1 成功
	self.result =  ""	
end

function UpHeroSkillLevelResponse:UpHeroSkillLevelResponse(data)
	if data.result == 1 then
		TaskData:addTaskParams("upHeroSkill", 1)
		-- 活动统计
		ActivityUtil.addParams("upHeroSkill", 1)
		
		local heroId = data.param1
		local skillId = data.param2
		local hero = HeroListData:getRoleWithId(heroId)
		local level = hero.skillLevel[skillId]
		hero.skillLevel[skillId] = level + 1

		local pos = 0
		for i=1,#hero.skills do
			if hero.skills[i] == skillId then
				pos = i
			end
		end

		local info = 0
		if pos == 4 then
			hero:updateProperty()
			info = GameConfig.skill_4[skillId]
		else
			info = GameConfig.skill[skillId]
		end

		local consumeInfo = GameConfig.consume[tostring(level+1)]
		local key = string.format("SkillConsume_%d",pos)
		local upCost = consumeInfo[key] * tonumber(info.level_money)
		UserData:addSoul(-upCost)		

	    local limitPoint = tonumber(GameConfig.Global["1"].SkillPointLimit)
		if UserData:getSkillPoint() == limitPoint then
			UserData.skillPoint = limitPoint
			UserData.skillRecoverTime = UserData.curServerTime
		end
		UserData:addSkillPoint(-1)

    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return UpHeroSkillLevelResponse