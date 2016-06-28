
local GameMail = class("GameMail")

function GameMail:ctor(params)
	params = params or {}
	local mailId = params.mailId 
	local cfg = GameConfig.Mail[mailId] 
	if cfg then 
		self:parse(mailId, params)
	end 

	self.received 	= 	false 						-- 是否已经接收
	
end

function GameMail:parse(mailId, params)	
	local cfg = GameConfig.Mail[mailId] 	
	local sendType = checknumber(cfg.TimeType)

	self.id 	= 	params.id or "" 		-- 邮件唯一id
	self.mailId = 	mailId 					-- 邮件配置id		
	self.items 	= 	params.items or {} 		-- 附件物品
	self.heros 	= 	params.heros or {} 		-- 附件英雄

	self.icon 	= 	cfg.Icon 			 	-- 邮件图像 
	if sendType == 3 then -- gm发送 
		self.from 	= 	params.sender or "" 	-- 发件人
		self.desc 	= 	params.desc 			-- 描述
		self.type 	= 	checknumber(cfg.Type) 	-- 类型 1带附件，0不带附件
		self.title 	= 	params.title 		 		-- 标题	
	else 
		self.title 	= 	cfg.Theme 		 		-- 标题	
		self.from 	= 	cfg.Name or "" 					-- 发件人
		self.type 	= 	checknumber(cfg.Type) 			-- 类型 1带附件，0不带附件
		self.desc 	= 	formatString(cfg.Description) 	-- 描述
		if params.param then 
			local param = string.split(params.param, ",")
			self.desc = self:formatParams(self.desc, param)
		end 
	end 

	self.sendTime 	= 	params.sendTime or "" 		-- 发送时间 
	
end

function GameMail:formatParams(str, arr)	
	return string.format(str, unpack(arr))
end

-- 是否包含附件
function GameMail:haveAnnex() 
	if self.type == 1 then 
		if table.nums(self.items) > 0 or table.nums(self.heros) > 0 then 
			return true 
		end 
	end 

	return false 
end

-- 增加附件物品 
function GameMail:addItem(itemId, count)	
	if not self.items[itemId] then 
		self.items[itemId] = 0
	end 
	self.items[itemId] = self.items[itemId] + count 
end

-- 增加附件英雄
function GameMail:addHero(heroId, count)	
	if not self.heros[heroId] then 
		self.heros[heroId] = 0
	end 
	self.heros[heroId] = self.heros[heroId] + count 
end

return GameMail 
