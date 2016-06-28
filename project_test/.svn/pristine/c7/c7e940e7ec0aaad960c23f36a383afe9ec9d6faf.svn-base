local ShowTeamDefenseInfoResponse = class("ShowTeamDefenseInfoResponse")
function ShowTeamDefenseInfoResponse:ShowTeamDefenseInfoResponse(data)
    if data.result == 1 then

		local teamData = {}
        for k,v in pairs(data.a_param1 or {}) do
            local team = PlayerData.parseArenaTeam(v)
            table.insert(teamData, team)
        end

        teamData[1].score_ = data.param3
        teamData[1].vip = data.param4

        UserData:showTeamInfo(teamData[1], data.param2)

    end
end
function ShowTeamDefenseInfoResponse:ctor()
	--返回结果,1 成功; 其他:非法操作
	self.result =  ""
	--排行榜战队信息
	self.a_param1 =  ""
end

return ShowTeamDefenseInfoResponse
