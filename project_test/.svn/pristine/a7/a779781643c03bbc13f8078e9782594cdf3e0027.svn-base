local ShowMainFrameProcess = class("ShowMainFrameProcess")

function ShowMainFrameProcess:ctor()
	--请求消息号
	self.order = 10003
	--用户Id
	self.userid =  ""
	--服务器id
	self.serverid =  ""
	--sdkid
	self.uuid =  ""
	--验证值
	self.token =  ""
	--设备id
	self.param1 =  ""
	--平台的sdk的类型
	self.param2 =  ""
	--平台sdk的渠道类型,见platform表
	self.param3 =  ""
	--uc的登陆token,由sdk获得
	self.sid =  ""	
end


function ShowMainFrameProcess:serialization()
	local data = {
		order = self.order,
		userid = self.userid,
		serverid = self.serverid,
		uuid = self.uuid,
		token = self.token,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		sid = self.sid,
		
	}
	return data
end

return ShowMainFrameProcess