local DianJinStartResponse = class("DianJinStartResponse")
function DianJinStartResponse:DianJinStartResponse(data)
	if data.result == 1 then 	
		local data2 = GoldAlert 
		local diamond 	= data2.gems 		-- 花费的钻石
		local gold 		= data2.gold 			-- 获得的金币
		local crit 		= tonumber(data.value)  -- 点金暴击
		if crit == 0 then crit = 1 end 
		UserData:addDiamond(-diamond)
		UserData:addGold(gold * crit)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})

		data2.times 	= tonumber(data.param1) 	-- 购买次数
		data2.timesMax 	= tonumber(data.param2)		-- 最大购买次数
		data2.gems 		= tonumber(data.diamond) -- 点金花费钻石
		data2.gold  	= tonumber(data.gold) 	-- 点金获得金币

		-- 更新日常任务数据
		TaskData:addTaskParams("gold", 1) 
		-- 活动数据
		ActivityUtil.addParams("buyGold", 1)

		return crit, gold 
	elseif data.result == 2 then 
		-- 今日次数已经用完		
		local data2 = GoldAlert
		data2.times = data2:getTimesMax()
		data2:check()
	elseif data.result == 3 then 
		-- 钻石不足
		ResponseEvent.lackGems()
	end 

end
function DianJinStartResponse:ctor()
	--响应消息号
	self.order = 10008
	--返回结果,如果成功才会返回下面的参数：1 成功,2 今日次数已用完 ；3 钻石不足
	self.result =  ""
	--已使用过的次数
	self.param1 =  ""
	--最大次数
	self.param2 =  ""
	--花费的钻石
	self.diamond =  ""
	--获得的金币
	self.gold =  ""
	--大于0是产生的暴击翻倍数，等于0无暴击效果
	self.value =  ""	
end

return DianJinStartResponse