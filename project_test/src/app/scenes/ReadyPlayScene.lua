--[[
主线关卡备战界面
]]
local ReadyPlayScene = class("ReadyPlayScene", base.Scene)

--[[
@param options table 参数表
-chapterId  章节id
-stageId  关卡id
]]


function ReadyPlayScene:initData(options)
	self.heroList_ = UserData:getBattleList()
	self.chapterId = options.chapterId
	self.stageId = options.stageId
	self.stageType = options.stageType
end

function ReadyPlayScene:initView()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 关卡数据
	local stageData = ChapterData:getStage(self.stageId)

	-- 选择层
	self.selectLayer_ = app:createView("readyplay.SelectHeroLayer", {limitnum = stageData.fighterMax}):addTo(self)
	:setHeroList(self.heroList_)
	:onTouch(function(event)
		local name = event.name
		if name == "selected" then
			self.startPlayBtn_:setButtonEnabled(true)
		elseif name == "unselected" then
			if event.count <= 0 then
				self.startPlayBtn_:setButtonEnabled(false)
			end
		end
		-- body
	end)

	-- 开始按钮
	self.startPlayBtn_ = CommonButton.start()
	:onButtonClicked(function(event)
		CommonSound.click() -- 音效
		if self.selectLayer_:canSelected() then
			local msg = base.Label.new({text="现在未满员出战，是否继续开始战斗？", size=20}):align(display.CENTER)

			AlertShow.show2("友情提示", msg, "确定", function()
				self:didStartGame()
			end)
		else
			self:didStartGame()
		end
	end)
	:addTo(self)
	:pos(display.cx + 400, 220)
	:zorder(10)
	:setButtonEnabled(false)

	-- 返回按钮
	CommonButton.back()
	:onButtonClicked(function(event)
		CommonSound.back() -- 音效

		self:pop()
	end)
	:addTo(self)
	:pos(display.right - 90, display.top - 60)
	:zorder(10)

end

function ReadyPlayScene:didStartGame()
	local ids, heroData = self.selectLayer_:getHeroList()
	NetHandler.request("BeginBattle", {
		data={
			param1 = self.stageId,
			param2 = table.concat(ids, ","), -- 英雄列表
		},
		onsuccess = function(data)
			self:completedGuide(data)
		end
	}, self)
end

function ReadyPlayScene:completedGuide(params)
	if self.guideData.tipsGuide then
		GuideData:setCompleted(self.guideData.param100, function()
			self:netToBattle(params)
		end,
		function()

		end)
	else
		self:netToBattle(params)
	end
end

function ReadyPlayScene:netToBattle(params)
	local dropData = params.drops

	local ids, heros = self.selectLayer_:getHeroList()
	heros = clone(heros)

	local dataInfo = self.data

	function enterGame(data)
		local stage = ChapterData:getStage(self.stageId)
		local chapterData = ChapterData:getChapter(self.chapterId)

		local costPower = chapterData.power

		local exp1 = UserData.totalExp  		-- 战前战队经验值
		local exp2 = exp1 + stage:getTeamExp()	-- 战后战队经验值
		local level1 = GameExp.getUserLevel(exp1)
		local level2 = GameExp.getUserLevel(exp2)
		local addLevel = level2 - level1

		local toData = {
			star 			= 	stage:getStar(),
			building 		= 	CityData:getBuilding(),
			seal_xing 		= 	SealData:getAttributeForBattle(),
			guide 			= 	self.guideData,
			team 			= 	heros,
			customId 		= 	stage.id,
			item 			= 	data or {},
			gold 			= 	stage.gold + level1 * 10 * costPower,
			skillValue 		= 	stage.soul + math.floor(level1 * 0.2 * costPower),
			heroAppendExp 	= 	stage.heroExp + level1 * costPower,
			teamTotalExp 	= 	UserData.totalExp,
			teamAppendExp 	= 	stage:getTeamExp(),
			secondStarTime 	= 	stage.star2,
    		thirdStarCondition = stage.star3,
    		type 			= 	stage.type, 		-- 关卡类型
    		stageType 		= 	self.stageType, 	-- 普通。精英
    		endTime 		= 	stage.endTime, 		-- 判定为失败的时长
    		tailSkill 		= 	{
    								level = SealData:getSealLevel(), 	-- 封印等级
    								skill = TailsData:getTailsSkillIdList(),	-- 尾兽技能id列表
    							},

    		winFunction 	= 	function()
    								print("win function")
    								AudioManage.playMusic("Main.mp3",true)

									if dataInfo.isFirstOver then
										print("is first")
    									if dataInfo.isEndStage then
    										local index = app:indexOfScene("ChapterScene")
    										if index == 0 then
    											app:popScene()
    										else
	    										SceneData:pushScene("Chapter", {elite=stage:isElite()}, self)
    										end
    									elseif not dataInfo.nextStageId then
    										app:popScene()
    									else
    										SceneData:pushScene("Stage", {stageId=dataInfo.nextStageId}, self)
    									end
    								else
    									print("not first")
    									app:popScene()
    								end

    							end,
    		failedFunction 	= 	function()
    								print("failed function")
    								AudioManage.playMusic("Main.mp3",true)
    								app:popScene()
    							end,
		}

		-------------------------
		if addLevel > 0 then
			toData.levelUp = {
				power1 = UserData.power - chapterData.power, 					-- 升级前 体力
				powerMax1 = GameExp.getLimitPower(exp1),						-- 升级前 体力上限
				levelMax1 = GameExp.getHeroLimitLv(exp1), 						-- 升级前 英雄等级上限
				power2 = UserData.power - chapterData.power + GlobalData.addPower * addLevel,	-- 升级后 体力
				powerMax2 = GameExp.getLimitPower(exp2),						-- 升级后 体力上限
				levelMax2 = GameExp.getHeroLimitLv(exp2),						-- 升级后 英雄等级上限
			}
		end

		if toData.type == 3 then -- 护送
			toData.escortId = stage.escortId
			toData.escortLevel = stage.escortLevel
		end

		app:enterScene("BattleScene", {toData})
	end

	-- 进入战斗场景
	enterGame(dropData)
end

function ReadyPlayScene:updateData()
	local stage = ChapterData:getStage(self.stageId)
	local chapterData = ChapterData:getChapter(self.chapterId)

	self.data = {
		stageData = stage,
		isFirstOver 	= stage.passLevel == 0,					-- 是否是第一次通关
		nextStageId 	= ChapterData:getNextStageId(self.chapterId, stage.id), 	-- 下一关id
		isEndStage 		= chapterData:isLastStage(stage.id) 	-- 是否是本章最后一关
	}

	self.guideData = {}
end

------------------------------------------------
-- 新手引导
function ReadyPlayScene:onGuide()
	GuideManager:makeReadyGuide(self, self.data, self.guideData)
end

function ReadyPlayScene:showSelectGuideIndex(index, textFlag, callback)
	local posX = display.cx - 370 + (index-1) * 185
	local posY = 100

	showTutorial2({
	    text = GameConfig.tutor_talk[textFlag].talk,
	    rect = cc.rect(posX, posY, 130, 130),
	    x = posX + 250,
	    y = posY + 20,
	    callback = function(target)
	        self.selectLayer_:selectedGetListIndex(index)
	    	if callback then
	    		callback()
	    	end
	    	target:removeSelf()
	    end,
	})

end

function ReadyPlayScene:showExchangeRole(callback)
	local posX = display.cx + 200
	local posY = display.cy + 120
	local startX = posX + 150
	local startY = posY - 70
	local endX = posX - 30
	local endY = posY + 40
	local moveAction = cc.RepeatForever:create(cc.Sequence:create(
		cc.MoveTo:create(1, cc.p(endX, endY)),
		cc.DelayTime:create(1),
		cc.MoveTo:create(0, cc.p(startX, startY))
	))
    local guideLayer = app:createView("widget.GuideLayer"):addTo(self):zorder(10)
    :showRect(440, 320, posX, posY, nil, false)

    local finger = display.newSprite("shou.png"):pos(startX, startY)
    :addTo(guideLayer)
    finger:runAction(moveAction)

    local box = display.newSprite("talk_box_2.png"):pos(posX - 450, posY)
	:addTo(guideLayer)

	base.Label.new({
		text = GameConfig.tutor_talk["27"].talk,
		size = 18,
		color = cc.c3b(0, 0, 0),
		border = false,
	}):align(display.CENTER)
	:pos(240, 70)
	:addTo(box)


    local isShow = false
    local item1 = self.selectLayer_.getViewList_[1]
    local item2 = self.selectLayer_.getViewList_[3]
    base.Grid.new()
    :addTo(self)
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
				self.selectLayer_:movedGetGrid(1, event.x, event.y)
			end
		elseif event.name == "ended" then
			if isShow then
				if item2:hiteTest(event.x, event.y) then
					self.selectLayer_:endedGetGrid(1, event.x, event.y)
					guideLayer:removeSelf()
					if callback then
						callback()
					end
				else
					self.selectLayer_:endedGetGrid(1, 0, 0)
				end
				isShow = false
			end
		end
	end, cc.size(440, 320))



end

function ReadyPlayScene:showStartGuide()
	local point = convertPosition(self.startPlayBtn_, self)
	local posX = point.x
	local posY = point.y

	showTutorial2({
		text = GameConfig.tutor_talk["14"].talk,
	    rect = cc.rect(posX, posY, 120, 120),
	    x = posX - 250,
	    y = posY + 20,
	    callback = function(target)
	        target:removeSelf()
	    	self:didStartGame()
	    end,
	})

end


return ReadyPlayScene
