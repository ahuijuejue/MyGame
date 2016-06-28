--[[
引导起名
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if targetScene.name ~= "MainScene" then return false end 
	if GuideData:isNotCompleted("Name") then 
		showAside({key = "10002",callback = function()
			self:enterGuide(targetScene)
		end})		
		return true
	end 
	return false
end

function GuideClass:enterGuide(targetScene)
	local isTake = false 
	app:createView("setup.TakeNameLayer"):addTo(targetScene)
    :zorder(10)
    :onEvent(function(event)
        if event.name == "close" then 
            if not isTake then 
                showToast({text="请设置名字"})
            else 
                event.target:removeSelf()                 
            end 
        elseif event.name == "ok" then 
            local name = event.text 
            if string.len(name) > 0 then 
                if MatchWord:check(name) then 
                    self.takeNameLayer = event.target
                    NetHandler.request("UpdateTeamName", {
                        data={param1=1, param2=name, param100="Name"}, 
                        onsuccess = function()
                            isTake = true 
                            showToast({text="起名成功"})
                            if self.takeNameLayer then 
                                self.takeNameLayer:removeSelf()
                                self.takeNameLayer = nil 
                            end 
                            
                            targetScene.mainLayer:updateUserName()
                            targetScene:onGuide()
                        end
                    }, self)  
                else 
                    showToast({text="含有非法字符"})
                end 
            else 
                showToast({text="名字不能为空"})
            end 
        end 
    end)
end 


return GuideClass
