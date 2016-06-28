--[[
引导激活艾伦
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_()
	if GuideData:isNotCompleted("Activate") then
		self:enterGuide()
		return true
	end
	return false
end

function GuideClass:enterGuide()
	local rect = {x = display.right - 110, y = display.bottom + 95, width = 100 ,height = 100}
    local posX = rect.x - 240
    local posY = rect.y + rect.height/2 + 110
    local text = GameConfig.tutor_talk["15"].talk
    local param = {rect = rect, text = text,x = posX ,y = posY,callback = function (tutor)
        tutor:removeFromParent(true)
        tutor = nil
        app:pushToScene("HeroListScene")
    end}
    showTutorial(param)
end

return GuideClass
