--
-- Author: zsp
-- Date: 2014-12-03 15:01:12
--

local Skill = class("Skill")
local MissileNode = import("..node.MissileNode")

--[[
	角色技能的基类，子类重写事件方法 由角色释放 手动或自动触发
--]]
function Skill:ctor(skillId,owner,level)

	self.isPaused   = false

	-- body
	self.skillId    = skillId
	self.owner      = owner
	self.dtCooldown = 0
	self.level      = level or 1 --以后读数据

	local cfg       = GameConfig.skill[skillId]

	-- 可升级属性 和skill表字段必须保持一致==================================================================
	self.rate         = checknumber(cfg["rate"])
	self.crit_rate    = checknumber(cfg["crit_rate"])
	self.crit_num     = checkint(cfg["crit_num"])
	self.damage       = checkint(cfg["damage"])
	self.damage_ratio = checknumber(cfg["damage_ratio"])
	self.damage_real  = checkint(cfg["damage_real"])
	self.cd_time      = checknumber(cfg["cd_time"])
	self.recover      = checkint(cfg["recover"])
	self.buff_rate    = checknumber(cfg["buff_rate"])
	self.type         = checkint(cfg["type"])
	self.atkNum       = checkint(cfg["num"])
	
	--==================================================================
	self.name              = cfg["skill_name"] or ""
	self.typeOpen          = checkint(cfg["type_open"])
	self.damage_type       = checkint(cfg["damage_type"])
	self.level_max         = checkint(cfg["level_max"])
	self.target            = checkint(cfg["target"])
	self.missileId         = cfg["fly_id"] or ""
	self.buffId            = cfg["buff_id"] or ""
	self.myBuffId          = cfg["my_buff"] or ""
	self.attackEffect      = cfg["atk_effect"]
	--self.attackEffectNum = checkint(cfg["atk_effect_num"])
	self.nodeOffset = cc.p(checkint(cfg["skill_box"][1]),checkint(cfg["skill_box"][2]))
	self.nodeSize   = cc.size(checkint(cfg["skill_box"][3]), checkint(cfg["skill_box"][4]))
	
	--属性升级
	local levelData = cfg["level_data"]
	if levelData ~= nil then
		for i=1,#levelData do
			local data = levelData[i]
			local tb = string.split(data,":")
			local k = tb[1]
			local v = checknumber(tb[2])
			self[k] = Formula[7](self[k], self.level,checknumber(v))
		end
	end

	-- 技能的后仰打断附加值
	self.breaks     = checkint(cfg["breaks"])
	self.tumble     = checkint(cfg["tumble"])
	local breaksUpgrade = checkint(cfg["breaks_upgrade"])
	local tumbleUpgrade = checkint(cfg["tumble_upgrade"])
	self.breaks = (self.breaks + ( self.level - 1 ) * breaksUpgrade)
	self.tumble = (self.tumble + ( self.level - 1 ) * tumbleUpgrade)
end

function Skill:isCooldown()
	-- body
	if self.dtCooldown <  self.cd_time then
		return false
	end

	return true
end

function Skill:resetCooldown()
	-- body
	--if self.dtCooldown >= self.cooldown then
		--todo
		self.dtCooldown = 0
	--end
end

function Skill:update(dt)
		-- body
	if self.isPaused then
		return
	end

	self.dtCooldown = math.min(self.dtCooldown + dt, self.cd_time)
end

--[[
	设置技能冷却时间立即完成
--]]
function Skill:setCooldownFinish()
	-- body
	self.dtCooldown = self.cd_time
end

--[[
	释放技能
--]]
function Skill:doRelease(skillRatio,isFinish)
	if self.recover > 0 then
		self.owner:doRecover(self.recover)
	end

	if isFinish and self.myBuffId ~= "" then
		--todo 没有打到敌人时候是否也添加这个buff	
		self.owner.buffMgr:addBuff(self.myBuffId, self.level, self.owner)
	end

	--脱离角色的技能 todo 分次攻击的都是在范围内随机的一个
	if self.type == 2 then
		self:doReleaseType2()
	--分次攻击 单独的动画
	elseif self.type == 3 then
		self:doReleaseType3()
	elseif self.type == 4 then
		self:doReleaseType4()
	else
		if  self.missileId ~= "" then
			self:doFarRelease(skillRatio,isFinish)
		else
			self:doNearRelease(skillRatio,isFinish)
		end
	end
end

function Skill:doNearRelease(skillRatio,isFinish)
	
	local tb = self.owner:findSkillRange(self.skillId)

	table.walk(tb, function(v, k)
		local role = v
    	role:showEffect(self.attackEffect)
    	role:doSkillDamage({
			attacker    = self.owner,
			a_atk       = self.owner.model.atk,
			a_m_atk     = self.owner.model.magicAtk,
			a_acp       = self.owner.model.acp,
			a_m_acp     = self.owner.model.magicAcp,
			-- a_break  = self.owner.model.breakValue,
			-- a_tumble = self.owner.model.tumble,
			a_break     = self.owner:getBreakTotal(),
			a_tumble    = self.owner:getTumbleTotal(),
			a_skillNum  = self.owner.skillMgr.skillNum,
			a_lv        = self.owner.level
    	},{
    		skill_finish	   = isFinish,
			rate               = self.rate,
			skill_ratio        = skillRatio,
			skill_damage       = self.damage,
			skill_damage_ratio = self.damage_ratio,
			damage_real        = self.damage_real,
			damage_type        = self.damage_type,
			crit_rate          = self.crit_rate,
			crit_num           = self.crit_num,
			buffId             = self.buffId,
			buff_rate          = self.buff_rate,
			level              = self.level
    	})
	end)
end

function Skill:doFarRelease(skillRatio,isFinish)

	local missile = MissileNode.new({
		missileId  = self.missileId,
		owner      = self.owner,
		distance   = self.nodeSize.width,
		attackerData = {
			attacker    = self.owner,
			a_atk       = self.owner.model.atk,
			a_m_atk     = self.owner.model.magicAtk,
			a_acp       = self.owner.model.acp,
			a_m_acp     = self.owner.model.magicAcp,
			-- a_break  = self.owner.model.breakValue,
			-- a_tumble = self.owner.model.tumble,
			a_break     = self.owner:getBreakTotal(),
			a_tumble    = self.owner:getTumbleTotal(),
			a_skillNum  = self.owner.skillMgr.skillNum,
			a_lv        = self.owner.level
    	},
    	skillData = {
    		skill_finish	   = isFinish,
			rate               = self.rate,
			skill_ratio        = skillRatio,
			skill_damage       = self.damage,
			skill_damage_ratio = self.damage_ratio,
			damage_real        = self.damage_real,
			damage_type        = self.damage_type,
			crit_rate          = self.crit_rate,
			crit_num           = self.crit_num,
			buffId             = self.buffId,
			buff_rate          = self.buff_rate,
			level              = self.level
    	}
	})

	missile:addTo(self.owner:getParent())
end

--[[
	后扩展出来，技能动画和角色是分离的 
--]]
function Skill:doReleaseType2()

	local rect = self.owner:getSkillRect(self.skillId)
	local p = self.owner:getParent():convertToNodeSpace(cc.p(rect.x,rect.y));
	rect.x = p.x 
	rect.y = p.y

	local skillNode = require("app.battle.node.GameNode").new()
	skillNode.nodeType = GameNodeType.SKILL
	skillNode.nodeBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	skillNode.nodeBox:setContentSize(rect.width,rect.height)
	skillNode.nodeBox:addTo(skillNode)
	skillNode.nodeBox:setVisible(false)
	skillNode:setPosition(cc.p(rect.x,rect.y))
	skillNode:addTo(self.owner:getParent())

	local executeCount = 1

	local num = self.owner.skillMgr.skillNum
	local animNode = GafAssetCache.makeAnimatedObject(string.format("%s_skill_%d", self.owner.model.image,num))

	local skillFrameMap = self.owner:getSkillFrameMap(num)
	local frameMap = {}
	for i=2,#skillFrameMap do
		table.insert(frameMap,skillFrameMap[i])
	end
	
	local function onFrame(frame,finish)
		if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
			return
		end

        if finish then
       		animNode:stop()
            animNode:unregisterScriptHandler()
            -- animNode:getParent():removeFromParent() 
            animNode:getParent():runAction(cc.Sequence:create(cc.Hide:create(),cc.DelayTime:create(1),cc.RemoveSelf:create()))
        else
        	local isFinish = (table.nums(frameMap) == executeCount)
			local skillRatio = self.owner.model.skillRatioMap[num][executeCount]
			-- todo 统一用findSkillRange 获取
			local tb = BattleManager.roles[self.owner.enemyCamp]
			table.walk(tb,function(v,k)
			 
				if v:isActive() and  
				--v.nodeType == GameNodeType.ROLE and 
				cc.rectIntersectsRect(skillNode:getNodeRect(),v:getNodeRect()) then

					local role = v
		    	
			    	role:showEffect(self.attackEffect)
			    	
			    	role:doSkillDamage({
						attacker = self.owner,
						a_atk    = self.owner.model.atk,
						a_m_atk  = self.owner.model.magicAtk,
						a_acp    = self.owner.model.acp,
						a_m_acp  = self.owner.model.magicAcp,
						-- a_break  = self.owner.model.breakValue,
						-- a_tumble = self.owner.model.tumble,
						a_break     = self.owner:getBreakTotal(),
						a_tumble    = self.owner:getTumbleTotal(),
						a_skillNum  = self.owner.skillMgr.skillNum,
						a_lv     = self.owner.level
			    	},{
			    		skill_finish	   = isFinish,
						rate               = self.rate,
						skill_ratio        = skillRatio,
						skill_damage       = self.damage,
						skill_damage_ratio = self.damage_ratio,
						damage_real        = self.damage_real,
						damage_type        = self.damage_type,
						crit_rate          = self.crit_rate,
						crit_num           = self.crit_num,
						buffId             = self.buffId,
						buff_rate          = self.buff_rate,
						level              = self.level
			    	})

				end
			end)

			executeCount = executeCount + 1
        end
    end

	animNode:setDelegate()
    animNode:registerScriptHandler(onFrame)
	animNode:addTo(skillNode)
	animNode:start()


	if self.owner.camp == GameCampType.left then
		animNode:setPosition(animNode:getFrameSize().width * -0.5 + rect.width * 0.5, animNode:getFrameSize().height - 440)
		animNode:setScaleX(1)
	else
		--todo
		animNode:setPosition(animNode:getFrameSize().width * 0.5 + rect.width * 0.5, animNode:getFrameSize().height - 440)
		animNode:setScaleX(-1)
	end

end

--[[
	后扩展出来的，技能动画和角色是分离的 并且多次释放技能动画 ，每次攻击一个目标并随机
	todo重新设计技能表列,完善语义，让选敌时更通用
	范围由大缩小确定范围，攻击目标 共几次，每次什么样的敌人，是否随机等
--]]
function Skill:doReleaseType3()
	local rect = self.owner:getSkillRect(self.skillId)
	local p = self.owner:getParent():convertToNodeSpace(cc.p(rect.x,rect.y));
	rect.x = p.x 
	rect.y = p.y
	--读配置
	for i = 1,self.atkNum do
		local skillNode = require("app.battle.node.GameNode").new()
		skillNode.nodeType = GameNodeType.SKILL
		skillNode.nodeBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
		skillNode.nodeBox:setContentSize(rect.width,rect.height)
		skillNode.nodeBox:addTo(skillNode)
		skillNode.nodeBox:setVisible(false)
		skillNode:setPosition(cc.p(rect.x,rect.y))
		skillNode:addTo(self.owner:getParent())

		local executeCount = 1
		local num = self.owner.skillMgr.skillNum
		local animNode = GafAssetCache.makeAnimatedObject(string.format("%s_skill_%d", self.owner.model.image,num))
		local skillFrameMap = self.owner:getSkillFrameMap(num)
		local frameMap = {}
		for i=2,#skillFrameMap do
			table.insert(frameMap,skillFrameMap[i])
		end
		
		local function onFrame(frame,finish)
			if table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
				return
			end

	        if finish then
	       		animNode:stop()
	            animNode:unregisterScriptHandler()
	            skillNode:removeFromParent()
	            animNode:runAction(cc.Sequence:create(cc.Hide:create(),cc.DelayTime:create(1),cc.RemoveSelf:create()))
	        else
	        	local isFinish = (table.nums(frameMap) == executeCount)
				local skillRatio = self.owner.model.skillRatioMap[num][executeCount]

				if animNode.role then
						local role = animNode.role
				    	role:showEffect(self.attackEffect)
				    	role:doSkillDamage({
							attacker = self.owner,
							a_atk    = self.owner.model.atk,
							a_m_atk  = self.owner.model.magicAtk,
							a_acp    = self.owner.model.acp,
							a_m_acp  = self.owner.model.magicAcp,
							a_break     = self.owner:getBreakTotal(),
							a_tumble    = self.owner:getTumbleTotal(),
							a_skillNum  = self.owner.skillMgr.skillNum,
							a_lv     = self.owner.level
				    	},{
				    		skill_finish	   = isFinish,
							rate               = self.rate,
							skill_ratio        = skillRatio,
							skill_damage       = self.damage,
							skill_damage_ratio = self.damage_ratio,
							damage_real        = self.damage_real,
							damage_type        = self.damage_type,
							crit_rate          = self.crit_rate,
							crit_num           = self.crit_num,
							buffId             = self.buffId,
							buff_rate          = self.buff_rate,
							level              = self.level
				    	})			
				end

				executeCount = executeCount + 1
	        end
	    end

		animNode:setDelegate()
	    animNode:registerScriptHandler(onFrame)
		animNode:addTo(self.owner:getParent())

		animNode:runAction(cc.Sequence:create(cc.DelayTime:create(0.3*(i-1)),cc.CallFunc:create(function()

			local tb = BattleManager.roles[self.owner.enemyCamp]

			local hitTable = {}

			for k,v in pairs(tb or {}) do
				if v:isActive() and  cc.rectIntersectsRect(skillNode:getNodeRect(),v:getNodeRect()) then
					table.insert(hitTable,v)
				end
			end

			if table.nums(hitTable) > 0 then
				newrandomseed()
				rmd = math.random(1,table.nums(hitTable))
				animNode.role = hitTable[rmd]

				if self.owner.camp == GameCampType.left then
					animNode:setPosition(animNode:getFrameSize().width * -0.5 + animNode.role:getPositionX(), animNode:getFrameSize().height - 440 + animNode.role:getPositionY())
					animNode:setScaleX(1)
					animNode:setLocalZOrder(animNode.role:getLocalZOrder()+1)
				else
					animNode:setPosition(animNode:getFrameSize().width * 0.5 + animNode.role:getPositionX(), animNode:getFrameSize().height - 440 + animNode.role:getPositionY())
					animNode:setScaleX(-1)
					animNode:setLocalZOrder(animNode.role:getLocalZOrder()+1)
				end		
			end
			animNode:start()
		end)))	
	end
end

--[[
	后扩展出来，技能动画和角色是分离的 和类型2的却别是攻击目标每次生效帧，只随机击中一个人
--]]
function Skill:doReleaseType4()
	local rect = self.owner:getSkillRect(self.skillId)
	local p = self.owner:getParent():convertToNodeSpace(cc.p(rect.x,rect.y));
	rect.x = p.x 
	rect.y = p.y

	local skillNode = require("app.battle.node.GameNode").new()
	skillNode.nodeType = GameNodeType.SKILL
	skillNode.nodeBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	skillNode.nodeBox:setContentSize(rect.width,rect.height)
	skillNode.nodeBox:addTo(skillNode)
	skillNode.nodeBox:setVisible(false)
	skillNode:setPosition(cc.p(rect.x,rect.y))
	skillNode:addTo(self.owner:getParent())
	skillNode:setLocalZOrder(self.owner:getParent():getLocalZOrder()+100)

	local executeCount = 1

	local num = self.owner.skillMgr.skillNum
	local animNode = GafAssetCache.makeAnimatedObject(string.format("%s_skill_%d", self.owner.model.image,num))
	local skillFrameMap = self.owner:getSkillFrameMap(num)
	local frameMap = {}
	for i=2,#skillFrameMap do
		table.insert(frameMap,skillFrameMap[i])
	end
	
	local function onFrame(frame,finish)
			
		if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
			return
		end

        if finish then
       		animNode:stop()
            animNode:unregisterScriptHandler()
            -- animNode:getParent():removeFromParent() 
            animNode:getParent():runAction(cc.Sequence:create(cc.Hide:create(),cc.DelayTime:create(1),cc.RemoveSelf:create()))
        else
  	     	local isFinish = (table.nums(frameMap) == executeCount)
			local skillRatio = self.owner.model.skillRatioMap[num][executeCount]
			-- todo 统一用findSkillRange 获取
			local tb = BattleManager.roles[self.owner.enemyCamp]
			
			local hitTable = {}
			for k,v in pairs(tb) do
				if v:isActive() and  
				   cc.rectIntersectsRect(skillNode:getNodeRect(),v:getNodeRect()) then
				   table.insert(hitTable,v)
				end
			end

			if table.nums(hitTable) > 0  then
				newrandomseed()
				rmd = math.random(1,table.nums(hitTable))

				local role = hitTable[rmd]
		    	
		    	role:showEffect(self.attackEffect)
		    	
		    	role:doSkillDamage({
					attacker = self.owner,
					a_atk    = self.owner.model.atk,
					a_m_atk  = self.owner.model.magicAtk,
					a_acp    = self.owner.model.acp,
					a_m_acp  = self.owner.model.magicAcp,
					-- a_break  = self.owner.model.breakValue,
					-- a_tumble = self.owner.model.tumble,
					a_break     = self.owner:getBreakTotal(),
					a_tumble    = self.owner:getTumbleTotal(),
					a_skillNum  = self.owner.skillMgr.skillNum,
					a_lv     = self.owner.level
		    	},{
		    		skill_finish	   = isFinish,
					rate               = self.rate,
					skill_ratio        = skillRatio,
					skill_damage       = self.damage,
					skill_damage_ratio = self.damage_ratio,
					damage_real        = self.damage_real,
					damage_type        = self.damage_type,
					crit_rate          = self.crit_rate,
					crit_num           = self.crit_num,
					buffId             = self.buffId,
					buff_rate          = self.buff_rate,
					level              = self.level
		    	})
			end

			executeCount = executeCount + 1
        end
    end

	animNode:setDelegate()
    animNode:registerScriptHandler(onFrame)
	animNode:addTo(skillNode)
	animNode:start()

	if self.owner.camp == GameCampType.left then
		animNode:setPosition(animNode:getFrameSize().width * -0.5 + rect.width * 0.5, animNode:getFrameSize().height - 440)
		animNode:setScaleX(1)
	else
		animNode:setPosition(animNode:getFrameSize().width * 0.5 + rect.width * 0.5, animNode:getFrameSize().height - 440)
		animNode:setScaleX(-1)
	end
		
end


function Skill:setPause(pause)
	self.isPaused = pause
end

return Skill