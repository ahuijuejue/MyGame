
local UpdateBase = require("update.UpdateBase")
local UpdateScript = class("UpdateScript", UpdateBase)
local scheduler = require("framework.scheduler")

local function resetRequire(callback)
    scheduler.performWithDelayGlobal(function ()
        for k, v in pairs(package.loaded) do
            if not cacheKeys[k] then 
                package.loaded[k] = nil         
            end 
        end
        if callback then
            callback()
        end 
    end,1)
end

-- 加载资源
function UpdateScript:loadSource(callback)
    resetRequire(callback)
end

-- 下载文件
function UpdateScript:downloadFile(list, index, count, callback)  
    if index <= count then 
        local data = list[index]
        local path = self:getFileAtPath(data)
        FL.checkDirOK(path)
    end 

    UpdateScript.super.downloadFile(self, list, index, count, callback)  
end 

-- 文件所在目录全路径
function UpdateScript:getFileAtPath(data)
    return self.path..data.path
end 

-- 文件名
function UpdateScript:getFileName(data)
    return data.path..data.name
end 


return UpdateScript 
