local UnionMemberModel = class("UnionMemberModel")

function UnionMemberModel:ctor()
    -- 成员id
    self.userid = ""
    -- 战队id
    self.teamid = ""
    -- 成员名字
    self.name = ""
    -- 成员战力
    self.combat = ""
    -- 成员头像
    self.headIcon = ""
    -- 成员等级
    self.level = ""
    -- 成员在公会中职位
    self.duty = ""
    -- vip等级
    self.vipLevel = ""
    --成员英雄数据
    self.heros = {}
    -- 封印等级 
    self.sealLevel = 0          
    -- 尾兽出战列表
    self.tailsIdList = {}       
    -- 出战尾兽等级列表 
    self.tailsStarList = {}     
    --变身数量
    self.evolveNum = 0  
end

function UnionMemberModel:setUserId( id_ )
    self.userid = id_
end

function UnionMemberModel:setTeamId(id)
    self.teamid = id
end

function UnionMemberModel:setUserName( name_ )
	self.name = name_
end

function UnionMemberModel:setUserCombat( combat_ )
	self.combat = tostring(tonumber(combat_))
end

function UnionMemberModel:setUserHeadIcon( headIcon_ )
	self.headIcon = headIcon_
end

function UnionMemberModel:setUserLevel( exp_ )
	self.level = tostring(GameExp.getUserLevel(tonumber(exp_)))
end

function UnionMemberModel:setUserDuty( duty_ )
	self.duty = duty_
end

function UnionMemberModel:setUserVipLevel( level_ )
	self.vipLevel = level_
end

function UnionMemberModel:insertHero(hero)
    table.insert(self.heros,hero)
end

function UnionMemberModel:getHeroList() 
    local superCount = ArenaData:getSuperOpen(tonumber(self.level))
    for i,v in ipairs(self.heros) do
        if superCount >= i and v:checkEvolve() then 
            v.evolve = true
        else 
            v.evolve = false
        end 
    end
    return self.heros
end 

function UnionMemberModel:setSealLevel(level)
    self.sealLevel = level 
end 

function UnionMemberModel:getSealLevel()
    return self.sealLevel 
end 

function UnionMemberModel:setTailsIdList(list)
    self.tailsIdList = {} 
    for i,v in ipairs(list) do
        if string.len(v) > 0 then 
            table.insert(self.tailsIdList, v)
        end 
    end
end 

function UnionMemberModel:getTailsIdList()
    return self.tailsIdList 
end 

function UnionMemberModel:setTailsStarList(list)   
    self.tailsStarList = {} 
    for i,v in ipairs(list) do      
        table.insert(self.tailsStarList, checknumber(v))        
    end
end 

function UnionMemberModel:getTailsStarList()
    return self.tailsStarList 
end 

function UnionMemberModel:getTailsSkillList()
    return TailsSkillData:getTailsSkillIdList(self:getTailsIdList(), self:getTailsStarList())   
end

return UnionMemberModel
