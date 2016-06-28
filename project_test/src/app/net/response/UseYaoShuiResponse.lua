local UseYaoShuiResponse = class("UseYaoShuiResponse")

function UseYaoShuiResponse:ctor()
	--响应消息号
	self.order = 10023
	--返回结果,1 成功
	self.result =  ""	
end

function UseYaoShuiResponse:UseYaoShuiResponse(data)
	dump(data)
	if data.result == 1 then
		local heroId = data.param1
		local itemId = data.param2
		local hero = HeroListData:getRoleWithId(heroId)
		local useTime = tonumber(GameConfig.Global["1"].SuperDrug)

		if itemId == SUPER_ITEM[1] then
			if hero.leaderWater > 0 then
				hero.leaderWater = hero.leaderWater + useTime
			else
				hero.leaderWater = UserData.curServerTime + useTime
			end
		elseif itemId == SUPER_ITEM[2] then
			if hero.memberWater > 0 then
				hero.memberWater = hero.memberWater + useTime
			else
				hero.memberWater = UserData.curServerTime + useTime
			end
		end

		ItemData:reduceMultipleItem(itemId,1)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return UseYaoShuiResponse