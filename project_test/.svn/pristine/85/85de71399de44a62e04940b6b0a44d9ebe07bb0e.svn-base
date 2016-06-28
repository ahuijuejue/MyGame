local BasicScene = import("..ui.BasicScene")
local StartScene = class("StartScene", BasicScene)

local TAG = "StartScene"
local UIListView = import("framework.cc.ui.UIListView")
local ZoneListLayer = import("..views.login.ZoneListLayer")
local NoticeLayer = import("..views.login.NoticeLayer")
local GafNode = import("app.ui.GafNode")

local logoIamge = "Login_Logo.png"

local func1 = function (alert)
    hideAlert(alert)
    showLoading()
	GameConnection:connect(UserData.ip,UserData.port)
end

local func2 = function (alert)
	hideAlert(alert)
	showLoading()
    AccountConnection:connect(ACCOUNT_SERVER,ACCOUNT_PORT)
end

local func3 = function ()
	os.exit()
end

local func4 = function (alert)
	hideAlert(alert)
end

function StartScene:ctor()
	StartScene.super.ctor(self,TAG)

	local param = {gaf = "loading"}
    local effectNode = GafNode.new(param)
    effectNode:playAction("loading",true)
    effectNode:setPosition(display.cx,display.cy)
    self:addChild(effectNode)

	local param1 = {normal = "Login_Button.png", pressed = "Login_Button.png"}
	local startBtn = cc.ui.UIPushButton.new(param1)
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		if	UserData.ip ~= "" and UserData.port ~= "" then
			showLoading()
			AccountConnection:disconnect()
	    	GameConnection:connect(UserData.ip,UserData.port)
	    else
	    	if AccountConnection:isConnected() then
		    	NetHandler.loginHandler()
		    else
		    	showLoading()
		    	AccountConnection:againConnect(function ()
		    		hideLoading()
		    		NetHandler.loginHandler()
		    	end)
	    	end
		end
	end)
	startBtn:setPosition(display.cx+140,70)
	self:addChild(startBtn)

	local param1 = {normal = "ServerBanner.png", pressed = "ServerBanner.png"}
	self.zoneBtn = cc.ui.UIPushButton.new(param1)
	:onButtonClicked(function ()
		AudioManage.playSound("Click.mp3")
		local func = function ()
			if	UserData.ip ~= "" and UserData.port ~= "" then
				NetHandler.serviceListHandler()
			else
				NetHandler.loginHandler()
			end
		end
		if AccountConnection:isConnected() then
			func()
		else
			showLoading()
			AccountConnection:againConnect(function ()
				hideLoading()
				func()
			end)
		end
	end)
	self.zoneBtn:setPosition(display.cx-140,70)
	self:addChild(self.zoneBtn)

	self.zoneBtnLabel = createOutlineLabel({text = "",size = 20})
	self.zoneBtnLabel:pos(56,0)
	self.zoneBtnLabel:addTo(self.zoneBtn)

	local logoSprite = display.newSprite(logoIamge)
	logoSprite:setPosition(display.width-170,display.height-95)
	self:addChild(logoSprite)

	local verLabel = createOutlineLabel({text = VER,size = 20})
	verLabel:setAnchorPoint(1,0.5)
	verLabel:setPosition(display.width-20,30)
	self:addChild(verLabel)

	self:createZoneList()
end

function StartScene:updateView(event)
	local data = event.data
	local order = data.order
	if order == OperationCode.LoginProcess then
		hideLoading()
		self:updateZoneName()
		self:createNoticeLayer()
	elseif order == OperationCode.GetServerListProcess then
		self.listLayer:setVisible(true)
		self.listLayer:updateList(data.a_param1,data.param1,data.param2)
	elseif order == OperationCode.ShowMainFrameProcess then
		hideLoading()
		app:enterToScene("OpenScene")
		app:addNetEvent()
		app:setGameTick()
		app:setChatTick()

		ChatConnection:disconnect()
		ChatConnection:connect(UserData.chatSever,UserData.chatPort)

		ConnectManage:start()
		ChatManage:start()
	end
end

function StartScene:connectEvent(event)
	local data = event.data
	if data.name == cc.net.SocketTCP.EVENT_CONNECTED then
		if data.tag == "Game" then
			NetHandler.enterGameHandler()
		elseif data.tag == "Account" then
			NetHandler.loginHandler()
		end
	elseif data.name == cc.net.SocketTCP.EVENT_CONNECT_FAILURE then
		hideLoading()
		if data.tag == "Game" then
		    showAlert("",GET_TEXT_DATA("TEXT_SERVER_ERR"),{sure = func1,cancel = func4})
		elseif data.tag == "Account" then
		    showAlert("",GET_TEXT_DATA("TEXT_SERVER_ERR"),{sure = func2,cancel = func3})
		end
	end
end

function StartScene:updateZoneName()
	self.zoneBtnLabel:setString(UserData.zoneName)
end

function StartScene:createNoticeLayer()
	if UserData.notice then
		local noticeLayer = NoticeLayer.new(UserData.notice)
		self:addChild(noticeLayer,3)
	end
end

function StartScene:createZoneList()
	self.listLayer = ZoneListLayer.new()
	self.listLayer.delegate = self
	self.listLayer:setVisible(false)
	self:addChild(self.listLayer)
end

function StartScene:onEnter()
	StartScene.super.onEnter(self)
	AudioManage.playMusic("Battle1.mp3",true)

	showLoading()
    --与账号服务器建立连接
    AccountConnection:connect(ACCOUNT_SERVER,ACCOUNT_PORT)
    --网络事件
    self.update = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.updateView))
    self.connect = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_STATUS,handler(self,self.connectEvent))
end

function StartScene:onExit()
	StartScene.super.onExit(self)
    GameDispatcher:removeEventListener(self.update)
    GameDispatcher:removeEventListener(self.connect)
end

return StartScene