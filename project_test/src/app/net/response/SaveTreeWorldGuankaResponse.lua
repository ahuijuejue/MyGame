local SaveTreeWorldGuankaResponse = class("SaveTreeWorldGuankaResponse")

function SaveTreeWorldGuankaResponse:ctor()
	--响应消息号
	self.order = 20025
	--返回结果,1 成功;
	self.result =  ""	
end

function SaveTreeWorldGuankaResponse:SaveTreeWorldGuankaResponse(data)
	if data.result == 1 then 
		TreeData:addWinTimes(1)
		TreeData:addTotalWin(1) -- 累加通关总层数
		-- 活动数据			
		ActivityUtil.addParams("treeLevel", 1)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end 
end

return SaveTreeWorldGuankaResponse