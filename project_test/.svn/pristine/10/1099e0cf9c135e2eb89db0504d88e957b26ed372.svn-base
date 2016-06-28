
local GameAincradBuff = class("GameAincradBuff")

function GameAincradBuff:ctor(params)
	local cfg = params.cfg 
	self.id 	= params.id 	-- id
	self.icon 	= cfg.icon 	-- 图标 
	self.image 	= cfg.image 	-- 翻牌图片
	self.type 	= cfg.type 		-- 代表属性 
    self.mothod = cfg.mothod --0 百分比 1 定值 增加
	self.process = checknumber(params.process) 	-- 百分值 
	self.desc 	= cfg.info or "" -- 描述

	self.costStar = 0
	self.uid 	= nil 
end 

function GameAincradBuff:addProcess(value)
	self.process = self.process + value 

	return self 
end 

function GameAincradBuff:setCostStar(value)
	self.costStar = value
end 

function GameAincradBuff:getCostStar()
	return self.costStar
end 

function GameAincradBuff:setBuffUID(uid)
	self.uid = uid
end 

function GameAincradBuff:getBuffUID()
	return self.uid
end 

return GameAincradBuff
