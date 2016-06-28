local UseItemResponse = class("UseItemResponse")

function UseItemResponse:ctor()
	--响应消息号
	self.order = 10050
	--返回结果,1 成功;-1 数量错误; -2 数量不足
	self.result =  ""
	--结果值
	self.param1 =  ""
	--物品类型
	self.param2 =  ""
end

function UseItemResponse:UseItemResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local itemId = data.param2
		local count = data.param3
		local config = GameConfig.item[itemId]
		ItemData:reduceMultipleItem(itemId,count)

		if config.Type == 6 then
			local exp = config.Content.exp * count
			local hero = HeroListData:getRoleWithId(heroId)
			local oldLv = hero.level

			hero.exp = GameExp.getFinalExp(hero.exp,exp)
			hero:setLevel(GameExp.getLevel(hero.exp))

			TaskData:addTaskParams("useExpWater",count)
			TaskData:addTaskParams("upHeroLevel",hero.level - oldLv)
		elseif config.Type == 7 or config.Type == 23 then
			PlayerData.addItem(data.a_param1)
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
		elseif config.Type == 15 then
			local value = config.Content.Value * count
			UserData:addSoul(value)
			
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
		elseif config.Type == 17 then
			local value = config.Content.Value * count
			UserData:addCityValue(value)

			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
		end
	end
end

return UseItemResponse