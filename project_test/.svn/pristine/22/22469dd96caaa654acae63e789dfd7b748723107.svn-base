local SearchUnionProcess = class("SearchUnionProcess")

function SearchUnionProcess:ctor()
	--请求消息号
	self.order = 30005
	--用户id
	self.userid =  ""
	--战队id
	self.teamid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--检索关键字
	self.param1 =  ""	
end


function SearchUnionProcess:serialization()
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

return SearchUnionProcess