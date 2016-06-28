--[[
引导尾兽 第二部分
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_()
	if GuideData:isNotCompleted("Tails2") and UserData:getUserLevel() >= OpenLvData.tails.openLv then
		self:enterGuide()
		return true
	end
	return false
end

function GuideClass:enterGuide()
	UserData:showGuideLayer({
        text = GameConfig.tutor_talk["61"].talk,
        x = display.right - 60,
        y = display.bottom + 450,
        offX = -300,
        offY = 110,
        callback = function(target)
            SceneData:pushScene("Tails", self:getCurrentScene())
        end,
    })
end

return GuideClass
