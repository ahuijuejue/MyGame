local ChatData = class("ChatData")

function ChatData:ctor()
	self.sysSize = {}
	self.worldSize = {}
	self.unionSize = {}

	self.sysData = {}
	self.worldData = {}
	self.unionData = {}

    self.setState  = {"1", "1", "1"}

	self.allLeftData   = {} -- 左下角显示全部信息

end

--插入聊天数据
function ChatData:insertData(type_,chatModel)
	local msg = toChatStr(chatModel.msg, 0.45, 22)
	local params = {
        dimensions = cc.size(540,0),
        text = msg,
    }
    local RichLabel = require("app.ui.RichLabel")
	local chatLabel = RichLabel:create(params)

	if type_ == "2" then -- 系统
		local itemHeight = chatLabel:getLabelSize().height+30	
		if #self.sysData == 50 then
			table.remove(self.sysSize, 50)
			table.remove(self.sysData, 50)
		end
		table.insert(self.sysSize,1,itemHeight)
		table.insert(self.sysData,1,chatModel)

		if self.setState[1] == "1" then
			if #self.allLeftData < 50 then
				table.insert(self.allLeftData, 1, chatModel)
			elseif #self.allLeftData == 50 then
				table.remove(self.allLeftData, #self.allLeftData)
				table.insert(self.allLeftData, 1, chatModel)
			end
		end
	elseif type_ == "3" then -- 世界
		local itemHeight = chatLabel:getLabelSize().height+90
		if #self.worldData == 50 then
			table.remove(self.worldSize, 50)
			table.remove(self.worldData, 50)
		end
		table.insert(self.worldSize,1,itemHeight)
		table.insert(self.worldData,1,chatModel)

		if self.setState[2] == "1" then
			if #self.allLeftData < 50 then
				table.insert(self.allLeftData, 1, chatModel)
			elseif #self.allLeftData == 50 then
				table.remove(self.allLeftData, #self.allLeftData)
				table.insert(self.allLeftData, 1, chatModel)
			end
		end
	elseif type_ == "4" then  -- 公会
		local itemHeight = chatLabel:getLabelSize().height+90	
		if #self.unionData == 50 then
			table.remove(self.unionSize, 50)
			table.remove(self.unionData, 50)
		end
		table.insert(self.unionSize,1,itemHeight)
		table.insert(self.unionData,1,chatModel)

		if self.setState[3] == "1" then
			if #self.allLeftData < 50 then
				table.insert(self.allLeftData, 1, chatModel)
			elseif #self.allLeftData == 50 then
				table.remove(self.allLeftData, #self.allLeftData)
				table.insert(self.allLeftData, 1, chatModel)
			end
		end
	end
end

--删除聊天数据
function ChatData:cleanData()
	for i,v in ipairs(self.sysData) do
		v = nil
	end
	for i,v in ipairs(self.sysSize) do
		v = nil
	end

	self.sysSize = {}
	self.sysData = {}

	for i,v in ipairs(self.worldData) do
		v = nil
	end
	for i,v in ipairs(self.worldSize) do
		v = nil
	end


	self.worldSize = {}
	self.worldData = {}

	for i,v in ipairs(self.unionData) do
		v = nil
	end
	for i,v in ipairs(self.unionSize) do
		v = nil
	end

	self.unionSize = {}
	self.unionData = {}
end

return ChatData
