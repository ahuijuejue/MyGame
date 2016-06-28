require("update.FL")

local UpdateScript = class("UpdateScript")

local status = {
	plist = "plist",
	files = "files",
}

local scheduler = require("framework.scheduler")
local param = "?dev="..device.platform

function UpdateScript:ctor(params)
	local path = params.path or "" 		-- 附加路径 存储路径 
	local filename = params.filename 	-- 配置文件名 存储文件名 
	local server = params.server 	-- 服务器地址  存储文件地址 

	self.path = device.writablePath..path 				-- 配置文件 存放全路径 
	self.listFileName = filename 
	self.server = server 

	self.curListFile =  self.path..self.listFileName 	-- 配置文件 全路径文件名 


	self.requesting = nil 
	self.requestCount = 0 
	self.downList = {} 	-- 下载列表 
	self.loadList = {} -- 加载列表 
	self.loadCount = 0 	-- 下载总数 

    self.totalSize = 0 
	
end

function UpdateScript:addRequestCount()
    self.requestCount = self.requestCount + 1
end

function UpdateScript:onEvent(listener)
    self.event_ = listener 

    return self 
end

function UpdateScript:onEvent_(event)
    if not self.event_ then return end 
    event.target = self 
    self.event_(event)
end 

--------------------------------------------------------
function UpdateScript:getResponseData(data)
   	if self.requesting == status.plist then
   		self:parseConfig(data)
   	elseif self.requesting == status.files then
   		self:parseFile(data)
   	end 
end 

function UpdateScript:requestFromServer(filename, waittime)
    local url = self.server..filename..param
    print("url:", url)
    self:addRequestCount()
    local index = self.requestCount

    local request = network.createHTTPRequest(function(event)
        self:onResponse(event, index)
    end, url, "GET")
    
    if request then
        request:setTimeout(waittime or 30)
        request:start()
    else
        self:onEvent_({name="error", msg="request error"})
    end
end

function UpdateScript:onResponse(event, index, dumpResponse)
    local request = event.request
    
    if event.name == "completed" then        
        if request:getResponseStatusCode() ~= 200 then
        	self:onEvent_({name="error", msg=string.format("code:%d", request:getResponseStatusCode())})
        else           	
            self:getResponseData(request:getResponseData())
        end
    elseif event.name == "progress" then
        if self.requesting == status.files then
    	   -- dump(event, "progress")
           self:onEvent_({name="progress", value=event.dltotal, max=total})
        end 
    else 
        printf("REQUEST %d - getErrorCode() = %d, getErrorMessage() = %s", index, request:getErrorCode(), request:getErrorMessage())
                   
    end    
end

------------------------------------------------

-- 加载 配置文件
function UpdateScript:loadConfig()
	if not FL.checkDirOK(self.path) then
        self:onEvent_({name="error", msg="检测可写路径失败"})        
        return self 
    end
    
    -- 读取 配置文件                
    self.fileList = nil
    if io.exists(self.curListFile) then
        self.fileList = dofile(self.curListFile)
    end
    if self.fileList==nil then
        self.fileList = {
            ver = "1.0.0",
            stage = {},
            remove = {},
        }
    end

    return self 
end 

-- 下载 配置文件
function UpdateScript:downloadConfig()      
    self.requesting = status.plist     
    self.newListFile = self.curListFile..".upd" 	-- 配置文件 临时文件名 
    
    self:requestFromServer(self.listFileName)  

    return self 
end 

function UpdateScript:downloadFiles()
    
    self.numFileCheck = 0
    self.requesting = status.files 
    self:reqNextFile()

end 

function UpdateScript:reqNextFile()
    self.numFileCheck = self.numFileCheck+1
    self.curStageFile = self.downList[self.numFileCheck]
    if self.curStageFile and self.curStageFile.name then     
        local count = #self.loadList 
        -- self:onEvent_({name="progress", index=count, max=self.loadCount})   
        self:requestFromServer(self.curStageFile.name)  -- 没有文件 且 没有下载文件         
    else    -- 读取配置结束 
        self:toUpdateFiles()     
    end    
end

----------------------------------------------------------

-- 获取尚未下载的文件列表 和需要更新的临时文件全路径文件名列表 
function UpdateScript:checkFiles(list, oldVer, newVer)  
    list = list or {} 
    local count = #list 

    if count == 0 then -- 更新资源列表为空 
        self:updateConfig()
        self:onEvent_({name="update", update=false, ver=newVer})
    else 
        self:checkFile(list, 1, count, oldVer, newVer)
    end 	
end 

function UpdateScript:checkFile(list, index, count, oldVer, newVer)     
    if index <= count then 
        self:onEvent_({name="checkfile", index=index, max=count})
        scheduler.performWithDelayGlobal(function() 
            local data = list[index]             
            local size = checknumber(data.size)    -- 资源大小  
            self.totalSize = self.totalSize + size 

            local fn = self.path..data.name    -- 下载文件 全路径名 
            local dFn = fn..".upd"          -- 临时文件 全路径名 
            if FL.checkFile(fn, data.code) then            -- 源文件 存在 并且 md5 正确                     
            elseif FL.checkFile(dFn, data.code) then   -- 下载的临时文件 已经 下载                 
                table.insert(self.loadList, dFn)            
            else                                        -- 没有文件 且 没有下载文件                                                     
                table.insert(self.downList, data)               
            end 
            self:checkFile(list, index+1, count, oldVer, newVer)
        end, 0)       

    else 
        local nLoad = #self.loadList 
        local nDown = #self.downList 
        self.loadCount = nLoad + nDown 
        print("nLoad:", nLoad, "nDown:", nDown)
        if nDown > 0 then 
            self:onEvent_({name="update", update=true, oldver=oldVer, newver=newVer, index=nLoad, max=self.loadCount, size=self.totalSize})
        elseif nLoad > 0 then -- 有下载的临时文件 
            self:toUpdateFiles() 
        else  
            self:updateConfig()
            self:onEvent_({name="update", update=false, ver=newVer})             
        end 
    end 
end 

------------------------------------------

function UpdateScript:toUpdateFiles()
    print("替换资源")
    scheduler.performWithDelayGlobal(function()
        self:updateFiles()
    end,0)
end 

function UpdateScript:updateFiles()     
    self:updateFiles_(function()         
        self:updateConfig()
        self:onEvent_({name="completed"})
    end)
end 

function UpdateScript:updateConfig()
    print("update config")
    local data = FL.readFile(self.newListFile)
    io.writefile(self.curListFile, data)
    self.fileList = dofile(self.curListFile)
    if self.fileList==nil then  -- 读取 更新的 配置文件失败 
        self:onEvent_({name="error", msg="读取更新的配置文件失败!"})
        return
    end
    FL.removeFile(self.newListFile)     -- 删除下载的临时配置文件 
      
end

function UpdateScript:updateFiles_(completedFunc)  
    -- 更新文件 
    local count = #self.loadList 
    self:updateFile(self.loadList, 1, count, completedFunc)      
end 

function UpdateScript:updateFile(list, index, count, completedFunc) 
    if index <= count then 
        self:onEvent_({name="updatefile", index=index, max=count})
        scheduler.performWithDelayGlobal(function()
            local name = list[index]
            local data=FL.readFile(name)        -- 读取 临时文件 
            local fn = string.sub(name, 1, -5)        
            io.writefile(fn, data)              -- 更新 文件 
            FL.removeFile(name)                 -- 删除 临时文件 

            self:updateFile(list, index+1, count, completedFunc)
        end,0)
    else         
        if completedFunc then 
            completedFunc()
        end         
    end 
end 
--------------------------------------------

function UpdateScript:toLoadFiles()
    scheduler.performWithDelayGlobal(function()
        self:loadFiles()
    end, 0)
end 

function UpdateScript:loadFiles()	
    if self.fileList and self.fileList.stage then
        local checkOK = true
        -- 检测文件 
        -- for i,v in ipairs(self.fileList.stage) do
        --     if not FL.checkFile(self.path..v.name, v.code) then -- 检测文件错误                 
        --         checkOK = false
        --         break
        --     end
        -- end

        if checkOK then
            for i,v in ipairs(self.fileList.stage) do
                if v.act=="load" then
                    cc.LuaLoadChunksFromZIP(self.path..v.name)
                end
            end
            for i,v in ipairs(self.fileList.remove) do
                FL.removeFile(self.path..v)
            end

            self:onEvent_({name="loadend", load=true}) 
        else
            FL.removeFile(self.curListFile)
            self:onEvent_({name="loadend", load=false})             
        end
    end
    
      
end

---------------------------------------------
-- 解析 下载的 配置文件
function UpdateScript:parseConfig(data)
	io.writefile(self.newListFile, data)
	
	self.fileListNew = dofile(self.newListFile)
	if self.fileListNew==nil then		
		self:onEvent_({name="error", msg="open download plist error"})
		return
	end

	if self.fileListNew.ver==self.fileList.ver then 	        	  
        self:onEvent_({name="update", update=false, ver=self.fileList.ver}) 
        FL.removeFile(self.newListFile)     -- 删除下载的临时配置文件 
    else 	
		self:checkFiles(self.fileListNew.stage, self.fileList.ver, self.fileListNew.ver) 
	end
    
end 

-- 解析 下载的 其他文件
function UpdateScript:parseFile(data)
	local fn = self.path..self.curStageFile.name..".upd"
    io.writefile(fn, data)    
    if FL.checkFile(fn, self.curStageFile.code) then
        table.insert(self.loadList, fn)        	
        self:reqNextFile()
    else
        self:onEvent_({name="error", msg=string.format("下载的文件错误：%s", self.curStageFile.name..".upd")})
    end
end 

-------------------------------------------

return UpdateScript 
