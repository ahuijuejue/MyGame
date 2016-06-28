local CallBackMercenaryResponse = class("CallBackMercenaryResponse")
function CallBackMercenaryResponse:CallBackMercenaryResponse(data)
    if data.result == 1 then
        local heroLevel = 0
        local agentTimes = 0
        local agentTime = 0
    	for i,v in ipairs(UnionListData.ownAgentData) do
            if v.roleId == data.param1 then
                heroLevel = v.level
                agentTimes = v.useTimes
                agentTime = v.sendTime
                table.remove(UnionListData.ownAgentData, i)
                break
            end
        end
        for i,v in ipairs(UnionListData.allAgentData) do
            if v.roleId == data.param1 then
                table.remove(UnionListData.allAgentData, i)
                break
            end
        end
    	-- 增加获得佣金
        local gold = UnionListData:getTotalGain( heroLevel, agentTime, agentTimes)
        UserData:addGold(gold)

        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function CallBackMercenaryResponse:ctor()
	--返回结果,1:成功，其他:非法数据
	self.result =  ""
	--英雄id
	self.param1 =  ""
end

return CallBackMercenaryResponse
