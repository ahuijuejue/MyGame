local BeginBattleResponse = class("BeginBattleResponse")
function BeginBattleResponse:BeginBattleResponse(data)
	if data.result == 1 then
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})		
		if data.param2 and data.param2 ~= "" then 
			UserData:setBattleList(string.split(data.param2, ","))
		end 
		local dropArr = dataToItem(data.param1)			
		return {drops = dropArr} 
	elseif data.result == -1 then 
		ResponseEvent.lackPower()
	elseif data.result == -2 then 
		ResponseEvent.lackBattle()
	elseif data.result == -3 then 
		ResponseEvent.lackLevel()
	elseif data.result == -4 then 
		ResponseEvent.stageNotOpen()
	end 
end
function BeginBattleResponse:ctor()
	--响应消息号
	self.order = 20003
	--返回结果,1 成功;
	self.result =  ""
	--要掉落的物品，格式：物品id#数量_物品id#数量
	self.param1 =  ""	
end

return BeginBattleResponse