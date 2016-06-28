local GetShanDuoLaRewardResponse = class("GetShanDuoLaRewardResponse")

function GetShanDuoLaRewardResponse:ctor()
	--响应消息号
	self.order = 20009
	--返回结果,1 成功;-1 未开放，-2 次数已用完,-3 等级不足; -4 一个没打破 
	self.result =  ""	
end

function GetShanDuoLaRewardResponse:GetShanDuoLaRewardResponse(data)
	if data.result == 1 then 
		local gold = checknumber(data.param1) 	-- 获得的金币 
		-- 增加奖励
		UserData:addGold(gold) 
		-- 增加完成次数
		local light = TrialData:getTrial("light")
		light:addTimes()
		-- 完成任务 
		TaskData:addTaskParams("holyLand", 1) 

		-- 活动数据			
		ActivityUtil.addParams("holylandTimes", 1)
		ActivityUtil.addParams("lightTimes", 1)

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -1 then 	-- 未开放
		showToast({text="未开放"})
	elseif data.result == -2 then 	-- 次数已用完
		showToast({text="今日次数已用完"})
	elseif data.result == -3 then 	-- 等级不足
		showToast({text="等级不足"})
	elseif data.result == -4 then 	-- 一个没打破 
		showToast({text="一个没打破"})
	end 
end

return GetShanDuoLaRewardResponse