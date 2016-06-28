--[[
精英关卡
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	local firstChapter = ChapterData:getChapterAtIndex(1, false)
	if not ChapterData:isChapterOver(firstChapter.id) then return false end

	if GuideData:isNotCompleted("EliteStage") and UserData:getUserLevel() >= OpenLvData.elite.openLv then
		local name = targetScene.name
		if name == "MainScene" then
			self:showMainSceneGuide(targetScene)
			return true
		elseif name == "ChapterScene" then
			self:showChapterSceneGuide(targetScene)
			return true
		end
	end

	return false
end

function GuideClass:showMainSceneGuide(targetScene)
	showAside({key = "10009",callback = function ()

        local posX = display.cx + 170
        local posY = display.cy - 50

        showTutorial2({
            text = GameConfig.tutor_talk["9"].talk,
            rect = cc.rect(posX, posY, 200, 200),
            x = posX - 300,
            y = posY + 150,
            callback = function(target)
                SceneData:pushScene("Chapter", targetScene)
                target:removeSelf()
            end,
        })
    end})
end

function GuideClass:showChapterSceneGuide(targetScene)
	local point = convertPosition(targetScene.btnGroup_:getButtonAtIndex(2), targetScene)
	local posX = point.x
	local posY = point.y

    showTutorial2({
        text = GameConfig.tutor_talk["54"].talk,
        rect = cc.rect(posX, posY, 200, 200),
        x = posX + 330,
        scale = -1,
        callback = function(target)
        	targetScene.btnGroup_:selectedButtonAtIndex(2)
			target:removeSelf()
        	self:showSelect(targetScene)
        end,
    })
end

-- 选择精英的章节
function GuideClass:showSelect(targetScene)
	local items = targetScene.items_[2]
	local data = items[1]

	local index = ChapterData:getIndexOfChapter(data.id, true)
	targetScene:scrollIndex(index, false)

	self:showEnterStage({chapterId=data.id, chapterIndex=index})
end

function GuideClass:showEnterStage(params)
	local posX = display.cx - 10
	local posY = display.cy

    showTutorial2({
        text = GameConfig.tutor_talk["59"].talk,
        rect = cc.rect(posX, posY, 220, 300),
        x = posX - 250,
        y = posY + 140,
        callback = function(target)
        	target:removeSelf()

            self:endEliteStageGuide(function()
            	app:pushScene("MissionScene", {{chapterId=params.chapterId, stageId= params.stageId}})
            end)
        end,
    })
end

function GuideClass:endEliteStageGuide(callback)
	GuideData:setCompleted("EliteStage", function()
		callback()
	end,
	function()

	end)
end

return GuideClass
