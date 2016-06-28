--物品类
local GameItem = class("GameItem")

--[[
type 
1、英雄硬币
2、装备（装备）
3、装备（材料）
4、宝石（宝石）
5、宝石（材料）
6、消耗品（其他）
7、消耗品（宝箱）
8、金币
9、钻石
10、体力
11、灵能
12、竞技场币

drop way
1、关卡掉落
2、神秘商店
3、竞技场商店
4、试炼商店
5、公会商店
6、积分商城
7、签到
8、特殊途径

quality 
1、白
2、绿
3、蓝
4、紫
5、橙

packageType
1、硬币
2、装备
3、宝石
4、消耗
]]

function GameItem:ctor(param)
	local item = GameConfig.item[tostring(param.itemId)]
	self.uniqueId = tostring(param.id) or 0
	self.itemId = tostring(param.itemId)	-- 物品id
	self.count = tonumber(param.count) or 0 			-- 物品数量
	-- 物品名字
	self.itemName = item.Name
	-- 物品品质
	self.configQuality = item.Quality
	self.quality = getQualityLevel(item.Quality)[1]
	self.imageName = item.Icon 		-- 物品图片名
	self.dropStage = item.DropWay 			-- 掉落关卡
	self.type = tonumber(item.Type)		-- 物品类型 
	self.packageType = item.BagLabel 		-- 背包分类
	self.desc = item.Description 			-- 物品描述
	self.value = item.Gold or 0 			-- 出售价格
	self.overly = item.Overly == 1 and true or false -- 是否能叠加

	self.dropWay = item.DropWay 			-- 掉落途径
	self.mapId = item.MapID 				-- 掉落地图
	self.useType = item.Use --物品使用类型
	self.detailType = item.Details --物品详情类型
	self.content = item.Content			--物品扩展结构

	self.seal = checknumber(item.Seal) 		-- 封印获得点数
end

function GameItem:getSuperName(level)
	local num = getQualityLevel(level)[2]
	local name = self.configName
	if num > 0 then
		name = name.."+"..num
	end
	return name
end

return GameItem