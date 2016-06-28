--[[
引导关卡流程
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene, params, outparams)
	if GuideData:isCompleted(self.data.name) then return false end

	local name = targetScene.name
	if name == "MainScene" then
		self:guideMainScene(targetScene)
		return true
	elseif name == "ChapterScene" then
		self:guideChapterScene(targetScene)
		return true
	elseif name == "MissionScene" then
		self:guideStageScene(targetScene)
		return true
	elseif name == "ReadyPlayScene" then
		self:guideReadyScene(targetScene, params, outparams)
		return true
	end

	return false
end

function GuideClass:guideMainScene(targetScene)
	local posX = display.cx + 180
    local posY = display.cy - 80

    showTutorial2({
        text = GameConfig.tutor_talk["9"].talk,
        rect = cc.rect(posX, posY, 200, 200),
        x = posX - 280,
        y = 430,
        callback = function(target)
            SceneData:pushScene("Chapter", self)
            target:removeSelf()
        end,
    })
end

function GuideClass:guideChapterScene(targetScene)
	local items = targetScene.items_[1]

	local name = self.data.name
	name = string.sub(name, 6)
	local ids = string.split(name, "-")

	local index = checknumber(ids[1])
	local data = items[index]

	targetScene:scrollIndex(index, false)
	self:showEnterStage({chapterId=data.id, chapterIndex=index})
end

function GuideClass:guideStageScene(targetScene)
	local name = self.data.name
	name = string.sub(name, 6)
	local ids = string.split(name, "-")

	local index = self:getSortIndex(checknumber(ids[2]), checknumber(ids[3]), targetScene.items_)
	targetScene:selectedIndex(index)

	self:showEnterBattle(function()
		targetScene:startGame()
	end)
end

function GuideClass:guideReadyScene(targetScene, params, outparams)

end

-------------------------------
--/////////////////////////////

function GuideClass:showEnterStage(params)
	local posX = display.cx - 10
	local posY = display.cy

	local talkid = "10"
	if params.chapterIndex == 2 then
		talkid = "23"
	end
    showTutorial2({
        text = GameConfig.tutor_talk[talkid].talk,
        rect = cc.rect(posX, posY, 220, 300),
        x = posX - 220,
        y = 460,
        callback = function(target)
        	target:removeSelf()
            app:pushScene("MissionScene", {{chapterId=params.chapterId, stageId= params.stageId}})
        end,
    })
end

function GuideClass:getSortIndex(sort1, sort2, items)
	for i,v in ipairs(items) do
		if v.sort == sort1 and v.sort2 == sort2 then
			return i
		end
	end
	return 1
end

function GuideClass:showEnterBattle(callback)
	local posX = display.cx + 285
	local posY = display.cy - 240

    showTutorial2({
        text = GameConfig.tutor_talk["11"].talk,
        rect = cc.rect(posX, posY, 200, 85),
        x = posX - 325,
        y = posY + 120,
        callback = function(target)
            callback()
            target:removeSelf()
        end,
    })
end

function GuideClass:showSelectIndex(targetScene, index, textFlag, callback)
	local posX = display.cx - 370 + (index-1) * 185
	local posY = 100
    if textFlag ==  "24" then
    	showTutorial2({
		    text = GameConfig.tutor_talk[textFlag].talk,
		    rect = cc.rect(posX, posY, 130, 130),
		    x = posX - 320,
		    y = posY + 130,
		    callback = function(target)
		    	targetScene.selectLayer_:selectedGetListIndex(index)
		    	if callback then
		    		callback()
		    	end
		    	target:removeSelf()
		    end,
		})
	else
		showTutorial2({
		    text = GameConfig.tutor_talk[textFlag].talk,
		    rect = cc.rect(posX, posY, 130, 130),
		    x = posX + 230,
		    y = posY + 130,
		    scale = -1,
		    callback = function(target)
		    	targetScene.selectLayer_:selectedGetListIndex(index)
		    	if callback then
		    		callback()
		    	end
		    	target:removeSelf()
		    end,
		})
    end
end

function GuideClass:showStartButton(targetScene)
	local point = convertPosition(targetScene.startPlayBtn_, targetScene)
	local posX = point.x
	local posY = point.y

	showTutorial2({
		text = GameConfig.tutor_talk["11"].talk,
	    rect = cc.rect(posX, posY, 120, 120),
	    x = posX - 250,
	    y = posY + 120,
	    callback = function(target)
	        target:removeSelf()
	    	targetScene:didStartGame()
	    end,
	})

end



return GuideClass