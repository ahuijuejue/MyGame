local AppointUnionResponse = class("AppointUnionResponse")
function AppointUnionResponse:AppointUnionResponse(data)
    if data.result == 1 then
    	for i,v in ipairs(UnionListData.unionMemberData) do
            if data.param2 == 1 then
                if v.id == UserData.userId then
                    v.duty = "4"
                end
                if v.id == data.param1 then
                    v.duty = tostring(data.param2)
                end
            else
                if v.id == data.param1 then
                    v.duty = tostring(data.param2)
                    break
                end
            end
    	end
    	if data.param2 == 1 then
    		showToast({text = "转移成功！"})
    	elseif data.param2 == 2 or data.param2 == 3 then
    		showToast({text = "任命成功！"})
    	elseif data.param2 == 4 then
    		showToast({text = "取消成功！"})
    	end
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == 4 then
        showToast({text = "该职位数量已经到达上限！"})
    end
end
function AppointUnionResponse:ctor()
	--响应消息号
	self.order = 30016
	--返回结果,1:成功退出 ，2:不是管理员，3:级别不够
	self.result =  ""
	--公会名称
	self.param1 =  ""
	--公会图标
	self.param2 =  ""
end

return AppointUnionResponse
