require("update.FL")
local UpdateBase = class("UpdateBase")
local Request = require("update.Request")

--[[
下载文件 
流程 
1.加载配置文件
2.下载配置文件
3.找出需更新列表
4.找出需下载列表
5.下载
6.替换资源
7.替换plist
8.加载资源
9.结束
]]

local scheduler = require("framework.scheduler")
local param = "?dev="..device.platform

--[[
server 服务器地址  服务器存储文件地址 
path 附加路径 沙盒存储路径 
filename 配置文件名 存储文件名 
localpath 本地配置文件路径
]]
function UpdateBase:ctor(params)
	local path = params.path or "" 		-- 附加路径 存储路径 
	local filename = params.filename 	-- 配置文件名 存储文件名 
	local server = params.server 	    -- 服务器地址  存储文件地址 
    self.localPath = params.localpath or "" -- 本地配置文件路径

	self.path = device.writablePath..path 		-- 沙盒 存放路径 
	self.listFileName = filename                -- 配置文件名

    self.fileList = nil             -- 当前配置
    self.fileListNew = nil          -- 当前服务器配置 

    self.fileListName = filename                        -- 配置文件名
    self.fileListNewName = self.fileListName..".upd"    -- 配置文件 临时文件名 

    self.fileListPath = self.path..self.fileListName    -- 配置文件 全路径文件名 

    self.loadList = {}  -- 需更新列表 
    self.downList = {}  -- 需下载列表 

    self.downSize = 0   -- 已经下载大小
    self.totalSize = 0  -- 总更新大小

    self.request = Request.new({
        server = server
    })

    
    cc.FileUtils:getInstance():addSearchPath("")
	
end

function UpdateBase:onEvent(listener)
    self.event_ = listener 

    return self 
end

function UpdateBase:onEvent_(event)
    if not self.event_ then return end 
    event.target = self 
    self.event_(event)
end 

function UpdateBase:getLoadListCount()
    return #self.loadList
end 

--------------------------------------------------------
-- 加载 配置文件
function UpdateBase:loadConfig()   
    if not FL.checkDirOK(self.path) then -- 沙盒路径失败
        self:onEvent_({name="error", msg="检测可写路径失败"})        
        return false
    end

    -- 读取 沙盒配置文件                
    self.fileList = nil
    if io.exists(self.fileListPath) then
        self.fileList = dofile(self.fileListPath)
        -- print("list:", self.fileList)
        -- dump(self.fileList.ver, "file list ver")
    end
    if self.fileList then  -- 读取到沙盒里的配置
        return true
    end

    -- 读取本地配置
    local filename = cc.FileUtils:getInstance():fullPathForFilename(self.localPath..self.fileListName)
    if io.exists(filename) then
        -- print("exist 本地:", filename)
        local datastring = io.readfile(filename)
        self.fileList = loadstring(datastring)()
    end
    if self.fileList then  -- 读取到本地的配置        
        return true
    end

    self:onEvent_({name="error", msg="没有检测到配置文件"})
    return false 
end 

-- 下载 配置文件
function UpdateBase:downloadConfig(callback)
    self.request:request(self.fileListName, function(event)
        if event.name == "completed" then 
            local data = event.data 
            local fileNewPath = self.fileListPath..".upd"
            io.writefile(fileNewPath, data)
            self.fileListNew = dofile(fileNewPath)

            if self.fileListNew == nil then 
                self:onEvent_({name="error", msg="open download plist error"})
                return self 
            else 
                local isNew = self:convertVertionToNumber(self.fileListNew.ver) > self:convertVertionToNumber(self.fileList.ver)
                -- print("ver:", self.fileListNew.ver, self.fileList.ver)
                self:doCallback(callback, {
                    isNew   = isNew,
                    oldver  = self.fileList.ver,
                    newver  = self.fileListNew.ver,
                })
            end 

        elseif event.name == "error" then 
            self:onEvent_(event)
        end 
    end)

    return self 
end 
---------------------------------------------------
-- 找出需更新列表
function UpdateBase:checkLoadList()
    local oldList = self.fileList.stage or {}
    local newList = self.fileListNew.stage or {}
    for k,v in pairs(newList) do
        if not self:isHave(v, oldList) then 
            table.insert(self.loadList, v)
        end 
    end
-- dump(self.loadList, "load list")
    -- 计算需更新的资源总大小
    self.totalSize = 0
    for i,v in ipairs(self.loadList) do
        local size = checknumber(v.size) 
        self.totalSize = self.totalSize + size
    end
end
---------------------------------------------------
-- 找出需下载列表
function UpdateBase:checkDownloadList(callback)
    self:checkFile(self.loadList, 1, #self.loadList, self.fileList.ver, self.fileListNew.ver, function(event)
        if event.name == "getfile" then 
            if event.have then 
                self.downSize = self.downSize + checknumber(event.data.size)
            else 
                table.insert(self.downList, event.data)
            end 
            self:doCallback(callback, {
                name = "process",
                index= event.index, 
                max = event.max,
            })
        elseif event.name == "process" then 

        elseif event.name == "completed" then 
            -- print("completed")
            -- dump(self.downList, "down list")
            if callback then 
                local nLoad = #self.loadList 
                local nDown = #self.downList 
                
                callback({
                    name="completed", 
                    oldver  = self.fileList.ver,
                    newver  = self.fileListNew.ver, 
                    count   = nDown,         -- 需要下载数量
                    index   = nLoad - nDown, -- 已经下载了的数量 
                    max     = nLoad,         -- 总共需下载数量 
                    totalSize    = self.totalSize, 
                    downSize= self.downSize,
                    target  = self
                })
            end 
        end 
    end) 
end

---------------------------------------------------
-- 根据下载列表 下载文件
function UpdateBase:downloadFiles(callback)
    self:downloadFile(self.downList, 1, #self.downList, function(event)
        event.target = self
        if event.name == "getfile" then 
            self.downSize = self.downSize + checknumber(event.data.size) 
            -- print("getfile", self:getFileName(event.data))
            self:doCallback(callback, {
                name = "process",
                downSize = self.downSize,
                totalSize = self.totalSize,
            })
        elseif event.name == "process" then 
           
        elseif event.name == "completed" then 
            self:doCallback(callback, event)
        end 
    end) 
end 

---------------------------------------------------
-- 根据需更新列表 替换文件
function UpdateBase:replaceFiles(callback)
    self:replaceFile(self.loadList, 1, #self.loadList, function(event)
        event.target = self
        if event.name == "process" then 
            self:doCallback(callback, event)
        elseif event.name == "completed" then 
            self:doCallback(callback, event)
        end 
    end) 
end 

-- 替换配置文件
function UpdateBase:replaceCofig()
    local newConfigPath = self.fileListPath..".upd"
    local data = FL.readFile(newConfigPath)
    -- print("path:", self.fileListPath)
    -- dump(data, "data")
    io.writefile(self.fileListPath, data)
    self.fileList = dofile(self.fileListPath)
    if self.fileList==nil then  -- 读取 更新的 配置文件失败 
        self:onEvent_({name="error", msg="读取更新的配置文件失败!"})
        return false
    end
    FL.removeFile(newConfigPath)     -- 删除下载的临时配置文件 

    return true
end 

-- 加载资源
function UpdateBase:loadSource()
    -- 子类处理
end

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
----- //////////////////////////////////////////////////////////////////////////////////////////------
--private:

--[[


]]

-- 文件列表中是否含有文件并且相同
function UpdateBase:isHave(node, list)
    local nodeName = self:getFileName(node)
    for k,v in pairs(list) do
        if nodeName == self:getFileName(v) then 
            if node.code == v.code then 
                return true 
            end 
            return false
        end  
    end
    return false
end 
---------------------------------------------------
-- 检测沙盒是否有文件
function UpdateBase:checkFile(list, index, count, oldVer, newVer, callback)
    if index <= count then 
        callback({name="process", index=index, max=count})
        
        scheduler.performWithDelayGlobal(function() 
            local data = list[index]             
            local size = checknumber(data.size)    -- 资源大小 

            local fn = self:getFilePath(data)      -- 下载文件 全路径名 
            local dFn = fn..".upd"              -- 临时文件 全路径名 
            if FL.checkFile(fn, data.code) then         -- 源文件 存在 并且 md5 正确
                callback({name="getfile", data=data, have=true, index=index, max=count})
            elseif FL.checkFile(dFn, data.code) then    -- 下载的临时文件 已经 下载 
                callback({name="getfile", data=data, have=true, index=index, max=count})
            else                                        -- 没有文件 且 没有下载文件 
                callback({name="getfile", data=data, have=false, index=index, max=count})
            end 
            self:checkFile(list, index+1, count, oldVer, newVer, callback)
        end, 0) 
    else 
        scheduler.performWithDelayGlobal(function()
            callback({name="completed"})
        end, 0.1)
    end 
end  

-- 下载文件
function UpdateBase:downloadFile(list, index, count, callback)  
    if index <= count then 
        local fileData = list[index]
        local filename = self:getFileName(fileData)
        callback({name="process", index=index, max=count, size=fileData.size})        
        self.request:request(filename, function(event)
            if event.name == "completed" then 
                local data = event.data  
                local filenewpath = self:getFilePath(fileData)..".upd"
                io.writefile(filenewpath, data)
                callback({name="getfile", data=fileData})         

                self:downloadFile(list, index+1, count, callback)
            elseif event.name == "error" then 
                self:onEvent_(event)
            end 
        end)
    else 
        scheduler.performWithDelayGlobal(function()
            callback({name="completed"})
        end, 0)
    end 
end 

function UpdateBase:replaceFile(list, index, count, callback)
    if index <= count then 
        -- print("replaceFile", index, count)
        callback({name="process", index=index, max=count}) 
        scheduler.performWithDelayGlobal(function()
            local filepath = self:getFilePath(list[index])
            local filenewpath = filepath..".upd"
            if FL.exists(filenewpath) then 
                local data=FL.readFile(filenewpath)        -- 读取 临时文件            
                io.writefile(filepath, data)               -- 更新 文件 
                FL.removeFile(filenewpath)                 -- 删除 临时文件 
            end 
            self:replaceFile(list, index+1, count, callback)
        end, 0)
    else         
        scheduler.performWithDelayGlobal(function()
            callback({name="completed"})
        end, 0)
    end 
end

-- 将版本号转换成数值
function UpdateBase:convertVertionToNumber(ver)
    local verarr = string.split(ver, ".")
    local numstr = table.concat(verarr)
    return tonumber(numstr) or 0
end

function UpdateBase:doCallback(callback, event)
    if callback then 
        event.target=self
        callback(event)
    end 
end 

-- 删除配置文件
function UpdateBase:removeConfig()
    local newConfigPath = self.fileListPath..".upd"
    FL.removeFile(newConfigPath)     -- 删除下载的临时配置文件 

    return true
end 

-- 全路径文件名
function UpdateBase:getFilePath(data)
    return self.path..self:getFileName(data)
end 

-- 文件名
function UpdateBase:getFileName(data)
    return data.name
end 

-- private end 
----- //////////////////////////////////////////////////////////////////////////////////////////------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------


return UpdateBase 
