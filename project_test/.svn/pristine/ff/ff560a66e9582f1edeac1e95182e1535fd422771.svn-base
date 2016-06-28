local HeartProcess = class("HeartProcess")

function HeartProcess:ctor()
	--响应消息号
	self.order = 11004
	--用户id
	self.userid =  ""
	--uuid
	self.uuid =  ""
	--token值
	self.token =  ""
	--版本检测号
	self.param1 = ""
end


function HeartProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		uuid = self.uuid,
		token = self.token,
		param1 = VER_CHECK,
	}
	return data
end

return HeartProcess