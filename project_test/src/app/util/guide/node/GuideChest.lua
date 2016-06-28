--[[
引导宝箱
]]

local GuideNode = import("..GuideNode")
local GuideClass = class("GuideClass", GuideNode)

-- overwrite
-- 引导操作
function GuideClass:makeGuide_(targetScene)
	if GuideData:isCompleted("Chest") then return false end

	if targetScene.name == "MainScene" then
		self:showMainSceneGuide(targetScene)
		return true
	elseif targetScene.name == "ChapterScene" then
		self:showChapterGuide(targetScene)
		return true
	end

	return false
end

function GuideClass:showMainSceneGuide(targetScene)
	local posX = display.cx + 170
    local posY = display.cy - 50

    showTutorial2({
        text = GameConfig.tutor_talk["9"].talk,
        rect = cc.rect(posX, posY, 200, 200),
        x = posX - 265,
        y = posY + 155,
        callback = function(target)
            SceneData:pushScene("Chapter", self)
            target:removeSelf()
        end,
    })
end

function GuideClass:showChapterGuide(targetScene)
	targetScene:scrollIndex(1, false)

	local item = targetScene.listView_:getItemAtIndex(1)
	local pos = convertPosition(item, targetScene)

	UserData:showGuideLayer({
        text = GameConfig.tutor_talk["21"].talk,
        x = pos.x + 60,
        y = pos.y - 110,
        offX = -250,
        offY = 120,
        callback = function(target)
        	GuideData:setCompleted("Chest", function()
				self:showChestGuideAward(function()
					targetScene:onGuide()
				end)
				targetScene:updateListView()
			end,
			function()
				targetScene:onGuide()
			end)
        end,
    })
end

-- 宝箱引导 获取奖励
function GuideClass:showChestGuideAward(callback)
	local items = {}
	local chapter = ChapterData:getChapterAtIndex(1, false)
	for j=1,3 do
		for i,v in ipairs(ChapterData:getAwardData(chapter.id, j)) do
			local itemdata = ItemData:getItemConfig(v.id)
		 	table.insert(items, {
		 		itemId = v.id,
		 		count  = v.count,
		 		name   = itemdata.itemName,
		 	})

		 	-- 增加奖励物品
			UserData:addItem(v.id, v.id, v.count)
		end
	end

	-- 增加领取星级奖励次数
	ChapterData:setAwardNum(chapter.id, 3)
	UserData:showReward(items, callback)

end

return GuideClass
