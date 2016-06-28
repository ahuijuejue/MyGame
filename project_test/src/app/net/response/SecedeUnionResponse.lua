local SecedeUnionResponse = class("SecedeUnionResponse")
function SecedeUnionResponse:SecedeUnionResponse(data)
    if data.result == 1 then
    	UnionListData:cleanData()
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == 2 then
    	showToast({text = "会长不能退出，请转移公会会长职位后退出！"})
    end
end
function SecedeUnionResponse:ctor()
	--响应消息号
	self.order = 30011
	--返回结果,1:成功退出 ，2:会长不能退出，-1:非法操作()
	self.result =  ""
end

return SecedeUnionResponse
