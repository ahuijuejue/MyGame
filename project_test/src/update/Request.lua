
local Request = class("Request")

local param = "?dev="..device.platform

function Request:ctor(params)
	self.server = params.server or ""
	self.waittime = params.waittime or 30
end

function Request:setServer(serverpath)
	self.server = serverpath
	return self 
end 

function Request:setWaitTime(time)
	self.waittime = time 
	return self 
end 

function Request:request(filename, callback)
	local url = self.server..filename..param
	print("url:", url)
	local request = network.createHTTPRequest(function(event)
        self:onResponse(event, callback)
    end, url, "GET")
    
    if request then
        request:setTimeout(waittime or 30)
        request:start()
    else
        self:onEvent_({name="error", msg="request error"}, callback)
    end
end 


------------------------------------
-- private:
function Request:onResponse(event, callback)
	local request = event.request
    
    if event.name == "completed" then        
        if request:getResponseStatusCode() ~= 200 then
        	self:onEvent_({name="error", msg=string.format("code:%d", request:getResponseStatusCode())}, callback)
        else
        	self:onEvent_({name="completed", data=request:getResponseData()}, callback)            
        end
    elseif event.name == "progress" then
	   -- dump(event, "progress")
        self:onEvent_({
            name="progress", 
            data={
                value=event.dltotal, 
                valueMax=event.total
                },
        }, 
        callback)
    else 
        local str = string.format("getErrorCode() = %d, getErrorMessage() = %s", request:getErrorCode(), request:getErrorMessage())
        self:onEvent_({name="error", msg=str}, callback)
    end 
end 

function Request:onEvent_(event, callback)
	if callback then 
		callback(event)
	end 
end 

------------------------------------


return Request
