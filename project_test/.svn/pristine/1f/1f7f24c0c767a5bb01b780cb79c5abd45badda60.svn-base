--[[
竞技场第二部分
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if GuideData:isNotCompleted("Arena2") and UserData:getUserLevel() >= OpenLvData.arena.openLv then

		if targetScene.name == "MainScene" then
       		self:showMainSceneGuide(targetScene)
       		return true
       	end
    end

	return false
end


function GuideClass:showMainSceneGuide(targetScene)
	-- showAside({key = "10008",callback = function ()
        local point = convertPosition(targetScene.mainLayer.arenaGaf, targetScene)
        local posX = point.x
        local posY = point.y + 200

        showTutorial2({
            text = GameConfig.tutor_talk["44"].talk,
            rect = cc.rect(posX, posY, 200, 300),
            x = posX - 295,
            y = posY + 130,
            callback = function(target)
                SceneData:pushScene("Arena", targetScene)
                target:removeSelf()
            end,
        })
    -- end})
end


return GuideClass
