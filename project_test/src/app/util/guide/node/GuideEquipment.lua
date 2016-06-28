--[[
合成强化升级装备
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_()
	if GuideData:isNotCompleted("Equipment") and OpenLvData:isOpen("equip") then
        self:enterGuide()
        return true
	end
	return false
end

function GuideClass:enterGuide()
	showAside({key = "10007",callback = function ()
        UserData:showGuideLayer({
            text = GameConfig.tutor_talk["32"].talk,
            x = display.right - 60,
            y = display.bottom + 150,
            offX = -280,
            offY = 110,
            callback = function(target)
                app:pushToScene("HeroListScene")
            end,
        })
    end})
end

return GuideClass
