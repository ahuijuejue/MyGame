--
-- Author: zsp
-- Date: 2015-07-10 17:07:16
--

local BattleEvent   = require("app.battle.BattleEvent")

--[[
 	出兵创建点,添加到BattleLogic中
--]]
local CreatePoint = class("CreatePoint", function()
	return display.newNode()
end)

function CreatePoint:ctor(params)
	self.waveId    = params.waveId
	self.waveTableName = params.waveTableName or "wave" 
	self.interval  = params.interval
	self.waveNum   = params.waveNum
	self.logic     = params.logic

	-- 每波出现的最多敌人种类数量
	self.maxNum = 5
	--创建完成标记，出兵后设置true
	self.remove = false
end

--[[
	开始创建出一波兵
--]]
function CreatePoint:doCreate()
	local waveData = GameConfig[self.waveTableName][self.waveId]
	local waveEnemies = {}

	for i = self.maxNum,1,-1 do
		if self.logic.treeCustomId then
			local customData = GameConfig.tree_custom[self.logic.treeCustomId]
			local eid = waveData[string.format("enemy%d",i)]
			local elv = customData.lv
			local slv = customData.lv
			local num = checkint(waveData["number"..i])
			for k=1,num do
				table.insert(waveEnemies,{
					enemyId = eid,
					enemyLv = elv,
					skillLv = slv
				})
			end
		else
			local eid = waveData[string.format("enemy%d",i)]
			local elv = math.max(checkint(waveData[string.format("enemy%d_lv",i)]),1)
			local slv = math.max(checkint(waveData[string.format("enemy%d_skill_lv",i)]),1)
			local num = checkint(waveData["number"..i])
			for k=1,num do
				table.insert(waveEnemies,{
					enemyId = eid,
					enemyLv = elv,
					skillLv = slv
				})
			end
		end
	end

	local bossFlag = false
	for k,v in pairs(waveEnemies) do
		if GameConfig.enemy[v.enemyId].boss == "1" then
			bossFlag =  true
		end
	end

	local createCount = table.nums(waveEnemies)

	BattleEvent:dispatchEvent({
		name      = BattleEvent.LOGIC_CREATE_WAVE,
		waveTotal = self.logic.waveTotal,
		currWave  = self.waveNum,
		count     = createCount,
		hasBoss   = bossFlag
    })

	self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(self.interval),cc.CallFunc:create(function()

		if table.nums(waveEnemies) == 0 then
			self:setVisible(false)
			self.remove = true
			self:stopAllActions()
			
		else
			local data = waveEnemies[table.nums(waveEnemies)]
			table.remove(waveEnemies)

			self.logic.createdNum = self.logic.createdNum + 1
			
			local eventData = {
				name       = BattleEvent.LOGIC_CREATE_ENEMY,
				enemyId    = data.enemyId,
				enemyLv    = data.enemyLv,
				skillLv    = data.skillLv,
				createdNum = self.logic.createdNum,
				createX    = self:getPositionX()
            }
			BattleEvent:dispatchEvent(eventData)
		end
	end))))

	--创建伏兵波，会增加出兵总数，保证杀光判断正确性
	if not self.waveNum then
		self.logic.enemiesTotal = self.logic.enemiesTotal + createCount
	end

	self.logic.createTotal = self.logic.createTotal + createCount

	return createCount 
end

return CreatePoint