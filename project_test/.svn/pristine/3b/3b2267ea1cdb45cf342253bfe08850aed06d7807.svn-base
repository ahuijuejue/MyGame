local CityQiangHuaResponse = class("CityQiangHuaResponse")
function CityQiangHuaResponse:CityQiangHuaResponse(data)
	if data.result == 1 then 
		local cityTypeId = data.param1 -- 建筑类型
		cityTypeId = tostring(cityTypeId)
		
		local cityData = CityData:getCity(cityTypeId)
		cityData.level = cityData.level+1
		local cost = CityData:getStrongCost(cityTypeId, cityData.level)
		UserData:addGold(-cost)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		
		-- 完成任务
		TaskData:addTaskParams("city", 1)

		-- 活动数据			
		ActivityUtil.addParams("upCityTimes", 1)

	elseif data.result == -1 then 
		showToast({text="已达当前最大等级"})
	elseif data.result == -2 then 
		showToast({text="金币不足"})
	end 

end
function CityQiangHuaResponse:ctor()
	--响应消息号
	self.order = 10045
	--返回结果,1 成功; -1 已达战队等级；-2 货币不足
	self.result =  ""
	--强化后剩下的货币
	self.param1 =  ""
	--建筑类型：（1，主建筑,2 攻击，3 防御）
	self.param2 =  ""	
end

return CityQiangHuaResponse