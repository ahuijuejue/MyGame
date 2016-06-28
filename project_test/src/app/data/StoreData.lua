

GameState = require(cc.PACKAGE_NAME .. ".cc.utils.GameState")
GameState.init(function(param)
    local returnValue=nil    
    if param.errorCode then
        print("error")        
    else
        -- crypto
        if param.name=="save" then              
            local str=json.encode(param.values)                   
            str=crypto.encryptXXTEA(str, "abcd")
            returnValue={data=str}
        elseif param.name=="load" then
            local str = param.values.data
            local str=crypto.decryptXXTEA(str, "abcd")
            returnValue=json.decode(str)  
        end
        -- returnValue=param.values
    end
    return returnValue
end, "data", "1234")

StoreData = StoreData or {}
StoreData.data = GameState.load() or {}

function getClassName(obj)
    local t = type(obj)
    local mt
    if t == "table" then
        mt = getmetatable(obj)
    elseif t == "userdata" then
        mt = tolua.getpeer(obj)
    end
    return mt.__cname
end 

function StoreData:save(value, key)
    -- print(key)
	self.data[key] = value 
    print("save value")
    -- dump(self.data, "save value")
	GameState.save(self.data)    
end 

function StoreData:get(key, default)
    if self.data[key] == nil then 
        return default 
    end 
	return self.data[key]
end 

function StoreData:saveForObj(obj, value, key)
    local objName = getClassName(obj)
    local mixKey = objName .. key 
    self:save(value, mixKey)
end 

function StoreData:getForObj(obj, key)
    local objName = getClassName(obj)
    local mixKey = objName .. key 
    return self:get(mixKey)
end

