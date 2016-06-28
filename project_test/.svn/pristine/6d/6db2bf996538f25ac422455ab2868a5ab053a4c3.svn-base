local GetSpiritHomeRewardResponse = class("GetSpiritHomeRewardResponse")

function GetSpiritHomeRewardResponse:ctor()
	--响应消息号
	self.order = 20010
	--返回结果,1 成功;-1 未开放,-2 次数已用完,-3 等级不足;-4 难度不存在；
	self.result =  ""	
end

function GetSpiritHomeRewardResponse:GetSpiritHomeRewardResponse(data)
	if data.result == 1 then 		
		local items = data.a_param1 or {}
		local light = TrialData:getTrial("time")
		-- 增加完成次数
		light:addTimes()
		-- 完成任务 
		TaskData:addTaskParams("holyLand", 1) 
		-- 增加获得物品 
		for k,v in pairs(items) do
		 	local itemId = tostring(v.param1) 
		 	local uId = v.param2 or itemId
		 	local nItem = tonumber(v.param3)
		 	ItemData:addItem(uId, itemId, nItem) 
		end

		-- 活动数据			
		ActivityUtil.addParams("holylandTimes", 1)
		ActivityUtil.addParams("houseTimes", 1)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -1 then 	-- 未开放
		showToast({text="未开放"})
	elseif data.result == -2 then 	-- 次数已用完
		showToast({text="今日次数已用完"})
	elseif data.result == -3 then 	-- 等级不足
		showToast({text="等级不足"})
	elseif data.result == -4 then 	-- 难度不存在 
		showToast({text="难度不存在"})
	end 
end

return GetSpiritHomeRewardResponse