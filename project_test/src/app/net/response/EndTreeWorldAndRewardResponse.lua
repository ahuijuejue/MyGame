local EndTreeWorldAndRewardResponse = class("EndTreeWorldAndRewardResponse")
function EndTreeWorldAndRewardResponse:EndTreeWorldAndRewardResponse(data)
	if data.result == 1 then 
		local items = data.a_param1 or {}

		local times = TreeData.useTimes
		TreeData:resetData()
		TreeData.useTimes = times 

		-- 活动数据			
		ActivityUtil.addParams("treeBattle", 1)
		
		-- 增加奖励物品
		UserData:rewardItems(items) 
		local showItems = UserData:parseItems(items)

		return {items=showItems}
	end 

end
function EndTreeWorldAndRewardResponse:ctor()
	--响应消息号
	self.order = 20024
	--返回结果,1 成功;
	self.result =  ""
	--抽到的物品id
	self.a_param1 =  ""	
end

return EndTreeWorldAndRewardResponse