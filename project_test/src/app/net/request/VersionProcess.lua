local VersionProcess = class("VersionProcess")

function VersionProcess:ctor()
	--请求消息号
	self.order = 10000	
end


function VersionProcess:serialization()
	local data = {
		order = self.order,
		
	}
	return data
end

return VersionProcess