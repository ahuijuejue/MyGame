local ModifyUnionSetUpResponse = class("ModifyUnionSetUpResponse")
function ModifyUnionSetUpResponse:ModifyUnionSetUpResponse(data)
    if data.result == 1 then
    	UnionListData.unionData.applyLv = tostring(data.param1)
    	UnionListData.unionData.applyType = tostring(data.param2)
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function ModifyUnionSetUpResponse:ctor()
	--响应消息号
	self.order = 30019
	--返回结果,1:成功,-2:不是管理员，无权查看，-1：其他错误
	self.result =  ""
	--申请人等级限制
	self.param1 =  ""
	--是否需要审批（1：需要，2：不需要）
	self.param2 =  ""
end

return ModifyUnionSetUpResponse
