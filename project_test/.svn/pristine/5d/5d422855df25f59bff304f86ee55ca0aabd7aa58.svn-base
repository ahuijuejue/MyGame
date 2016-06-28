--[[
英雄升级
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_()
	if not GuideData:isCompleted("experience") and OpenLvData:isOpen("expMode") then
        self:enterGuide()
       	return true
    end
	return false
end

function GuideClass:enterGuide()
	showAside({key = "10013",callback = function ()
        local rect = {x = display.right - 110, y = display.bottom + 105, width = 100 ,height = 100}
        local posX = rect.x - 250
        local posY = rect.y + rect.height/2+30
        local text = GameConfig.tutor_talk["32"].talk
        local param = {rect = rect, text = text,x = posX ,y = posY,callback = function (tutor)
            tutor:removeFromParent(true)
            tutor = nil
            app:pushToScene("HeroListScene")
        end}
        showTutorial(param)
    end})
end

return GuideClass
