
local OpenLvData = class("OpenLvData")
local GameOpenLv = import(".GameOpenLv")

--[[
OpenLvData.arena.openLv

]]

function OpenLvData:ctor()

	local cfg = GameConfig["Open_Level"]

	self:addConfig("hero", cfg.Hero) 					-- 英雄解锁等级
	self:addConfig("package", cfg.Bag) 					-- 背包解锁等级
	self:addConfig("shop", cfg.Shop) 					-- 商店解锁等级
	self:addConfig("shopScore", cfg.ScoreShop) 			-- 积分商店解锁等级
	self:addConfig("card", cfg.Card) 					-- 抽卡解锁等级
	self:addConfig("mail", cfg.Mail) 					-- 邮箱解锁等级
	self:addConfig("playerSet", cfg.PlayerSet) 			-- 玩家设置解锁等级
	self:addConfig("chat", cfg.Chat) 					-- 聊天解锁等级
	self:addConfig("sendMessage", cfg.SendMessage) 	    -- 发送消息解锁等级
	self:addConfig("gold", cfg.Exchange) 				-- 点金解锁等级
	self:addConfig("recharge", cfg.Recharge) 			-- 充值解锁等级
	self:addConfig("arena", cfg.Arena) 					-- 竞技场解锁等级
	self:addConfig("elite", cfg.EliteStage) 			-- 精英关卡解锁等级
	self:addConfig("city", cfg.Castle) 					-- 城建解锁等级
	self:addConfig("tails", cfg.Tails) 					-- 尾兽解锁等级
	self:addConfig("tree", cfg.WorldTree) 				-- 保卫世界树解锁等级
	self:addConfig("arenaPos", cfg.ArenaMorphPosition) 	-- 竞技场变身位
	self:addConfig("tailsPos", cfg.TailsFightPosition) 	-- 尾兽出战位置
	self:addConfig("dreamBook", cfg.DreamBook) 			-- 恶魔之书 开启等级
	self:addConfig("holyLand", cfg.TheHolyLand) 		-- 修炼圣地 开启等级
	self:addConfig("aincrad", cfg.Aincrad) 				-- 艾恩葛朗特 开启等级
	self:addConfig("holyHouse", cfg.Trials_Exp) 		-- 精神时间屋 开启等级
	self:addConfig("holyLight", cfg.Trials_Gold) 		-- 山多拉的灯 开启等级
	self:addConfig("holyMount", cfg.Trials_Skill) 		-- 庐山五老峰 开启等级
	self:addConfig("starUp", cfg.Skill)					-- 英雄进击 开启等级
	self:addConfig("task", cfg.Quest)					-- 任务解锁等级
	self:addConfig("expMode",cfg.ExpMode)				-- 经验模式开放等级
	self:addConfig("dailyTask",cfg.DailyQuest)			-- 每日任务开放等级
	self:addConfig("equip",cfg.Equipment)				-- 专属开放等级
	self:addConfig("auto",cfg.AutoFight)				-- 自动战斗
	self:addConfig("wanted",cfg.Wanted)					-- 日月追缉

end

function OpenLvData:addConfig(key, cfg, testOpenLv)
	local target = self
	target[key] = GameOpenLv.new({
		id = key,
		cfg = cfg,
		test = testOpenLv, -- 测试解锁等级
	})
end

--是否开放
function OpenLvData:isOpen(key)
	if UserData:getUserLevel() >= self[key].openLv then
		return true
	end
	return false
end

return OpenLvData