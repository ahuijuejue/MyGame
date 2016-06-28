local CityUpStarReponse = class("CityUpStarReponse")
function CityUpStarReponse:CityUpStarReponse(data)
	if data.result == 1 then 
		local cityTypeId = tostring(data.param1)
		local cityData = CityData:getCity(cityTypeId)
		local nextId = cityData.data.nextCityId
		if nextId then 			
			CityData:didCostStarUpItems(cityTypeId) -- 消耗升星材料
			CityData:setCity(cityTypeId, nextId)

		else 
			showToast("没有找到下一星级数据")
			print("没有找到下一星级数据")
		end 

	elseif data.result == -1 then
		showToast({text="已达最大星星"})
	elseif data.result == -2 then 
		showToast({text="材料不足"})
	end 

end
function CityUpStarReponse:ctor()
	--响应消息号
	self.order = 10047
	--返回结果,1 成功;-1 已达最大星星 ；-2 材料不足
	self.result =  ""
	--建筑类型：（1，主建筑,2 攻击，3 防御）
	self.param1 =  ""	
end

return CityUpStarReponse