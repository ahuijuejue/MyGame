local ItemData = class("ItemData")
local GameItem = import(".GameItem")
local GameEquip = import(".GameEquip")

--经验药水ID
EXP_ITEM = {"40004","40003","40002","40001"}
--超神水超圣水ID
SUPER_ITEM = {"40005","40006"}

local color_white = cc.c4b(255, 255, 255,255)
local color_green = cc.c4b(80, 239, 0,255)
local color_blue = cc.c4b(52, 152, 255,255)
local color_purple = cc.c4b(224, 111, 255,255)
local color_yellow = cc.c4b(252,189,38,255)
local color_red = cc.c4b(255, 44, 44, 255)

COLOR_RANGE = {color_white,color_green,color_blue,color_purple,color_yellow,color_red}

function ItemData:ctor()
	--物品列表
	self.itemList = {}
end

--查询物品
function ItemData:getItemWithId(id)
	for k,v in pairs(self.itemList) do
		if v.itemId == id then
			return v
		end
	end
	return nil
end

--只可查询能叠加物品
function ItemData:getItemCountWithId(id)
	for k,v in pairs(self.itemList) do
		if v.itemId == id then
			return v.count
		end
	end
	return 0
end

--增加可叠加物品接口
function ItemData:addMultipleItem(id,count)
	if count <= 0 then
		return
	end
	local item = self:getItemWithId(id)
	if item then
		item.count = item.count + count
	else
		local param = {itemId = id, id = id, count = count}
		local item = GameItem.new(param)
		table.insert(self.itemList,item)
	end
end

--减少可叠加物品接口
function ItemData:reduceMultipleItem(id,count)
	if count <= 0 then
		return
	end
	local item = self:getItemWithId(id)
	if item then
		assert(item.count >= count,"Invalid count")
		item.count = item.count - count
		if item.count <= 0 then
			self:removeItem(item)
			item = nil
		end
	end
end

--移除物品接口
function ItemData:removeItem(item)
	if item then
		local index = table.indexof(self.itemList,item)
		table.remove(self.itemList,index)
	end
end

--获取可装备列表
function ItemData:getEquipList(ids)
	local uniqueIds = table.unique(ids)
	local list = {}
	for i=1,#uniqueIds do
		for k=1,#self.itemList do
			if uniqueIds[i] == self.itemList[k].itemId then
				table.insert(list,self.itemList[k])
			end
		end
	end
	return list
end

--获取所有装备
function ItemData:getEquips()
	local items = {}
	for i,v in ipairs(self.itemList) do
		if v.count > 0 and v.type == 2 then 
			table.insert(items, v)			
		end 
	end	
	return items
end 

--获取指定物品类型列表
function ItemData:getItemWithItemType(type_)
	local list = {}
	for i,v in ipairs(self.itemList) do
		if v.type == type_ then
			table.insert(list,v)
		end
	end
	return list
end

--获取指定背包类型列表
function ItemData:getItemWithType(type_)
	local list = {}
	if type_ == 0 then
		return self.itemList
	end
	for i,v in ipairs(self.itemList) do
		if v.packageType == type_ then
			table.insert(list,v)
		end
	end
	return list
end

--查询装备
function ItemData:getEquipWithUid(uId)
	for i,item in ipairs(self.itemList) do
		if item.type == 2 then
			for j,eUid in ipairs(item.uniqueId) do
				if eUid == uId then
					return item
				end
			end
		end
	end
	return nil
end

--装备叠加
function ItemData:superimposeEquip(param)
	local equip = self:getSameEquip(tostring(param.itemId),tonumber(param.level) or 0)
	if equip then
		equip:addSameEquip(param.id)
	else
		equip = GameEquip.new(param)
		table.insert(self.itemList,equip)
	end
end

--移除叠加装备中的uid
function ItemData:removeSuperimposeEquip(uId)
	local equip = self:getEquipWithUid(uId)
	if equip then
		equip:removeSameEquip(uId)
		if equip.count <= 0 then
			self:removeItem(equip)
			equip = nil
		end
	end
	return equip
end

--查询是否存在相同id 相同强化等级的装备
function ItemData:getSameEquip(id,level)
	for i,v in ipairs(self.itemList) do
		if v.type == 2 then
			if v.itemId == id and v.strLevel == level then
				return v
			end
		end
	end
	return nil
end

function ItemData:getItems()
	local items = {}
	for i,v in ipairs(self.itemList) do
		if v.count > 0 then 
			items[#items + 1] = v
		end 
	end	
	return items
end 

function ItemData:getItemConfig(itemId)	
	return GameItem.new({itemId = itemId})
end 

function ItemData:getEquipConfig(itemId)
	return GameEquip.new({itemId = itemId})
end

function ItemData:getItem(uid)
	uid = tostring(uid)
	for k,v in pairs(self.itemList) do
		if type(v.uniqueId) == "table" then 
			for i2,v2 in ipairs(v.uniqueId) do
				if v2 == uid then
					return v
				end
			end
		elseif v.uniqueId == uid then
			return v
		end
	end
	return nil
end 

function ItemData:createItem(id, itemId, count)
	local param = {id = id, itemId = itemId, count = count}
	return GameItem.new(param)
end 

function ItemData:setItem(id, itemId, count)	
	local item = self:getItem(id)
	if item then
		item.count = count or 0
	else
		local param = {id = id, itemId = itemId, count = count}
		local item = GameItem.new(param)		
		table.insert(self.itemList,item)
	end

	return self
end 

function ItemData:addItem(id, itemId, count)
	if not count then count = 0 end 

	local item = self:getItem(id)
	if item then
		item.count = item.count + count
	else
		self:setItem(id, itemId, count)		
	end

	return self
end 

function ItemData:reduceItem(id, count)
	if not count or count <= 0 then 
		return self 
	end 

	local item = self:getItem(id)
	if item then		
		assert(item.count >= count , "Invalid count")
		if type(item.uniqueId) == "table" then 			
			self:removeSuperimposeEquip(id)				
		else 
			item.count = item.count - count	
		end 
	end

	return self
end 

function ItemData:reduceItemWithItemId(itemId, count)
	if not count or count <= 0 then 
		return self 
	end 

	local item = self:getItemWithId(itemId)
	if item then		
		assert(item.count >= count , "Invalid count")
		if type(item.uniqueId) == "table" then 			
			for i=1,count do
				table.remove(item.uniqueId)
				item.count = #item.uniqueId
			end		
		else 
			item.count = item.count - count	
		end 
	end

	return self
end 

function ItemData:getItemCount(itemId)
	local count = 0 
	itemId = tostring(itemId)
	for k,v in pairs(self.itemList) do
		if v.itemId == itemId then
			count = count + v.count
		end
	end
	
	return count
end 

function ItemData:clean()
	for i,v in ipairs(self.itemList) do
		v = nil
	end
	self.itemList = {}
end

return ItemData
