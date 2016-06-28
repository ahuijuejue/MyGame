local UnionSignResponse = class("UnionSignResponse")
function UnionSignResponse:UnionSignResponse(data)
    if data.result == 1 then
    	UnionListData.isSignIn[data.param1] = "1"

        local cost = tonumber(GameConfig.ConsortiaCredit[tostring(data.param1)].CostItemNum)
    	if GameConfig.ConsortiaCredit[tostring(data.param1)].CostItemID == 1 then
        	UserData:addGold(-cost)
        elseif GameConfig.ConsortiaCredit[tostring(data.param1)].CostItemID == 2 then
        	UserData:addDiamond(-cost)
        end
        -- 增加公会经验  公会币
        local unionData = GameConfig.ConsortiaCredit[tostring(data.param1)].GetItemID
        local unionCounts = GameConfig.ConsortiaCredit[tostring(data.param1)].GetItemNum

        for i,v in ipairs(unionData) do
            if v == "13" then -- 公会币
                UserData:addUnionValue(tonumber(unionCounts[i]))
            end
        end

        -- 增加公会经验
        local unionExp = GameConfig.ConsortiaCredit[tostring(data.param1)].GetConsortiaExp
        UnionListData:setUnionExp(unionExp)
        if UnionListData:getLevel(tonumber(UnionListData.unionData.exp)) > UserData.unionLevel then
            UserData.unionLevel = UnionListData:getLevel(tonumber(UnionListData.unionData.exp))
        end

        -- 增加今日贡献 累计贡献
        for i,v in ipairs(UnionListData.unionMemberData) do
            if v.id == UserData.userId then
                local todayCon_ = tonumber(v.todayCon) + unionExp
                local todalCon_ = tonumber(v.totalCon) + unionExp
                v.todayCon = tostring(todayCon_)
                v.totalCon = tostring(todalCon_)
                break
            end
        end

        GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    end
end
function UnionSignResponse:ctor()
	--响应消息号
	self.order = 30010
	--返回结果,1:成功申请
	self.result =  ""
	--礼拜类型
	self.param1 =  ""
end

return UnionSignResponse