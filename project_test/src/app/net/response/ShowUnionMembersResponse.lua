local ShowUnionMembersResponse = class("ShowUnionMembersResponse")
function ShowUnionMembersResponse:ShowUnionMembersResponse(data)
    if data.result == 1 then
    	-- UnionListData.unionArenaId = data.param1
    	UnionListData.times = data.param2
        UnionListData.timesCost = data.param3
    	if #data.a_param1 > 0 then
    		UnionListData.unionArenaMembers = {}
    		for i,v in ipairs(data.a_param1) do
                local model = require("app.model.UnionMemberModel").new()
                model:setUserId(v.userid)
                model:setTeamId(v.teamid)
                model:setUserName( v.name )
                model:setUserCombat( v.combat )
                model:setUserHeadIcon( v.headSrc )
                model:setUserLevel( v.exp )
                model:setUserDuty( v.duty )
                model:setUserVipLevel( v.viplevel )
                for i,v in ipairs(v.a_param1) do
                    local param = PlayerData.parseHero(v)
                    local hero = require("app.data.ArenaRole").new(param)
                    model:insertHero(hero)
                end

                local starInfo = parseTailsStar(v.param2)
                local tailsList = convertTailsList(v.param3)
                local starList = {}
                for i,w in ipairs(tailsList) do
                    local star = tonumber(starInfo[w]) or 1
                    table.insert(starList, star)
                end
                model:setTailsIdList(tailsList)
                model:setTailsStarList(starList)
                model:setSealLevel(checknumber(v.param4))

	    		UnionListData:insertUnionArenaMember(model)
	    	end
    	end
    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})
    else
    	--todo
    end
end
function ShowUnionMembersResponse:ctor()
	--返回结果,1:成功
	self.result =  ""
	--公会ID
	self.param1 =  ""
	--工会成员信息
	self.a_param1 =  ""
end

return ShowUnionMembersResponse