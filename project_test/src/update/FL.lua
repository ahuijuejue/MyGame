module("FL", package.seeall)
-- 转换成16进制 
function hex(s)
 	s=string.gsub(s,"(.)",function (x) 
 			return string.format("%02X",string.byte(x)) 
 		end)
 	return s
end
--读取文件 
function readFile(path)
    local file = io.open(path, "rb")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content
    end
    return nil
end
-- 移除文件 
function removeFile(path)    
    io.writefile(path, "")
    if device.platform == "windows" then
        os.execute("del " .. string.gsub(path, '/', '\\'))
    else
        os.execute("rm " .. path)
    end
end
-- 文件是否存在
function exists(filename)
    return io.exists(filename)
end 

-- 检测文件md5是否存在 
function checkFile(fileName, cryptoCode)    
    if not io.exists(fileName) then    	
        return false
    end

    local data=readFile(fileName)
    if data==nil then    	
        return false
    end

    if cryptoCode==nil then    	
        return true
    end

    local ms = crypto.md5(hex(data))    
    if ms==cryptoCode then        
        return true
    end
    
    return false
end

function mkDir(path)         
    pathcfg = io.pathinfo(path)   
    path = pathcfg.dirname      
    lstr = string.sub(path, -1)

    -- idx = path.rfind("/")
    spath = ""
    if string.len(path) > 0 and lstr == "/" then 
        spath = string.sub(path, 1, -2)
    end 
    
    if string.len(path) <= 0 then 
        if not io.exists(path) then 
            -- print("make:"..path)
            lfs.mkdir(path)
        end 
        return true

    elseif mkDir(spath) then        
        if not io.exists(path) then 
            -- print("make:"..path)
            lfs.mkdir(path)
        end 

        return true
    else
        return false
    end 
end 

function checkDirOK( path )
    require "lfs"
    local oldpath = lfs.currentdir()
    
    if lfs.chdir(path) then
        lfs.chdir(oldpath)        
        return true
    end

    if lfs.mkdir(path) then        
        return true
    elseif mkDir(path) then         
        return true
    end
end

-- 将字节转换成兆
function convertByteToMb(value)
    return value / 1048576
end 

function md5(text)
    crypto.md5(hex(text))
end

