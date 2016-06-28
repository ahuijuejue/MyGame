--[[
引导城建
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if GuideData:isNotCompleted("Castle") and UserData:getUserLevel() >= OpenLvData.city.openLv then
        self:enterGuide(targetScene)

        return true
    end
	return false
end

function GuideClass:enterGuide(targetScene)
	 showAside({key = "10012",callback = function ()
        UserData:showGuideLayer({
            text = GameConfig.tutor_talk["68"].talk,
            x = display.right - 60,
            y = display.bottom + 350,
            offX = -300,
            offY = 100,
            callback = function(target)
                SceneData:pushScene("City", self:getCurrentScene())
            end,
        })
    end})
end

return GuideClass
