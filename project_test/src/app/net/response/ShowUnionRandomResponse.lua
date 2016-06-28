local ShowUnionRandomResponse = class("ShowUnionRandomResponse")
function ShowUnionRandomResponse:ShowUnionRandomResponse(data)
    if data.result == 1 then
    	if #data.a_param1 > 0 then
    		UnionListData.unionArenaList = {}
    		for i,v in ipairs(data.a_param1) do
	    		UnionListData:insertUnionAreanList(v)
	    	end
    	end
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    else
    	--todo
    end
end
function ShowUnionRandomResponse:ctor()
	--返回结果,1:成功
	self.result =  ""
	--工会信息
	self.a_param1 =  ""
end

return ShowUnionRandomResponse
