local ModifyUnionInfoResponse = class("ModifyUnionInfoResponse")
function ModifyUnionInfoResponse:ModifyUnionInfoResponse(data)
	if data.result == 1 then
		if data.param1 == 1 then     -- 签名
			UnionListData.unionData.info = data.param2
	    elseif data.param1 == 2 then -- 公告
	    	UnionListData.unionData.notice = data.param2
	    elseif data.param1 == 3 then -- 图标
	    	UnionListData.unionData.icon = data.param2
		end
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	end
end
function ModifyUnionInfoResponse:ctor()
	--响应消息号
	self.order = 30015
	--返回结果,1:成功退出 ，2:没有权限，-1:异常错误
	self.result =  ""
	--1:签名，2:公告，3:图标
	self.param1 =  ""
	--内容
	self.param2 =  ""
end

return ModifyUnionInfoResponse
