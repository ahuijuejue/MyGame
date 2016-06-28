--[[
新手引导
升星
]]
local GuideNode = import("..GuideNode")
local GuideStarUp = class("GuideStarUp", GuideNode)

-- overwrite
-- 引导操作
function GuideStarUp:makeGuide_()
	if GuideData:isNotCompleted("StarUp") and UserData:getUserLevel() >= OpenLvData.starUp.openLv then --使用经验药水
        showAside({key = "10014",callback = function ()
            local rect = {x = display.right - 110, y = display.bottom + 105, width = 100 ,height = 100}
            local posX = rect.x - 250
            local posY = rect.y + rect.height/2+30
            local text = GameConfig.tutor_talk["15"].talk
            local param = {rect = rect, text = text,x = posX ,y = posY,callback = function (tutor)
                tutor:removeFromParent(true)
                tutor = nil
                app:pushToScene("HeroListScene")
            end}
            showTutorial(param)
        end})

       	return true
    end
	return false
end

return GuideStarUp