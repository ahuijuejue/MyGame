local GetWuLaoFengRewardResponse = class("GetWuLaoFengRewardResponse")

function GetWuLaoFengRewardResponse:ctor()
	--响应消息号
	self.order = 20011
	--返回结果,1 成功;-1 未开放,-2 次数已用完,-3 等级不足;-4 难度不存在；
	self.result =  ""	
end

function GetWuLaoFengRewardResponse:GetWuLaoFengRewardResponse(data)
	if data.result == 1 then 
		-- 增加完成次数
		local mount = TrialData:getTrial("mount")
		mount:addTimes()
		-- 完成任务 
		TaskData:addTaskParams("holyLand", 1)
		
		-- 活动数据			
		ActivityUtil.addParams("holylandTimes", 1)
		ActivityUtil.addParams("mountainTimes", 1)

		local items = string.split(data.param1, "_")
		for i,v in ipairs(items) do
			local item = string.split(v,"#")
	    	ItemData:addMultipleItem(item[1],tonumber(item[2]))
		end
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

return GetWuLaoFengRewardResponse