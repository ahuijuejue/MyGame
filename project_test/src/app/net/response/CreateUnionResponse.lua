local CreateUnionResponse = class("CreateUnionResponse")
local UnionModel = import("app.data.UnionModel")
function CreateUnionResponse:CreateUnionResponse(data)
    if data.result == 1 then
        -- 公会基本信息
        local UnionModel = UnionModel.new({
                id            = data.param3,
                icon          = data.param2,
                exp           = data.param5,
                name          = data.param1 ,
                info          = data.param10,
                memberNums    = data.param6,
                memberMaxNums = data.param7 ,
                applyLv       = data.param8,
                applyType     = data.param9,
                })
        UnionListData:insertUnionData(UnionModel)

        -- 公会成员信息table
        UnionListData.unionMemberData = {}
        if #data.a_param1 > 0 then
            for i,v in ipairs(data.a_param1) do
                UnionListData:insertUnionMemberData(UnionModel:unionMember(v))
            end
        end

    	local cost = tonumber(GameConfig.ConsortiaInfo["1"].Consortiaestablishcost)
    	UserData:addDiamond(-cost)

        UnionListData.isTheNewUnion = 1
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == -3 then
    	showToast({text = "钻石不足！"})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -2 then
    	showToast({text = "等级不足！"})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
	elseif data.result == -1 then
    	showToast({text = "参数非法(名称或图标为空)"})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == 2 then
    	showToast({text = "公会名过长！"})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == 3 then
    	showToast({text = "公会名含有非法字符！"})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    elseif data.result == 4 then
    	showToast({text = "公会名已存在！"})
        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end

end
function CreateUnionResponse:ctor()
	--响应消息号
	self.order = 30004
	--返回结果,1 成功,-1:参数非法(名称或图标为空),-2:等级不足,-3:钱不够,-4:玩家已经加入了公会,2:公会名字超长(12个字符), 3:名字含有非法字符, 4:名字已经被使用
	self.result =  ""
	--公会名称
	self.param1 =  ""
	--公会图标
	self.param2 =  ""
	--公会ID
	self.param3 =  ""
	--公会经验
	self.param5 =  ""
	--公会会员数量
	self.param6 =  ""
	--公会会员数量上限
	self.param7 =  ""
	--申请加入等级
	self.param8 =  ""
	--申请类型
	self.param9 =  ""
	--公会说明
	self.param10 =  ""
	--工会成员信息
	self.a_param1 =  ""
end

return CreateUnionResponse
