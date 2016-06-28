--
-- Author: zsp
-- Date: 2014-11-20 17:11:21
--

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local GameNode      = import(".GameNode")
local SkillManager  = import("..skill.SkillManager")
local BuffManager   = import("..buff.BuffManager")
local RoleNode      = class("RoleNode", GameNode)
local AnimWrapper = import("app.util.AnimWrapper")

--[[
	战斗场景中，角色的基类 由子类实例化
--]]
function RoleNode:ctor(params)

	RoleNode.super.ctor(self)

	--todo 可能没用到 先注释掉
	--cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

--------------------------------------------------------------------------------------
---- 技能冷却进度回调接口，提供给界面显示用
--------------------------------------------------------------------------------------

	-- function RoleNode:onUpdateHp(role,hp,maxHp)
	-- end
	self.onUpdateHp = nil

	-- function RoleNode:onUpdateAnger(role,anger,maxAnger)
	-- end
	self.onUpdateAnger = nil

	-- function RoleNode:onUpdateHit(role,hit)
	-- end
	self.onUpdateHit = nil

	--self.onEvolutionBegin = nil
	--self.onEvolutionEnd = nil

	--[[
		冷却时间回调，用于界面上显示进度条
	--]]
	-- function SkillManager:onCooldown(role,skillId,dt,cooldown)
	-- 	-- body
	-- end


	self.nodeType = GameNodeType.ROLE
	self.liveTime = params.liveTime or 0 --不等于0代表有个存活时间,此属性用来支持被临时放入战场的角色

	self.isPaused              = false --是否暂定角色的动画和状态
	self.limitLeft             = 100 --距离地图左边界的距离
	self.limitRight            = 300 --距离地图右边界的距离
	self.isEnableEvolve        = false --是否启用变身，觉醒后触发
	self.isSkillCooldownEnable = false  --登场时角色技能冷却是否开启的，觉醒后触发
	self.subAnger              = 2 --变身后每次自动减少的怒气值 激活了队长技能会修改此属性
	self.addAnger              = 0 --激活了队长技能每次额外增加的怒气值
	self.evolveAddAnger        = 0 --激活了队长技能每次额外增加的变身后怒气值
	self.nodeScale             = params.nodeScale or 1 --角色缩放比例

	--角色释放技能状态时，设置为true,退出技能状态时为false,
	--可用于判断角色是正在处于释放技能状体
	--锁定技能释放妆后不能控制移动，以免打断正在释放的技能
	self.skillLock = false

	self.model                 = params.model
	self.roleId                = self.model.roleId or "1"
	self.level                 = self.model.level

	--角色动画有缩放，也要同时缩放角色的碰撞盒
	if nodeScale ~= 1 then
		--角色有缩放 todo 放大后角色如射出的飞行道具或单独的技能动画，还没有放大
		self.model.nodeSize.width    = self.model.nodeSize.width * self.nodeScale
		self.model.nodeSize.height   = self.model.nodeSize.height * self.nodeScale
		self.model.nodeOffset.x      = self.model.nodeOffset.x * self.nodeScale
		self.model.nodeOffset.y      = self.model.nodeOffset.y * self.nodeScale

		self.model.attackSize.width  = self.model.attackSize.width * self.nodeScale
		self.model.attackSize.height = self.model.attackSize.height * self.nodeScale
		self.model.attackOffset.x    = self.model.attackOffset.x * self.nodeScale
		self.model.attackOffset.y    = self.model.attackOffset.y * self.nodeScale

		self.model.viewSize.width    = self.model.viewSize.width * self.nodeScale
		self.model.viewSize.height   = self.model.viewSize.height * self.nodeScale
		self.model.viewOffset.x      = self.model.viewOffset.x * self.nodeScale
		self.model.viewOffset.y      = self.model.viewOffset.y * self.nodeScale
	end

	self.auto                  = params.auto or false --自动控制，主要用于玩家控制的队长角色身上
	self.isForward             = true   -- 相对所属阵营方向，角色是否朝前方
	self.disabled              = params.disabled or false -- 禁用角色全部动作，移动 释放技能等
	self.unbeatable            = params.unbeatable or false -- 物理无敌状态
	self.magicUnbeatable       = params.magicUnbeatable or false -- 魔法无敌状态
	self.rebound               = params.rebound or false -- 物理反伤
	self.magicRebound          = params.magicReBound or false -- 魔法反伤
	self.shield                = params.shield or 0 -- 物理护盾
	self.magicShield           = params.magicShield or 0 -- 魔法护盾
	self.superBody             = params.superBody or false -- 霸体
	self.defaultTumbleDistance = 30 --默认的伤害后移距离
	self.tumbleDistance        = self.defaultTumbleDistance  --当前的后仰移动值
	self.hpBarFixed 		   = params.hpBarFixed or false -- 是否固定显示血条

	self.tailSkillMgr          = nil --尾兽技能 只有队长才会有
	self.skillMgr              = SkillManager.new(self) -- 角色的技能管理器
	self.buffMgr               = BuffManager.new(self) -- 角色的buff的管理器

	self.camp                  = params.camp -- 角色的阵营
	self.enemyCamp             = params.enemyCamp -- 角色敌人的阵营

	self.hit                   = 0 -- 连击数
	self.dtAtkInterval         = 0 -- 攻击间隔
	self.attackNum             = 1 -- 攻击数

	self.stateMgr              = nil -- 状态管理器，子类设置
	self.state                 = nil -- 当前角色状态

	self.viewRect              = cc.rect(0,0,0,0) -- 视野范围
	self.attackRect            = cc.rect(0,0,0,0) -- 攻击范围

	-- body
	for i=1,#self.model.skillids do
		local skillId = self.model.skillids[i]
		self.skillMgr:addSkill(skillId,i,self.model.skillLevel[skillId])
		--print(string.format("roleId == %s, skillId == %s level = %s", self.roleId,self.model.skillids[i],self.model.skillLevel[i]))
	end

	-- 创建判定范围盒
	self:createBoundingBox()
	-- 创建角色动画
	self:createAnimNode()
	-- 创建buff显示节点
	self:createBuffEffectNode()
	-- 创建身上挂的特效节点
	self:createEffectNode()
	-- 创建角色血条
	self:createHpBar()
	-- 创建角色动作关键帧字典
	self:createFrameMap()

	BattleManager.addRole(self)

	self.__hitScheduleHandle      = nil --连击数定时回调句柄
	self.__subAngerScheduleHandle = nil --自动减怒气定时回调句柄

	if self.liveTime > 0 then
		self:runAction(cc.Sequence:create(cc.DelayTime:create(self.liveTime),cc.CallFunc:create(handler(self, self.onLiveTimeEnd))))
	end
end

--[[
	按攻击段数获取攻击关键帧
--]]
function RoleNode:getAttackFrameMap(attackNum)
	return self.attackFrameMap[attackNum]
end

--[[
	按技能编号获取技能关键帧
--]]
function RoleNode:getSkillFrameMap(skillNum)
	return self.skillFrameMap[skillNum]
end

--[[
	按技能编号获取关键帧的生效比
--]]
function RoleNode:getSkillRatio(skillNum,frame)
	return self.skillFrameMap[skillNum]
end

--[[
	创建动作关键帧字典，当动作动画执行到关键帧时，执行相应状态的功能
--]]
function RoleNode:createFrameMap()

	--记录攻击动作的关键帧 按所属阵营方向保存 不支持反向攻击
	self.attackFrameMap = {}

   	for i = 1, 4 do
   		local frame = self.model.data[string.format("hit%d_frame",i)]
   		if frame ~= "0" then
   			local arr = string.split(frame, ",")
   			self.attackFrameMap[i] = arr
   		end
   	end

   	self.attackTotal = table.nums(self.attackFrameMap)

   	--记录技能动作的关键帧 按所属阵营方向保存 不支持反向攻击
   	self.skillFrameMap = {}

   	for i = 1, 3 do
   		local frame = self.model.data[string.format("skill%d_frame",i)]
   		if frame ~= "0" then
   			local frameArr = string.split(frame, ",")
 			self.skillFrameMap[i] = frameArr
   		end
   	end

   	self.skillTotal = table.nums(self.skillFrameMap)
end

--[[
	创建碰撞检测的包围盒
--]]
function RoleNode:createBoundingBox()
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

	for k,v in pairs(self.skillMgr.skills) do
		local box = cc.LayerColor:create(cc.c4b(255, 255, 0, 50))
		box:addTo(self)
		box:setContentSize(v.nodeSize.width * self.nodeScale,v.nodeSize.height * self.nodeScale)
		box:setVisible(false)
		self["skillBox"..k] = box
	end

	self:restBoundingBox()
end

--[[
	根据所属阵营 更新包围盒位置 可能会用于动态变换阵营
--]]
function RoleNode:restBoundingBox()

	self.nodeBox:setPosition(self.model.nodeOffset.x - self.model.nodeSize.width * 0.5 ,self.model.nodeOffset.y)

	if self.camp == GameCampType.left then
		self.viewBox:setPosition(self.model.viewOffset.x, self.model.viewOffset.y)
		self.attackBox:setPosition(self.model.attackOffset.x, self.model.attackOffset.y)
	else
		self.viewBox:setPosition(self.model.viewOffset.x  - self.model.viewSize.width, self.model.viewOffset.y)
		self.attackBox:setPosition(-self.model.attackOffset.x - self.model.attackSize.width, self.model.attackOffset.y)
	end

	for k,v in pairs(self.skillMgr.skills) do
		local box = self["skillBox"..k]
		if self.camp ==  GameCampType.left then
			box:setPosition(v.nodeOffset.x * self.nodeScale,v.nodeOffset.y * self.nodeScale)
		else
			box:setPosition( (- v.nodeSize.width - v.nodeOffset.x) * self.nodeScale,v.nodeOffset.y * self.nodeScale)
		end
	end
end

--[[
	创建角色动画
--]]
function RoleNode:createAnimNode()

	local function onFrame(frame,finish)
        self.stateMgr.currentState:executeAnim(self,frame,finish)
    end

	self.animNode = GafAssetCache.makeAnimatedObject(self.model.image)
	self.animNode:setDelegate()
	self.animNode:registerScriptHandler(onFrame)
	self.animNode:addTo(self)
	self.animNode:start()
	self:updateAnimNodeDirection()
end

--[[
	按所属阵营更新动画方向
--]]
function RoleNode:updateAnimNodeDirection()

	if self.camp == GameCampType.left then
		if self.isForward then
			self.animNode:setPosition(self.animNode:getFrameSize().width * self.nodeScale * -0.5,(self.animNode:getFrameSize().height - 440 ) * self.nodeScale )
			self.animNode:setScale(1 * self.nodeScale,self.nodeScale)
		else
			self.animNode:setPosition(self.animNode:getFrameSize().width * self.nodeScale * 0.5,(self.animNode:getFrameSize().height - 440) * self.nodeScale)
			self.animNode:setScale(-1 * self.nodeScale,self.nodeScale)
		end
	else
		if self.isForward then
			--todo
			self.animNode:setPosition(self.animNode:getFrameSize().width * self.nodeScale * 0.5,(self.animNode:getFrameSize().height - 440) * self.nodeScale)
			self.animNode:setScale(-1 * self.nodeScale,self.nodeScale)
		else
			self.animNode:setPosition(self.animNode:getFrameSize().width * self.nodeScale * -0.5,(self.animNode:getFrameSize().height - 440) * self.nodeScale)
			self.animNode:setScale(1 * self.nodeScale,self.nodeScale)
		end
	end
end

--[[
	创建角色效果节点 显示受伤效果等
--]]
function RoleNode:createEffectNode()
	self.effectNode = display.newSprite()
	self.effectNode:setPosition(0,self.model.nodeSize.height * 0.5)
	--self.effectNode:setVisible(false)
	self.effectNode:addTo(self)
end

--[[
	buff效果的在角色身上的上中下三个节点位置
--]]
function RoleNode:createBuffEffectNode()
	self.buffEffectNode = display.newNode()
	self.buffEffectNode:addTo(self)

	--文字类型的buff
	self.buffTxtNode = display.newNode()
	self.buffTxtNode:addTo(self)
end

--[[
	创建角色的hp条
--]]
function RoleNode:createHpBar()
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

--[[
	获取角色的视野范围信息
--]]
function RoleNode:getViewRect()
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
function RoleNode:getAttackRect()
	local pt = self.attackBox:convertToWorldSpace(cc.p(0,0))
	self.attackRect.width  = self.attackBox:getContentSize().width
	self.attackRect.height = self.attackBox:getContentSize().height
	self.attackRect.x = pt.x
	self.attackRect.y = pt.y

	return self.attackRect
end

--[[
	获取技能范围
--]]
function RoleNode:getSkillRect(skillid)
	-- body
	local pt    = self["skillBox"..skillid]:convertToWorldSpace(cc.p(0,0))
	local rect  = cc.rect(0,0,0,0)
	rect.width  = self["skillBox"..skillid]:getContentSize().width
	rect.height = self["skillBox"..skillid]:getContentSize().height
	rect.x      = pt.x
	rect.y      = pt.y
	return rect
end

--[[
	播放动画
--]]
function RoleNode:playAnim(name,loop)
	self:updateAnimNodeDirection()
	self.animNode:playSequence(name,loop)
end

--[[
	播放空闲动画
--]]
function RoleNode:playCheer()
	--self:playAnim("idle",true)
	--printError("RoleNode:playIdle() - must override in inherited class")
	--self:updateAnimNodeDirection()
	self:playAnim( "cheer", false)
end

--[[
	播放空闲动画
--]]
function RoleNode:playIdle()
	--self:playAnim("idle",true)
	--printError("RoleNode:playIdle() - must override in inherited class")
	--self:updateAnimNodeDirection()
	self:playAnim( "idle", true)
end

--[[
	播放行走动画
--]]
function RoleNode:playWalk()
	--self:updateAnimNodeDirection()
	self:playAnim( "walk", true)
end

--[[
	播放攻击动画
--]]
function RoleNode:playAttack()
	--printError("RoleNode:playAttack() - must override in inherited class")
	self:playAnim(string.format("attack_%d",self.attackNum), false)
end

function RoleNode:playSkill()
	--printError("RoleNode:playSkill() - must override in inherited class")
	self:playAnim(string.format("skill%d",self.skillMgr.skillNum), false)
end

--[[
	播放受伤动画1
--]]
function RoleNode:playDamage1()
	-- body
	--printError("RoleNode:playDamage1() - must override in inherited class")
	self:playAnim("damage_1", false)
end

--[[
	播放受伤动画2
--]]
function RoleNode:playDamage2()
	--printError("RoleNode:playDamage2() - must override in inherited class")
	self:playAnim("damage_2", false)
end

--[[
	播放死亡动画
--]]
function RoleNode:playDead()
	self:playAnim("dead", false)
end

--[[
	进入空闲状态
--]]
function RoleNode:doIdle()
	-- body
	self.stateMgr:changeState(self.state.idle)
end

--[[
	进入行走状态
--]]
function RoleNode:doWalk()
	self.stateMgr:changeState(self.state.walk)
end

--[[
	进入攻击状态
--]]
function RoleNode:doAttack()
	-- body
	if table.nums(self.buffMgr:getBuffByType(14)) > 0 then
		self.stateMgr:changeState(self.state.idle)
	else
		self.stateMgr:changeState(self.state.attack)
	end
end

function RoleNode:doSkill(skillId)
	self.skillMgr:setReleaseSkillById(skillId)
	self.stateMgr:changeState(self.state.skill)
end

--[[
	攻击间隔
--]]
function RoleNode:doAttackDelay()
	self.stateMgr:changeState(self.state.delayAttack)
end

--[[
	远程攻击
--]]
function RoleNode:doFarAttack()
	-- body
	self.stateMgr:changeState(self.state.farAttack)
end

--[[
	进程攻击
--]]
function RoleNode:doNearAttack()
	-- body
	self.stateMgr:changeState(self.state.nearAttack)
end

--[[
	免疫伤害
	@params damageType 伤害类型
--]]
function RoleNode:immunityDamage(damageType)
	--免疫物理和魔法伤害
	if self.unbeatable and self.magicUnbeatable and damageType ~= 4 then
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

--[[
	中hp类型buff的伤害
	@params attacker 攻击的角色
	@params hp 伤害的血量
--]]
function RoleNode:doBuffDamage(attacker,hp)
	self:doAttackDamage(3,hp)
	return true
end

--[[
	反伤，被攻击时，反弹伤害攻击者
	@params attackType 攻击类型
	@params damageReal 绝对伤害
--]]
function RoleNode:doReboundDamage(attackType,damageReal)

	-- body
	if self:immunityDamage(attackType) then
		return
	end

	self:doAttackDamage(attackType,damageReal)
end

--[[
	陷阱攻击伤害
--]]
function RoleNode:doTrapDamage(damageType,damage,buffId)

	--无敌状态，免疫全部物理伤害
	if self:immunityDamage(damageType) then
		return
	end
	self:doAttackDamage(attackType,damage)

	if buffId ~= "" then
		self.buffMgr:addBuff(buffId, 1, trap)
	end
end

--[[
	根据攻击类型减少伤害
--]]
function RoleNode:doAttackDamage(attackType,damageReal,damageFont)

	local buffs = self.buffMgr:getBuffByType(21)
	if table.nums(buffs) > 0 then
		damageReal = damageReal * buffs[1].data
	end

	local fnt = "font_atk.fnt"
	if damageFont and damageFont ~= "" then
		fnt = damageFont
	end

	if attackType == 1 and self.shield > 0 then
		--物理护盾防御
		self.shield = self.shield - damageReal
		local sp = display.newSprite("absorb.png")
		self:showTipNode(sp)
	elseif attackType == 2 and self.magicShield > 0 then
		--魔法护盾防御
		self.magicShield = self.magicShield - damageReal
		local sp = display.newSprite("absorb.png")
		self:showTipNode(sp)
	else
		local curHp = self.model.hp - damageReal
		self:setHp(curHp)

		local label = display.newBMFontLabel({
			text = string.format("%d",damageReal) ,font = fnt})
		self:showTipNode(label)
		self:showHpBar();
		self:updateHpBar()
	end
end

--[[
	技能攻击伤害
	attackerData 攻击者数据
	skillData 攻击的技能数据
--]]
function RoleNode:doSkillDamage(attackerData,skillData)
	AudioManage.playSound("hit.mp3",false)

	local attacker       = attackerData.attacker
	local a_atk          = attackerData.a_atk
	local a_m_atk        = attackerData.a_m_atk
	local a_acp          = attackerData.a_acp
	local a_m_acp        = attackerData.a_m_acp
	local a_break        = attackerData.a_break
	local a_tumble       = attackerData.a_tumble
	local a_lv           = attackerData.a_lv
	local a_skillNum     = attackerData.a_skillNum

	local s_finish       = skillData.skill_finish
	local s_rate         = skillData.rate
	--同一个技能照成多次伤害中的单次伤害比
	local s_ratio        = skillData.skill_ratio
	local s_damage       = skillData.skill_damage
	local s_damage_ratio = skillData.skill_damage_ratio
	local s_damage_real  = skillData.damage_real
	local s_damage_type  = skillData.damage_type
	local s_crit_rate    = skillData.crit_rate
	local s_crit_num     = skillData.crit_num
	local s_buffId       = skillData.buffId
	local s_buff_rate    = skillData.buff_rate
	local s_lv           = skillData.level

	if self:immunityDamage(s_damage_type) then
		return false
	end

	if s_damage_type ~= 3 then
		local damageFont = "font_atk.fnt"
		local damageReal = 0
		newrandomseed()
		--技能命中
		if s_rate * 100 >= math.random(1,100) then
			--有伤害绝对值就直接计算，忽略计算公式
			if s_damage_real > 0 then
				damageReal = s_damage_real
			else
				if s_damage_type == 1 then
					--物理攻击
					damageReal = Formula[9](a_atk,s_damage,s_damage_ratio,a_lv,self.model.defense, a_acp)
				elseif s_damage_type == 2 then
					--魔法攻击
					damageReal = Formula[8](a_m_atk,s_damage,s_damage_ratio,a_lv,self.model.magicDefense, a_m_acp)
				elseif s_damage_type == 4 then
					--真实伤害
					damageReal = Formula[7](s_damage,s_damage_ratio,a_lv)
				end
				--计算暴击伤害
				if math.random(1,100) <= s_crit_rate * 100 then
					damageFont = "font_crit.fnt"
					damageReal = s_crit_num * damageReal
				end
			end

			damageReal = damageReal * s_ratio

			self:doAttackDamage(s_damage_type,damageReal,damageFont)

   		  	self:doDamageFeedback(attacker,damageReal)

			--攻击者增加吸血
			if attacker ~= nil and not attacker.dead and attacker.nodeType == GameNodeType.ROLE then

				attacker:appendAnger(Formula[2](damageReal,self.model.maxHp,50, attacker.model.powerGet))

				attacker:doRecover(attacker.model.blood)

				local buffTb = self.buffMgr:getReBoundBuff()
				if table.nums(buffTb) > 0 then
					for k,v in pairs(buffTb) do
						if checkint(v.key) == s_damage_type or checkint(v.key) == 3 then
							attacker:doReboundDamage(s_damage_type,v.data * damageReal)
						end
					end
				end
			end

			if self.model.hp <= 0 then

		  		if attacker ~= nil and not attacker.dead and attacker.nodeType == GameNodeType.ROLE then
		            --死亡时增加攻击角色怒气
		            attacker:appendAnger(20)
		       	end

				self:setBuffEffectVisible(false)
				self:doDead()
				return true
			else

				self:appendAnger(Formula[2](damageReal,self.model.maxHp,500, self.model.powerGet))

				if self.superBody then
					return true
				end

				local r_break = Formula[12](a_break,self:getBreakTotal(), damageReal / self.model.maxHp)
				local r_tumble = Formula[13](a_tumble,self:getTumbleTotal(), damageReal / self.model.maxHp)

				newrandomseed()
				if a_skillNum then
					if a_skillNum == 2 then
						if r_tumble * 100 >= math.random(0,100) then
							self.stateMgr:changeState(self.state.demage2)
						end
					else
						if r_break * 100 >=  math.random(0,100) then
							self.stateMgr:changeState(self.state.demage1)
						end
					end
				end
			end
		else
			--技能闪避
			local sp = display.newSprite("miss.png")
			self:showTipNode(sp)
			return false
		end
	end

	--if skillData.damage_type == 3 then
	if s_finish and s_buffId ~= "" then
		newrandomseed()
		if s_buff_rate * 100 >= math.random(0,100) then
			self.buffMgr:addBuff(s_buffId, s_lv, attacker)
		else
			-- print(string.format("角色roleId = %s 闪避了buff buffId = %s",self.roleId,s_buffId[1]))
		end
	end

	return true
end

--[[
	普通角色攻击的伤害
	attackerData 攻击者数据
--]]
function RoleNode:doDamage(attackerData)

	AudioManage.playSound("hit.mp3",false)

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

	if self:immunityDamage(a_damage_type) then
		return false
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
		damageFont = "font_atk.fnt"
		if a_damage_type == 1 then
			damageReal = Formula[6](a_atk, a_lv,self.model.defense,a_acp)
		else
			damageReal = Formula[6](a_m_atk, a_lv,self.model.magicDefense,a_m_acp)
		end
	end

	if a_attackNum == 2 then
		 damageReal = damageReal * 1.05
	elseif a_attackNum == 3 then
		 damageReal = damageReal * 1.25
	elseif a_attackNum == 4 then
		 damageReal = damageReal * 1.7
	end

	self:doAttackDamage(a_damage_type,damageReal,damageFont)

	self:doDamageFeedback(attacker,damageReal)

	if self.model.hp <= 0 then

  		if attacker ~= nil and not attacker.dead and attacker.nodeType == GameNodeType.ROLE then
            --死亡时增加攻击角色怒气
            attacker:appendAnger(10)
       	end

		self:setBuffEffectVisible(false)
		self:doDead()
	else
		self:appendAnger(Formula[2](damageReal,self.model.maxHp,500,self.model.powerGet))

		--不是霸体要计算是否后仰后移
		if self.superBody then
			return true
		end

		--普攻前三段 只判断后仰 r_break 第四段和技能类型damage_type 1 和2 的判断后退r_tumble
		--local r_break = Formula[12](a_break,self.model.breakValue, damageReal / self.model.maxHp)
		--local r_tumble = Formula[13](a_tumble,self.model.tumble, damageReal / self.model.maxHp)

		local r_break = Formula[12](a_break,self:getBreakTotal(), damageReal / self.model.maxHp)
		local r_tumble = Formula[13](a_tumble,self:getTumbleTotal(), damageReal / self.model.maxHp)

		newrandomseed()
		if a_attackNum < 4 then
			if r_break * 100 >=  math.random(0,100) then
				self.stateMgr:changeState(self.state.demage1)
			end
		else
			if r_tumble * 100 >= math.random(0,100) then
				self.stateMgr:changeState(self.state.demage2)
			end
		end
	end

	return true
end

--[[
	受伤后给攻击者的反馈处理
--]]
function RoleNode:doDamageFeedback(attacker,damageReal)
	if attacker ~= nil and not attacker.dead and attacker.nodeType == GameNodeType.ROLE then

		attacker:appendAnger(Formula[2](damageReal,self.model.maxHp,50,attacker.model.powerGet))
		--攻击者按吸血属性定值回血
		attacker:doRecover(attacker.model.blood)

		--攻击者如有吸血buff,取最后一个吸血buff的data数值,按照成伤害百分比吸血
		local suckBuffTable = attacker.buffMgr:getSuckBuff()
		if table.nums(suckBuffTable) > 0 then
			local buff = suckBuffTable[#suckBuffTable]
			attacker:doRecover(buff.data * damageReal)
		end

		--如有反伤buff,会给攻击者照成反弹伤害
		local reBoundBuffTable = self.buffMgr:getReBoundBuff()
		if table.nums(reBoundBuffTable) > 0 then
			for k,v in pairs(reBoundBuffTable) do
				if checkint(v.key) == a_damage_type or checkint(v.key) == 3 then
					attacker:doReboundDamage(a_damage_type,v.data * damageReal)
				end
			end
		end
	end
end

--[[
	角色恢复增加hp
--]]
function RoleNode:doRecover(hp)

	if hp <= 0 then
		return
	end

	local buffs = self.buffMgr:getBuffByType(20)
	if table.nums(buffs) > 0 then
		hp = hp * buffs[1].data
	end

	local curHp = self.model.hp + hp
	self:setHp(curHp)
	local label =  display.newBMFontLabel({
		text = string.format("%d",hp) ,font = "font_health.fnt"})

	self:showTipNode(label)
	self:showHpBar();
	self:updateHpBar()

end

--[[
	进入死亡状态
--]]
function RoleNode:doDead()
	self:hideHpBar()
	self:stopAllSchedule()
	self.stateMgr:changeState(self.state.dead)
end

--[[
	进入胜利状态
--]]
function RoleNode:doWin()
	-- body
	self:stopAllSchedule()
	self.stateMgr:changeState(self.state.win)
end


--[[
	设置下一次攻击编号
--]]
function RoleNode:doNextAttackNum()
	-- body
	local num = self.attackNum
	num = num + 1

	if num > self.attackTotal then
		num = 1
	end

	self.attackNum = num
end

--[[
	是最后一段攻击么
--]]
function RoleNode:isLastAttack()

	if self.attackNum == self.attackTotal then
		return true
	else
		return false
	end

end

--[[
 	视野范围内时候有人
--]]
function RoleNode:hasViewRange()
	-- body
	return BattleManager.hasViewRange(self)
end

function RoleNode:hasAttackRange()
	-- body
	return BattleManager.hasAttackRange(self)
end

--[[
	获取视野内的敌人
--]]
function RoleNode:findViewRange()
	-- body
	return BattleManager.findViewRange(self)
end

--[[
	获取攻击范围内的敌人
--]]
function RoleNode:findAttackRange()
	-- body
	return BattleManager.findAttackRange(self)
end

--[[
	获取攻击范围内最近的敌人
--]]
function RoleNode:findOneAttackRange()
	-- body
	return BattleManager.findOneAttackRange(self)
end

--[[
	获取技能生效范围内
--]]
function RoleNode:findSkillRange(skillId)
	return BattleManager.findSkillRange(self,skillId)
end

--[[
	是否碰撞障碍
--]]
function RoleNode:hasObstruct()
	return BattleManager.hasObstruct(self)
end

--[[
	被攻击时播放被攻击到的效果
	@params name 资源动画名称
	@params callback 动画完成后回调
--]]
function RoleNode:showEffect(name,callback)
	if name == "" then
		return
	end
	local anim =  GafAssetCache.makeAnimatedObject(name)

	local frameSize = anim:getFrameSize()
	anim:setPosition(frameSize.width * - 0.5,frameSize.height * 0.5)
	anim:addTo(self.effectNode)
	anim:start()

	if callback then
		anim:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.Hide:create(),cc.CallFunc:create(function()
			callback()
		end), cc.RemoveSelf:create()))
	else
		anim:runAction(cc.Sequence:create(cc.DelayTime:create(0.2),cc.RemoveSelf:create()))
	end

	return anim
end

--[[
	显示提示 免疫 miss等
--]]
function RoleNode:showTipNode(tip)
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
	显示技能名称
	@params name 资源图片名
--]]
function RoleNode:showSkillName(name)
    --local img = string.format("skillname%s.png", skillId)
    if name == "" or name == nil then
    	printInfo("roleId = %s 技能名称图片没有找到", self.roleId)
    	return
    end

    local sp = display.newSprite(name..".png")
    sp:setScale(5)

    if self.camp == GameCampType.left then
    	sp:setAnchorPoint(cc.p(0.8,0))
    else
    	sp:setAnchorPoint(cc.p(0.2,0))
    end

    sp:setPosition(0,self.model.nodeSize.height )
    sp:addTo(self)

    transition.scaleTo(sp,{scale = 1, time = 0.3 , easing = "elasticOut", onComplete = function ()
    	sp:runAction(cc.Sequence:create(cc.DelayTime:create(1.5),cc.RemoveSelf:create()))
    end})
end

--[[
	显示血条
--]]
function RoleNode:showHpBar()
	self.hpBar:stopAllActions()
	--固定显示血条
	if self.hpBarFixed then
		self.hpBar:setVisible(true)
	else
		local sequence = transition.sequence({
			cc.Show:create(),
			cc.DelayTime:create(0.5),
			cc.Hide:create()
		})
		self.hpBar:runAction(sequence)
	end
end

--[[
	隐藏血条
--]]
function RoleNode:hideHpBar()
	self.hpBar:stopAllActions()
	self.hpBar:setVisible(false)
end

--[[
	更新血条数值
--]]
function RoleNode:updateHpBar()
	self.hpProgress:setPercentage(self.model.hp * 1.0 / self.model.maxHp * 100)
end

--[[
	暂停角色全部操作
--]]
function RoleNode:pauseAll()
	self.isPaused = true
	self:pause()
	self:pauseSkill()
	self:pauseTailSkill()
	self:pauseBuff()
	self.animNode:pauseAnimation()
	if self.bombNode then
		self.bombNode:pause()
	end
end

--[[
	恢复角色全部操作
--]]
function RoleNode:resumeAll()
	self.isPaused = false
	self:resume()
	self:resumeSkill()
	self:resumeTailSkill()
	self:resumeBuff()
	self.animNode:resumeAnimation()
	if self.bombNode then
		self.bombNode:resume()
	end
end

--[[
	暂停尾兽技能
--]]
function RoleNode:pauseTailSkill()
	if self.tailSkillMgr then
		self.tailSkillMgr.isPaused = true
	end
end

--[[
	恢复尾兽技能
--]]
function RoleNode:resumeTailSkill()
	if self.tailSkillMgr then
		self.tailSkillMgr.isPaused = false
	end
end

--[[
	暂停角色技能
--]]
function RoleNode:pauseSkill()
	-- body
	self.skillMgr.isPaused = true
end

--[[
	恢复角色技能
--]]
function RoleNode:resumeSkill()
	-- body
	self.skillMgr.isPaused = false
end

--[[
	暂停身上的buff
--]]
function RoleNode:pauseBuff()
	-- body
	self.buffMgr.isPaused = true
end

--[[
	恢复身上的buff
--]]
function RoleNode:resumeBuff()
	-- body
	self.buffMgr.isPaused = false
end

--[[
	添加buff效果
	对已有的相同的效果添加，如果不是循环的，只是重新播放一次
--]]
function RoleNode:addBuffEffect(buff)

	local effect = buff.effect
	local site   = buff.site
	local txt    = buff.txt

	if effect == "" then
		return
	end

	local anim = self:getBuffEffect(buff.buffId)

	if anim == nil then
		--todo buff动画可进入游戏的时候加载一次
		if  GafAssetCache.hasCache(effect) then
			anim =  GafAssetCache.makeAnimatedObject(effect)
		else
			local zipPath = effect..".zip"
			local gafPath = effect.."/"..effect..".gaf"
			local asset = gaf.GAFAsset:createWithBundle(zipPath,gafPath)
			GafAssetCache.addAsset(effect,asset)
			anim =  AnimWrapper.new(asset)
		end

		local frameSize = anim:getFrameSize()
		anim:setPosition(frameSize.width * - 0.5,frameSize.height * 0.5)
		anim:setTag(buff.buffId)

		if site == 1 then
			anim:setPositionY(anim:getPositionY() - 20)
			anim:addTo(self.buffEffectNode)
		elseif site == 2 then
			anim:setPositionY(anim:getPositionY() + self.model.nodeSize.height * 0.5)
			anim:addTo(self.buffEffectNode)
		elseif site == 3 then
			anim:setPositionY(anim:getPositionY() + self.model.nodeSize.height + 50)
			if txt ~= "" then
				local count = self.buffTxtNode:getChildrenCount()
				if count > 0 then
					anim:setVisible(false)
				end

				anim:addTo(self.buffTxtNode)
				anim:runAction(
					cc.Sequence:create(
						cc.DelayTime:create((count -1)* 1),
						cc.Show:create(),
						cc.MoveBy:create(0.8,cc.p(0,30)),
						cc.DelayTime:create(1),
						cc.RemoveSelf:create()
					))
			else
				anim:addTo(self.buffEffectNode)
			end
		end

		anim:start()
	end

	anim:playSequence("buff",buff.effectLoop)

end

--[[
	删除角色身上的buff显示效果
	now 马上删除
--]]
function RoleNode:removeBuffEffect(buff,removeNow)

	local anim = self:getBuffEffect(buff.buffId)
	if anim then
		--延时删除buff效果，以便立即执行一次的buff能看到效果
		if removeNow then
			anim:removeFromParent()
		else
			anim:runAction(cc.Sequence:create(cc.FadeOut:create(0.5),cc.RemoveSelf:create()))
		end
	end
end

--[[
	获取角色身上显示的buff效果
--]]
function RoleNode:getBuffEffect(buffId)
	return self.buffEffectNode:getChildByTag(buffId)
end

--[[
	设置角色身上的buff效果是否可见
--]]
function RoleNode:setBuffEffectVisible(visible)
	-- body
	self.buffEffectNode:setVisible(visible)
end

--[[
	设置hp 并触发回调 hp属性变动 统一调用此方法
--]]
function RoleNode:setHp(hp)
	self.model.hp = math.max(hp,0)
	self.model.hp = math.min(self.model.hp,self.model.maxHp)

	if self.onUpdateHp ~= nil then
		self.onUpdateHp(self,self.model.hp,self.model.maxHp)
	end
end

--[[
	设置maxHp 并触发回调 maxHp属性变动 统一调用此方法
--]]
function RoleNode:setMaxHp(maxHp)
	self.model.maxHp = math.max(maxHp, 0)
	if self.onUpdateHp ~= nil then
		self.onUpdateHp(self,self.model.hp,self.model.maxHp)
	end
end


--[[
	受伤后增加怒气
--]]
-- function RoleNode:afterDamageAppendAnger(damage)
-- 	if damage <= 0 then
-- 		return
-- 	end

-- 	local anger = 1 + (damage / self.model.maxHp * 100)
-- 	self:appendAnger(anger)
-- end

--[[
	攻击后增加怒气
--]]
-- function RoleNode:afterAttackAppendAnger(attackNum)
-- 	local anger = 0

-- 	if attackNum == 1 then
-- 		anger = 5 + math.min(5 * 2.3,self.hit/10) + 1
-- 	elseif attackNum == 2 then
-- 		anger = (5 + math.min(5 * 2.3,self.hit/10)) * 1.1
-- 	elseif attackNum == 3 then
-- 		anger = (5 + math.min(5 * 2.3,self.hit/10)) * 1.2
-- 	elseif attackNum == 4 then
-- 		anger = (5 + math.min(5 * 2.3,self.hit/10)) * 1.5
-- 	end

-- 	self:appendAnger(anger)
-- end

--[[
	增加怒气
--]]
function RoleNode:appendAnger(anger)
	--printInfo("anger %d====%d=====%d",anger,self.model.anger,self.model.maxAnger)
	self:setAnger(anger + self.model.anger + self.addAnger)
end

--[[
	设置怒气
--]]
function RoleNode:setAnger(anger)
	if self.model.anger == anger then
		return
	end

	self.model.anger = anger
	self.model.anger = math.max(self.model.anger, 0)
	self.model.anger = math.min(self.model.anger, self.model.maxAnger)
	self.model.anger = math.floor(self.model.anger)

	if self.onUpdateAnger ~= nil then
		self.onUpdateAnger(self,self.model.anger,self.model.maxAnger)
	end
end

--[[
	添加连击数
--]]
function RoleNode:appendHit(hit)
	if hit == 0 then
		return
	end

	self.hit = self.hit + hit
	if  self.onUpdateHit ~= nil then
		self.onUpdateHit(self,self.hit)
	end

	if self.__hitScheduleHandle then
		scheduler.unscheduleGlobal(self.__hitScheduleHandle)
		self.__hitScheduleHandle = nil
	end

	self.__hitScheduleHandle = scheduler.performWithDelayGlobal(handler(self,self.resetHit),3)

end

--[[
	重置连击数
--]]
function RoleNode:resetHit()
	self.hit = 0
	if  self.onUpdateHit ~= nil then
		self.onUpdateHit(self,0)
	end
end

--[[
	变身后开启自动减怒气值
--]]
function RoleNode:startSubAngerTimer()
	if not self.__subAngerScheduleHandle then
		self.__subAngerScheduleHandle = scheduler.scheduleGlobal(handler(self,self.doAutoSubAnger),0.1)
	end
end

--[[
	停止减少怒气定时器
--]]
function RoleNode:stopSubAngerTimer()
	if self.__subAngerScheduleHandle then
		scheduler.unscheduleGlobal(self.__subAngerScheduleHandle)
		self.__subAngerScheduleHandle = nil
	end
end

--[[
	变身后，定时执行减少怒气
--]]
function RoleNode:doAutoSubAnger( dt )
	if self.isPaused then
		return
	end
	local anger = self.model.anger
	anger = anger - self.subAnger
	self:setAnger(anger)
end

--[[
	停止这个角色上的定时器 , 在角色死亡时调用下， 确保角色全局定时器中没有对死亡角色的调用
--]]
function RoleNode:stopAllSchedule()

	if self.__hitScheduleHandle then
		scheduler.unscheduleGlobal(self.__hitScheduleHandle)
		self.__hitScheduleHandle = nil
	end

	self:stopSubAngerTimer()

end

--[[
 	设置动画速度
--]]
function RoleNode:setAnimSpeed(speed)
	-- body
	self.model.walkSpeed = self.model.baseProperty.walkSpeed * speed
	local fps = math.floor(30 * speed)
	printInfo("roleId = %s 设置动画fps == %d walkSpeed = %d", self.roleId,fps,self.model.walkSpeed)
	self.animNode:setFps(fps)
end

function RoleNode:destory()
	self.animNode:stop()
	self.animNode:clearSequence()
	self.animNode:enableTick(false)
	self:stopAllSchedule()
end

--[[
	判断角色是否可以自动释放技能
--]]
function RoleNode:autoRealseSkill(hasEnemy)
	if not self.auto then
		return false
	end

	--自动释放尾兽技能
	if self.tailSkillMgr then

		local skill = self.tailSkillMgr:getSkillByCurrent()
		local isRelease = self.tailSkillMgr:checkEnableById(skill.skillId)
		if (skill.typeOpen == 1 or hasEnemy) and isRelease  then
			self:doTailSkill(skill.skillId)
			return true
		end
	end

	--自动释放角色节能
	for i=table.nums(self.model.skillids) ,1,-1 do
		local skill = self.skillMgr:getSkillByNum(i)
		local isRelease = self.skillMgr:checkEnableByNum(i)
		if (skill.typeOpen == 1 or hasEnemy) and isRelease then
	    	self:doSkill(skill.skillId)
	    	return true
		end
	end

	return false
end

--[[
	判断角色是否可以自动移动
--]]
function RoleNode:autoWalk()
	if not self.auto then
		return false
	end

	if self:hasObstruct() then
		return false
	end
	self:doWalk()
	return true
end

--[[
	角色存活时间到了回调
--]]
function RoleNode:onLiveTimeEnd()
	print(string.format("towerId = %s 存活时间到了",self.towerId))
	self:doDead()
end

--[[
	只是根据ID判断是不是变身角色,CharacterNode 子类重写了这个
--]]
function RoleNode:isEvolve()
	return false
end

--[[
	按角色当前状态，获得后仰总值（按技能的后仰值+角色的后仰值）
--]]
function RoleNode:getBreakTotal()
	local total = self.model.breakValue
	if self.skillLock then
		total = total + self.skillMgr:getSkillByCurrent().breaks
	end
	--printInfo(total)
	return total
end

--[[
	按角色当前状态，获得击退总值（按技能的击退值+角色的击退值）
--]]
function RoleNode:getTumbleTotal()
	local total = self.model.tumble
	if self.skillLock then
		total = total + self.skillMgr:getSkillByCurrent().tumble
	end
	--printInfo(total)
	return total
end

return RoleNode