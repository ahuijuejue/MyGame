
local SceneData = class("SceneData")

function SceneData:ctor()
	self.element = base.SceneElement.new()
	self.saveOrders = {visitor=1}
end

function SceneData:pushScene(scenename, params, target, callback, callback2)
	local scene = self:createScene(scenename, params, target, callback, callback2)
	if self:isHave(scene:getNetOrder()) then
		self.element:pushScene(scene)
	else
		self.element:netPushScene(scene)
	end
end

function SceneData:enterScene(scenename, params, target, callback, callback2)
	local scene = self:createScene(scenename, params, target, callback, callback2)
	if self:isHave(scene:getNetOrder()) then
		self.element:enterScene(scene)
	else
		self.element:netEnterScene(scene)
	end
end

function SceneData:createScene(scenename, params, target, callback, callback2)
	if type(params) ~= "table" then
		callback2 = callback
		callback = target
		target = params
		params = {}
	end
	local cls = import("app.util.scenevisitor."..scenename.."Visitor")
	local scene = cls.new({
		target = target,
		params = params,
		callback = function(event)
			if event.name == "success" then
				self:add(event.save)
				if callback then
					callback()
				end
			elseif event.name == "error" then
				if callback2 then
					callback2()
				end
			end
		end,
	})
	return scene
end

function SceneData:get(name)
	-- dump(name, "name")
	if not self.saveOrders[name] then
		self.saveOrders[name] = 0
	end
	return self.saveOrders[name]
end

function SceneData:set(name, count)
	self.saveOrders[name] = count
end

function SceneData:add(name)
	self:set(name, self:get(name) + 1)
end

function SceneData:isHave(name)
	return self:get(name) > 0
end

function SceneData:reset(names)
	if type(names) == "table" then
		for k,v in pairs(names) do
			self.saveOrders[v] = 0
		end
	else
		self.saveOrders[names] = 0
	end
end

function SceneData:resetAll()
	self.saveOrders = {visitor=1}
end

function SceneData:removeTarget(target)
	NetHandler.removeTarget(target)
end

local toUI = {
		"Main", 			-- 1主界面
		"StageNormal", 		-- 2当前普通最大关卡
		"StageElite", 		-- 3当前精英最大关卡
		"ExpMode", 			-- 4经验模式界面
		"HeroList", 		-- 5英雄列表
		"Gold", 			-- 6弹出点金界面
		"Card", 			-- 7抽卡界面
		"HolyLand", 		-- 8修炼圣地
		"Arena", 			-- 9竞技场
		"Tree", 			-- 10保卫世界树
		"Aincrad", 			-- 11艾恩葛朗特
		"Tails", 			-- 12尾兽
		"City", 			-- 13城建
		"Recharge", 		-- 14充值
		"ShopNormal", 		-- 15商店
		"ShopArena", 		-- 16竞技场商店
		"ShopScore", 		-- 17积分商店
		"ShopTree", 		-- 18神树商店
		"Stage", 			-- 19指定关卡
		"Wanted", 			-- 20日月追缉
		"Power", 			-- 21购买体力
		"Union",            -- 22公会
		"Coin",             -- 23寻宝
	}

function SceneData:JumpUI(index, params, target, callback)
	index = index or 0
	local name = toUI[index]
	if name then
		self:pushScene(name, params, target, callback)
	end
end

return SceneData
