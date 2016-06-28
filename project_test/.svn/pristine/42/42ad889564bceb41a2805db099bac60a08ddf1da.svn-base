
--
-- Author: zsp
-- Date: 2014-11-20 14:52:18
--
-- 暂时用json文件，以后直接用lua数据文件替换

GameData = {
	keys = {
		"tower",
		"trap",
		"buff",
		"character",
		"custom",
		"enemy",
		"flys",
		"loot",
		"skill",
		"wave",
	 	"recharge",
	 	"Trials_Exp",
	 	"Trials_Gold",
	 	"Trials_Gold_enemy",
	 	"Trials_Skill",
	 	"skill_tails",
	 	"tower_skill",
	 	"skill_4",
	 	"new_war",
	 	"HeroSound"
	}
}

function GameData:loadData()
	for key, value in pairs(self.keys) do 
		local str = cc.FileUtils:getInstance():getStringFromFile(value..".json"); 
		printInfo("加载配置文件%s",value)
		local data = json.decode(str)
		self[value] = {}
		for i, v in pairs(data) do  
        	--self[value][v["id"]] = v
        	self[value][i] = v
    	end  
	    
		--dump(self.buff)
	end 
	-- dump(self.character)
end

return GameData