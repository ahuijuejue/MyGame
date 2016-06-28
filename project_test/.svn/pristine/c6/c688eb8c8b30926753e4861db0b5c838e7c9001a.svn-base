--
-- Author: zsp
-- Date: 2014-12-01 10:36:22
--

local GameNode      = import(".GameNode")
local MissileNode   = class("MissileNode", GameNode)

--[[
	战场上射出的武器 数据逻辑多在抽离model
--]]
function MissileNode:ctor(params)
	
	MissileNode.super.ctor(self)


	self.touching     = false
	self.missileId    = params.missileId
	self.owner        = params.owner
	self.camp         = params.camp or self.owner.camp
	self.enemyCamp    = params.enemyCamp or self.owner.enemyCamp
	self.distance     = params.distance + 50 -- 50 是修正值，打不到人 移动位置到了，判断检测帧数没到 
	self.attackerData = params.attackerData
	self.skillData    = params.skillData
	--在角色身上的y轴发射点
	self.launchY      = params.launchY or self.owner.model.nodeSize.height * 0.6
		
	self:setLocalZOrder(self.owner:getLocalZOrder())
	local cfg     = GameConfig.flys[self.missileId]
	self.strike   = checkint(cfg["strike"])
	self.buffId   = cfg["buff"] or ""
	self.rate     = checknumber(cfg["rate"])
	local img     = cfg["img"]
	local imgNum  = checkint(cfg["img_num"])
	local flyType = checkint(cfg["type"])
	local speed   = checkint(cfg["speed"])
	
	self.attackEffect    = cfg["atk_effect"]
	--self.attackEffectNum = checkint(cfg["atk_effect_num"])

	-- for i=1,self.attackEffectNum do
	-- 	--print(i)
	-- 	--CCTextureCache::sharedTextureCache()->addImage(sf("%s_%d.png",m_atkEff.c_str(),i));
	-- end

	if imgNum > 1 then
		self.sprite = display.newSprite(img.."_1.png")
	else
		self.sprite = display.newSprite(img..".png")
	end
	
	local size = self.sprite:getContentSize()
	--self.sprite:setPosition(size.width * -0.5,size.height * -0.5)
	self.sprite:addTo(self)

	self:setContentSize(size)

	if imgNum > 1 then
		local animation = cc.Animation:create()
		for i=1,imgNum do
			animation:addSpriteFrameWithFile(string.format("%s_%d.png",img,i))
		end
		animation:setDelayPerUnit(0.14)
		animation:setRestoreOriginalFrame(true)
		animation:setLoops(-1)

		local animate = cc.Animate:create(animation)
		self.sprite:runAction(animate)
	end

	--爆炸大小 和起始点偏移量 偏移量应该没什么用 通常用导弹的中心点为爆炸范围
	self.bombSize   = cc.size(checkint(cfg["bomb_box"][3]),checkint(cfg["bomb_box"][4]))
	--self.bombOffset = cc.p(checkint(cfg["bomb_origin_x"]), checkint(cfg["bomb_origin_y"]))

	--导弹飞行物的大小和起点偏移 偏移量是用图片的中心点为参考点
	self.nodeOffset = cc.p(checkint(cfg["body_box"][1]), checkint(cfg["body_box"][2]))
	self.nodeSize   = cc.size(checkint(cfg["body_box"][4]), checkint(cfg["body_box"][4]))

	self:createBoundingBox()

	if self.camp == GameCampType.left then
		self.sprite:flipX(true)
	else
		self.distance = self.distance * -1
	end

	local function deadCallback()
		-- body
		self.dead = true
	end

	local function feadOut()
		local action = transition.fadeOut(self.sprite, {time = 0.2})
	end

	local function removeCallback()
		-- body
		self.remove = true
	end

	if flyType == 1 then
		--todo
		local sequence = transition.sequence({
	   		ThrowAction:createForThrowFire(math.abs(self.distance) / speed ,self.distance,100,100),
		    cc.CallFunc:create(deadCallback),
		    cc.CallFunc:create(feadOut),
		    cc.DelayTime:create(1),
		    cc.CallFunc:create(removeCallback)
		})
		self:runAction(sequence);

	elseif flyType == 2 then
		--todo
		local sequence = transition.sequence({
	    	cc.MoveBy:create(math.abs(self.distance) / speed, cc.p(self.distance,0)),
		    cc.CallFunc:create(deadCallback),
		    cc.CallFunc:create(feadOut),
		    cc.DelayTime:create(1),
		    cc.CallFunc:create(removeCallback)
		})

		self:runAction(sequence);

	elseif flyType == 3 then
		--todo
		local sequence = transition.sequence({
	    	ThrowAction:createForFlatFire(math.abs(self.distance) / speed ,self.distance,self.launchY - self.sprite:getContentSize().width * 0.5),
		    cc.CallFunc:create(deadCallback),
		    cc.CallFunc:create(feadOut),
		    cc.DelayTime:create(1),
		    cc.CallFunc:create(removeCallback)
		})
		self:runAction(sequence);

	end

	BattleManager.addMissile(self)

end

function MissileNode:createBoundingBox()
	--节点的检测范围盒子
	self.nodeBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 255))
	self.nodeBox:setContentSize(self.nodeSize.width,self.nodeSize.height)
	self.nodeBox:addTo(self)
	self.nodeBox:setVisible(false)

	--在角色身上发射出的位置

	if self.camp == GameCampType.left then
		self.nodeBox:setPosition(self.nodeSize.height * -0.5 + 40, self.nodeSize.height * - 0.5 + 0)
		--self:setPosition(self.owner:getPositionX() + self:getContentSize().width * 0.5, self.owner:getPositionY() + launchY)
		self:setPosition(self.owner:getPositionX(), self.owner:getPositionY() + self.launchY)
	else
		self.nodeBox:setPosition(self.nodeSize.height * -0.5 - 40, self.nodeSize.height * - 0.5 + 0)
		--self:setPosition(self.owner:getPositionX() - self:getContentSize().width * 0.5, self.owner:getPositionY() + launchY)
		self:setPosition(self.owner:getPositionX(), self.owner:getPositionY() + self.launchY)
	end

	self.bombBox = cc.LayerColor:create(cc.c4b(255, 0, 0, 255))
	self.bombBox:setContentSize(self.bombSize.width,self.bombSize.height)
	self.bombBox:setPosition(self.bombSize.width * -0.5,self.bombSize.height * -0.5)
	self.bombBox:addTo(self)
	self.bombBox:setVisible(false)
end

function MissileNode:getBombRect()
	
	local pt = self.bombBox:convertToWorldSpace(cc.p(0,0))
	local bomRect  = cc.rect(0,0,0,0)
	bomRect.width  = self.bombBox:getContentSize().width
	bomRect.height = self.bombBox:getContentSize().height
	bomRect.x      = pt.x
	bomRect.y      = pt.y

	return bomRect
end

-- function MissileNode:bombAfterAddBuff()
-- 	-- body
-- 	local roles = BattleManager.roles[self.enemyCamp]
-- 	table.walk(roles,function(v,k)
-- 		if v:isActive() == false then
-- 			--不是活动的节点
-- 		elseif not cc.rectIntersectsRect(self:getBombRect(),v:getNodeRect())  then
-- 			--不在检测范围
-- 		else
-- 			v.buffMgr:addBuff(self.buffId,self.level,self.owner)
-- 		end
-- 	end)
-- end

function MissileNode:pauseAll()
	--print("暂停子弹")
	self.sprite:resume()
	self:pause()
end

function MissileNode:resumeAll()
	--print("恢复子弹")
	self.sprite:resume()
	self:resume()
end

--[[
	是否有爆炸
--]]
function MissileNode:isBomb()
	if self.bombSize.width > 0 then
	 	return true
	end 

	return false
end

return MissileNode