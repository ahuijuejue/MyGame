--[[
引导每日任务
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if GuideData:isNotCompleted("DailyQuest") and TaskData:isDailyTaskOpen() then 	-- 每日任务
		if targetScene.name == "TaskScene" then
			self:showTaskGuide(targetScene)
		else
       		self:enterGuide()
       	end

        return true
    end
	return false
end

function GuideClass:enterGuide()
	UserData:showGuideLayer({
        text = GameConfig.tutor_talk["80"].talk,
        x = display.right - 60,
        y = display.bottom + 250,
        offX = -290,
        offY = 110,
        callback = function(target)
            SceneData:pushScene("Task", self:getCurrentScene())
        end,
    })
end

function GuideClass:showTaskGuide(targetScene)
	local posX = display.cx + 220
	local posY = display.cy + 90

	showTutorial2({
        rect = cc.rect(posX, posY, 150, 100),
        callback = function(target)
            self:showTaskFinishGuide(targetScene)
        	target:removeSelf()
        end,
    })
end


function GuideClass:showTaskFinishGuide(targetScene)
	GuideData:setCompleted("DailyQuest", function()
		local datas = targetScene:getCurrentData()
		local data = datas[1]
		local info = TaskData:getAchieveInfo(data.id)
		if info then
			if info.isOk then
				targetScene:completeTask(data)
			else
				targetScene:gotoScene(data)
			end
		end
	end,
	function()

	end)
end

return GuideClass
