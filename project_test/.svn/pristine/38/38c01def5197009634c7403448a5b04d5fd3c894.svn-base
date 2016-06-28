local XiangQianHeroNameChipResponse = class("XiangQianHeroNameChipResponse")

function XiangQianHeroNameChipResponse:ctor()
	--响应消息号
	self.order = 10018
	--返回结果,-1，条件不足，失败,1 成功
	self.result =  ""	
end

function XiangQianHeroNameChipResponse:XiangQianHeroNameChipResponse(data)
	if data.result == 1 then
		local heroId = data.param1
		local pos = data.param2
		local count = data.param3

		local hero = HeroListData:getRoleWithId(heroId)
		local nowNum = hero.coinNums[pos]
		local awakeInfo = GameConfig.skill_awake[hero.roleId]
		local key1 = string.format("SkillNameNum%d",math.min(hero.starLv+1,NAME_MAX_LEVEL))
		local needNum = awakeInfo[key1][pos]
		
		local key2 = string.format("SkillNameItemID%d",math.min(hero.starLv+1,NAME_MAX_LEVEL))
		local itemId = awakeInfo[key2][pos]
		local itemCount = ItemData:getItemCountWithId(itemId)
		local num = math.min(count,itemCount)

	    if num + nowNum > needNum then
		    ItemData:reduceMultipleItem(itemId,needNum-nowNum)
	    else
		    ItemData:reduceMultipleItem(itemId,num)
	    end

		nowNum = math.min(nowNum+num,needNum)
	    hero.coinNums[pos] = nowNum

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end

return XiangQianHeroNameChipResponse