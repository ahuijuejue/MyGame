
local GameReport = class("GameReport") 

function GameReport:ctor(params) 
	self.type 		= params.type or 1				-- 战报类型（1，我挑战别人，2 别人挑战我）
	self.win 		= params.win 					-- 胜负
	self.offset 	= checknumber(params.offset) 	-- 变化的名次（正升，负降，0 没有变化） 
	self.name 		= params.name or ""				-- 对手名字 
	self.time 		= checknumber(params.time) 		-- 挑战时间（秒数）
	self.icon 		= params.icon 					-- 头像 
	self.level 		= checknumber(params.level) 	-- 等级 

	self.offset 	= math.abs(self.offset) 
	-- if string.len(self.icon) > 0 and string.sub(self.icon, 1, 1) ~= "#" then 
	-- 	self.icon = "#"..self.icon 
	-- end 
end

function GameReport:getTimeString() 
	local time = UserData:getServerSecond() - self.time 
	local str = self:convertTime(time) 
	if str then 
		return str.."前"
	end 
	return "刚刚"
end 

function GameReport:convertTime(time) 
	local day  = math.floor(time / 86400) 
	if day > 0 then 
		return string.format("%d天", day)
	end  
	local hour = math.floor(time / 3600) 
	if hour > 0 then 
		return string.format("%d小时", hour)
	end 
	local minute  = math.mod(time, 60) 
	if minute > 0 then 
		return string.format("%d分钟", minute)
	end 
	local sec = time 
	if sec > 5 then 
		return string.format("%d秒钟", sec)
	end 
	return nil
end 

return GameReport 
