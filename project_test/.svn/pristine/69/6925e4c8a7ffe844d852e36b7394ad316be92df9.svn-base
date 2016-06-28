local SendMercenaryResponse = class("SendMercenaryResponse")
function SendMercenaryResponse:SendMercenaryResponse(data)
    if data.result == 1 then
    	for i,v in ipairs(UnionListData.heroList_) do
            if v.roleId == data.param1 then
                v.teamId = UserData.teamId
                v.userId = UserData.userId
                v.teamName = UserData.name
                v.sendTime = data.param2
                v.useTimes = 0
                UnionListData:insertOwnAgentData( v )
                UnionListData:insertAllAgentData( v )
                break
            end
        end
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function SendMercenaryResponse:ctor()
	--返回结果,1:成功，其他:非法数据
	self.result =  ""
	--英雄id
	self.param1 =  ""
end

return SendMercenaryResponse
