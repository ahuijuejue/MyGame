local FinishGeneralActivityResponse = class("FinishGeneralActivityResponse")

function FinishGeneralActivityResponse:ctor()
	--响应消息号
	self.order = 30003
	--返回结果,1 成功; -1 活动已经完成过或条件不足
	self.result =  ""
	--任务id
	self.param1 =  ""
	--奖励 的物品id
	self.a_param1 =  ""	
end

function FinishGeneralActivityResponse:FinishGeneralActivityResponse(data)
	if data.result == 1 then 
		local dataId = data.param1 		-- 活动id 
		local items = data.a_param1 	-- 奖励的物品

		local data1 = ActivityNormalData:getActivityData(dataId) 
		data1:setCompleted(true)

		if data1.okCode == 28 then -- 交换物品
			local oknums = data1.okParam2
			local okids = data1.okParam1
			for i,v in ipairs(okids) do
				local itemId = tostring(v)
				local itemCount = checknumber(oknums[i])				
				UserData:removeItem(itemId, itemCount)
			end
		end 

		PlayerData.addItem(items)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -1 then 
		showToast({text="活动已经完成过或条件不足", time=3})
	end 
end

return FinishGeneralActivityResponse