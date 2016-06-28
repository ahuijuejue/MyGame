local SelectAincradTeamProcess = class("SelectAincradTeamProcess")

function SelectAincradTeamProcess:ctor()
	--请求消息号
	self.order = 20012
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--对手teamid
	self.param1 =  ""	
end


function SelectAincradTeamProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		
	}
	return data
end

return SelectAincradTeamProcess