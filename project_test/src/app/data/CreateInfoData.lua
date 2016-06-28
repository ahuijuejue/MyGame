
local CreateInfoData = class("CreateInfoData") 

function CreateInfoData:ctor()
	local cfg = GameConfig["CreateInfo"]["1"] 

	self.heroId 	= cfg.CreateHeroID 		-- 初始英雄 
	self.gold 		= cfg.CreateGold 		-- 初始金币 
	self.diamond 	= cfg.CreateDiamond 	-- 初始宝石 
	self.power 		= cfg.CreateEnergy		-- 初始体力 
end

return CreateInfoData
