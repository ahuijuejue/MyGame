--
-- Author: zsp
-- Date: 2014-12-05 11:26:30
--

local scheduler            = require(cc.PACKAGE_NAME .. ".scheduler")
local BattleEvent          = require("app.battle.BattleEvent")
local AngerButton          = import(".AngerButton")
local SkillButtonGroup     = import(".SkillButtonGroup")
local MemberButtonGroup    = import(".MemberButtonGroup")
local TailSkillButtonGroup = import(".TailSkillButtonGroup")
local BattlePauseDialog    = import(".BattlePauseDialog")

--[[
	战斗界面上的ui控件层
--]]
local BattleHubLayer = class("BattleHubLayer",function()
    return display.newNode()
end)

function BattleHubLayer:ctor(params) --(team,followNode)

	self:setNodeEventEnabled(true)

	local team       = params.team
	local tailSkill  = params.tailSkill
	local guide      = params.guide or {}

	self.isPaused   = false
	self.leader = team[1]
    
    self.timer = 0 --战斗使用的时间
	self.currTime             = 0  --记录当前时间，用于战斗倒计时
	self.timeOut              = params.timeOut or 300 --90秒一波战斗超时
	self.dtTimeOut            = 0  --倒计时计数
	self.__timeScheduleHandle = nil
	
	self.leader.onUpdateHit   = handler(self, self.onUpdateHit)

	self.goldBanner = display.newSprite("FGold_Banner.png")
	self.goldBanner:setAnchorPoint(0,0.5)
	self.goldBanner:setPosition(20,display.top-40)
	self.goldBanner:addTo(self)

	self.goldLabel =  display.newTTFLabel({
		text  = "0",
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.goldLabel:setAnchorPoint(0,0.5)
	self.goldLabel:setPosition(50,20)
	self.goldLabel:setColor(cc.c3b(255,255,0))
	self.goldLabel:addTo(self.goldBanner)

	self.itemBanner = display.newSprite("FItem_Banner.png")
	self.itemBanner:setAnchorPoint(0,0.5)
	self.itemBanner:setPosition(220,display.top-40)
	self.itemBanner:addTo(self)

	self.itemLabel =  display.newTTFLabel({
		text  = "0",
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.itemLabel:setAnchorPoint(0,0.5)
	self.itemLabel:setPosition(60,20)
	self.itemLabel:setColor(cc.c3b(255,255,0))
	self.itemLabel:addTo(self.itemBanner)

	self.waveLabel = display.newBMFontLabel({
    	text = "0/0",
    	font = "font_ui.fnt",
	})
	self.waveLabel:setPosition(display.cx,display.top - 40)
	self.waveLabel:setColor(cc.c3b(255, 255, 0))
	self.waveLabel:addTo(self)

	local timeBanner = display.newSprite("FTime_Banner.png")
	timeBanner:setAnchorPoint(1,0.5)
	timeBanner:setPosition(display.right-120,display.top-40)
	timeBanner:addTo(self)

	self.timeLabel =  display.newTTFLabel({
		text  = string.format("%d:%02d",math.floor(self.timeOut / 60) , self.timeOut % 60),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.timeLabel:setAnchorPoint(0,0.5)
	self.timeLabel:setPosition(40,20)
	self.timeLabel:setColor(cc.c3b(255,255,0))
	self.timeLabel:addTo(timeBanner)

	self.hitSprite = display.newSprite("hit.png")
	self.hitSprite:setAnchorPoint(0,0.5)
	self.hitSprite:setPosition(display.left + 50,display.top - 150)
	self.hitSprite:setVisible(false)
	self.hitSprite:addTo(self)

	self.hitLabel = cc.Label:createWithCharMap("battle_number.png",50,78,48)
	self.hitLabel:setAnchorPoint(0.5,0.5)
	self.hitLabel:setPosition(265,100)
	self.hitLabel:addTo(self.hitSprite)

	self.buttonLayer = display.newNode()
	self.buttonLayer:addTo(self)

	--队长变身前技能按钮组
	self.skillButtonGroup = {}

	local leaderSkillButtonGroup = SkillButtonGroup.new(self.leader,guide)
	leaderSkillButtonGroup:setPosition(display.width - leaderSkillButtonGroup:getContentSize().width,70)
	leaderSkillButtonGroup:addTo(self.buttonLayer)
	self.skillButtonGroup[1] = leaderSkillButtonGroup

	--队长变身后技能按钮组
	if self.leader.evolveNode then
		local superSkillButtonGroup = SkillButtonGroup.new(self.leader.evolveNode,guide)
		superSkillButtonGroup:setPosition(display.width - superSkillButtonGroup:getContentSize().width,70)
		superSkillButtonGroup:addTo(self.buttonLayer)
		self.skillButtonGroup[2] = superSkillButtonGroup
		self:createAngerButton(guide)
	end
	
	--登场队员按钮
	self.memberButtonGroup = MemberButtonGroup.new(params,guide)
	self.memberButtonGroup:addTo(self.buttonLayer)

	--尾兽技能按钮
	if tailSkill then
		self.tailSkillButtonGroup = TailSkillButtonGroup.new(self.leader,tailSkill)
		self.tailSkillButtonGroup:setPosition(display.width - 60, 180)
		self.tailSkillButtonGroup:addTo(self.buttonLayer)
	end

	self:startCountdown()
end

--[[
	添加暂停按钮 
	todo必须实例已经添加到场景后调用
--]]
function BattleHubLayer:addPauseButton()

	self.pauseBtn = cc.ui.UIPushButton.new({
       normal   = "Fight_Pause.png",
       pressed  = "Fight_Pause.png",
       disabled = "Fight_Pause.png"
	})

	self.pauseBtn:setPosition(display.right-50,display.top-40)
	self.pauseBtn:addTo(self)
	self.pauseBtn:onButtonClicked(handler(self, self.gamePause))

	self.pauseDialog = BattlePauseDialog.new()
	self.pauseDialog:setVisible(false)
	self.pauseDialog:addTo(self:getScene(),10000)
	self.pauseDialog:setContent("点击继续按钮继续游戏，点击退出按钮退出当前游戏场景")
	self.pauseDialog.resumeButton:onButtonClicked(function(event)
		self:gameResume()
	end)

	self.pauseDialog.exitButton:onButtonClicked(function(event)
    	self:stopCountdown()
    	self:gameResume()
        app:popToScene()
    end)

    return self
end

function BattleHubLayer:onUpdate(dt)
	-- if self.followRole then
	-- 	if self.followRole.evolveNode and self.followRole.evolveNode:isActive() then
	-- 		self.followRole = self.followRole.evolveNode
	-- 	end
		
	-- 	local w =  math.max(BattleManager.targetWidth - self.followRole:getPositionX(),0)
	-- 	self.followLabel:setString(string.format("终点:%d米",w)) 

	-- 	if w == 0 then
	-- 		self:unscheduleUpdate()

	-- 		--发送护送结束事件
	-- 	    BattleEvent:dispatchEvent({
	-- 	       name  = BattleEvent.ESCORT_END,
	-- 	       role  = owner
	-- 	    })
	-- 	end
	-- end
end

--[[
	创建队长的变身怒气按钮
--]]
function BattleHubLayer:createAngerButton(guide)
	self.angerButton = AngerButton.new(self.leader)
	self.angerButton.guide = guide.evolve
	self.angerButton:setScale(0.7)
	self.angerButton:setPosition(display.width - 280,60)
	self.angerButton:addTo(self.buttonLayer)
	self.leader.onUpdateAnger            = handler(self.angerButton, self.angerButton.onUpdateAnger1)
	self.leader.evolveNode.onUpdateAnger = handler(self.angerButton, self.angerButton.onUpdateAnger2)
	self.angerButton.onEvolveMode       = handler(self, self.setEvolveMode)
	self.angerButton:setEvolveMode(false)

	self.angerButton:onButtonClicked(function(event)
		self.angerButton:setGuideEnd()
		if self.leader == nil or not self.leader:isActive() then
			return
		end

		BattleEvent:dispatchEvent({
		    name  = BattleEvent.HERO_FALSH
		})

		if guide.evolve then
			local skills = self.leader.evolveNode.model.skillids
			local skillBtn = self.skillButtonGroup[2].btnMap[skills[1]]
			skillBtn.guide = true
		end

		self.angerButton:setButtonEnabled(false)
		self.angerButton.progress1:setPercentage(0)
		self.angerButton:setEvolveMode(true)
	end)
end

--[[
	隐藏界面上可操作的button
--]]
function BattleHubLayer:setButtonVisible(visible)
	self.buttonLayer:setVisible(visible)
	if self.pauseBtn then
		self.pauseBtn:setVisible(visible)
	end
end

--[[
	设置关注的角色，更新这个角色的距离标签
--]]
function BattleHubLayer:setFollowRole(role)
		--跟踪角色 显示终点进度
	self.followRole = role
	self.followLabel =  display.newTTFLabel({
		text  = string.format("%d米", BattleManager.targetWidth - self.followRole:getPositionX()),
		size  = 30,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	self.followLabel:setAnchorPoint(1,0.5)
	self.followLabel:setPosition(display.width - 100 ,display.height - 100)
	self.followLabel:setColor(cc.c3b(255,0,0))
	self.followLabel:addTo(self)
end

--[[
	显示暂停对话框
--]]
function BattleHubLayer:gamePause(event)
	self.pauseDialog:setVisible(true)
	display.pause()
end

--[[
	关闭展厅对话框
--]]
function BattleHubLayer:gameResume(event)
	self.pauseDialog:setVisible(false)
	display.resume()
end

--[[
	暂停
--]]
function BattleHubLayer:pauseAll()
	self:pause()
	self:stopCountdown()
	if self.memberButtonGroup then
		self.memberButtonGroup:pauseCooldown()
	end
end

--[[
	恢复暂停
--]]
function BattleHubLayer:resumeAll()
	self:resume()
	self:startCountdown()
	if self.memberButtonGroup then
	   self.memberButtonGroup:resumeCooldown()
	end
end

--[[
	设置变身模式 更新变身后的hub显示
--]]
function BattleHubLayer:setEvolveMode(mode)
	
	if not self.leader.evolveNode then
		return
	end
	-- -- body
	if mode then
		self.skillButtonGroup[1]:setVisible(false)
		self.skillButtonGroup[2]:setVisible(true)
	else 
		self.skillButtonGroup[1]:setVisible(true)
		self.skillButtonGroup[2]:setVisible(false)
	end
end

--[[
	显示连击数
--]]
function BattleHubLayer:showHit( hit )
	self.hitSprite:setVisible(true)
	if hit == 1 then
		self.hitSprite:setScale(display.width/self.hitSprite:getContentSize().width,display.height/self.hitSprite:getContentSize().height)  --------------------------------------------------连击动画效果
		local sequence = transition.sequence({
		    cc.ScaleTo:create(0.08, 1),
		})
		self.hitSprite:runAction(sequence)
	end
	self.hitLabel:setString(hit)
	self.hitLabel:stopAllActions()
	self.hitLabel:setScale(0)
	self.hitLabel:runAction(cc.ScaleTo:create(0.05,1)) 
end

--[[
	隐藏连击数
--]]
function BattleHubLayer:hideHit()
	self.hitSprite:setVisible(false)
end

--[[
	更新队长血量
--]]
function BattleHubLayer:onLeaderUpdateHp(role,hp,maxHp )
	--self.leaderHpProgress:setPercentage( hp * 1.0 / maxHp * 100)
end

--[[
	更新变身后队长血量
--]]
function BattleHubLayer:onSuperLeaderUpdateHp(role,hp,maxHp )
	-- self.superLeaderHpProgress:setPercentage( hp * 1.0 / maxHp * 100)
end

--[[
	更新连击次数
--]]
function BattleHubLayer:onUpdateHit(role,hit)
	if hit > 0 then
		self:showHit(hit)
	else
		self:hideHit()
	end
end

--[[
	更新波次提示
--]]
function BattleHubLayer:updateWave(wave,totalWave)
	self.waveLabel:setString(string.format("%d/%d",wave,totalWave))
end

--[[
	更新战斗倒计时
--]]
function BattleHubLayer:updateCountdown(dt)
	if self.isPaused then
		return
	end
	-- 更新战斗时长
	self.timer = self.timer + 1
	self.dtTimeOut = self.dtTimeOut + 1
	local time = self.timeOut - self.dtTimeOut
	self.timeLabel:setString(string.format("%d:%02d",math.floor(time / 60) , time % 60))

	if time == 0 then
		self:stopCountdown()
		BattleEvent:dispatchEvent({
			name    = BattleEvent.GAME_TIMEOUT
 		})
	end
end

--[[
	启动战斗时间计时器
--]]
function BattleHubLayer:startCountdown()
	
	self:stopCountdown()

	self.currTime = os.time()
	if not self.__timeScheduleHandle then
		self.__timeScheduleHandle = scheduler.scheduleGlobal(handler(self,self.updateCountdown),1)
	end
end

--[[
	停止战斗时间计时器
--]]
function BattleHubLayer:stopCountdown()
	if self.__timeScheduleHandle then
		scheduler.unscheduleGlobal(self.__timeScheduleHandle)
		self.__timeScheduleHandle = nil
	end
end

function BattleHubLayer:onExit()
	self:stopCountdown()
end

function BattleHubLayer:addGold(value)	
	local label =  display.newTTFLabel({
		text  = string.format("%d", value),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	local ax,ay = self.goldLabel:getAnchorPoint()
	label:setAnchorPoint(cc.p(ax,ay))
	local x,y = self.goldLabel:getPosition()
	label:setPosition(cc.p(x,y))
	label:setColor(cc.c3b(255,255,0))
	label:addTo(self.goldBanner)
	label:runAction(cc.Sequence:create(cc.MoveBy:create(0.2,cc.p(0,40)),cc.RemoveSelf:create()))

	local s = self.goldLabel:getString()
	self.goldLabel:setString(string.format("%s", checkint(s)+value))

end

--[[
	添加战利品显示数字
--]]
function BattleHubLayer:addChest(value)
	local label =  display.newTTFLabel({
		text  = string.format("%d", value),
		size  = 24,
		align = cc.TEXT_ALIGNMENT_CENTER -- 文字内部居中对齐
	})
	local ax,ay = self.itemLabel:getAnchorPoint()
	label:setAnchorPoint(cc.p(ax,ay))
	local x,y = self.itemLabel:getPosition()
	label:setPosition(cc.p(x,y))
	label:setColor(cc.c3b(255,255,0))
	label:addTo(self.itemBanner)
	label:runAction(cc.Sequence:create(cc.MoveBy:create(0.2,cc.p(0,40)),cc.RemoveSelf:create()))

	local s = self.itemLabel:getString()
	self.itemLabel:setString(string.format("%s", checkint(s)+value))
end

function BattleHubLayer:showGo()
	local sp = display.newSprite("guide_go.png")
	sp:setPosition(display.width - 200, display.cy)
	sp:addTo(self)
	sp:setVisible(false)
	sp:runAction(cc.Sequence:create(
		cc.DelayTime:create(1),
		cc.Show:create(),
		cc.FadeOut:create(0.5),
		cc.FadeIn:create(0.5),
		cc.FadeOut:create(0.5),
		cc.RemoveSelf:create()
	))
end

return BattleHubLayer