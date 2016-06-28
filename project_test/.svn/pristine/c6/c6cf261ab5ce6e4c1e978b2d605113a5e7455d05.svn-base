local SelectAincradBuffProcess = class("SelectAincradBuffProcess")

function SelectAincradBuffProcess:ctor()
	--请求消息号
	self.order = 20016
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--buff的真实ID，取值范围1-5
	self.param1 =  ""
	--buffid的唯一标识，20015接口中的param2
	self.param2 =  ""	
end


function SelectAincradBuffProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		teamid = self.teamid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		
	}
	return data
end

return SelectAincradBuffProcess