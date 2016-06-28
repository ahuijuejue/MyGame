
--[[
机器人数据
]]

local GameRobot = class("GameRobot")

function GameRobot:ctor(params)
	local cfg = params.cfg 

	self.id = params.id 
	self.evolveNum 		= checknumber(cfg.num_bian) 	-- 变身数量
	self.level 			= checknumber(cfg.lv) 			-- 等级 
	self.pz 			= checknumber(cfg.pz) 			-- 品质(影响边框)
	self.star 			= checknumber(cfg.star) 		-- 星级 

	self.roleData = {
		hp 	= checknumber(cfg.hp), 
		atk 	= checknumber(cfg.atk),
		m_atk 	= checknumber(cfg.m_atk), 
		defense 	= checknumber(cfg.defense),
		m_defense 	= checknumber(cfg.m_defense),
		acp 	= checknumber(cfg.acp),
		m_acp 	= checknumber(cfg.m_acp),
		rate 	= checknumber(cfg.rate),
		dodge 	= checknumber(cfg.dodge),
		crit 	= checknumber(cfg.crit),
		blood 	= checknumber(cfg.blood),
		breaks = checknumber(cfg.breaks),
		tumble = checknumber(cfg.tumble),
	}



end


return GameRobot
