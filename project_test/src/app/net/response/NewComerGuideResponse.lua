local NewComerGuideResponse = class("NewComerGuideResponse")

function NewComerGuideResponse:NewComerGuideResponse(data)
	if data.result == 1 then 
		local key = data.param1
		GuideData:setCompleted_(key)
		
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -1 then 
		showToast({text="新手引导参数错误"})
	end
end

function NewComerGuideResponse:ctor()
	--响应消息号
	self.order = 10064
	--返回结果,1 成功;-1 参数错误
	self.result =  ""	
end

return NewComerGuideResponse