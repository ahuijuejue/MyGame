--关卡类
local GameStage = class("GameStage")
--[[

第三颗星条件
1、塔不倒
2、队员不死
3、不使用变身
4、不召唤替补
5、单人通关
]]
local starString = {
	"塔不倒",
	"队员不死",
	"不使用变身",
	"不召唤替补",
	"单人通关",
	"基地血量大于等于50%",
	"基地不受到伤害",
	"出场人数小于等于3人",
	"出场人数小于等于5人",
	"60秒过关",
}
-- 关卡类型 文字描述
local typeString = {
	"普通", -- 普通
	"防守",
	"护送",
	"逃跑",
	"单骑",
}

function GameStage:ctor(param)
	local cfg = param.cfg	
	local chapter = param.chapter
	
	self.chapterInfo = chapter
	self.id 		= param.id 							-- 关卡id
	self.name 		= cfg.Name 							-- 关卡名字
	self.chapterId 	= cfg.Chapter 						-- 章节id
	self.desc 		= cfg.Description 					-- 描述
	self.sort 		= checknumber(cfg.Sort)				-- 主关卡代号
	self.sort2 		= checknumber(cfg.Order) 			-- 子关卡代号
	self.type 		= tonumber(cfg.Type) 				-- 1.普通 2.守塔 3.护送 4.逃跑
	self.icon 		= cfg.Icon 							-- 关卡图标
	self.map 		= cfg.Map 							-- 关卡地图
	self.star1 		= "通过本关" 							-- 第一星达成条件
	self.star2 		= tonumber(cfg.SecondStarTime) 		-- 第二星达成时间
	self.star3 		= tonumber(cfg.ThirdStarCondition)	-- 第三星达成条件
	self.dropItems 	= cfg.FallItem 						-- 掉落物品
	self.fighterMax = tonumber(cfg.FighterNum) 			-- 上场最大人数
	self.endTime 	= checknumber(cfg.EndTime) 			-- 判定为失败的时长 
	self.escortId 	= cfg.EscortID 						-- 护送id 
	self.escortLevel = checknumber(cfg.EscortLevel) 	-- 护送等级 

	self.typeStr 	= typeString[self.type] 			-- 关卡类型 文字描述
	self.star3Str 	= starString[self.star3] 			-- 三星条件文字显示

	self.gold 		= checknumber(cfg.Gold) 			-- 通关获得金币
	self.heroExp 	= checknumber(cfg.HeroExp) 			-- 通关获得英雄经验
	self.soul 		= checknumber(cfg.Skill) 			-- 通关获得灵能值

	self.stageType 	= checknumber(chapter.Type)			-- 1:普通关卡，2:精英关卡 
	self.chapterIndex = checknumber(chapter.Sort) 		-- 第几章 
	self.nextStageId = cfg.NextStageId 					-- 下一关卡id
	self.nextSubStageId = cfg.SubStageID 				-- 下一子关卡id

	-- 药品掉落
	self.drugs = {} 
	for i,v in ipairs(cfg.FallDrug or {}) do
		self.drugs[v] = checknumber(cfg.FallDrugNum[i])
	end
			
	self.teamExp 	= param.teamExp  	-- 战队经验
	self.passLevel 	= 0 				--通关星级 服务器给

	-- 精英
	self.passLimit 	= param.passLimit 	-- 精英关卡 通过次数限制
	self.passNum 	= 0 				-- 精英关卡 通关次数	
	self.buyEliteNum = 0 				-- 购买的 （精英次数） 

	-- 处理数据
	
	if self.sort2 > 0 then 
		self.preName = string.format("%d-%d-%d", chapter.Sort, self.sort, self.sort2) -- 关卡
	else 
		self.preName = string.format("%d-%d", chapter.Sort, self.sort) -- 关卡
	end 

	self.preStage = nil 
	self.nextStage = nil 
	self.nextSubStage = nil -- 主关卡的第一个子关卡

end

-- 是否是主关卡
function GameStage:isMainStage()
	return self.sort2 <= 0
end 

-- 本关星级
function GameStage:getStar()
	return self.passLevel
end 

-- 本关最大星级
function GameStage:getStarMax()
	return 3
end 

-- 是否通关
function GameStage:isOver()
	return self.passLevel > 0
end 

-- 获得战队经验
function GameStage:getTeamExp()
	return self.teamExp
end 

-- 获得精英关卡剩余次数
function GameStage:getEliteTimes()	
	return self.passLimit + self.buyEliteNum - self.passNum
end 

-- 是否是精英关卡
function GameStage:isElite()
	return self.stageType == 2
end 

-- 标记名
function GameStage:getMarkName()
	return typeString[self.type]
end 

-- 有下一个子关卡
function GameStage:haveNextSubStage()	
	return self.nextSubStageId and string.len(self.nextSubStageId) > 0
end 

return GameStage