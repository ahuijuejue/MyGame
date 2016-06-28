local FinishTaskResponse = class("FinishTaskResponse")
function FinishTaskResponse:FinishTaskResponse(data)
	if data.result == 1 then 
		local taskId = data.param1 		-- 任务id 
		local items = data.a_param1 	-- 奖励的物品

		local task = TaskData:getTask(taskId) 
		task.completed = true 
		-- 领取奖励前数据
		local power1 = UserData.power 			-- 升级前 体力
		local exp1 = UserData.totalExp  		-- 之前 经验值		
		local level1 = UserData:getUserLevel()	-- 之前 等级
		
		-- 增加奖励物品
		UserData:rewardItems(items) 

		-- 领取奖励后数据
		local exp2 = UserData.totalExp			-- 之后 经验值 
		local level2 = UserData:getUserLevel() 	-- 之后 等级
		local addLevel = level2 - level1 		-- 增加等级
		
		local levelUpData 
		if addLevel > 0 then  -- 升级了
			-- 升级奖励体力 
			UserData:addPower(GlobalData.addPower * addLevel)
			power2 = UserData.power 			-- 升级后 体力

			levelUpData = {
				teamTotalExp 	= 	exp1,
				teamAppendExp 	= 	exp2 - exp1,
			}

			-- 显示升级数据
			levelUpData.levelUp = {
				power1 = power1, 				-- 升级前 体力
				power2 = UserData.power, 		-- 升级后 体力
				powerMax1 = GameExp.getLimitPower(exp1), 		-- 升级前 体力上限
				powerMax2 = GameExp.getLimitPower(exp2),		-- 升级后 体力上限
				levelMax1 = GameExp.getHeroLimitLv(exp1), 			-- 升级前 英雄等级上限
				levelMax2 = GameExp.getHeroLimitLv(exp2), 			-- 升级后 英雄等级上限
			}
		end 

		local showItems = UserData:parseItems(items)		
		return {items=showItems, levelUp = levelUpData}

	elseif data.result == -1 then 
		showToast({text="任务完成条件不足"})
	elseif data.result == -2 then 
		showToast({text="任务已经完成过"})
	end 

end
function FinishTaskResponse:ctor()
	--响应消息号
	self.order = 10039
	--返回结果,1 成功;
	self.result =  ""	
end

return FinishTaskResponse