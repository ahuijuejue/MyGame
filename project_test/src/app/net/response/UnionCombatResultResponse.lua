local UnionCombatResultResponse = class("UnionCombatResultResponse")

function UnionCombatResultResponse:ctor()
	--返回结果,1:成功，-1:挑战次数不足
	self.result =  ""
	--挑战对手的userid
	self.param1 =  ""
	--战斗结果,1:胜利,2:失败
	self.param2 =  ""
	--抽到的物品id
	self.a_param1 =  ""
end

function UnionCombatResultResponse:UnionCombatResultResponse(data)
	if data.result == 1 then
		UnionListData.times = UnionListData.times - 1
		if data.param2 == 1 then
			PlayerData.addItem(data.a_param1)
		else
			local exp = tonumber(UnionListData.unionData.exp)
			if UnionListData:getUnionExp(tonumber(UnionListData.unionData.exp)) > 0 then
				exp = exp - 1
				UnionListData.unionData.exp  = tostring(exp)
			end
		end
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
		GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.UPDATE_USER_RES})
	end
end

return UnionCombatResultResponse