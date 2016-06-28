
local RankData = class("RankData")
local ArenaTeam = import(".ArenaTeam")

function RankData:ctor()
	self.ranks = {}
end

function RankData:createTeam(params)
	return ArenaTeam.new(params)
end

function RankData:resetRank(key)
	self.ranks[key] = {
		teams = {}, -- 队伍列表
		rank = 0, 	-- 自己排名
		rankMax = 0, -- 自己历史最高排名
	}
end

function RankData:getRank(key)
	if not self.ranks[key] then
		self:resetRank(key)
	end
	return self.ranks[key]
end

function RankData:addRankTeam(team, key)
	local rank = self:getRank(key)
	table.insert(rank.teams, team)
end

function RankData:setRankValue(key, rank, rankMax)
	local data = self:getRank(key)
	data.rank = rank
	data.rankMax = rankMax
end

local ranknames = {
	"arena", 	-- 竞技场排行榜
	"aincrad", 	-- 艾恩葛朗特排行榜
	"sword", 	-- 战力排行榜
	"teamLv", 	-- 战队等级排行榜
	"stageStar", -- 关卡得星
	"",
	"union",     -- 公会等级
}

function RankData:getRankTypeName(index)
	return ranknames[checknumber(index)]
end

function RankData:getRankTypeIndex(name)
	return table.indexof(ranknames, name)
end


return RankData
