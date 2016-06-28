
local NameData = class("NameData")
--[[
取名字
]]
function NameData:ctor()
	self.arr = {} 
	self.arrCount = 0 
	local cfg = GameConfig["Name"]
	for k,v in pairs(cfg) do		
		self.arrCount = self.arrCount + 1 
		table.insert(self.arr, {
			id 	= k, 
			name1 	= v.FirstName or "",
			name2 	= v.SecondName or "", 
			name3 	= v.ThirdName or "", 
		})
	end
end

function NameData:getName()	
	local name1 = randInt(1, self.arrCount) 
	local name2 = randInt(1, self.arrCount) 
	local name3 = randInt(1, self.arrCount) 
	return self.arr[name1].name1 .. self.arr[name2].name2 .. self.arr[name3].name3 
end 

return NameData 
