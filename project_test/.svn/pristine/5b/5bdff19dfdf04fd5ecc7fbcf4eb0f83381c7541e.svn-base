local UnionEliminateResponse = class("UnionEliminateResponse")
function UnionEliminateResponse:UnionEliminateResponse(data)
    if data.result == 1 then
        -- UnionListData.unionData.memberNums = tostring(tonumber(UnionListData.unionData.memberNums) - 1)
    	for i,v in ipairs(UnionListData.unionMemberData) do
    		if v.id == data.param1 then
    			table.remove(UnionListData.unionMemberData, i)
    			break
    		end
    	end
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function UnionEliminateResponse:ctor()
	--响应消息号
	self.order = 30013
	--返回结果,1:成功退出 ,-1:非法操作()
	self.result =  ""
	--被踢出人的userid
	self.param1 =  ""
end

return UnionEliminateResponse
