local ShowTeamDefenseInfoProcess = class("ShowTeamDefenseInfoProcess")

function ShowTeamDefenseInfoProcess:ctor()
	--请求消息号
	self.order = 30107
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--战队userid
	self.param1 =  ""
	--排行榜类型
	self.param2 =  ""
	--战队经验 星星数 战力
	self.param3 =  ""
end


function ShowTeamDefenseInfoProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
	}
	return data
end

return ShowTeamDefenseInfoProcess
