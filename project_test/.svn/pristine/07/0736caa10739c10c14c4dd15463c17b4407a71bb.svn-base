--
-- Author: zsp
-- Date: 2014-11-23 11:15:09
--

local BattleEvent   = require("app.battle.BattleEvent")
local BattleManager = require("app.battle.BattleManager")
local DropManager   = require("app.battle.DropManager")
local TriggerPoint  = require("app.battle.TriggerPoint")
local CreatePoint   = require("app.battle.CreatePoint")

--[[
	出兵逻辑管理,关卡和时间屋试炼副本通用
	出兵点必须是左至右顺序出兵，1波2波3波
	默认有按波数创建的触发出兵点，还有不同类型触发伏兵的点，
	具体出兵逻辑参考：出兵机制文档中
--]]
local BattleLogic = class("BattleLogic")

-- 每波出现的最多敌人种类数量
local WAVE_ENEMY_TYPE_MAX = 5

function BattleLogic:ctor(params)
  	
  	--cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	self.isPaused         = false --暂停
	
	self.createTotal      = 0 --已经创建的敌人数量
	self.createdNum       = 0 --正在创建的敌人数量
	self.enemiesTotal     = 0 --此关卡会出现的敌人总数,触发伏兵后会增加此数量
	self.createInterval   = 0.5 --创建每个敌人时间间隔
	self.currWave         = 1 --当前的波次 todo 同时出发多个波次 
	
	self.waveData         = {} --每波敌人的数据
	--self.waveEnemies      = {} --每波的敌人

	-- 正常波次的出兵触发点,触发后立即删除，保证只能被触发一次
	self.triggerPointArr = {}
	-- 正常波次的出兵点，兵出完后，立即删除
	self.createPointArr = {}

	self.customId      = params.customId --params.customId		--关卡id
	self.wave          = params.wave --有wave参数是副本玩法， customId必须会是nil
	self.play          = params.play -- 关卡玩法类型
	self.triggerRole   = params.triggerRole -- 触发初定的角色
	self.parent        = params.parent -- 装出发点和出兵点的父节点，应该是战场上的主mainLayer节点
	self.waveTableName = params.waveTableName or "wave" -- 默认是wave表 ，世界树用的是tree_wave
	self.extraWave     = params.extraWave --伏兵数据,世界树是外部参数传入
	self.treeCustomId = params.treeCustomId

 	--副本玩法没有customId
	if self.play then
		local data = GameConfig.custom[params.customId]
		self.wave = data["wave"] or ""
		--关卡内塔的数量
		self.towersTotal = self:getTowersTotal(self.customId)

		--添加关卡的伏兵数据
		if data.condition then
			self.extraWave = {}
			self.extraWave["condition"] = data.condition
			self.extraWave["keys"]      = data.keys
			self.extraWave["wave_pos"]  = data.wave_pos
			self.extraWave["wave_wave"] = data.wave_wave
		end
	end

	--读取wave配置 初始化关卡的波数据和波内敌人数据
	local array  = string.split(self.wave, ",")
	self.waveTotal = table.nums(array)
   
   	for i=1, #array do
   		local w = GameConfig[self.waveTableName][array[i]]
   		self.waveData[i] = w

		local createNode = CreatePoint.new({
			["waveTableName"] = self.waveTableName,
			["waveId"]      = array[i],
			["interval"]    = self.createInterval,
			["waveNum"]     = i,
			["waveTotal"]   = table.nums(array),
			["logic"]       = self,
		})
		
		table.insert(self.createPointArr,createNode)
		local triggerNode = TriggerPoint.new({
			["type"]        = 2,
			["waveNum"]     = i,
			["createPoint"] = createNode
		})

		table.insert(self.triggerPointArr,triggerNode)

   		--普通关卡按配置设置出兵点和出发点
   		if self.play then
			local posData = GameConfig.custom_pos[tostring(self.play)]
			local chu_x   = checkint(posData[string.format("chu_%d",i)])
			local pos_x   = checkint(posData[string.format("pos_%d",i)])
			
			triggerNode:setPosition(chu_x,250)
			createNode:setPosition(pos_x,250)
		else
		-- 试炼关卡默认配置地图终点
			triggerNode:setPosition(0,250)
			createNode:setPosition(BattleManager.sceneWidth,250)
   		end

   		if self.parent then
			triggerNode:addTo(self.parent)
			createNode:addTo(self.parent)
		end
   	end

   	self.enemiesTotal = self:getEnemiesTotalByWave(self.waveTotal)

   	if self.extraWave and self.extraWave.condition then	
   		for i=1,#self.extraWave.condition do
   			local cond = self.extraWave.condition[i]
   			local key = checkint(self.extraWave.keys[i])
   			local pos = checkint(self.extraWave.wave_pos[i])
   			local wid = self.extraWave.wave_wave[i]
   			self[string.format("conditionTrigger%s",cond)](self,key,pos,wid)
   		end
   	end

   	--记录角色死亡数量
	self.kills = {
		[GameCampType.left] = {
			[GameNodeType.ROLE] = 0,
			[GameNodeType.TOWER] = 0,
		},
		[GameCampType.right] = {
			[GameNodeType.ROLE] = 0,
			[GameNodeType.TOWER] = 0,
		}
	}

	if params.gold or params.item then
		self.dropMgr = DropManager.new(self.waveTotal,params.gold,params.item)
	end

	-- 试炼关卡 新手引导 自动出兵
	--如果不是护送玩法 正常出兵
	if not self.play or self.play ~= 3 then
		for k,v in pairs(self.triggerPointArr) do
			if v.waveNum == 1 then
				v:doTrigger()
			end
		end		
	end
end

--[[
 	刷新执行
--]]
function BattleLogic:update(dt , totalFrame)
	
	if self.isPaused then
		return
	end

    if totalFrame % 5 ~= 0 then
        return
    end

    for k,v in pairs(self.triggerPointArr) do
    	if not v.remove and v.type == 2 then
    		local role = nil
    		if self.triggerRole then
    			if self.triggerRole:isActive() then
				 	role = self.triggerRole
				elseif self.triggerRole.evolveNode and self.triggerRole.evolveNode:isActive() then
				 	role = self.triggerRole
				end
    		end

			if role then
    			local rect = cc.rect(role:getPositionX(),role:getPositionY(),role.nodeBox:getContentSize().width,role.nodeBox:getContentSize().height)
		 		local point = cc.p(v:getPositionX(),v:getPositionY())
		 		if cc.rectContainsPoint( rect , point) then
		 			v:doTrigger()
		 		end
    		end
    	end

    end

    --如果是护送玩法 不自动出兵
    if self.play ~= 3 then
    	--当前杀敌数
		local kills = self.kills[GameCampType.right][GameNodeType.ROLE]
		-- 按触发点获取已触发多少敌人
		local num =  math.max(self.createTotal,self:getEnemiesTotalByWave(self.currWave))
		
		--按当前波次获取已经创建了多少个敌人
		--self:getEnemiesTotalByWave(self.currWave)

		--消灭完一波人了，自动出下一波，
		--todo 优化循环
		if kills == num then
			local waveTriger = {}
			for k,v in pairs(self.triggerPointArr) do
				if v.waveNum then
					waveTriger[v.waveNum] = v
				end
			end

			for i=1,#waveTriger do
				if not waveTriger[i].remove then
					self.currWave = i
					waveTriger[i]:doTrigger()
					return
				end
			end
		end
    end
end


--[[
	获取关卡敌人的塔总数
--]]
function BattleLogic:getTowersTotal(customId)
	local towersTotal = 0

	local cfg = GameConfig.custom[customId].tower
    if not cfg then
      return towersTotal 
    end

    local table = string.split(cfg, ":")

    for k,v in pairs(table) do
		local data = string.split(v, ",")
		local towerId = data[1]
		local towerType = checkint(GameConfig.tower[towerId])
		--塔防关卡，必须打碎全部的塔（不包括无敌塔）增加敌人总数 结算判断用
		if towerType == 1 or 
		   towerType == 2 or
		   towerType == 3 
		then
			 towersTotal = towersTotal + 1
		end
    end

    return towersTotal
end

--[[
	敌人是否全部死亡
--]]
function BattleLogic:isKillEnemyies()
	-- body
	 local k = self.kills[GameCampType.right][GameNodeType.ROLE] 
	 local t = self.enemiesTotal
	 printInfo("杀光敌人判断 kills ==== %d , enemiesTotal ==== %d ",k,t)
	 return k == t
end

-- function BattleLogic:isKillTowers()
-- 	-- body
-- 	 return self.kills[GameCampType.right][GameNodeType.TOWER] == self.towersTotal
-- end

--[[
	添加死亡对象记录
--]]
function BattleLogic:addKill(campType,dead)
	self.kills[campType][dead.nodeType] = self.kills[campType][dead.nodeType] + 1
end


--[[
	敌人死亡后的掉落
--]]
function BattleLogic:drop(dead)
	
	if not self.dropMgr then
		return nil
	end
	--当前波死亡的boss
	if dead.model.boss then
		return self.dropMgr:onDrop(self.currWave,dead)
	end

	--当前波次最后一个死亡的
	local num = self:getEnemiesTotalByWave(self.currWave)
	if self.kills[dead.camp][GameNodeType.ROLE] == num then
		return self.dropMgr:onDrop(self.currWave,dead)
	end

	return nil
end

--[[
	这一波是否有boss
--]]
function BattleLogic:hasBossInWave(waveEnemies)

	-- for i=1,table.nums(self.waveBoss) do
	-- 	if i == checkint(self.waveBoss[i]) then
	-- 		return true
	-- 	end
	-- end

	-- return false
	
	-- if table.keyof(self.waveBoss,string.format("%d",wave)) then
	-- 	return true
	-- else
	-- 	return false
	-- end

	if not waveEnemies then
		return false
	end

	for k,v in pairs(waveEnemies) do
		if GameConfig.enemy[v.enemyId].boss == "1" then
			return true
		end
	end

	return false
end


--[[
	达到某波次会出现的敌人总数
--]]
function BattleLogic:getEnemiesTotalByWave( wave )
    
    local total = 0

    for i=1,wave do
    	total = total + self:getEnemiesByWave(i)
    end

    return total;
end

--[[
	某波次的敌人数量
--]]
function BattleLogic:getEnemiesByWave( wave )
	
	local total = 0;
	local data = self.waveData[wave]

	for i=1,WAVE_ENEMY_TYPE_MAX do
		local key = string.format("number%d",i)
		local num = checkint(data[key])
		total = total + num
	end

    return total

end

--[[
	随机洗牌
--]]
function BattleLogic:sortRandom( array )
	for i=1,#array do
		newrandomseed()
		local rmd = math.random(1,table.nums(array))
		local tmp = array[i]
		array[i] = array[rmd]
		array[rmd] = tmp
	end
end

--[[
	设置暂停
--]]
function BattleLogic:setPause(pause)
	self.isPaused = pause
	--todo 暂停子节点动画

	if pause then
		for k,v in pairs(self.triggerPointArr) do
			v:pause()
		end

		for k,v in pairs(self.createPointArr) do
			v:pause()
		end
	else
		for k,v in pairs(self.triggerPointArr) do
			v:resume()
		end

		for k,v in pairs(self.createPointArr) do
			v:resume()
		end
	end
end

--[[
	战斗结束时调用，防止在触发出现伏兵
--]]
function BattleLogic:stopLogic()

end

--[[
	按关卡条件1触发，敌方第K个塔受伤,
	调用此方法必须是在战斗场景创建敌方塔后调用
--]]
function BattleLogic:conditionTrigger1(key,pos,wave)
	-- 获取地几个塔 添加触发点 
	-- todo 按位置排序由左至右第几个塔

	local tb = BattleManager.roles[GameCampType.right]

	local towers = {}
	for k,v in pairs(tb) do
		if v.nodeType == GameNodeType.TOWER then
			table.insert(towers,v)
		end
	end

	function comps(a,b)
		return a:getPositionX() < b:getPositionX()
	end

	table.sort(towers,comps)

	if towers[key] then
		
		local createNode = CreatePoint.new({
			["waveTableName"] = self.waveTableName,
			["waveId"]    = wave,
			["interval"]  = self.createInterval,
			["logic"]     = self,
		})
		
		createNode:setPosition(pos,250)
		createNode:addTo(self.parent)
		table.insert(self.createPointArr,createNode)

		local triggerNode = TriggerPoint.new({
			["type"]        = 1,
			["createPoint"] = createNode
		})

		triggerNode:setPosition(towers[key]:getPositionX(),450)
		triggerNode:addTo(self.parent)
		table.insert(self.triggerPointArr,triggerNode)

		towers[key]:addTrigger(triggerNode)
	end

end

--[[
	按关卡条件2触发，移动到某个位置
--]]
function BattleLogic:conditionTrigger2(key,pos,wave)

	local createNode = CreatePoint.new({
		["waveTableName"] = self.waveTableName,
		["waveId"]    = wave,
		["interval"]  = self.createInterval,
		["logic"]     = self,
	})
	
	createNode:setPosition(pos,250)
	createNode:addTo(self.parent)
	table.insert(self.createPointArr,createNode)

	local triggerNode = TriggerPoint.new({
		["type"]        = 2,
		["createPoint"] = createNode
	})

	triggerNode:setPosition(key,250)
	triggerNode:addTo(self.parent)
	table.insert(self.triggerPointArr,triggerNode)

end

--[[
	按关卡条件3触发，游戏开始k秒
--]]
function BattleLogic:conditionTrigger3(key,pos,wave)

local createNode = CreatePoint.new({
		["waveTableName"] = self.waveTableName,
		["waveId"]    = wave,
		["interval"]  = self.createInterval,
		["logic"]     = self,
	})
	
	createNode:setPosition(pos,250)
	createNode:addTo(self.parent)
	table.insert(self.createPointArr,createNode)

	local triggerNode = TriggerPoint.new({
		["type"]        = 3,
		["createPoint"] = createNode
	})

	triggerNode:setPosition(100,250)
	triggerNode:addTo(self.parent)
	table.insert(self.triggerPointArr,triggerNode)

	triggerNode:runAction(cc.Sequence:create(cc.DelayTime:create(key),cc.CallFunc:create(function()
		triggerNode:doTrigger()
	end)))
end


return BattleLogic