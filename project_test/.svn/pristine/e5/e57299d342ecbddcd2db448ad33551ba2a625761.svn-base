--
-- Author: zsp
-- Date: 2014-12-10 10:14:21
--

local BuffBase = class("BuffBase")

--[[
	buff的基类 子类重写事件方法
--]]
function BuffBase:ctor(buffId,level,manager,attacker)
	self.buffId   = buffId
	--等级 由触发此buff的技能传入等级
	self.level    = level
	--buff管理器
	self.manager  = manager
	--中buff的角色
	self.owner    = manager.owner
	--释放这个buff的角色
	self.attacker = attacker

	self.cfg      = GameConfig.buff[buffId]
	self.time     = checknumber(self.cfg["time"])
	self.interval = checknumber(self.cfg["interval"])
	self.data     = checknumber(self.cfg["data"])

	self.method     = checkint(self.cfg["method"])
	self.up_down    = checkint(self.cfg["up_down"])
	self.key        = self.cfg["key"]
	self.type       = checknumber(self.cfg["type"])
	self.effect     = self.cfg["effect"] or ""
	self.site       = checknumber(self.cfg["effect_site"])
	self.way        = checknumber(self.cfg["way"])
	self.txt 		= self.cfg["txt"] or ""
	self.effectLoop = false
	if checkint(self.cfg["effect_loop"]) == 1 then
		self.effectLoop = true
	end

	self.remove     = false
	self.dtInterval = 0
	self.dtTime     = 0
	--属性升级
	local levelData = self.cfg["level_data"]
	if levelData then
		for i=1,#levelData do
			local data = levelData[i]
			if data and string.len(data) > 0 then
				local tb = string.split(data,":")
				local k = tb[1]
				local v = checknumber(tb[2])
				self[k] = Formula[7](self[k], self.level,checknumber(v))
			end
		end
	end

end

function BuffBase:update( dt )

	self.dtTime  = self.dtTime + dt

	if self.dtTime >= self.time then
		self.remove = true
		return
	end


	self:doUpdate(dt)

	if self.interval > 0 then
		self.dtInterval = self.dtInterval + dt
		if  self.dtInterval >= self.interval then
			self.dtInterval = 0
			self:doBuff()
		end
	end
end

--[[
	重置buff计时
--]]
function BuffBase:reset()

	self.dtInterval = 0
	self.dtTime     = 0
end

--[[
	buff进入时触发
--]]
function BuffBase:doBegin()
	-- body
	printError("BuffBase:doBegin() - must override in inherited class")
end

--[[
	单次执行buff逻辑
--]]
function BuffBase:doBuff()
	-- body
	printError("BuffBase:doBuff() - must override in inherited class")
end

--[[
	buff结束
--]]
function BuffBase:doEnd()
	-- body
	printError("BuffBase:doEnd() - must override in inherited class")
end

--[[
	更新buff逻辑
--]]
function BuffBase:doUpdate(dt)
	-- body
	printError("BuffBase:doUpdate() - must override in inherited class")
end

return BuffBase