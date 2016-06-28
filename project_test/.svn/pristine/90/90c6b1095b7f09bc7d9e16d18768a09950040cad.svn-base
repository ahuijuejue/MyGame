--
-- Author: zsp
-- Date: 2015-02-07 10:53:18
--

local GameNode     = import(".GameNode")
local TowerModel   = import("..model.TowerModel")
local BattleEvent  = import("..BattleEvent")
local MissileNode  = import(".MissileNode")
local ItemNode     = import(".ItemNode")
local TowerState   = import("..state.TowerState")
local StateManager = import("..state.StateManager")

local TowerNode   = class("TowerNode", GameNode)

--[[
	基地塔 防御塔 土豆塔
--]]

function TowerNode:ctor(params)
	
	TowerNode.super.ctor(self)

	self.nodeType        = GameNodeType.TOWER
	self.liveTime        = params.liveTime or 0 --不等于0代表有个存活时间
	self.isPaused        = false
	self.towerId         = params.towerId
	self.starLv          = params.starLv or 0
	self.level           = params.level or 5
	
	self.camp            = params.camp
	self.enemyCamp       = params.enemyCamp
	self.isReboundDamage = false --反弹伤害
	self.isUnbeatable    = false --无敌状态
	self.isAttack        = false --是否能攻击
	self.model           = TowerModel.new(self.level,GameConfig.tower[self.towerId])
	
	self.viewRect        = cc.rect(0,0,0,0)
	self.attackRect      = cc.rect(0,0,0,0)

	self.animGroup = {}

	self:createBoundingBox()
	self:createEffectNode()
	self:createHpBar()
	self:createFrameMap()
		
	--按星级初始化塔功能 todo 暂时关闭 1~3种类型
	if self.camp == GameCampType.left then
		if self.starLv > 0 then
			for i=1,self.starLv do
				self[string.format("type%sstar%d", self.model.type,i)](self)
			end
		end
	end

	if self.liveTime > 0 then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(self.liveTime),cc.CallFunc:create(handler(self, self.onLiveTimeEnd))))
	end

	 --攻击塔默认能攻击
	if self.model.type == 2 then
		self.isAttack = true
	end

	if self.model.type == 4 then
		self.isUnbeatable = true
	end

	self:setLocalZOrder(900)

	BattleManager.addTower(self)
end

function TowerNode:update( dt )
	
	if self.isPaused then
		return
	end

	self.stateMgr:update(dt)
end

--[[
	创建碰撞检测的包围盒
--]]
function TowerNode:createBoundingBox()
	--self.nodeBox:addTo(self)
	self.nodeBox   = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	self.viewBox   = cc.LayerColor:create(cc.c4b(0, 255, 0, 100))
	self.attackBox = cc.LayerColor:create(cc.c4b(0, 0, 255, 100))

	self.nodeBox:addTo(self)
	self.nodeBox:setContentSize(self.model.nodeSize.width,self.model.nodeSize.height)
	self.nodeBox:setVisible(false)
	
	self.viewBox:addTo(self)
	self.viewBox:setContentSize(self.model.viewSize.width,self.model.viewSize.height)
	self.viewBox:setVisible(false)

	self.attackBox:addTo(self)
	self.attackBox:setContentSize(self.model.attackSize.width,self.model.attackSize.height)
	self.attackBox:setVisible(false)

	self:restBoundingBox()
end

--[[
	调用此方法前必须添加到节点总并设置好位置
--]]
function TowerNode:createAnimNode()

	local pNode = self:getParent()
	local x,y = self:getPosition()

	if self.model.type == 1 or self.model.type == 5 then
		local function onFrame(frame,finish)
	        self.stateMgr.currentState:executeAnim(self,frame,finish)
	    end

		local animNode = GafAssetCache.makeAnimatedObject(self.model.image) 
		animNode:setDelegate()
		animNode:registerScriptHandler(onFrame)
		local p1 = cc.p(animNode:getFrameSize().width * -0.5,animNode:getFrameSize().height - 440)
		local p2 = cc.p(x,y)
		animNode:setPosition(cc.pAdd(p1,p2))
		
		animNode:setLocalZOrder(840)
		animNode:addTo(pNode)
		animNode:start()

		if self.camp == GameCampType.right then
			animNode:setPosition(cc.pAdd(cc.p(animNode:getFrameSize().width * 0.5,animNode:getFrameSize().height - 440),p2))
			animNode:setScaleX(-1)
		end


		table.insert(self.animGroup,animNode)
	else
		
		local function onFrame(frame,finish)
	       self.stateMgr.currentState:executeAnim(self,frame,finish)
	    end

		local animNode1 = GafAssetCache.makeAnimatedObject(self.model.image) 
		animNode1:setDelegate()
		animNode1:registerScriptHandler(onFrame)

		local p1 = cc.p(animNode1:getFrameSize().width * -0.5,animNode1:getFrameSize().height - 440)

		animNode1:setPosition(cc.pAdd(p1,cc.p(x-30,y + 100)))
		animNode1:setLocalZOrder(600)
		animNode1:addTo(pNode)
		animNode1:start()

		local animNode2 = GafAssetCache.makeAnimatedObject(self.model.image) 
		animNode2:setPosition(cc.pAdd(p1,cc.p(x+30,y - 50)))
		animNode2:setLocalZOrder(900)
		animNode2:addTo(pNode)
		animNode2:start()

		if self.camp == GameCampType.right then
			animNode1:setPosition(cc.pAdd(cc.p(animNode1:getFrameSize().width * 0.5 - 30,animNode1:getFrameSize().height - 440),cc.p(x+30,y + 90)))
			animNode1:setScaleX(-1)

			animNode2:setPosition(cc.pAdd(cc.p(animNode1:getFrameSize().width * 0.5 + 30,animNode1:getFrameSize().height - 440),cc.p(x+30,y - 50)))
			animNode2:setScaleX(-1)
		end

		table.insert(self.animGroup,animNode1)
		table.insert(self.animGroup,animNode2)

		self.hpBar:setPosition(cc.pAdd(cc.p(self.hpProgress:getPosition()), cc.p(-50,330)))
	end

	self.state    = TowerState
	self.stateMgr = StateManager.new(self,self.state.idle)

	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
    	self:update(dt)
	end)

	self:scheduleUpdate()

end

--[[
	根据所属阵营 更新包围盒位置 可能会用于动态变换阵营 
--]]
function TowerNode:restBoundingBox()
	
	self.nodeBox:setPosition(self.model.nodeOffset.x - self.model.nodeSize.width * 0.5 ,self.model.nodeOffset.y)

	if self.camp == GameCampType.left then
		self.viewBox:setPosition(self.model.viewOffset.x, self.model.viewOffset.y)
		self.attackBox:setPosition(self.model.attackOffset.x, self.model.attackOffset.y)
		-- self.viewBox:setVisible(false)
		-- self.attackBox:setVisible(false)	
	else
		self.viewBox:setPosition(self.model.viewOffset.x  - self.model.viewSize.width, self.model.viewOffset.y)
		self.attackBox:setPosition(self.model.attackOffset.x - self.model.attackSize.width, self.model.attackOffset.y)
	end
end


--[[
	获取角色的视野范围信息
--]]
function TowerNode:getViewRect()

	local pt = self.viewBox:convertToWorldSpace(cc.p(0,0))
	self.viewRect.width  = self.viewBox:getContentSize().width
	self.viewRect.height = self.viewBox:getContentSize().height
	self.viewRect.x = pt.x
	self.viewRect.y = pt.y

	return self.viewRect
end

--[[
	获取角色的攻击范围
--]]
function TowerNode:getAttackRect()

	local pt = self.attackBox:convertToWorldSpace(cc.p(0,0))
	self.attackRect.width  = self.attackBox:getContentSize().width
	self.attackRect.height = self.attackBox:getContentSize().height
	self.attackRect.x = pt.x
	self.attackRect.y = pt.y

	return self.attackRect

end

--[[
	创建角色效果节点 显示受伤效果等
--]]
function TowerNode:createEffectNode()

	self.effectNode = display.newSprite()
	self.effectNode:setPosition(0,self.model.nodeSize.height * 0.5)
	--self.effectNode:setVisible(false)
	self.effectNode:addTo(self)

end

--[[
	创建角色的hp条
--]]
function TowerNode:createHpBar()
	-- body
	self.hpBar = display.newSprite("hp_progress_bg.png")
	self.hpBar:setPosition(0,self.model.nodeSize.height + 20)
	self.hpBar:setVisible(false)
	self.hpBar:addTo(self)

	self.hpProgress = cc.ProgressTimer:create(display.newSprite(string.format("hp_progress_%d.png", self.camp)))
    self.hpProgress:setType(cc.PROGRESS_TIMER_TYPE_BAR)
    self.hpProgress:setMidpoint(cc.p(0, 0))
    self.hpProgress:setBarChangeRate(cc.p(1, 0))

	local size = self.hpBar:getContentSize()
	self.hpProgress:setPosition(size.width * 0.5,size.height * 0.5)
	self.hpProgress:addTo(self.hpBar)

	self:updateHpBar()
end

function TowerNode:hasViewRange()
	-- body
	return BattleManager.hasViewRange(self)
end

function TowerNode:hasAttackRange()
	-- body
	return BattleManager.hasAttackRange(self)
end

--[[
	获取视野内的敌人
--]]
function TowerNode:findViewRange()
	-- body
	return BattleManager.findViewRange(self)
end

--[[
	获取攻击范围内的敌人
--]]
function TowerNode:findAttackRange()
	-- body
	return BattleManager.findAttackRange(self)
end

--[[
	获取攻击范围内最近的敌人
--]]
function TowerNode:findOneAttackRange()
	-- body
	return BattleManager.findOneAttackRange(self)
end

--[[
	被攻击时播放被攻击到的效果
--]]
function TowerNode:showEffect(name,callback)
	
	if name == "" then
		return
	end

	local anim = self.effectNode:getChildByTag(1)
	
	if anim ~= nil then
		return
	end
	
	--todd 创建销毁有点频繁
	anim = GafAssetCache.makeAnimatedObject(name)

	local function onFrame(frame,finish)
       if finish then
       		anim:stop()
           	anim:setVisible(false)
            if callback then
            	callback()
            end 

            anim:unregisterScriptHandler()
            anim:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.RemoveSelf:create()))
        end
    end

	local frameSize = anim:getFrameSize()
	anim:setPosition(frameSize.width * - 0.5,frameSize.height * 0.5)
	anim:setDelegate()
    anim:registerScriptHandler(onFrame)
	anim:addTo(self.effectNode)
	anim:start()
end

--[[
	显示提示 免疫 miss等
--]]
function TowerNode:showTipNode(tip)
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
	显示血条
--]]
function TowerNode:showHpBar( )
	-- body
	transition.stopTarget(self.hpBar)
	local sequence = transition.sequence({
		cc.Show:create(),
		cc.DelayTime:create(0.5),
		cc.Hide:create()
	})
	self.hpBar:runAction(sequence)

end

function TowerNode:updateHpBar()
	
	self.hpProgress:setPercentage(self.model.hp * 1.0 / self.model.maxHp * 100)

end

--[[
	设置hp 并触发回调 hp属性变动 统一调用此方法
--]]
function TowerNode:setHp(hp)
	self.model.hp = math.max(hp,0)
	self.model.hp = math.min(self.model.hp,self.model.maxHp)

	if self.onUpdateHp ~= nil then
		self.onUpdateHp(self,self.model.hp,self.model.maxHp)
	end

	--基地剩余血量不足时，触发伏兵点
	if self.triggerNode then
		if self.model.hp /  self.model.maxHp < 0.5 then
			self.triggerNode:doTrigger()
			self.triggerNode = nil
		end	
	end
end

--[[
	反伤 兼容角色接口
--]]
function TowerNode:doReboundDamage(attackType,damageReal)
	-- body
end

--[[
	技能攻击伤害
	attackerData 攻击者数据
	skillData 攻击的技能数据
--]]
function TowerNode:doSkillDamage(attackerData,skillData)
	
	AudioManage.playSound("hit.mp3",false)
	
	-- body
	local attacker       = attackerData.attacker
	local a_atk          = attackerData.a_atk
	local a_m_atk        = attackerData.a_m_atk
	local a_acp          = attackerData.a_acp
	local a_m_acp        = attackerData.a_m_acp
	local a_break        = attackerData.a_break
	local a_tumble       = attackerData.a_tumble
	local a_lv           = attackerData.a_lv
	
	local s_finish       = skillData.skill_finish
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

	if self.isUnbeatable then
		local sp = display.newSprite("immune.png")
		self:showTipNode(sp)
		return false
	end

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

			if not self.isAttack then
				self:playDamage()
			end

			--攻击者增加吸血
			if attacker ~= nil and not attacker.dead and attacker.nodeType == GameNodeType.ROLE then
				attacker:appendAnger(Formula[2](damageReal,self.model.maxHp,50, attacker.model.powerGet))
				attacker:doRecover(attacker.model.blood)
				if self.isReboundDamage then
					attacker:doReboundDamage(s_damage_type,0.1 * damageReal)
				end
			end

			if self.model.hp <= 0 then

		  		if attacker ~= nil and not attacker.dead then
		            --死亡时增加攻击角色怒气
		            attacker:appendAnger(10)
		       	end
		       	
				self:doDead()
			end

		else
			--技能闪避
			local sp = display.newSprite("miss.png")
			self:showTipNode(sp)
			return false	
		end
	end

	return true
end

--[[
	普通角色攻击的伤害
	attackerData 攻击者数据
--]]
function TowerNode:doDamage(attackerData)
	
	AudioManage.playSound("hit.mp3",false)

	local attacker    = attackerData.attacker
	local a_attackNum = attackerData.a_attackNum
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

	if self.isUnbeatable then
		local sp = display.newSprite("immune.png")
		self:showTipNode(sp)
		return true
	end

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
		if a_damage_type == 1 then
			damageReal = 2 * Formula[6](a_atk, a_lv,self.model.defense,a_acp)
		else
			damageReal = 2 * Formula[6](a_m_atk, a_lv,self.model.magicDefense,a_m_acp)
		end
	else
		--普攻
		damageFont = "font_atk.fnt"
		if a_damage_type == 1 then
			damageReal = Formula[6](a_atk, a_lv,self.model.defense,a_acp)
		else
			damageReal = Formula[6](a_m_atk, a_lv,self.model.magicDefense,a_m_acp)
		end	
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


	if not self.isAttack then
		self:playDamage()
	end
	-- for k,v in pairs(self.animGroup) do
	-- 	v:runAction(cc.Sequence:create(cc.MoveBy:create(0.1, cc.p(-10,0)),cc.MoveBy:create(0.1, cc.p(10,0))))
	-- end

	--攻击者增加吸血
	if attacker ~= nil and not attacker.dead and attacker.nodeType == GameNodeType.ROLE then
		attacker:appendAnger(Formula[2](damageReal,self.model.maxHp,50,attacker.model.powerGet))
		attacker:doRecover(attacker.model.blood)
		if self.isReboundDamage then
			attacker:doReboundDamage(a_damage_type,0.1 * damageReal)
		end

	end

	if self.model.hp <= 0 then

  		if attacker ~= nil and not attacker.dead then
            --死亡时增加攻击角色怒气
            attacker:appendAnger(10)
       	end

		self:doDead()
	end

	return true
end

function TowerNode:pauseAll()
	self.isPaused = true
	self:pause()

	for k,v in pairs(self.animGroup) do
		v:pauseAnimation()
	end
end

function TowerNode:resumeAll()
	self.isPaused = false
	self:resume()

	for k,v in pairs(self.animGroup) do
		v:resumeAnimation()
	end
end

--[[
	覆盖node 的setVisible
--]]
function TowerNode:setVisible(visible)
	--print("TowerNode:setVisible =================== ")
	--TowerNode.super.setVisible(self,visible)
	if not self.animGroup then
		return
	end
	
	for k,v in pairs(self.animGroup) do
		v:setVisible(visible)
	end
end

--[[
	进入空闲状态
--]]
function TowerNode:doIdle()
	-- body
	self.stateMgr:changeState(self.state.idle)
end


--[[
	攻击间隔
--]]
function TowerNode:doAttackDelay()
	self.stateMgr:changeState(self.state.delayAttack)
end

--[[
	远程攻击
--]]
function TowerNode:doFarAttack()
	-- body
	self.stateMgr:changeState(self.state.farAttack)
end

--[[
	进程攻击
--]]
function TowerNode:doNearAttack()
	-- body
	self.stateMgr:changeState(self.state.nearAttack)
end


function TowerNode:doDead()
	-- self.dead = true

	-- for k,v in pairs(self.animGroup) do
	-- 	v:removeFromParent()
	-- end

	-- self:stopAllSchedule()
	
	-- --发送死亡事件
	-- if self.camp == GameCampType.left then
 --     	BattleEvent:dispatchEvent({
	--       name  = BattleEvent.KILL_TOWER,
	--       dead  = self
	--     })
 --  	end

	-- self:showEffect("atk_effect_2",function()
	-- 	 self.remove = true	
	-- end)   
	
	--self:hideHpBar()
	self:stopAllSchedule()
	self.stateMgr:changeState(self.state.dead)

end

function TowerNode:doAttack()
	--todo findViewRange 优化判断有没有人 不用取全部数组 减少判断
 --  	if isPaused then
 --    	return
 --    end

	-- -- local hasEnemy = self:hasViewRange()
	
	-- -- if not hasEnemy then
	-- -- 	return
	-- -- end

	-- self:playAttack()

	-- if self.model.missileId ~= "" then
	-- 	self:doFarAttack()
	-- else
	-- 	self:doNearAttack()
	-- end

	self.stateMgr:changeState(self.state.attack)
end

function TowerNode:doWin()
	self:stopAllActions()
	self:stopAllSchedule()
end



function TowerNode:onLiveTimeEnd()
	printInfo("towerId = %s 存活时间到了",self.towerId)
	self:doDead()
end


function TowerNode:stopAllSchedule()
	
end

function TowerNode:destory()
	printInfo("TowerNode:destory")
	self:stopAllSchedule()
	if self.animGroup then
		for k,v in pairs(self.animGroup) do
			v:unregisterScriptHandler()
			v:removeFromParent()
		end

		self.animGroup = nil
	end
end

--[[
	给队伍全体队员回血
--]]
function TowerNode:doTeamRecover()
	for k,v in pairs(BattleManager.roles[self.camp]) do
		 if v.nodeType == GameNodeType.ROLE  and v:isActive() then
		 	 local hp = v.model.hp * 0.2
		 	 v:doRecover(hp)
		 end
	end
end

function TowerNode:doRecover(hp)
	-- todo 兼容role
end

function TowerNode:appendAnger(anger)
	
end

function TowerNode:setAnger(anger)
	-- body
end

--[[
	播放动画
--]]
function TowerNode:playAnim(name,loop)
	for k,v in pairs(self.animGroup) do
		v:playSequence(name,loop)
	end
end

--[[
	播放空闲动画
--]]
function TowerNode:playIdle()
	self:playAnim( "idle", true)
end

--[[
	播放空闲动画
--]]
function TowerNode:playDamage()
	self:playAnim( "damage", false)
end

--[[
	播放空闲动画
--]]
function TowerNode:playDead()
	self:playAnim( "dead", false)
end

--[[
	播放攻击
--]]
function TowerNode:playAttack()
	self:playAnim( "attack", false)
end

function TowerNode:createFrameMap()
   	local frame = self.model.data["hit_frame"]
   	self.attackFrameMap = string.split(frame, ",")
end

function TowerNode:getAttackFrameMap()
	return self.attackFrameMap
end


--[[
	基地塔1星 每30秒扔一个回血（20%）Buff(增加Buff)
--]]
function TowerNode:type1star1()
    printInfo("1星基地 每30秒扔一个回血")
 	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(30),cc.CallFunc:create(function()
			local item = ItemNode.new({
		 		itemId = "10001"
			})

		  	item:addTo(self:getParent())
		  	item:setPosition(self:getPositionX(),self:getPositionY() + self.model.nodeSize.height)
		  	newrandomseed()
		  	local y = math.random(150,300)
		  	local dropAction = DropAction:create(0.5,y,50,  self.model.nodeSize.height  + self:getPositionY() - 200, BattleManager.sceneWidth)
		  	item:runAction(dropAction)
	end))))
end

--[[
	基地塔2星 可以攻击敌人
--]]
function TowerNode:type1star2()
	printInfo("2星基地 可以攻击敌人")
	self.isAttack = true
end

--[[
	基地塔3星 增加所有建筑物防（光环-群体增加属性）
--]]
function TowerNode:type1star3()
	printInfo("3星基地，增加所有建筑物物理防御")
	table.walk(BattleManager.roles[self.camp],function(v,k)
		if v.nodeType == GameNodeType.TOWER then
			v.model.defense = v.model.defense + v.model.defense * 0.2
			printInfo("towerId = %s 增加属性,物理防御=%d",v.towerId,v.model.defense)
		end
	end)	
end

--[[
	基地塔4星 增加所有建筑魔防
--]]
function TowerNode:type1star4()
	printInfo("4星基地，增加所有建筑物魔法防御")
	table.walk(BattleManager.roles[self.camp],function(v,k)
		if v.nodeType == GameNodeType.TOWER then
			v.model.magicDefense = v.model.magicDefense + v.model.magicDefense * 0.2
			printInfo("towerId = %s 增加属性,魔法防御=%d",v.towerId,v.model.magicDefense)
		end
	end)	
end

--[[
	基地塔5星 每隔一段时间给己方群体回血一次（光环-群体回血）
--]]
function TowerNode:type1star5()
	printInfo("5星基地，全体队员加血")
	--self.__recoverScheduleHandle =  scheduler.scheduleGlobal(handler(self,self.doTeamRecover),5)
	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(60),cc.CallFunc:create(function()
  		for k,v in pairs(BattleManager.roles[self.camp]) do
			 if v.nodeType == GameNodeType.ROLE  and v:isActive() then
			 	 local hp = v.model.hp * 0.2
			 	 v:doRecover(hp)
			 end
		end
   end))))

end

--[[
	攻击塔1星 每1分钟扔一个命中加强Buff。
--]]
function TowerNode:type2star1()
	printInfo("1星攻击塔 每1分钟扔一个命中加强Buff。")
  	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(60),cc.CallFunc:create(function()
			local item = ItemNode.new({
		 		itemId = "10002"
			})
		  	item:addTo(self:getParent())
		  	item:setPosition(self:getPositionX(),self:getPositionY() + self.model.nodeSize.height)
		  	newrandomseed()
		  	local y = math.random(150,300)
		  	local dropAction = DropAction:create(0.5,y,50,  self.model.nodeSize.height  + self:getPositionY() - 200, BattleManager.sceneWidth)
		  	item:runAction(dropAction)
	end))))
end

--[[
	攻击塔2星 增加塔暴击概率（修改塔的属性）
--]]
function TowerNode:type2star2()
	printInfo("2星攻击塔 增加塔暴击概率（修改塔的属性）")
	self.model.crit = self.model.crit + self.model.crit * 0.4
end

--[[
	攻击塔3星 攻击附带飞行道具—爆炸伤害
--]]
function TowerNode:type2star3()
	printInfo("3星攻击塔  攻击附带飞行道具—爆炸伤害")
	--塔配置的不同flyid
end

--[[
	攻击塔4星 每1分钟扔一个暴击加强Buff。
--]]
function TowerNode:type2star4()
	printInfo("4星攻击塔 每1分钟扔一个暴击加强Buff。")
 	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(60),cc.CallFunc:create(function()
			local item = ItemNode.new({
		 		itemId = "10003"
			})

		  	item:addTo(self:getParent())
		  	item:setPosition(self:getPositionX(),self:getPositionY() + self.model.nodeSize.height)
		  	newrandomseed()
		  	local y = math.random(150,300)
		  	local dropAction = DropAction:create(0.5,y,50,  self.model.nodeSize.height  + self:getPositionY() - 200, BattleManager.sceneWidth)
		  	item:runAction(dropAction)
	end))))

end

--[[
	攻击塔5星 被攻击目标有几率眩晕，（普通攻击附带BUFF）
--]]
function TowerNode:type2star5()
	printInfo("5星攻击塔 被攻击目标有几率眩晕，（普通攻击附带BUFF）")
end

--[[
	防御塔1星 每45秒扔一个物理防御加强Buff。
--]]
function TowerNode:type3star1()
	printInfo("1星防御塔 每45秒扔一个物理防御加强Buff。")
    self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(45),cc.CallFunc:create(function()
		  	local item = ItemNode.new({
		 		itemId = "10004"
			})

		  	item:addTo(self:getParent())
		  	item:setPosition(self:getPositionX(),self:getPositionY() + self.model.nodeSize.height)
		  	newrandomseed()
		  	local y = math.random(150,300)
		  	local dropAction = DropAction:create(0.5,y,50,  self.model.nodeSize.height  + self:getPositionY() - 200, BattleManager.sceneWidth)
		  	item:runAction(dropAction)
   	end))))

end

--[[
	防御塔2星 增加自身血量
--]]
function TowerNode:type3star2()
	printInfo("2星防御塔 增加自身血量")
	self.model.maxHp = self.model.maxHp + self.model.maxHp * 0.2
	self.model.hp = self.model.hp + self.model.hp * 0.2
end


--[[
	防御塔3星 增加自身10%反伤（光环-增加反伤BUFF）
--]]
function TowerNode:type3star3()
	printInfo("3星防御塔 增加自身反伤（光环-增加反伤BUFF）")
	self.isReboundDamage = true
end


--[[
	防御塔4星 每45秒扔一个魔法防御加强Buff
--]]
function TowerNode:type3star4()
	printInfo("4星防御塔 每45秒扔一个魔法防御加强Buff")

   	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(45),cc.CallFunc:create(function()
  		local item = ItemNode.new({
	 		itemId = "10005"
		})

	  	item:addTo(self:getParent())
	  	item:setPosition(self:getPositionX(),self:getPositionY() + self.model.nodeSize.height)
	  	newrandomseed()
	  	local y = math.random(150,300)
	  	local dropAction = DropAction:create(0.5,y,50,  self.model.nodeSize.height  + self:getPositionY() - 200, BattleManager.sceneWidth)
	  	item:runAction(dropAction)
   	end))))
end


--[[
	防御塔5星 每20秒无敌3秒.（光环-增加自身无敌）
--]]
function TowerNode:type3star5()
	printInfo("5星防御塔 每20秒无敌3秒.（光环-增加自身无敌）")
	self:runAction(cc.RepeatForever:create(cc.Sequence:create(
		cc.DelayTime:create(20),
		cc.CallFunc:create(function()
			self.isUnbeatable = true
			print("开启免疫")
		end),
		cc.DelayTime:create(3),
		cc.CallFunc:create(function()
			self.isUnbeatable = false
			print("关闭免疫")
		end)
	)))
end

--[[
	添加触发出兵点
--]]
function TowerNode:addTrigger(triggerNode)
	self.triggerNode = triggerNode
end

--[[
	获得塔仰总值，攻击人的时候用
--]]
function TowerNode:getBreakTotal()
	local total = self.model.breakValue
	return total
end

--[[
	获得塔击退值，攻击人的时候用
--]]
function TowerNode:getTumbleTotal()
	local total = self.model.tumble
	return total
end

return TowerNode
