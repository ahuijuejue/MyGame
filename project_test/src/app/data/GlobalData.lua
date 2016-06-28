
local GlobalData = class("GlobalData")


function GlobalData:ctor()
	local cfg = GameConfig["Global"]["1"]
	self.addPower 			= checknumber(cfg.LvUpEnergy) 		-- 升级增加体力
	self.sealBase 			= checknumber(cfg.SealGold) 		-- 封印消耗金币系数
	self.teamLevelMax 		= checknumber(cfg.PlayerLevelLimit) -- 战队等级上限

	self.arenaScoreWin 		= checknumber(cfg.ArenaWinScore) 	-- 竞技场胜利积分
	self.arenaScoreFailed 	= checknumber(cfg.ArenaLoseScore) 	-- 竞技场失败积分

	self.refreshTime 		= encodeTime(cfg.QuestRefreshTime) 	-- 重置时间

	self.powerRecover 		= checknumber(cfg.EnergyRecover) 	-- 体力恢复时间

	self.buyPower 			= checknumber(cfg.BuyEnergy) 		-- 购买一次获得体力的值

	self.sentMsgCold        = checknumber(cfg.ChatCD) 		    -- 发送消息冷却时间

	-- 人物属性
	self.typeDict = {}
	local typeCfg = GameConfig["nature"]
	for k,v in pairs(typeCfg or {}) do
		self.typeDict[v.type] = {
			id = v.type,
			info = v.keys, -- 属性对应的字段
			desc = v.info, -- 属性描述
		}
	end

	self.params = cfg

end

-- 根据类型id获取人物模型属性键值
function GlobalData:convertHeroType(typeId)
	return self.typeDict[typeId] or ""
end

-- 获取global参数
function GlobalData:getParam(key)
	return self.params[key]
end

return GlobalData

