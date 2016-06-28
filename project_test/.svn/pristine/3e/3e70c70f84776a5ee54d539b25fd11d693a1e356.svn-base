--[[
引导抽卡
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if targetScene.name ~= "MainScene" then return false end
	if GuideData:isNotCompleted("Card") then
		self:enterGuide(targetScene)
		return true
	end
	return false
end

function GuideClass:enterGuide(targetScene)
	showAside({key = "10003",callback = function ()
        local rect = {x = display.width - 615, y = display.bottom, width = 120 ,height = 120}
        local posX = rect.x - 100
        local posY = rect.y + rect.height/2 + 20
        local text = GameConfig.tutor_talk["6"].talk
        local param = {rect = rect, text = text,x = posX+25 ,y = posY+110,callback = function (tutor)
            targetScene.tutor = tutor
            NetHandler.gameRequest("OpenChoukaFrame")
        end}
        showTutorial(param)
    end})
end


return GuideClass
