
local CharacterModel = require("app.battle.model.CharacterModel")
local ArenaRole = class("ArenaRole", CharacterModel)

function ArenaRole:ctor(params)
	ArenaRole.super.ctor(self, params)
	self.evolve = params.evolve -- 是否可以变身	
end

function ArenaRole:setEvolve(b)
	self.evolve = b 

	return self 
end 


function ArenaRole:getBorder()
	return UserData:getHeroBorder(self)
end 

function ArenaRole:getIcon()
	return UserData:getHeroIcon(self.roleId)
end 

return ArenaRole 





