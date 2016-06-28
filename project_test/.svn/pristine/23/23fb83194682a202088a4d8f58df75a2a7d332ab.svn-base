--[[
竞技场第一部分
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if GuideData:isNotCompleted("Arena1") and UserData:getUserLevel() >= OpenLvData.arena.openLv then

		if targetScene.name == "MainScene" then
       		self:showMainSceneGuide(targetScene)
       		return true
       	end
    end

	return false
end


function GuideClass:showMainSceneGuide(targetScene)
	showAside({key = "10008",callback = function ()
        local point = convertPosition(targetScene.mainLayer.arenaGaf, targetScene)
        local posX = point.x
        local posY = point.y + 200

        local request = false
        showTutorial2({
            text = GameConfig.tutor_talk["44"].talk,
            rect = cc.rect(posX, posY, 200, 300),
            x = posX - 295,
            y = posY + 130,
            callback = function(target)
                if request then
                    showToast({text="服务器处理中！", time=3})
                else
                    SceneData:pushScene("Arena", targetScene, function()
                        target:removeSelf()
                        request = false
                    end, function(data)
                        showToast({text=string.format("数据错误，错误号：%d", data), time=3})
                        request = false
                    end)
                end

            end,
        })
    end})
end

return GuideClass
