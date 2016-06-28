module("NetHandler", package.seeall)

--请求登陆信息
function loginHandler()
    local request = require("app.net.request.LoginProcess").new()
    request.param1 = UserData.account
    request.param2 = UserData.pwd
    request.param3 = OPERATE_TYPE
    request.param4 = device.getOpenUDID()
    request.param5 = AD_TYPE
    request.param8 = IDFA
    AccountConnection:sendData(request:serialization())
end

--请求授权token
function tokenHandler()
	local request = require("app.net.request.SelectZoneProcess").new()
    request.param1 = UserData.userId
    request.param2 = UserData.uuid
    request.param3 = UserData.zoneId
    AccountConnection:sendData(request:serialization())
end

--请求服务器列表
function serviceListHandler()
    local request = require("app.net.request.GetServerListProcess").new()
    request.param1 = OPERATE_TYPE
    request.param2 = UserData.uuid
    AccountConnection:sendData(request:serialization())
end

--请求公告
function getNoticeHandler()
    local request = require("app.net.request.SystemNoticeProcess").new()
    AccountConnection:sendData(request:serialization())
end

--请求游戏数据
function enterGameHandler()
    local request = require("app.net.request.ShowMainFrameProcess").new()
    request.userid = UserData.userId
    request.token = UserData.token
    request.uuid  = UserData.uuid
    request.serverid = UserData.zoneId
    request.param1 = device.getOpenUDID()
    request.param2 = OPERATE_TYPE
    request.param3 = AD_TYPE
    GameConnection:sendData(request:serialization())
end

--聊天服务器接口
function chatRequest(requestName,params)
    local request = require("app.net.request."..requestName.."Process").new() 
    request.userid = UserData.userId
    request.uuid   = UserData.uuid
    request.token  = UserData.token
    
    if params then
        for k,v in pairs(params) do             
            request[k] = v             
        end
    end
    ChatConnection:sendData(request:serialization())
end

--游戏中接口
function gameRequest(requestName,params)
    local request = require("app.net.request."..requestName.."Process").new() 
    request.userid = UserData.userId
    request.uuid   = UserData.uuid
    request.token  = UserData.token
    request.teamid = UserData.teamId
    
    if params then
        for k,v in pairs(params) do             
            request[k] = v             
        end
    end
    GameConnection:sendData(request:serialization())
end

function request(requestName,params, target)    
    local request = require("app.net.request."..requestName.."Process").new() 
    request.userid = UserData.userId
    request.uuid   = UserData.uuid
    request.token  = UserData.token
    request.teamid = UserData.teamId

    local callback = {}
    if type(params) ~= "table" then 
        target = params 
        params = {}
    end 
    callback.onsuccess = params.onsuccess
    callback.onerror = params.onerror 
    for k,v in pairs(params.data or {}) do             
        request[k] = v             
    end 
    -- dump(params, "the callback")
    GameConnection:send(request:serialization(),callback, target)    
end 

function removeTarget(target) 
    GameConnection:removeTarget(target)
end 

