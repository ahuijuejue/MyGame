
local ArenaRole = import(".ArenaRole")

local ArenaTeam = class("ArenaTeam")

function ArenaTeam:ctor(params)
	self.userId = params.userId 				-- 用户id
	self.teamId = params.teamId 				-- 战队id
	self.rank 	= checknumber(params.rank) 		-- 竞技场排名
	self.name 	= params.name or "" 			-- 玩家名
	self.level 	= checknumber(params.level) 	-- 玩家战队等级
	self.icon 	= params.icon 					-- 玩家头像
	self.score = checknumber(params.score) 	    -- 战斗力（机器人）"艾恩积分，战斗力，战队等级，关卡得星"

	self.roleList = {}

	self.sealLevel = 0 			-- 封印等级
	self.tailsIdList = {} 		-- 尾兽出战列表
	self.tailsStarList = {} 	-- 出战尾兽等级列表

	self.evolveNum = 0 	-- 	变身数量

	self.vip = checknumber(params.vip)

	self.params = params
end

function ArenaTeam:createRole(params)
	return ArenaRole.new(params)
end

function ArenaTeam:setRoleList(list)
	assert(type(list) == "table", "list should be table")
	self.roleList = list

	return self
end

function ArenaTeam:addRole(role)
	table.insert(self.roleList, role)

	return self
end

function ArenaTeam:getRoleList()
	local superCount = 0
	if self.evolveNum > 0 then
		superCount = self.evolveNum
	else
		superCount = ArenaData:getSuperOpen(self.level) -- 可变身数量
	end

	for i,v in ipairs(self.roleList) do
		if superCount >= i and v:checkEvolve() then
			v.evolve = true
		else
			v.evolve = false
		end
	end

	return self.roleList
end

function ArenaTeam:getRole(roleId)
	for i,v in ipairs(self.roleList) do
		if roleId == v.roleId then
			return v
		end
	end
	return nil
end

-- 默认 从小到大
function ArenaTeam:sortRoleByLevel(bigger)
	table.sort(self.roleList, function(a, b)
		if bigger then
			return a.level > b.level
		else
			return a.level < b.level
		end
	end)
end

---------------------------------------
-- 战队等级
function ArenaTeam:getLevel()
	return self.level
end

-- 战队战斗力
function ArenaTeam:getBattle()
	if self.params then
		return self.params.battle
	end
	return 0
end

-- 战队战斗力_
function ArenaTeam:getBattle_()
	if self.params then
		return self.params.score
	end
	return 0
end

function ArenaTeam:getScore()
	if self.score then
		return self.score
	end
	return 0
end

-- 战队边框
function ArenaTeam:getBorder()
	return ArenaData:getDefaultBorder()
end


---------------------------------------
-- 封印相关
function ArenaTeam:setSealLevel(level)
	self.sealLevel = level
end

function ArenaTeam:getSealLevel()
	return self.sealLevel
end

function ArenaTeam:setTailsIdList(list)
	self.tailsIdList = {}
	for i,v in ipairs(list) do
		if string.len(v) > 0 then
			table.insert(self.tailsIdList, v)
		end
	end
end

function ArenaTeam:getTailsIdList()
	return self.tailsIdList
end

function ArenaTeam:setTailsStarList(list)
	self.tailsStarList = {}
	for i,v in ipairs(list) do
		table.insert(self.tailsStarList, checknumber(v))
	end
end

function ArenaTeam:getTailsStarList()
	return self.tailsStarList
end

-- 尾兽技能id列表
function ArenaTeam:getTailsSkillList()
	return TailsSkillData:getTailsSkillIdList(self:getTailsIdList(), self:getTailsStarList())
end

return ArenaTeam