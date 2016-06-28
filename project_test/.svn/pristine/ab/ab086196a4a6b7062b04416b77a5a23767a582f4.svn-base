local Connection = class("Connection")
local PacketBuffer = import(".PacketBuffer")

function Connection:ctor(name)
	self.name = name
    self.tcp_ = nil
    --是否为重连
    self.isRetry = false
    --建立连接后回调
    self.openCallback = nil
    --收到请求后回调
    self.responseCallback = {}
    self.host_ = nil
    self.port_ = nil
	self._buf = PacketBuffer.new()
end

function Connection:send(msg, callback, target)
	function checkCallBack(order, pTarget, pCallBack) -- 检测是否已添加方法
		self.responseCallback[order] = {}
		return false
	end
	if callback and target then
		local key = tostring(msg.order)
		if not checkCallBack(key, target, callback) then
			table.insert(self.responseCallback[key], {
				target 	= target,
				callback = callback,
			})
		end
	end

	if self:isConnected() then
		local newMsg = {
			value = msg,
			sign = crypto.md5(json.encode(msg)..REQUEST_CHECK_KEY)
		}
		local __buf = PacketBuffer.createPacket(newMsg)
		self.tcp_:send(__buf:getPack())
	else
		self:setOnError_(callback)
	end
end

function Connection:setOnError()
	for k,w in pairs(self.responseCallback) do
		for i,v in ipairs(w) do
			self:setOnError_(v.callback)
		end
	end
end

function Connection:setOnError_(callback)
	if callback then
		if callback.onerror then
			callback.onerror(-100)
		end
	end
end

function Connection:sendData(msg)
	if self:isConnected() then
		local newMsg = {
			value = msg,
			sign = crypto.md5(json.encode(msg)..REQUEST_CHECK_KEY)
		}
		local __buf = PacketBuffer.createPacket(newMsg)
		self.tcp_:send(__buf:getPack())
	end
end

function Connection:removeTarget(target)
	for k,v in pairs(self.responseCallback) do
		local idx = {}
		for i,w in ipairs(v) do
			if w.target == target then
				table.insert(idx, i)
			end
		end
		for i,w in ipairs(idx) do
			table.remove(v, w)
		end
	end
end

function Connection:isConnected()
	return self.tcp_ and self.tcp_.isConnected
end

function Connection:connect(host, port, callback)
	self.host_ = host
	self.port_ = port
	self.openCallback = callback
	if not self.tcp_ then
		self.tcp_ = cc.net.SocketTCP.new(host, port, false)
		self.tcp_:addEventListener(cc.net.SocketTCP.EVENT_CONNECTED, handler(self,self.onOpen))
		self.tcp_:addEventListener(cc.net.SocketTCP.EVENT_CLOSE, handler(self,self.onClose))
		self.tcp_:addEventListener(cc.net.SocketTCP.EVENT_CLOSED, handler(self,self.onClosed))
		self.tcp_:addEventListener(cc.net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self,self.onError))
		self.tcp_:addEventListener(cc.net.SocketTCP.EVENT_DATA, handler(self,self.onResponse))
	end
	self.tcp_:connect(host, port)
end

function Connection:disconnect()
	if self.tcp_ then
		self.tcp_:removeAllEventListeners()
		self.tcp_:disconnect()
		self.tcp_:close()
		self.tcp_ = nil
	end
end

function Connection:onResponse(event)
	local __msgs = self._buf:parsePackets(event.data)
	local __msg = nil
	for i=1,#__msgs do
		__msg = __msgs[i]
		local operationName = GetOperationCodeName(__msg.order)
	    Response = require("app.net.response."..operationName).new()
	    ResponseData = __msg
	    ResponseRet = nil
	    local func = loadstring("ResponseRet={Response:"..operationName.."(ResponseData)}")
	    func()
	    local key = tostring(__msg.order)
		local isOk = __msg.result == 1

		if self.responseCallback[key] then
			for i,v in ipairs(self.responseCallback[key]) do
				if v.callback then
					if isOk then
						if v.callback.onsuccess then
							v.callback.onsuccess(unpack(ResponseRet or {}))
						end
					else
						if v.callback.onerror then
							v.callback.onerror(__msg.result)
						end
					end
				end
			end
		end

   		-- self.handler:dispatchEvent({name = "onResponse", data = __msg})
	end
end

function Connection:onOpen(event)
	event.tag = self.name
	if self.isRetry then
		if self.openCallback then
	    	self.openCallback()
	    	self.openCallback = nil
	    end
	    self.isRetry = false
	else
	    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_STATUS,data = event})
	end
end

function Connection:onClose(event)
	event.tag = self.name
    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_STATUS, data = event})
end

function Connection:onClosed(event)
    event.tag = self.name
    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_STATUS, data = event})
	self:setOnError()
end

function Connection:onError(event)
	event.tag = self.name
    GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_STATUS, data = event})
end

function Connection:againConnect(callback)
	self.isRetry = true
	if self.tcp_ then
		self.openCallback = callback
		self.tcp_:connect(self.host_,self.port_)
	else
		self:connect(self.host_,self.port_,callback)
	end
end

return Connection