local GetSevenDayRewardResponse = class("GetSevenDayRewardResponse")
function GetSevenDayRewardResponse:GetSevenDayRewardResponse(data)
	if data.result == 1 then 
		local items = data.a_param1 -- 获得物品 
		local signTime = checknumber(data.param1) 	-- 七日签到 最近的签到时间
		
		SignInData.sevenDate = signTime 						-- 设置 七日签到 最近的签到时间
		SignInData.sevenCount = SignInData.sevenCount + 1	-- 增加签到次数 

		-- 增加奖励物品
		PlayerData.addItem(items)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		
		local showItems = UserData:parseItems(items)

		return {items=showItems}
	elseif data.result == -1 then 	-- 已完全领取 
		showToast({text="已完全领取"})
	elseif data.result == -2 then 	-- 今日已领取 
		showToast({text="今日已领取"})
	end 

end
function GetSevenDayRewardResponse:ctor()
	--响应消息号
	self.order = 10063
	--返回结果,1 成功;-1 ，已完全领取；-2 今日已领取
	self.result =  ""
	--抽到的物品id
	self.a_param1 =  ""	
end

return GetSevenDayRewardResponse