
local c = cc 
local Scene = c.Scene 

local sharedDirector = cc.Director:getInstance()
cacheScenes = cacheScenes or {}

local checkScene = function(newScene)
    for i,v in ipairs(cacheScenes) do
        if v == newScene.name then 
            return i 
        end 
    end
    return 0
end

local popSceneToIndex = function(index)    
    while #cacheScenes > index do 
        table.remove(cacheScenes)
    end 
    sharedDirector:popToSceneStackLevel(index)
end 

function Scene:push(newScene)    
    if sharedDirector:getRunningScene() then
        local index = checkScene(newScene)
        -- print("push index:", index)
        if index > 0 then
            if index == 1 then 
            -- 不能 push 到第一层场景
            self:enter(newScene)
            else 
            popSceneToIndex(index - 1)
            self:push(newScene)
            end         
        else         
            table.insert(cacheScenes, newScene.name)
            sharedDirector:pushScene(newScene) 
            print("push", #cacheScenes)
        end        
    else
        cacheScenes = {newScene.name}
        sharedDirector:runWithScene(newScene)
        print("run", #cacheScenes)
    end    
    return self
end 

function Scene:pop()
    app:popToScene()
    -- assert(#cacheScenes > 1, "cache scene count must be > 1")
    -- popSceneToIndex(#cacheScenes - 1)
    -- print("pop", #cacheScenes)
  --   table.remove(cacheScenes)
  --   print("pop", #cacheScenes)
 	-- sharedDirector:popScene()
    -- dump(cacheScenes)
   
 	return self
end 

function Scene:enter(newScene)	
    print("enter scene name", newScene.name)
    local enterScene = function(scene)
        if #cacheScenes == 0 then            
            cacheScenes = {scene.name}
        else 
            cacheScenes[#cacheScenes] = scene.name
        end 
        print("enter", #cacheScenes)
        display.replaceScene(scene)
    end

    local index = checkScene(newScene)
    -- print("enter index:", index)
    if index > 0 then
        popSceneToIndex(index)
        enterScene(newScene)
    else         
        enterScene(newScene)
    end 

    return self
end 

function Scene:enterFirst(newScene)	
    popSceneToIndex(1)
    cacheScenes = {newScene.name}
    sharedDirector:replaceScene(newScene)   
    return self
end 

function Scene:popToFirst()	
    -- popSceneToIndex(1)
       
    return self
end 

function Scene:popToIndex(index) 
    popSceneToIndex(index)
       
    return self
end 

function Scene:indexOfScene(sceneName) 
    return checkScene(sceneName)
end 

function Scene:countOfScene() 
    return #cacheScenes
end 

------
function Scene:toPush()   
    self:push(self)
    return self
end 

function Scene:toEnter()  
    self:enter(self)
    return self
end 

function Scene:toEnterFirst() 
    self:enterFirst(self)
    return self
end 

function Scene:indexOfSelf() 
    return self:indexOfScene(self.name)
end

-----------------------------------------------------------------------


local AppBase = cc.mvc.AppBase

function AppBase:enterScene(sceneName,args, transitionType, time, more)
    local needNew = false
    if table.nums(args or {}) > 0 then needNew = true end 
    app:enterToScene(sceneName,needNew,args,transitionType,time,more)
    -- local scenePackageName = self. packageRoot .. ".scenes." .. sceneName
    -- local sceneClass = require(scenePackageName)
    -- local scene = sceneClass.new(unpack(checktable(args)))    
    -- if transitionType then
    --     local newScene = display.wrapSceneWithTransition(scene, transitionType, time, more)
    --     newScene.name = scene.name  
    --     scene = newScene
    -- end
    
    -- scene:toEnter()
end

function AppBase:pushScene(sceneName, args, transitionType, time, more)
    local needNew = false
    if table.nums(args or {}) > 0 then needNew = true end 
    app:pushToScene(sceneName,needNew,args,transitionType,time,more,needNew)
    -- local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
    -- local sceneClass = require(scenePackageName)
    -- local scene = sceneClass.new(unpack(checktable(args)))        
    
    -- if transitionType then
    --     local newScene = display.wrapSceneWithTransition(scene, transitionType, time, more)
    --     newScene.name = scene.name  
    --     scene = newScene
    -- end
    -- scene:toPush()    
end

function AppBase:popScene()
    -- assert(#cacheScenes > 1, "cache scene count must be > 1")
    -- popSceneToIndex(#cacheScenes - 1)
    -- print("pop", #cacheScenes)
    app:popToScene()
end 

-----------------------------------------------------------------------

function AppBase:getCurrentSceneName()
    if cacheScenes and #cacheScenes > 0 then 
        return cacheScenes[#cacheScenes]
    end 
    return nil 
end

function AppBase:getCurrentScene()
    return sharedDirector:getRunningScene()
end

function AppBase:enterFirstScene(sceneName)
    popSceneToIndex(1)
    self:enterScene(sceneName)
end 

function AppBase:createScene(sceneName, ...)
    local scenePackageName = self.packageRoot .. ".scenes." .. sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(...) 

    return scene    
end

function AppBase:getView(viewName, ...)
    local viewPackageName = self.packageRoot .. ".views." .. viewName
    return require(viewPackageName)    
end

function AppBase:popToFirstScene() 
    popSceneToIndex(1)     
end 
------

