--[[
引导进入1-2
]]

local GuideFightBase = import(".GuideFightBase")
local GuideClass = class("GuideClass", GuideFightBase)

-- overwrite
function GuideClass:guideMainScene(targetScene)
	-- showAside({key = "10006",callback = function ()
		GuideClass.super.guideMainScene(self, targetScene)
	-- end})
end

function GuideClass:guideReadyScene(targetScene, params, outparams)
	outparams.param100 = self.data.name

	local layer = targetScene.selectLayer_
	layer:setHeroList(string.split(self.data.itemId, ","))
	layer:updateData()
	layer:updateView()
	showAside({key = "10006",callback = function ()
		self:showExchangeRole(targetScene, function()
			self:showStartButton(targetScene)
		end)
	end})
end

local function exchangeIndex(startIdx, endIdx, targetScene, callback)
	-- 显示框
	local guideLayer = app:createView("widget.GuideLayer"):addTo(targetScene):zorder(10)

	local item1 = targetScene.selectLayer_.getViewList_[startIdx]
    local item2 = targetScene.selectLayer_.getViewList_[endIdx]

    local pos1 = convertPosition(item1, guideLayer)
    local pos2 = convertPosition(item2, guideLayer)

	local posX = pos1.x
	local posY = pos1.y
	local startX = posX
	local startY = posY
	local endX = pos2.x
	local endY = pos2.y
	local moveAction = cc.RepeatForever:create(cc.Sequence:create(
		cc.MoveTo:create(1, cc.p(endX + 50, endY)),
		cc.DelayTime:create(1),
		cc.MoveTo:create(0, cc.p(startX, startY))
	))

    guideLayer:showRect(700, 320, (posX+endX)*0.5, posY, nil, false)

    local finger = display.newSprite("shou.png"):pos(startX, startY)
    :addTo(guideLayer)
    finger:runAction(moveAction)

    local box = display.newSprite("talk_box_2.png"):pos((posX+endX)*0.5-110, posY + 150)
	:addTo(guideLayer)

	base.Label.new({
		text = GameConfig.tutor_talk["20"].talk,
		size = 18,
		color = cc.c3b(0, 0, 0),
		border = false,
	}):align(display.CENTER)
	:pos(350, 70)
	:addTo(box)

    local isShow = false

    base.Grid.new()
    :addTo(targetScene)
    :zorder(11)
    :pos(posX, posY)
    :onTouch(function(event)
    	if event.name == "began" then
    		if item1:hiteTest(event.x, event.y) then
    			isShow = true
    		else
    			isShow = false
    		end
		elseif event.name == "moved" then
			if isShow then
				targetScene.selectLayer_:movedGetGrid(startIdx, event.x, event.y)
			end
		elseif event.name == "ended" then
			if isShow then
				if item2:hiteTest(event.x, event.y) then
					targetScene.selectLayer_:endedGetGrid(startIdx, event.x, event.y)
					guideLayer:removeSelf()
					if callback then
						callback()
					end
				else
					targetScene.selectLayer_:endedGetGrid(startIdx, 0, 0)
				end
				isShow = false
			end
		end
	end, cc.size(440, 320))

	base.Grid.new()
    :addTo(targetScene)
    :zorder(11)
    :pos(endX, endY)
    :onTouch(function(event)
    	if event.name == "began" then
    		if item2:hiteTest(event.x, event.y) then
    			isShow = true
    		else
    			isShow = false
    		end
		elseif event.name == "moved" then
			if isShow then
				targetScene.selectLayer_:movedGetGrid(endIdx, event.x, event.y)
			end
		elseif event.name == "ended" then
			if isShow then
				if item1:hiteTest(event.x, event.y) then
					targetScene.selectLayer_:endedGetGrid(endIdx, event.x, event.y)
					guideLayer:removeSelf()
					if callback then
						callback()
					end
				else
					targetScene.selectLayer_:endedGetGrid(endIdx, 0, 0)
				end
				isShow = false
			end
		end
	end, cc.size(440, 320))
end

function GuideClass:showExchangeRole(targetScene, callback)
	exchangeIndex(1, 2, targetScene, callback)

end


return GuideClass
