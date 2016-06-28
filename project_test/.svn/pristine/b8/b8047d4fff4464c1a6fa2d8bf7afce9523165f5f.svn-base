--
-- Author: zsp
-- Date: 2014-11-20 17:21:22
--

local RoleNode       = import(".RoleNode")
local CharacterModel = import("..model.CharacterModel")
local StateManager   = import("..state.StateManager")
local BattleManager  = import("..BattleManager")
local BattleEvent    = import("..BattleEvent")
local TailSkillNode  = import(".TailSkillNode")
local CharacterNode  = class("CharacterNode", RoleNode)

--[[
	玩家角色 队长和召唤队员类，如队长和成员需求变化大在拆此类 
--]]
function CharacterNode:ctor(params)
	-- body
	params.camp      = params.camp or GameCampType.left
	params.enemyCamp = params.enemyCamp or GameCampType.right
	
	self.isLeader    = params.isLeader or false
	self.evolveNode  = params.evolveNode or nil --变身后的角色 目前只有队长角色使用

	if self.isLeader then
		params.hpBarFixed = true
	end

	CharacterNode.super.ctor(self,params)

	local stateName = "LeaderState"
	if not self.isLeader then
		stateName            = "MemberState"
		--是否跟随队长 todo 暂时未实现这个
		self.isFollowLeader  = true
		if params.isFollowLeader ~= nil and params.isFollowLeader == false then
		 	self.isFollowLeader  = false
		end
		--队长在前 超过这个范围 则前进
		self.followDistance  = params.followDistance or 0
		--队长在后 超过这个范围 则后退
		self.retreatDistance = 400 -- 没有考虑在右边情况
		--待机时和队长保持的距离
		self.leaderDistance  = params.leaderDistance or (self.model.attackSize.width - BattleManager.getLeader(self.camp).model.attackSize.width)
		--print( self.model.attackSize.width - BattleManager.getLeader(self.camp).model.attackSize.width)
		
		--队员需要扩展视野距离，以便发现队长前边的敌人，主动上前攻击
		self.expandViewDistance	= params.expandViewDistance or 300 	
		--增大视野范围
		self.model.viewSize = cc.size(self.model.viewSize.width + self.expandViewDistance,self.model.viewSize.height)
		self.viewBox:setContentSize(self.model.viewSize)
		self:restBoundingBox()
		
		--print(string.format("roleId = %s 添加登场技能 skillId == %s",self.roleId,self.model.enterSkillId))
		self.enterSkillMgr = require("app.battle.skill.EnterSkillManager").new(self)
		local enterSkill = self.enterSkillMgr:getSkill()
		--到二阶品质后有上场技能,添加上场技能的碰撞盒
		if enterSkill then
			local box = cc.LayerColor:create(cc.c4b(255, 255, 0, 50))
			self["skillBox"..self.model.enterSkillId] = box
			box:setContentSize(enterSkill.nodeSize)
			box:setPosition(enterSkill.nodeOffset)
			box:setVisible(false)
			box:addTo(self)
		end
	else

		--[[
			获取技能解锁帧
		--]]
		function getUnLockFrameBySkillFrame(tb)
			local frame = checkint(tb[#tb])
			for i=1,#tb -1  do
		    	if checkint(tb[i]) > checkint(tb[i+1]) then
				 	frame = checkint(tb[i])
				 	return frame
				end 
		    end
		    return frame
		end

		--手动控制队长释放技能时锁定移动状态 让其不能被移动打断
		self.skillUnLockFrameMap = {}
		for k,v in ipairs(self.skillFrameMap) do
			--print(i,v)
			self.skillUnLockFrameMap[k] = getUnLockFrameBySkillFrame(v)
		end
		
		if not self:isEvolve() then
			require("app.battle.skill.AwakeSkillManager").new(self)
		end
	end

	self.state    = require("app.battle.state."..stateName)
	self.stateMgr = StateManager.new(self,self.state.idle)

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self:update(dt)
	end)

	self:scheduleUpdate()

	if self.isLeader then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.CallFunc:create(function()
			self:showHpBar()
		end)))
	end
end

function CharacterNode:update( dt )
	if self.isPaused then
		return
	end
	
	self.stateMgr:update(dt)
	self.skillMgr:update(dt)
	self.buffMgr:update(dt)

	if self.tailSkillMgr then
		self.tailSkillMgr:update(dt)
	end
end

--[[
	只是根据ID判断是不是变身角色
--]]
function CharacterNode:isEvolve()
	-- body
	if checkint(self.roleId) % 2 == 0 then
		return true
	end

	return false
end


--[[
	播放变身动画
--]]
function CharacterNode:playEvolve()
	self:playAnim("evolve", false)
end

--[[
	执行变身动作
--]]
function CharacterNode:doEvolve()
	self.stateMgr:changeState(self.state.evolve)
end

--[[
	执行尾兽技能
--]]
function CharacterNode:doTailSkill(skillId)
	self.tailSkillMgr:setReleaseSkillById(skillId)
	self.stateMgr:changeState(self.state.idle)

	local skill = self.tailSkillMgr:getSkillById(skillId)
	local skillNode = TailSkillNode.new(self,skill)
	
	skillNode:addTo(self:getParent())
	if self.camp == GameCampType.left then
		skillNode:setPosition(cc.pAdd(cc.p(self:getPosition()),skill.nodeOffset))
	else
		skillNode:setPosition(cc.pSub(cc.p(self:getPosition()),skill.nodeOffset))
	end	

	self.tailSkillMgr:resetCooldownById(skillId)
	self.tailSkillMgr:doNextSkillNum()
end

--[[
	创建角色的变身
--]]
function CharacterNode:createEvolve()
	if checkint(self.roleId) % 2 == 0 then
		return nil
	end
	
	local evolveId = tostring(checkint(self.roleId) + 1)
	local config = GameConfig.character[evolveId]

	local skillLevel = {}

	--把变身前的技能等级设置给变身后的角色
	for i=1,4 do
		local sid = self.model.skills[i]
		local level = self.model.skillLevel[sid]
		local evolveSid = config[string.format("skill%d",i)]
		skillLevel[evolveSid] = level
	end

	local evolveNode = CharacterNode.new({
        auto = self.auto,
        isForward = self.isForward,
        isLeader = self.isLeader,
        camp = self.camp,
       	enemyCamp = self.enemyCamp,
       	followDistance     = self.followDistance,  
        expandViewDistance = self.expandViewDistance,
        nodeScale = self.nodeScale,
        model = CharacterModel.new({
			roleId      = evolveId,
			level       = self.model.level,
			starLv      = self.model.starLv,
			strongLv    = self.model.awakeLevel,
			leaderWater = self.model.leaderWater,
			memberWater = self.model.memberWater,
			skillLevel  = skillLevel,
			stone 		= self.model.stones,
			equip       = self.model.equip,
			propertyScale = self.model.propertyScale
        })
    })

	-- dump(self.model.property)
	-- dump(evolveNode.model.property)

    evolveNode.subAnger = self.subAnger
    evolveNode.addAnger = self.evolveAddAnger
	evolveNode.isSkillCooldownEnable = self.isSkillCooldownEnable
    evolveNode:setLocalZOrder(self:getLocalZOrder())
    self.evolveNode = evolveNode

    return evolveNode
end

--[[
	 显示登场技能特效
--]]
function CharacterNode:showEnterEffect() 
    local effectName = nil
	if self.model:checkEvolve() then
		effectName = GameConfig.character[self.roleId].enter_effect
	else
		effectName = "enter_effect_6"
	end

	local effect = GafAssetCache.makeAnimatedObject(effectName)
	local frameSize = effect:getFrameSize()
    local x,y = self:getPosition()

   	effect:setLocalZOrder(self:getLocalZOrder())
    effect:setPosition(frameSize.width * - 0.5 + x, frameSize.height - 440 + y)
    effect:addTo(self:getParent())
    effect:start()

     effect:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
    	self:setVisible(true)
    	self.enterSkillMgr:releaseSkill()
    	
		BattleEvent:dispatchEvent({
			name    = BattleEvent.ENTER_SKILL_EFFECT_END,
			member  = self,
		})
	end),cc.RemoveSelf:create()))

  	BattleEvent:dispatchEvent({
		name    = BattleEvent.ENTER_SKILL_EFFECT_BEGIN,
		member  = self,
    })
end

--[[
	 显示登场技能特效
--]]
function CharacterNode:showEvolutionEffect() 
    local evolveName = GameConfig.character[self.roleId].evolve_effect
	local evolveFrame = checkint(GameConfig.character[self.roleId].evolve_frame)
	local effect = GafAssetCache.makeAnimatedObject(evolveName)

    local frameSize = effect:getFrameSize()
    local x,y = self:getPosition()

    effect:setLocalZOrder(self:getLocalZOrder())
    effect:setPosition(frameSize.width * - 0.5 + x, frameSize.height - 440 + y)
    effect:addTo(self:getParent())
    effect:start()

    effect:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
		BattleEvent:dispatchEvent({
			name    = BattleEvent.EVOLVE_EFFECT_END,
			sender  = self,
	    })
	end),cc.RemoveSelf:create()))


  	BattleEvent:dispatchEvent({
		name    = BattleEvent.EVOLVE_BEGIN,
		sender  = self,
	})
end

--[[
	战斗刚开始时候，显示创建角色时的时的登场动画
--]]
function CharacterNode:showCreateEffect(delay,callback)
	self.animNode:setVisible(false)

	AudioManage.playSound("enter_effect_5.mp3",false)
	
	local effect = GafAssetCache.makeAnimatedObject("enter_effect_5")
    local frameSize = effect:getFrameSize()
    local x,y = self:getPosition()

    effect:setLocalZOrder(self:getLocalZOrder())
    effect:setPosition(frameSize.width * - 0.5 + x, frameSize.height - 440 + y)
    effect:addTo(self:getParent())
    effect:setVisible(false)

	self:runAction(cc.Sequence:create(cc.DelayTime:create(delay),cc.CallFunc:create(function()
		effect:setVisible(true)
		effect:start()
	end),cc.DelayTime:create(1),cc.CallFunc:create(function()
		self.animNode:setVisible(true)
		effect:removeFromParent()
		if callback then
			callback()
		end
	end)))

end

--[[
   获取对应技能解锁的的帧数
--]]
function CharacterNode:getSkillUnLockFrame(skillNum)
	return self.skillUnLockFrameMap[skillNum]
end

function CharacterNode:destory()
	CharacterNode.super.destory(self)
	if self.enterEffect then
		self.enterEffect:unregisterScriptHandler()
	end
	
	if self.evolveEffect then
		self.evolveEffect:unregisterScriptHandler()
	end
end

return CharacterNode