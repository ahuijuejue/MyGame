local ChatModel = class("ChatModel")

function ChatModel:ctor(param)
	-- 频道标识
	self.channelType = param.channelType or ""
	-- 发送者唯一标识
	self.sender = param.sender or ""
	-- 发送者Name
	self.name = param.name or ""
	-- 发送者头像
	self.headIcon = param.headIcon or ""
	-- 发送者vip等级
	self.vipLevel = param.vipLevel or 0
	-- 内容
	self.msg = param.msg or ""
	-- 发送时间
	self.sendTime = param.sendTime or ""
end

function ChatModel:isOwnMsg()
	-- body
end
return ChatModel