--[[
梦幻之书场景
]]
local TrialScene = class("TrialScene", base.Scene)

local images = {
	"Trials_Train.png",
	"Trials_Aincrad.png",
	"Trials_Defence.png",
}


local scene_enter = {
	"HolyLand",
	"Aincrad",
	"Tree",
}

--[[
--@param params
- toIndex  1 修炼圣地 2 艾恩葛朗特 3 世界树

]]


function TrialScene:initData(params)
	self.toIndex_ = params.toIndex or 1
end

function TrialScene:initView()
	self:autoCleanImage()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer2()
	:addTo(self)

	-- 按钮层
	app:createView("widget.MenuLayer", {user=false}):addTo(self)
	:onBack(function(layer)
		self:pop()
	end)

-- 主层
------------------------------------------------------
-- 背景框
	-- 标题

	CommonView.titleLinesFrame2()
	:addTo(self)
	:pos(display.cx, display.height - 55)


	display.newSprite("word_book.png"):addTo(self)
	:pos(display.cx, display.height - 55)

-----------------------------------------------------

	-- 列表
	self.listView_ = base.RotateGrid.new({radius=330})
	:addTo(self.layer_)
	:pos(480, 350)
	:onTouch(function(event)
		if event.name == "clicked" then
			CommonSound.click() -- 音效
			self:onButtonEnter()
		end
	end)


---------------------------------------------------------------
	-- 左右按钮
	base.Grid.new()
	:addTo(self.layer_)
	:pos(50, 350)
	:setNormalImage(display.newSprite("Trials_Right_Arrow.png"):rotation(-180))
	:onTouch(function(event)
		if event.name == "clicked" then
			CommonSound.click() -- 音效

			self.listView_:showPrevious(true)
		end
	end)

	base.Grid.new()
	:addTo(self.layer_)
	:pos(910, 350)
	:setNormalImage(display.newSprite("Trials_Right_Arrow.png"))
	:onTouch(function(event)
		if event.name == "clicked" then
			CommonSound.click() -- 音效

			self.listView_:showNext(true)
		end
	end)

-------------------------------------------------------------
	-- 规则 按钮
	CommonButton.yellow("说明", {size=28})
	:addTo(self)
	:zorder(5)
	:pos(display.cx - 200, 70)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效

		local index = self.listView_:getCurrentIndex()
		self.ruleLayer_:show()
		:setTitle(TrialData:getRuleTitle(index))
		:setRule(TrialData:getRuleText(index))
	end)

	-- 进入 按钮
	CommonButton.green("进入", {size=28})
	:addTo(self)
	:zorder(5)
	:pos(display.cx, 70)
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		self:onButtonEnter()
	end)

	-- 奖励 按钮
	CommonButton.red("奖励", {size=28})
	:addTo(self)
	:zorder(5)
	:pos(display.cx + 200, 70)
	:onButtonClicked(function(event)
		if event.comb == 1 then
			CommonSound.click() -- 音效

			local index = self.listView_:getCurrentIndex()
			self:showReward(index)
		end
	end)

---------------------------------------------------
	-- 规则层
	self.ruleLayer_ = app:createView("trial.TrialRuleLayer"):addTo(self)
	:zorder(105)
	:hide()
	:onClose(function(event)
		event.target:hide()
	end)

end

function TrialScene:onButtonEnter(callback)
	print("进入")
	local index = self.listView_:getCurrentIndex()

	if self.lv >= self.openLv[index] then
		if scene_enter[index] then
			self.toIndex_ = index
			SceneData:pushScene(scene_enter[index], self, callback)
		end
	end
end

function TrialScene:showReward(index)
	print("reward:", index)
	if not self.rewardLayer_ then
		self.rewardLayer_ = base.Grid.new():addTo(self)
		:setNormalImage(display.newSprite("Trials_Award.png"):pos(0, 0))
		:pos(display.cx + 220, 230)
		:zorder(10)
		:onTouch(function(event)
			if event.name == "began" then
				event.target:hide()
			end
		end, cc.size(display.width * 2, display.height * 2))
	end
	local reward = TrialData:getRewardShow(index)
	self.rewardLayer_:show()
	:removeItems()

	for i,v in ipairs(reward) do
		self.rewardLayer_:addItems({
			display.newSprite(v.icon):pos(-60, 45 * (2 - i)):scale(0.45),
			base.Label.new({text=v.name, size=20}):pos(-20, 45 * (2 - i)),
		})
	end

end

-----------------------------------------

function TrialScene:updateData()
	self.lv = UserData:getUserLevel()

	self.openLv = {
		OpenLvData.holyLand.openLv,
		OpenLvData.aincrad.openLv,
		OpenLvData.tree.openLv,
	}

end

function TrialScene:updateView()
	self:updateListView()

	if self.toIndex_ ~= self.listView_:getCurrentIndex() then
		self.listView_:showIndex(self.toIndex_, false)
	end
end

function TrialScene:updateListView()
	self.listView_:removeAllItems()
	:addItems(3, function(item, index)
		local openLevel = self.openLv[index]
		if self.lv < openLevel then
			item:addSprite(CommonView.filter_gray(images[index]))
			item:addItem(display.newSprite("Trials_Lock.png"):scale(1.1))
			local str = string.format("战队%d级开启", openLevel)
			item:addItem(base.Label.new({text=str, size=26, color=cc.c3b(255, 0, 0)}):align(display.CENTER):pos(0, -100))
		else
			item:addSprite(display.newSprite(images[index]))
		end
	end)
	:homeItems(false)
end

----------------------------------------------
-- 新手引导
function TrialScene:onGuide()
	local level = UserData:getUserLevel()

	if level < OpenLvData.dreamBook.openLv then return end
	if GuideData:isNotCompleted("DreamBook") then -- 梦幻之书
		self.toIndex_ = 1
		self.listView_:showIndex(1, false)
		self:showStartGuide(GameConfig.tutor_talk["56"].talk, function(target)
			target:removeSelf()
			GuideData:setCompleted("DreamBook", function()
				self:onButtonEnter()
			end,
			function()
				self:onGuide()
			end)
		end)

	elseif GuideData:isNotCompleted("Aincrad") then -- 艾恩葛朗特
		self.toIndex_ = 1
		self.listView_:showIndex(1, false)
		if level < OpenLvData.aincrad.openLv then return end
		self:showGuideNextButton(function()
			self.listView_:showNext()
			self:showStartGuide(GameConfig.tutor_talk["56"].talk, function(target)
				self:onButtonEnter()
				target:removeSelf()
			end)
		end)

	elseif GuideData:isNotCompleted("WorldTree") then -- 世界树
		self.toIndex_ = 1
		self.listView_:showIndex(1, false)
		if level < OpenLvData.tree.openLv then return end
		self:showGuidePreButton(function()
			self.listView_:showPrevious()
			self:showStartGuide(GameConfig.tutor_talk["56"].talk, function(target)
				self:onButtonEnter(function()
					target:removeSelf()
				end)
			end)
		end)
    end

end

function TrialScene:showGuidePreButton(callback)
    UserData:showGuideLayer({
        text = GameConfig.tutor_talk["58"].talk,
        x = display.cx - 430,
        y = display.cy + 30,
        offX = 300,
        offY = 120,
        scale = -1,
        callback = function(target)
        	if callback then
        		callback(target)
        	end
        end,
    })
end

function TrialScene:showGuideNextButton(callback)
    local posX = display.cx + 430
	local posY = display.cy + 30

    showTutorial2({
        text = GameConfig.tutor_talk["58"].talk,
        rect = cc.rect(posX, posY, 100, 100),
        x = posX - 300,
        y = posY+110,
        callback = function(target)
        	if callback then
        		callback()
        	end
        	target:removeSelf()
        end,
    })
end

function TrialScene:showStartGuide(text, callback)
	local posX = display.cx
	local posY = 70

    showTutorial2({
        text = text,
        rect = cc.rect(posX, posY, 220, 100),
        x = posX-240,
        y = posY + 130,
        callback = callback,
    })

end


return TrialScene