local BasicScene = import("..ui.BasicScene")
local UnionReadyBattleScene = class("UnionReadyBattleScene", BasicScene)

function UnionReadyBattleScene:ctor(stage)
	UnionReadyBattleScene.super.ctor(self,"UnionReadyBattleScene")
	self.heroList_ = {}
	self.stage = stage
	self:initView()
end

function UnionReadyBattleScene:initView()
	-- 背景
	CommonView.background()
	:addTo(self)
	:center()

	CommonView.blackLayer3()
	:addTo(self)

	-- 选择层
	self.selectLayer_ = app:createView("readyplay.UnionSelectHeroLayer", {limitnum = tonumber(self.stage.FighterNum)}):addTo(self)
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

function UnionReadyBattleScene:didStartGame()
	-- self:netToBattle()
	-- local ids, heroData = self.selectLayer_:getHeroList()
	-- local agents = ""
	NetHandler.gameRequest("BeginBattle",{param1 = self.stage.id})
end

function UnionReadyBattleScene:netToBattle(params)
	local dropData = params
	local ids, heros = self.selectLayer_:getHeroList()
	heros = clone(heros)

	function enterGame(data)
		local stage = self.stage
		local chapter = UnionListData:getChapterDataById(stage.Chapter)
		local power = chapter:getCostPower()
		local userLv = UserData:getUserLevel()

		local toData = {
			guide			=   {},
			star 			= 	UnionListData:getStageStar(stage.id),
			building 		= 	CityData:getBuilding(),
			seal_xing 		= 	SealData:getAttributeForBattle(),
			team 			= 	heros,
			customId 		= 	stage.id,
			item 			= 	data or {},
			gold 			= 	stage.Gold + userLv * 50 * power,
			uCoin			=   math.floor(userLv/10) + 1,
			skillValue 		= 	0,
			heroAppendExp 	= 	0,
			teamTotalExp 	= 	UserData.totalExp,
			teamAppendExp 	= 	0,
			secondStarTime 	= 	tonumber(stage.SecondStarTime),
    		thirdStarCondition = tonumber(stage.ThirdStarCondition),
    		type 			= 	stage.Type, 		-- 关卡类型
    		stageType 		= 	chapter.type, 		-- 普通 精英
    		endTime 		= 	stage.EndTime, 		-- 判定为失败的时长
    		tailSkill 		= 	{
    								level = SealData:getSealLevel(), 	-- 封印等级
    								skill = TailsData:getTailsSkillIdList(),	-- 尾兽技能id列表
    							},

    		winFunction 	= 	function()
    								AudioManage.playMusic("Main.mp3",true)
    								app:popScene()
    							end,
    		failedFunction 	= 	function()
    								AudioManage.playMusic("Main.mp3",true)
    								app:popScene()
    							end,
		}

		if toData.type == 3 then -- 护送
			toData.escortId = stage.EscortID
			toData.escortLevel = stage.EscortLevel
		end

		app:enterScene("BattleScene", {toData})
	end

	enterGame(dropData)
end

function UnionReadyBattleScene:netCallback(event)
    local data = event.data
    local order = data.order
    if order == OperationCode.BeginBattleProcess then
    	local dropArr = dataToItem(data.param1)
    	self:netToBattle(dropArr)
    end
end

function UnionReadyBattleScene:onEnter()
    self.netEvent = GameDispatcher:addEventListener(EVENT_CONSTANT.NET_CALLBACK,handler(self,self.netCallback))
end

function UnionReadyBattleScene:onExit()
	GameDispatcher:removeEventListener(self.netEvent)
end

return UnionReadyBattleScene