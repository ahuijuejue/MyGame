--
-- Author: zsp
-- Date: 2015-04-15 17:32:36
--
local GameNode      = import(".GameNode")
local BattleEvent     = require("app.battle.BattleEvent")
local TailSkillNode   = class("TailSkillNode", GameNode)

--[[
	尾兽技能战场显示特效
--]]
function TailSkillNode:ctor(owner,skill)
	
	TailSkillNode.super.ctor(self)
	self.nodeType  = GameNodeType.SKILL
	self.owner     = owner
	self.camp      = owner.camp
	self.enemyCamp = owner.enemyCamp
	self.skill     = skill
	self.skillId   = skill.skillId
	self.level     = skill.level

	--伤害次数
    self.executeCount = 1

	self:createPetAnim()
	self:createBoundingBox()

end

--[[
	创建碰撞检测的包围盒
--]]
function TailSkillNode:createBoundingBox()
	--self.nodeBox:addTo(self)
	self.nodeBox   = cc.LayerColor:create(cc.c4b(255, 0, 0, 100))
	self.nodeBox:addTo(self)
	
	self.nodeBox:setContentSize(self.skill.nodeSize.width,self.skill.nodeSize.height)
	self.nodeBox:setPosition(self.nodeBox:getContentSize().width * - 0.5,0)
	self.nodeBox:setVisible(false)
end

--[[
	创建角色身后的 尾兽动画 
--]]
function TailSkillNode:createPetAnim()
	
		  --发送技能特效开启事件
    BattleEvent:dispatchEvent({
      name    = BattleEvent.TAIL_SKILL_EFFECT_BEGIN,
      sender  = self.owner,
      skillId = self.skillId,
    })


	local animNode = GafAssetCache.makeAnimatedObject(string.format("pet_%s", self.skill.image))

	local function onFrame(frame,finish)
		local frameMap = self.skill.frameMap
		
        if finish then

        	 BattleEvent:dispatchEvent({
		      name    = BattleEvent.TAIL_SKILL_EFFECT_END,
		      sender  = self.owner,
		      skillId = self.skillId,
		    })

       		animNode:stop()
            animNode:setVisible(false)

            self:createAnimNode()

            animNode:unregisterScriptHandler()
            animNode:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.RemoveSelf:create()))
         end
    end


	animNode:setDelegate()
	animNode:registerScriptHandler(onFrame)
	animNode:setLocalZOrder(self.owner:getLocalZOrder()-1)
	
	local p1 = cc.p(self.owner:getPositionX(),self.owner.model.nodeSize.height + 70)
	if self.camp == GameCampType.left then
		local p2 = cc.p(animNode:getFrameSize().width * -0.5, animNode:getFrameSize().height - 440)
		animNode:setPosition(cc.pAdd(p1,p2))
		animNode:setScaleX(1)
	else
		local p2 = cc.p(animNode:getFrameSize().width * 0.5, animNode:getFrameSize().height - 440)
		animNode:setPosition(cc.pAdd(p1,p2))
		animNode:setScaleX(-1)
	end

	animNode:addTo(self.owner:getParent())
	animNode:start()

end

--[[
	创建特效动画
--]]
function TailSkillNode:createAnimNode()
	
	local function onFrame(frame,finish)
		
		local frameMap = self.skill.frameMap
		if 	table.keyof(frameMap,string.format("%d",frame)) == nil and finish == false then
			return
		end

        if finish then
       		self.animNode:stop()
            self.animNode:unregisterScriptHandler()
            -- self:removeFromParent()
            self:runAction(cc.Sequence:create(cc.Hide:create(),cc.DelayTime:create(1),cc.RemoveSelf:create()))
        else

        	local isFinish = (table.nums(frameMap) == self.executeCount)
			local skillRatio = self.skill.ratioMap[self.executeCount]
			--owner.skillMgr:releaseSkillByNum(num,checknumber(skillRatio),isFinish)
			self:doRelease(checknumber(skillRatio),isFinish)
			self.executeCount = self.executeCount + 1
        end
    end

	self.animNode = GafAssetCache.makeAnimatedObject(self.skill.image)
	self.animNode:setDelegate()
	self.animNode:registerScriptHandler(onFrame)
	self.animNode:addTo(self)
	self.animNode:start()

	self:updateAnimNodeDirection(self.animNode)

end

--[[
	设置特效动画方向
--]]
function TailSkillNode:updateAnimNodeDirection(animNode)
	if self.camp == GameCampType.left then
		animNode:setPosition(animNode:getFrameSize().width * -0.5, animNode:getFrameSize().height - 440)
		animNode:setScaleX(1)
	else
		--todo
		animNode:setPosition(animNode:getFrameSize().width * 0.5, animNode:getFrameSize().height - 440)
		animNode:setScaleX(-1)
	end
end

--[[
	技能关键帧 执行的释放技能
--]]
function TailSkillNode:doRelease(skillRatio,isFinish)
	
	-- if self.recover > 0 then
	-- 	self.owner:doRecover(self.recover)
	-- end

	if isFinish and self.skill.myBuffId ~= "" then
		--todo 没有打到敌人时候是否也添加这个buff	
		self.owner.buffMgr:addBuff(self.skill.myBuffId, self.level)
	end

	self:doNearRelease(skillRatio,isFinish)

end

function TailSkillNode:doNearRelease(skillRatio,isFinish)
	
	
	local tb = BattleManager.findTailSkillRange(self) --self.owner:findSkillRange(self.skillId)

	table.walk(tb, function(v, k)
		local role = v
    	
    	--print("==="..self.skill.attackEffect.."==")
    	role:showEffect(self.skill.attackEffect)
    	
    	role:doSkillDamage({
			attacker = nil,
			a_atk    = 0,
			a_m_atk  = 0,
			a_acp    = 0,
			a_m_acp  = 0,
			a_break  = 500,
			a_tumble = 500,
			a_lv     = 1
    	},{
    		skill_finish	   = isFinish,
			rate               = self.skill.rate,
			skill_ratio        = skillRatio,
			skill_damage       = self.skill.damage,
			skill_damage_ratio = self.skill.damage_ratio,
			damage_real        = self.skill.damage_real,
			damage_type        = self.skill.damage_type,
			crit_rate          = self.skill.crit_rate,
			crit_num           = self.skill.crit_num,
			buffId             = self.skill.buffId,
			buff_rate          = self.skill.buff_rate,
			level              = self.level
    	})

	end)
end

function TailSkillNode:pauseAll()
	self:pause()
end

function TailSkillNode:resumeAll()
	self:resume()
end

return TailSkillNode