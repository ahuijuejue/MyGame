--[[
引导梦幻之书
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if targetScene.name ~= "MainScene" then return false end

	if GuideData:isNotCompleted("DreamBook") and UserData:getUserLevel() >= OpenLvData.dreamBook.openLv then    -- 梦幻之书
        self:enterGuide(targetScene)

        return true
    end
	return false
end

function GuideClass:enterGuide(targetScene)
	 showAside({key = "10010",callback = function ()
        local point = convertPosition(targetScene.mainLayer.bookGaf, targetScene)
        local posX = point.x
        local posY = point.y + 200

        showTutorial2({
            text = GameConfig.tutor_talk["55"].talk,
            rect = cc.rect(posX, posY, 200, 300),
            x = posX - 295,
            y = posY + 140,
            callback = function(target)
                app:pushScene("TrialScene")
                target:removeSelf()
            end,
        })
    end})
end


return GuideClass
