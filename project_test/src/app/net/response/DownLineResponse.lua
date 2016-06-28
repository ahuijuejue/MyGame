local DownLineResponse = class("DownLineResponse")

function DownLineResponse:ctor()
	--响应消息号
	self.order = 11003
	--返回结果,1 成功;提示玩家本帐号已在其它地方登陆，本登陆断开
	self.result =  ""
end

function DownLineResponse:DownLineResponse(data)
	ConnectManage:stop()
	ChatManage:stop()
	local text = ""
	if data.result == 1 then
		text = GET_TEXT_DATA("TEXT_RELOGIN")
	elseif data.result == 2 then
		text = GET_TEXT_DATA("TEXT_SERVER_DOWN")
	elseif data.result == 3 then
		text = "游戏已更新，请重新登录"
	elseif data.result == -3 then
		text = data.param1
	end
	showAlert("",text,{sure = function (alert)
        hideAlert(alert)
        app:backToStart()
    end})
end

return DownLineResponse