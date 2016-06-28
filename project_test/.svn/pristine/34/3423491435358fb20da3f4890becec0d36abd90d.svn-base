
local TrialData = class("TrialData") 
local GameTrial = import(".GameTrial") 
local GameLight = import(".GameLight")
local GameHouse = import(".GameHouse")
local GameMount = import(".GameMount")

function TrialData:ctor() 
	local cfg = GameConfig["Trials_Info"]
	self.cfg = {}
	self:addTrial("light", cfg["1"]) 	-- 山多拉的灯解锁日期 等配置信息
	self:addTrial("time", cfg["2"]) 	-- 精神时间屋解锁日期 等配置信息
	self:addTrial("mount", cfg["3"]) 	-- 庐山五老峰解锁日期 等配置信息 

	self.lightList = {}  -- 珊朵拉的灯 关卡难度阵型 
	self.houseList = {}  -- 精神时间屋 难度信息
	self.mountList = {}  -- 庐山五老峰 难度信息
	
-----------------------------------------------
	self.arr = {}
	cfg = GameConfig["Trials_Rule"]
	for k,v in pairs(cfg) do 
		local nItem = table.nums(v.AwardName)
		local items = {} 
		for i=1,nItem do
			table.insert(items, {
				icon = v.AwardIcon[i],
				name = v.AwardName[i],
			})
		end
		table.insert(self.arr, {
			id = k,
			desc = v.Info,
			items = items,
		})
	end
	table.sort(self.arr, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)
------------------------------------------------
end

------------------------------------------------
------------------------------------------------
-- 试炼配置 
function TrialData:addTrial(key, cfg) 
	local target = self.cfg 
	target[key] = GameTrial.new({
		id = key,
		cfg = cfg,
	})
end 

function TrialData:getTrial(key) 
	return self.cfg[key]
end 

function TrialData:getTrials() 
	return self.cfg
end 

-- 难度解锁信息列表
function TrialData:getOpenList() 
	return OpenLvData.holyLvList.openLv 
end 

------------------------------------------------
------------------------------------------------
-- 山多拉的灯 阵型等 难度信息
function TrialData:resetLight() 
	self.lightList = {}
end 

function TrialData:addLight(params) 
	table.insert(self.lightList, GameLight.new(params))
end 

function TrialData:getLight(index) 
	return self.lightList[index]
end 

function TrialData:sortLight() 
	table.sort(self.lightList, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)
end 

------------------------------------------------
-- 精神时间屋 难度信息
function TrialData:resetHouse() 
	self.houseList = {}
end 

function TrialData:addHouse(params) 
	table.insert(self.houseList, GameHouse.new(params))
end 

function TrialData:getHouse(index) 
	return self.houseList[index]
end 

function TrialData:sortHouse() 
	table.sort(self.houseList, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)
end 

------------------------------------------------
-- 庐山五老峰 难度信息
function TrialData:resetMount() 
	self.mountList = {}
end 

function TrialData:addMount(params) 
	table.insert(self.mountList, GameMount.new(params))
end 

function TrialData:getMount(index) 
	return self.mountList[index]
end 

function TrialData:sortMount() 
	table.sort(self.mountList, function(a, b)
		return checknumber(a.id) < checknumber(b.id)
	end)
end 

------------------------------------------------
------------------------------------------------

-- 规则内容 
function TrialData:getRuleText(index) 
	return self.arr[index].desc
end 

local ruleTitles = {
	"word_holyland_rule.png",
	"word_aincrad_rule.png",
	"word_tree_rule.png",
}
-- 规则标题 
function TrialData:getRuleTitle(index) 
	return ruleTitles[index]
end 

-- 奖励显示 
function TrialData:getRewardShow(index) 
	return self.arr[index].items
end 



return TrialData 
