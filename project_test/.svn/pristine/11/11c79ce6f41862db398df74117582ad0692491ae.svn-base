
local UpdateBase = require("update.UpdateBase")
local UpdateResource = class("UpdateResource", UpdateBase)

-- 加载资源
function UpdateResource:loadSource()
    if self.fileList and self.fileList.stage then        
        for i,v in ipairs(self.fileList.stage) do
            if v.act=="load" then
                cc.FileUtils:getInstance():addSearchPath(self.path..v.path, true)
            end
        end
        for i,v in ipairs(self.fileList.remove) do
            FL.removeFile(self.path..v)
        end
    end
end

-- 下载文件
function UpdateResource:downloadFile(list, index, count, callback)  
    if index <= count then 
        local data = list[index]
        local path = self:getFileAtPath(data)
        FL.checkDirOK(path)
    end 

    UpdateResource.super.downloadFile(self, list, index, count, callback)  
end 

-- 文件所在目录全路径
function UpdateResource:getFileAtPath(data)
    return self.path..data.path
end 

-- 文件名
function UpdateResource:getFileName(data)
    return data.path..data.name
end 


return UpdateResource 
