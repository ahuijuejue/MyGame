local FinishActivityResponse = class("FinishActivityResponse")
function FinishActivityResponse:FinishActivityResponse(data)
	if data.result == 1 then
		local dataId = data.param1 		-- 任务id
		local items = data.a_param1 	-- 奖励的物品

		local data = ActivityOpenData:getActivityData(dataId)
		data:setCompleted(true)
--------------------------------------------------------------

-- 增加奖励物品
		UserData:rewardItems(items)

		local showItems = UserData:parseItems(items)

		for k,v in pairs(showItems) do
			if v.itemId then
				local itemData = data.itemsDict[v.itemId]
				if itemData then
					v.quality = itemData.quality
				end
			end
		end

		return {items=showItems}

	elseif data.result == -10 then
		showToast({text="完成条件不足/已完成过", time=3})
	end

end
function FinishActivityResponse:ctor()
	--响应消息号
	self.order = 30001
	--返回结果,1 成功; -1 完成条件不足
	self.result =  ""
	--活动id
	self.param1 =  ""
	--奖励 的物品id
	self.a_param1 =  ""
end

return FinishActivityResponse