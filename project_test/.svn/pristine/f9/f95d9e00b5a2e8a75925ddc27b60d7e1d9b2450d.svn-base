
local ArenaReport = class("ArenaReport") 
local GameReport = import(".GameReport")

function ArenaReport:ctor()
	self.list = {} 
end 

function ArenaReport:createReport(params)
	return GameReport.new(params)
end 

function ArenaReport:reset()
	self.list = {} 
end 

function ArenaReport:add(report)
	table.insert(self.list, report)  
end 

function ArenaReport:getReportList() 
	table.sort(self.list, function(a, b)
		return a.time > b.time 
	end)

	return self.list 
end 

return ArenaReport 
