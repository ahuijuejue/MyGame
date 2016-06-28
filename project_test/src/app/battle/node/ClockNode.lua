--
-- Author: zsp
-- Date: 2015-04-10 10:08:40
--

local GameNode     = import(".GameNode")
local ClockModel   = import("..model.ClockModel")
local ClockState   = import("..state.ClockState")
local StateManager = import("..state.StateManager")
local BattleEvent  = import("..BattleEvent")

local ClockNode   = class("ClockNode", GameNode)

--[[
	试炼 黄金钟
--]]

function ClockNode:ctor(params)
	
	ClockNode.super.ctor(self)

	self.nodeType = GameNodeType.CLOCK

	self.isPaused = false
	self.clockId  = params.clockId
	self.level    = params.level or 1
		
	self.camp       = GameCampType.right --params.camp
	self.enemyCamp  = GameCampType.left --params.enemyCamp
	
	self.unbeatable            = params.unbeatable or false
	self.magicUnbeatable       = params.magicUnbeatable or false

	
	self.model      = ClockModel.new(self.level,GameConfig.Trials_Gold_enemy[self.clockId])

	if checknumber(self.model.type) > 3  then
		self.magicUnbeatable = true
	else
		self.unbeatable = true
	end

	self:createAnimNode()
	self:createBoundingBox()
	self:createEffectNode()
	self:createHpBar()

	self.state    = ClockState
	self.stateMgr = StateManager.new(self,self.state.idle)

	--self:setLocalZOrder(900)

	BattleManager.addClock(self)

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self:update(dt)
	end)

	self:scheduleUpdate()

end

function ClockNode:update(dt)
	if self.isPaused then
		return
	end
	
	self.stateMgr:update(dt)
end


function ClockNode:createAnimNode()
	-- self.sprite = display.newSprite(self.model.image)
	-- self.sprite:setAnchorPoint(0.5,0)
	-- self.sprite:addTo(self)

	local function onFrame(frame,finish)
        self.stateMgr.currentState:executeAnim(self,frame,finish)
    end

	self.animNode = GafAssetCache.makeAnimatedObject(self.model.image) 
	self.animNode:setDelegate()
	self.animNode:registerScriptHandler(onFrame)
	self.animNode:setPosition(self.animNode:getFrameSize().width * -0.5,self.animNode:getFrameSize().height - 440)
	self.animNode:addTo(self)
	self.animNode:start()

end


--[[
	创建碰撞检测的包围盒
--]]
function ClockNode:createBoundingBox()
	--self.nodeBox:addTo(self)
	self.nodeBox   = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	self.nodeBox:addTo(self)
	self.nodeBox:setContentSize(self.model.nodeSize.width,self.model.nodeSize.height)
    self.nodeBox:setVisible(false)
	self:restBoundingBox()
end

--[[
	根据所属阵营 更新包围盒位置 可能会用于动态变换阵营 
--]]
function ClockNode:restBoundingBox()
	self.nodeBox:setPosition(self.model.nodeOffset.x - self.model.nodeSize.width * 0.5 ,self.model.nodeOffset.y)
end


--[[
	创建角色效果节点 显示受伤效果等
--]]
function ClockNode:createEffectNode()

	self.effectNode = display.newSprite()
	self.effectNode:setPosition(0,self.model.nodeSize.height * 0.5)
	--self.effectNode:setVisible(false)
	self.effectNode:addTo(self)

end

--[[
	创建角色的hp条
--]]
function ClockNode:createHpBar()
	-- body
	self.hpBar = display.newSprite("hp_progress_bg.png")
	self.hpBar:setPosition(0,self.model.nodeSize.height + 10)
	self.hpBar:setVisible(false)
	self.hpBar:addTo(self)

	self.hpProgress = cc.ProgressTimer:create(display.newSprite(string.format("hp_progress_%d.png", self.camp)))
    self.hpProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.hpProgress:setMidpoint(cc.p(0, 0))
    self.hpProgress:setBarChangeRate(cc.p(1, 0))

	local size = self.hpBar:getContentSize()
	self.hpProgress:setPosition(size.width * 0.5,size.height * 0.5)
	self.hpProgress:addTo(self.hpBar)
end

--[[
	显示提示 免疫 miss等
--]]
function ClockNode:showTipNode(tip)
	local x,y = self:getPosition()
	tip:setPosition(x,y + self.model.nodeSize.height + 10)
	tip:setLocalZOrder(self:getLocalZOrder() + 1)
	tip:addTo(self:getParent())

	local sequence = transition.sequence({
	    cc.MoveBy:create(0.5, cc.p(0,50)),
	    cc.RemoveSelf:create()
	})

	tip:runAction(sequence)
end

--[[
	被攻击时播放被攻击到的效果
--]]
function ClockNode:showEffect(name,callback)
	-- if name == "" then
	-- 	return
	-- end
	
	-- local anim = self.effectNode:getChildByTag(1)
	
	-- if anim ~= nil then
	-- 	return
	-- end
	
	-- --todd 创建销毁有点频繁
	-- anim = GafAssetCache.makeAnimatedObject(name)

	-- local function onFrame(frame,finish)
 --       if finish then
 --       		anim:stop()
 --            anim:unregisterScriptHandler()
 --            anim:removeFromParent()
 --            if callback then
 --            	callback()
 --            end   
 --        end
 --    end

	-- local frameSize = anim:getFrameSize()
	-- anim:setPosition(frameSize.width * - 0.5,frameSize.height * 0.5)
	-- anim:setDelegate()
 --    anim:registerScriptHandler(onFrame)
	-- anim:addTo(self.effectNode)
	-- anim:start()
end

--[[
	显示血条
--]]
function ClockNode:showHpBar( )
	-- body
	transition.stopTarget(self.hpBar)
	local sequence = transition.sequence({
		cc.Show:create(),
		cc.DelayTime:create(0.5),
		cc.Hide:create()
	})
	self.hpBar:runAction(sequence)

end

function ClockNode:updateHpBar()
	
	self.hpProgress:setPercentage(self.model.hp * 1.0 / self.model.maxHp * 100)

end

--[[
	设置hp 并触发回调 hp属性变动 统一调用此方法
--]]
function ClockNode:setHp(hp)
	self.model.hp = math.max(hp,0)
	self.model.hp = math.min(self.model.hp,self.model.maxHp)

	if self.onUpdateHp ~= nil then
		self.onUpdateHp(self,self.model.hp,self.model.maxHp)
	end
end

--[[
	技能攻击伤害
	attackerData 攻击者数据
	skillData 攻击的技能数据
--]]
function ClockNode:doSkillDamage(attackerData,skillData)
	
	-- body
	local attacker       = attackerData.attacker
	local a_atk          = attackerData.a_atk
	local a_m_atk        = attackerData.a_m_atk
	local a_acp          = attackerData.a_acp
	local a_m_acp		 = attackerData.a_m_acp
	local a_break        = attackerData.a_break
	local a_tumble       = attackerData.a_tumble
	local a_lv           = attackerData.a_lv
	
	local s_rate         = skillData.rate
	--同一个技能照成多次伤害中的单次伤害比
	local s_ratio 		 = skillData.skill_ratio
	local s_damage       = skillData.skill_damage
	local s_damage_ratio = skillData.skill_damage_ratio 
	local s_damage_real  = skillData.damage_real
	local s_damage_type  = skillData.damage_type
	local s_crit_rate    = skillData.crit_rate
	local s_crit_num     = skillData.crit_num
	local s_buffId       = skillData.buffId
	local s_buff_rate    = skillData.buff_rate
	local s_lv           = skillData.level

	-- if self:immunityDamage(s_damage_type) then
	-- 	return false
	-- end
	
	if s_damage_type ~= 3 then
		local damageFont = ""
		local damageReal = 0
		newrandomseed()
		--技能命中
		if s_rate * 100 >= math.random(1,100) then

			--有伤害绝对值就直接计算，忽略计算公式
			if s_damage_real > 0 then
				damageReal = s_damage_real
				damageFont = "font_atk.fnt"
			else
				if s_damage_type == 1 then
					--物理攻击
					damageReal = Formula[9](a_atk,s_damage,s_damage_ratio,a_lv,self.model.defense, a_acp)
				elseif s_damage_type == 2 then
					--魔法攻击
					damageReal = Formula[8](a_m_atk,s_damage,s_damage_ratio,a_lv,self.model.magicDefense, a_m_acp)
				end

				if math.random(1,100) <= s_crit_rate * 100 then
					--技能暴击
					damageFont = "font_crit.fnt"
					damageReal = s_crit_num * damageReal
				else
					--技能普通攻击
					damageFont = "font_atk.fnt"
				end
			end

			damageReal = damageReal * s_ratio
			
			self:showHpBar();

			local curHp = self.model.hp - damageReal
			self:setHp(curHp)

			local label = display.newBMFontLabel({ 
				text = string.format("%d",damageReal) ,font = damageFont})
			self:showTipNode(label)
			self:updateHpBar()

			--攻击者增加吸血
			if attacker ~= nil and not attacker.dead then
				attacker:doRecover(attacker.model.blood)
			end

			if self.model.hp <= 0 then

		  		if attacker ~= nil and not attacker.dead then
		            --死亡时增加攻击角色怒气
		            attacker:appendAnger(20)
		       	end
		       	
				self:doDead()
			else
				self.stateMgr:changeState(self.state.damage)
			end

		else
			--技能闪避
			-- local sp = display.newSprite("miss.png")
			-- self:showTipNode(sp)
			-- return false	
			printInfo("技能闪避")
			return false
		end
	end

	return true
end

--[[
	普通角色攻击的伤害
	attackerData 攻击者数据
--]]
function ClockNode:doDamage(attackerData)

	local attacker      = attackerData.attacker
	local a_attackNum   = attackerData.a_attackNum
	local a_damage_type = attackerData.a_damage_type or 0
	local a_atk         = attackerData.a_atk
	local a_m_atk       = attackerData.a_m_atk
	local a_acp         = attackerData.a_acp
	local a_m_acp       = attackerData.a_m_acp
	local a_rate        = attackerData.a_rate
	local a_crit        = attackerData.a_crit
	local a_break       = attackerData.a_break
	local a_tumble      = attackerData.a_tumble
	local a_lv          = attackerData.a_lv

	--是否免疫攻击
	-- if self:immunityDamage(a_damage_type) then
	-- 	return false
	-- end

	local r_rate = 10000 * Formula[10](a_rate,self.model.dodge)
	local r_crit = 10000 * Formula[11](a_crit,a_lv)
	newrandomseed()
	local rdm = math.random(1,10000)

	local damageFont = ""
	local damageReal = 0
	if rdm <= r_rate  then
		--闪避	
		local sp = display.newSprite("miss.png")
		self:showTipNode(sp)
		return false	
	elseif rdm <= r_crit + r_rate and rdm > r_rate  then
		--暴击
		damageFont = "font_crit.fnt"
		damageReal = 2 * Formula[6](a_atk, a_lv,self.model.defense,a_acp)
	else
		--普攻
		damageFont = "font_atk.fnt"
		damageReal = Formula[6](a_atk, a_lv,self.model.defense,a_acp)
	end

	self:showHpBar();

	if a_attackNum == 2 then
		 damageReal = damageReal * 1.05 
	elseif a_attackNum == 3 then
		 damageReal = damageReal * 1.25 
	elseif a_attackNum == 4 then
		 damageReal = damageReal * 1.7 
	end

	local curHp = self.model.hp - damageReal
	self:setHp(curHp)

	local label = display.newBMFontLabel({ 
		text = string.format("%d",damageReal) ,font = damageFont})
	self:showTipNode(label)
	self:updateHpBar()

	--self.sprite:runAction(cc.Sequence:create(cc.MoveBy:create(0.1, cc.p(-10,0)),cc.MoveBy:create(0.1, cc.p(10,0))))
	--self.animNode:playSequence("damaged",false)

	--攻击者增加吸血
	if attacker ~= nil and not attacker.dead then
		attacker:doRecover(attacker.model.blood)
	end

	if self.model.hp <= 0 then

  		if attacker ~= nil and not attacker.dead then
            --死亡时增加攻击角色怒气
            attacker:appendAnger(20)
       	end

		self:doDead()
	else
		self.stateMgr:changeState(self.state.damage)
	end

	return true
end

--[[
	免疫伤害
--]]
function ClockNode:immunityDamage(damageType)
	-- body
	--全部免疫
	if self.unbeatable and self.magicUnbeatable then
		local sp = display.newSprite("immune.png")
		self:showTipNode(sp)
		return true
	end

	--物理无敌 免疫物理伤害
	if self.unbeatable and damageType == 1 then
		local sp = display.newSprite("immune.png")
		self:showTipNode(sp)
		return true
	end

	--魔法无敌 免疫物理伤害
	if self.magicUnbeatable and damageType == 2 then
		local sp = display.newSprite("immune.png")
		self:showTipNode(sp)
		return true
	end

	return false
end


function ClockNode:doIdle()
	self.stateMgr:changeState(self.state.idle)
end

function ClockNode:doDead()
	self.stateMgr:changeState(self.state.dead)
end

function ClockNode:pauseAll()
	self.isPaused = true
	self:pause()
	--self.animNode:pauseAnimation()
end

function ClockNode:resumeAll()
	self.isPaused = false
	self:resume()
	--self.animNode:resumeAnimation()
end

--[[
	播放动画
--]]
function ClockNode:playAnim(name,loop)
	self.animNode:playSequence(name,loop)
end

--[[
	播放空闲动画
--]]
function ClockNode:playIdle()
	self:playAnim( "idle", true)
end

--[[
	播放空闲动画
--]]
function ClockNode:playDamage()
	self:playAnim( "damage", false)
end

--[[
	播放空闲动画
--]]
function ClockNode:playDead()
	self:playAnim( "dead", false)
end

return ClockNode
