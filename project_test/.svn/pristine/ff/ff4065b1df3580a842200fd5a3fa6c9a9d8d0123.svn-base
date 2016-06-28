local SealResponse = class("SealResponse")
function SealResponse:SealResponse(data)
	if data.result == 1 then 
		-- 封印成功
		local param1 = data.param1 		-- 封印消耗物品
		local id_str = string.split(param1, ",")

		-- 物品数据中除去消耗的物品
		local addExp = 0 			-- 增加的封印值
		for i,v in ipairs(id_str) do
			local itemInfo = string.split(v, "_") 
			if table.nums(itemInfo) == 2 then 
				local itemId = itemInfo[1]
				local nItem = checknumber(itemInfo[2])
				
				local item = ItemData:getItem(itemId) 
				if item then 
					addExp = addExp + item.seal * nItem
					ItemData:reduceItem(itemId, nItem) 
				else
					print("没有此物品")
				end 
			end 
		end

		local cost = SealData:getSealCost(addExp) 	-- 消耗的金币
		local sealLevel = SealData:getSealLevel()

		-- 消耗金币
		UserData:addGold(-cost)
		-- 增加封印经验
	    SealData:addSealExp(addExp)

	    if SealData:getSealLevel() ~= sealLevel then -- 封印层级变动，导致英雄加成改变
	    	PlayerData.updateHeros()
	    end 

		-- 增加任务进度
		TaskData:addTaskParams("seal", 1) 

		-- 活动数据			
		ActivityUtil.addParams("sealTimes", 1)
	    
	    -- 奖励 
	    local items = data.a_param1 
	    UserData:rewardItems(items)
	    local showItems = UserData:parseItems(items)

	    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})

		return {items=showItems}
	elseif data.result == -1 then -- 物品不存在
		showToast({text="物品不存在"})
	elseif data.result == -2 then -- 金币不足
		ResponseEvent.lackGold()
	elseif data.result == -3 then -- 已达封印最大值
		showToast({text="已达封印最大值"})

	end 
end
function SealResponse:ctor()
	--响应消息号
	self.order = 10040
	--返回结果,1 成功;
	self.result =  ""	
end

return SealResponse