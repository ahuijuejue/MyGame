
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

local path = cc.FileUtils:getInstance():getWritablePath().."srcc/?.lua;"
package.path = path..package.path..";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
cc.Device:setKeepScreenOn(true)

cacheKeys = {}
for k, v in pairs(package.loaded) do
    cacheKeys[k] = true
end
require("app.ui.Common")
require("app.MyApp").new():run()
-- local MainScene = import("app.scenes.MainScene")
-- local scene = MainScene.new()
-- display.replaceScene(scene)
