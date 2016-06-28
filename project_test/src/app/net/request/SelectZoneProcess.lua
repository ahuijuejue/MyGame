local SelectZoneProcess = class("SelectZoneProcess")

function SelectZoneProcess:ctor()
	--请求消息号
	self.order = 10002
	--用户id
	self.param1 =  ""
	--uuid
	self.param2 =  ""
	--选择的分区id
	self.param3 =  ""	
end


function SelectZoneProcess:serialization()
	local data = {
		order = self.order,
		param1 = self.param1,
		param2 = self.param2,
		param3 = self.param3,
		
	}
	return data
end

return SelectZoneProcess