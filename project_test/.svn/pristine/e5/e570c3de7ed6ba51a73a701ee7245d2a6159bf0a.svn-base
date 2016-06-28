local SHowUnionByPageResponse = class("SHowUnionByPageResponse")
local UnionModel = import("app.data.UnionModel")
function SHowUnionByPageResponse:SHowUnionByPageResponse(data)
    if data.result == 1 then
        if #data.a_param1>1 then
        	for i,v in ipairs(data.a_param1) do
				local UnionModel = UnionModel.new({
					id            = v.id,
					icon          = v.icon,
					exp           = v.exp,
					name          = v.name ,
					info          = v.declaration ,
					memberNums    = v.number,
					memberMaxNums = v.limit ,
					applyLv       = v.applyLevel,
					applyType     = v.applyType,
					isApply       = v.hasApply,
					})
		    	UnionListData:insertShowData(UnionModel)
			end
			GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
        end
    end
end
function SHowUnionByPageResponse:ctor()
	--响应消息号
	self.order = 30007
	--返回结果,1:成功
	self.result =  ""
	--页码
	self.param1 =  ""
	--工会列表
	self.a_param1 =  ""
end

return SHowUnionByPageResponse
