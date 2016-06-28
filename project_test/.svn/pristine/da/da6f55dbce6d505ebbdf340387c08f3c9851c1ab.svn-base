local SaveZhuijiResultResponse = class("SaveZhuijiResultResponse")
function SaveZhuijiResultResponse:SaveZhuijiResultResponse(data)
	if data.result == 1 then 
		-- 增加掉落物品		
		local items  = data.a_param1 or {}
		UserData:rewardItems(items) 

		-- 活动数据	
		TaskData:addTaskParams("wanted", 1)		
		ActivityUtil.addParams("sunAndMoon", 1)
		--************ 需要服务器返回类型（暂时没有）********
		local battleType = checknumber(data.param2)
		if battleType == 1 then 
			ActivityUtil.addParams("sunLookingFor", 1)
		elseif battleType == 2 then 
			ActivityUtil.addParams("moonLookingFor", 1)
		end 

		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -15 then -- 追缉点不足
		showToast({text="追缉点不足", time = 3})
	end 
end
function SaveZhuijiResultResponse:ctor()
	--响应消息号
	self.order = 20028
	--返回结果,1 成功;
	self.result =  ""
	--胜利获得的物品
	self.a_param1 =  ""	
end

return SaveZhuijiResultResponse