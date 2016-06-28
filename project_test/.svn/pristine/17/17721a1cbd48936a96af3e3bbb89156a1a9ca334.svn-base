local HeartResponse = class("HeartResponse")

function HeartResponse:ctor()
	--响应消息号
	self.order = 11004
	--返回结果,1 成功;提示玩家本帐号已在其它地方登陆，本登陆断开
	self.result =  ""
	--服务器当前时间
	self.param1 =  ""	
end

function HeartResponse:HeartResponse(data)
	if data.result == 1 then
		ConnectManage.isSending = false
		UserData:setServerSecond(data.param1)
	elseif data.result == -1 then
		showAlert("",GET_TEXT_DATA("TEXT_CON_FAIL"),{sure = function (alert)
	        hideAlert(alert)
	        app:backToStart()
	    end})

	    ConnectManage:stop()
	    GameConnection:disconnect()
	elseif data.result == 2 then
		showAlert("","游戏已更新，请重新登录",{sure = function (alert)
	        hideAlert(alert)
	        app:backToStart()
	    end})
 
		ConnectManage:stop()
	    GameConnection:disconnect()
	elseif data.result == -21 then
		showAlert("","检测到异常，你被管理员强制下线",{sure = function (alert)
			hideAlert(alert)
			app:backToStart()
		end})

		ConnectManage:stop()
	    GameConnection:disconnect()
	end
end

return HeartResponse