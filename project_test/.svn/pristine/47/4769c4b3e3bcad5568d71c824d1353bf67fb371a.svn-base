
--
-- Author: zsp
-- Date: 2014-11-21 16:33:10
--
import(".node.GameNode")

--[[
	战斗对象管理类 物体的碰撞检测 场景宽度设置 获取队长 
--]]

BattleManager = {}

--[[
   队长数据
--]]
BattleManager.leader = {
	[GameCampType.left]  = {},
	[GameCampType.right] = {}
}

--[[
	可碰撞物体 角色 塔 钟
--]]
BattleManager.roles = {
	[GameCampType.left]  = {},
	[GameCampType.right] = {},
}

--[[
	飞行道具数据
--]]
BattleManager.missiles = {
	[GameCampType.left]  = {},
	[GameCampType.right] = {},
}


BattleManager.loots = {}
--掉落道具
BattleManager.items = {}

BattleManager.__removed = {}

--战斗屏幕范围宽度
BattleManager.sceneWidth = 0
--目标距离 逃跑关卡 和守护段卡
BattleManager.targetWidth = 0


--获取阻挡的 isAll 包括人
function BattleManager.hasObstruct(role,isAll)
	
	local tb = BattleManager.roles[role.enemyCamp]
	for k,v in pairs(tb) do
		if v:isActive() then
			 if isAll then
			 	 if cc.rectIntersectsRect(role:getNodeRect(),v:getNodeRect()) then
				 	return true
				 end
			 else
			 	if v.nodeType == GameNodeType.TOWER or v.nodeType == GameNodeType.CLOCK  then
			 		if cc.rectIntersectsRect(role:getNodeRect(),v:getNodeRect()) then
					 	return true
					end
			 	end
			 end
		end	
	end

	return false
end

--[[
	设置战斗场景可移动宽度
--]]
function BattleManager.setSceneWidth(width)
	-- 战斗地图的左右边界范围
	BattleManager.sceneWidth = width
end

function BattleManager.setTargetWidth(width)
	BattleManager.targetWidth = width
end

function BattleManager.removeLeader(camp)
	for i = #BattleManager.leader[camp], 1, -1 do
		table.remove(BattleManager.leader[camp])
	end	
end
--[[
	获取队长 如果队长不是活的 返回nil
--]]
function BattleManager.getLeader(camp)
	
	local tb = BattleManager.leader[camp]
	
	if table.nums(tb) == 0 then
		return nil
	end

	local leader = nil
	for k,v in pairs(tb) do
		if v and v:isVisible() then
			leader = v
			break
		end
	end
	
	if leader and leader:isActive() then
		return leader
	end

	return nil
end

function BattleManager.update( dt )
	-- body 优化不是每帧都检测碰撞
	BattleManager.updateMissiles()
	BattleManager.updateLoots()
	BattleManager.updateItems()
	BattleManager.updateRemove()

end

--[[
	添加角色
--]]
function BattleManager.addRole(role)
	if role.isLeader then
		 table.insert(BattleManager.leader[role.camp],role)
	end

	table.insert(BattleManager.roles[role.camp], role)
end

--[[
	添加试炼的钟
--]]
function BattleManager.addClock(clock)
	table.insert(BattleManager.roles[clock.camp], clock)
end

--[[
	添加塔
--]]
function BattleManager.addTower(tower)
	table.insert(BattleManager.roles[tower.camp], tower)
end

--[[
	添加飞行道具
--]]
function BattleManager.addMissile(missile)
	table.insert(BattleManager.missiles[missile.camp], missile)
end

--[[
	添加奖励  暂时没用
--]]
function BattleManager.addLoot(loot)
	table.insert(BattleManager.loots, loot)
end

--[[
	添加掉落道具
--]]
function BattleManager.addItem(item)
	table.insert(BattleManager.items,item)
end

--[[
	获取角色
--]]
function BattleManager.getRolesByCamp(camp)
	return BattleManager.roles[camp]
end

--[[
	获取飞行道具
--]]
function BattleManager.getMissiles(camp)
	return BattleManager.missiles[camp]
end

--[[
	获取站礼品
--]]
function BattleManager.getLoots()
	-- body
	return BattleManager.loots
end

--[[
	更新删除
--]]
function BattleManager.updateRemove()
	if table.nums(BattleManager.__removed) then
		--todo
		local num = BattleManager.removeNodes(BattleManager.roles[GameCampType.left])
		--BattleManager.addKill(GameCampType.left,num)

		num = BattleManager.removeNodes(BattleManager.roles[GameCampType.right])
		--BattleManager.addKill(GameCampType.right,num)
		
		BattleManager.removeNodes(BattleManager.missiles[GameCampType.left])
		BattleManager.removeNodes(BattleManager.missiles[GameCampType.right])
		BattleManager.removeNodes(BattleManager.loots)
		BattleManager.removeNodes(BattleManager.items)
	end
end

--[[
	删除有删除标记节点的node
--]]
function BattleManager.removeNodes(tb)
	for key, value in pairs(tb) do  
    	if value.remove == true then
    		table.insert(BattleManager.__removed,key)
    	end
	end 

	local num = table.nums(BattleManager.__removed)

	for i = #BattleManager.__removed, 1, -1 do
		tb[BattleManager.__removed[i]]:destory()
		tb[BattleManager.__removed[i]]:removeFromParent(true)
   		table.remove(tb,BattleManager.__removed[i])
    end

    BattleManager.__removed = {}
    --删除的数量
    return num
end

function BattleManager.updateMissiles()

	table.walk(BattleManager.missiles[GameCampType.left], function(v, k)
    	BattleManager.collisionMissile(v,BattleManager.roles[GameCampType.right])
	end)

	table.walk(BattleManager.missiles[GameCampType.right], function(v, k)
    	BattleManager.collisionMissile(v,BattleManager.roles[GameCampType.left])
	end)

end

function BattleManager.updateLoots()
	-- body
end

function BattleManager.updateItems()
	for k,v in pairs(BattleManager.items) do
		local role = BattleManager.getLeader(GameCampType.left)
		if role then
			BattleManager.collisionItem(v,role)
		end
	end
end

--[[
	todo 碰撞爆炸逻辑
--]]
function BattleManager.collisionMissile(missile,roles)

	if missile == nil or  not missile:isActive() then
		return
	end

	for k = 1, #roles do
		local role = roles[k]
		if role == nil or not role:isActive() then
			
		else
			
			if cc.rectIntersectsRect(missile:getNodeRect(),role:getNodeRect()) then
				if missile.touching then
					--todo
				else
     	-- 			--判断是否为技能伤害 
     	-- 			if missile.skillData then
  				-- 		--技能是一个爆炸范围的伤害
 					-- 	local tb = BattleManager.roles[missile.enemyCamp]
						-- table.walk(tb,function(v,k)
						-- 	if v:isActive() == false then
						-- 		--不是活动的节点
						-- 	elseif not cc.rectIntersectsRect(missile:getBombRect(),v:getNodeRect())  then
						-- 		--不在检测范围
						-- 	else
						-- 		v:showEffect(missile.attackEffect) 
						-- 		v:doSkillDamage(missile.attackerData, missile.skillData)
						-- 	end
						-- end)
     	-- 			else
     	-- 				role:showEffect(missile.attackEffect) 
     	-- 				role:doDamage(missile.attackerData)
     	-- 			end

     				if missile:isBomb() then
 						local tb = BattleManager.roles[missile.enemyCamp]
						table.walk(tb,function(v,k)
							if v:isActive() and  cc.rectIntersectsRect(missile:getBombRect(),v:getNodeRect()) then
								
								v:showEffect(missile.attackEffect)
								
								if missile.skillData  then
									v:doSkillDamage(missile.attackerData, missile.skillData)
								else
									v:doDamage(missile.attackerData)
								end	

								if missile.buffId ~= "" then
									if missile.rate * 100 >= math.random(0,100) then
										v.buffMgr:addBuff(missile.buffId, 1, nil)
									else
										printInfo("角色roleId = %s 闪避了buff buffId = %s",self.roleId,s_buffId)
									end
								end
							end
						end)
     				else
     					role:showEffect(missile.attackEffect)
								
						if missile.skillData  then
							role:doSkillDamage(missile.attackerData, missile.skillData)
						else
							role:doDamage(missile.attackerData)
						end	

						if missile.buffId ~= "" then
							if missile.rate * 100 >= math.random(0,100) then
								role.buffMgr:addBuff(missile.buffId, 1, nil)
							else
								--printInfo("角色roleId = %s 闪避了buff buffId = %s",self.roleId,s_buffId)
							end
						end
     				end

					missile.touching = true

					--不穿透
					if  missile.strike == 1 then
						--todo
						missile:stopAllActions()
						missile.dead = true
						missile.remove = true
					end
				end

			else
				missile.touching = false
			end
		end
	end
end

function BattleManager.collisionLoot()
	-- body
end

function BattleManager.collisionItem(item,role)

	if cc.rectIntersectsRect(item:getNodeRect(),role:getNodeRect()) then
		if item:isActive() then
			AudioManage.playSound("FightAwardFly.mp3",false)

			local buffId = item.buffId
			item.dead = true
			item.remove = true
			role.buffMgr:addBuff(buffId, 1, nil)
		end
	end
end

--[[
	查找视野范围内有没有敌人
--]]
function BattleManager.hasViewRange(role)
	
	if role:getViewRect().width == 0 then
		--视野范围是0的就不检查了
		
		return false
	end

	local enemies = BattleManager.roles[role.enemyCamp]
	
	for k,v in pairs(enemies) do

		if v == role then
			--todo
		elseif v.dead then
			--todo
		elseif v.remove then

		elseif not v:isVisible() then

		elseif not cc.rectIntersectsRect(role:getViewRect(),v:getNodeRect()) then

		else
			return true
		end
	end
	
	return false
end

--[[
	查找视野范围内有没有敌人
--]]
function BattleManager.hasAttackRange(role)
	-- body
	if role:getAttackRect().width == 0 then
		--攻击范围是0的就不检查了
		return false
	end

	local enemies = BattleManager.roles[role.enemyCamp]
	
	for k,v in pairs(enemies) do

		if v == role then
			--todo
		elseif v.dead then
			--todo
		elseif v.remove then

		elseif not v:isVisible() then

		elseif not cc.rectIntersectsRect(role:getAttackRect(),v:getNodeRect()) then

		else
			return true
		end
	end
	
	return false
end


--[[
	查找视野范围内的敌人
--]]
function BattleManager.findViewRange(role)
	-- body
	local enemies = BattleManager.roles[role.enemyCamp]
	local result  = {}
	
	table.walk(enemies,function(v,k)
		if v == role then
			--todo
		elseif v.dead then
			--todo
		elseif v.remove then

		elseif not v:isVisible() then
			--todo
		elseif not cc.rectIntersectsRect(role:getViewRect(),v:getNodeRect()) then

		else
			result[k] = v
		end

	end)

	return result
end


--[[
	查找攻击范围内的敌人
--]]
function BattleManager.findAttackRange(role)
	-- body

	local enemies = BattleManager.roles[role.enemyCamp]
	local result = {}
	
	table.walk(enemies,function(v,k)
		
		if v == role then

		elseif v.dead then
			
		elseif v.remove then

		elseif not v:isVisible() then
			
		elseif not cc.rectIntersectsRect(role:getAttackRect(),v:getNodeRect()) then

		else
			result[k] = v
		end

	end)

	return result
end

--[[
	查找近战攻击范围内最进的一个敌人
--]]
function BattleManager.findOneAttackRange(role)
	-- body
	local enemies = BattleManager.roles[role.enemyCamp]
	
	local enemy = nil

	for k, v in pairs(enemies) do
		if v:isActive() and cc.rectIntersectsRect(role:getAttackRect(),v:getNodeRect()) then

			if enemy == nil then
				enemy = v
			else
				local x1,y1 = role:getPosition()
				local x2,y2 = v:getPosition()
				local x3,y3 = enemy:getPosition()
				
				local a = x1 - x2
				local b = x1 - x3

				if math.abs(a) < math.abs(b) then
					enemy = v
				end
				
			end
    	end
	end

	return enemy
end

--[[
	todo 优化目标，实现一个通用的技能筛选器 和findTailSkillRange合并成一个
	并提供分次和随机筛选的配置逻辑
--]]
function BattleManager.findSkillRange(role,skillId)
	
	local cfg       = GameConfig.skill[skillId]
	local target    = checkint(cfg["target"])
	local targetNum = checkint(cfg["num"])
	
	local result = {}

	local filter = function(v,k)
		if v:isActive() and  
			cc.rectIntersectsRect(role:getSkillRect(skillId),v:getNodeRect()) then			
			table.insert(result,v)
		end
	end

	if target == 0 then
		return  result
	elseif target == 1  then
		table.walk(BattleManager.roles[role.enemyCamp],filter)
		return result
	elseif target == 2 then
		table.walk(BattleManager.roles[role.camp],filter)
		return result
	elseif target == 3 then
		table.insert(result,role)
		return  result
	elseif target == 4 then
		table.walk(BattleManager.roles[role.enemyCamp],filter)
		return result
	elseif target == 5 then
		table.walk(BattleManager.roles[role.camp],filter)
		table.sort(result,function(a,b)
			return a.model.hp < b.model.hp
		end)

		if targetNum > 0  and table.nums(result) > 0 then
			local tb = {}
			local i = 1
			for k,v in pairs(result) do
				if i<= targetNum then
					table.insert(tb,v)
				end
				i = i + 1
			end
			return tb
		end
		return result

	elseif target == 6 then
		table.walk(BattleManager.roles[role.enemyCamp],filter)
		table.sort(result,function(a,b)
			return a.model.hp < b.model.hp
		end)

		if targetNum > 0  and table.nums(result) > 0 then
			local tb = {}
			local i = 1
			for k,v in pairs(result) do
				if i<= targetNum then
					table.insert(tb,v)
				end
				i = i + 1
			end
			return tb
		end
		return result
	elseif target == 7 then
		table.walk(BattleManager.roles[role.enemyCamp],filter)
		table.sort(result,function (a,b)
			local x1 = a:getPositionX()
			local x2 = b:getPositionX()
			return x1 < x2
		end)
		local tb = {}
		for i,v in ipairs(result) do
			if i <= targetNum then
				table.insert(tb,v)
			end
		end
		return tb
	elseif target == 8 then
		table.walk(BattleManager.roles[role.enemyCamp],filter)
		table.sort(result,function (a,b)
			local x1 = a:getPositionX()
			local x2 = b:getPositionX()
			return x1 > x2
		end)
		local tb = {}
		for i,v in ipairs(result) do
			if i <= targetNum then
				table.insert(tb,v)
			end
		end
		return tb
	end
end

--[[
	todo 优化逻辑 获取尾兽技能范围
--]]
function BattleManager.findTailSkillRange(skillNode)
	
	local cfg       = GameConfig.skill_tails[skillNode.skillId]
	local target    = checkint(cfg["target"])
	local targetNum = checkint(cfg["num"])
	
	local result = {}

	local filter = function(v,k)
		if v:isActive() and  
			cc.rectIntersectsRect(skillNode:getNodeRect(),v:getNodeRect()) then
			table.insert(result,v)
		end
	end

	if target == 0 then
		return  result

	elseif target == 1  then
		--todo
		table.walk(BattleManager.roles[skillNode.enemyCamp],filter)
		return result

	elseif target == 2 then

		table.walk(BattleManager.roles[skillNode.camp],filter)
		return result

	elseif target == 3 then
		table.insert(result,skillNode.owner)
		return  result
	
	elseif target == 4 then

		table.walk(BattleManager.roles[skillNode.enemyCamp],function(v,k)
			if v:isActive() and  
			--v.nodeType == GameNodeType.ROLE and 
			cc.rectIntersectsRect(skillNode:getNodeRect(),v:getNodeRect()) then
			
				table.insert(result,v)

			end
		end)
		
		return result
	elseif target == 5 then
		--todo
		table.walk(BattleManager.roles[skillNode.camp],filter)
		table.sort(result,function(a,b)
			return a.model.hp < b.model.hp
		end)

		if targetNum > 0  and table.nums(result) > 0 then
			local tb = {}
			local i = 1
			for k,v in pairs(result) do
				if i<= targetNum then
					table.insert(tb,v)
				end
				i = i + 1
			end
			return tb
		end
		return result

	elseif target == 6 then
		table.walk(BattleManager.roles[skillNode.enemyCamp],filter)
		table.sort(result,function(a,b)
			return a.model.hp < b.model.hp
		end)

		if targetNum > 0  and table.nums(result) > 0 then
			local tb = {}
			local i = 1
			for k,v in pairs(result) do
				if i<= targetNum then
					table.insert(tb,v)
				end
				i = i + 1
			end
			return tb
		end
		return result
	end
end

--根据条件获取
function BattleManager.find(fn)
	
	local result = {}

	table.walk(BattleManager.roles[GameCampType.left],function(v,k)
		if fn(v, k) then
			--todo
			--result[k] = v
			table.insert(result,v)
		end
	end)

	table.walk(BattleManager.roles[GameCampType.right],function(v,k)
		if fn(v, k) then
			--todo
			--result[k] = v
			table.insert(result,v)
		end
	end)
	
	return result
end

--[[
  暂停全部
--]]
function BattleManager.pauseAll(exRole)
  local roles = BattleManager.getRoles(exRole)

  table.walk(roles,function(v,k) v:pauseAll() end)

  BattleManager.missilesIterator(function (v,k) v:pauseAll() end)

  -- 还需暂停塔
end

--[[
	恢复暂停
--]]
function BattleManager.resumeAll(exRole)
  local roles = BattleManager.getRoles(exRole)
  table.walk(roles,function(v,k) v:resumeAll() end)

  BattleManager.missilesIterator(function (v,k) v:resumeAll() end)

  -- 还需要恢复塔
end

--[[
    获取除了exRole之外的角色
--]]
function BattleManager.getRoles(exRole)
  
  local roles = BattleManager.find(function(v,k)
    
    if exRole then
       if v.roleId == exRole.roleId and v.camp == exRole.camp then
         	return false
       end
    end

    if v:isVisible() == false or v.remove == true then
      	return false
    end
   
    return true
  
  end)

  return roles
end

--[[
	遍历角色
--]]
function BattleManager.roleIterator(fn)

	table.walk(BattleManager.roles[GameCampType.left],function(v,k)
		if v.nodeType == GameNodeType.ROLE then
			fn(v, k)
		end
	end)

	table.walk(BattleManager.roles[GameCampType.right],function(v,k)
		if v.nodeType == GameNodeType.ROLE then
			fn(v, k)
		end
	end)
end

--[[
	便利角色 塔
--]]
function BattleManager.nodeIterator(fn)

	table.walk(BattleManager.roles[GameCampType.left],function(v,k)
		fn(v, k)
	end)

	table.walk(BattleManager.roles[GameCampType.right],function(v,k)
		fn(v, k)
	end)
end

--[[
	遍历飞行道具
--]]
function BattleManager.missilesIterator(fn)

	table.walk(BattleManager.missiles[GameCampType.left],function(v,k)
		fn(v, k)
	end)

	table.walk(BattleManager.missiles[GameCampType.right],function(v,k)
		fn(v, k)
	end)
end


--[[
	重置初始化战斗管理对象
--]]
function BattleManager.reset()
	BattleManager.sceneWidth = 0

	for key, value in pairs(BattleManager.roles[GameCampType.left]) do  
    	value:destory()
	end

	for key, value in pairs(BattleManager.roles[GameCampType.right]) do  
    	value:destory()
	end

	for key, value in pairs(BattleManager.missiles[GameCampType.left]) do  
    	value:destory()
	end

	for key, value in pairs(BattleManager.missiles[GameCampType.right]) do  
    	value:destory()
	end

	BattleManager.roles[GameCampType.left]     = nil 
	BattleManager.roles[GameCampType.right]    = nil  
	BattleManager.missiles[GameCampType.left]  = nil 
	BattleManager.missiles[GameCampType.right] = nil  
	BattleManager.loots                        = nil
	BattleManager.items                        = nil
	BattleManager.__removed                    = nil
	
	BattleManager.roles[GameCampType.left]     = {} 
	BattleManager.roles[GameCampType.right]    = {}   
	BattleManager.missiles[GameCampType.left]  = {}  
	BattleManager.missiles[GameCampType.right] = {}   
	
	BattleManager.removeLeader(GameCampType.left)
	BattleManager.removeLeader(GameCampType.right)

	BattleManager.loots     = {} 
	BattleManager.items     = {}
	BattleManager.__removed = {} 
end

return BattleManager