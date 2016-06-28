
local MailData = class("MailData")

local saveMailKey = "readmaillist"
local GameMail = import(".GameMail")

function MailData:ctor()
	self.list = {} 		-- 未读过
	self.readList = nil -- 已读过
end

function MailData:createMail(params)
	return GameMail.new(params)
end

-- 重置邮件
function MailData:resetList()
	self.list = {}
	self.readList = nil
end

-- 排序邮件
function MailData:sortMail()
	table.sort(self.list, function(a, b)
		return a.sendTime > b.sendTime
	end)
end

-- 清空本地存储已读邮件
function MailData:clearReadMail()
	StoreData:save({}, saveMailKey)
	self.readList = {}
end

-- 增加未读邮件
function MailData:addMail(data)
	table.insert(self.list, data)
end

-- 获取未读邮件
function MailData:getMails()
	return self.list
end

function MailData:getMail(id)
	for i,v in ipairs(self.list) do
		if v.id == id then
			return v
		end
	end
	for i,v in ipairs(self.readList or {}) do
		if v.id == id then
			return v
		end
	end
	return nil
end

-- 增加已读邮件
function MailData:addReadMail(data)
	data.received = true

	self:getReadMails()

	table.insert(self.readList, 1, data)
	-- 已读取最多只保留5条
	while #self.readList > 5 do -- 已读取最多只保留5条
		table.remove(self.readList)
	end

	-- 本地存储
	self:saveMails(self.readList)

	-- 将邮件从未读中删除
	local index = table.indexof(self.list, data)
	if index then
		table.remove(self.list, index)
	end
end

-- 获取已读邮件
function MailData:getReadMails()
	if not self.readList then
		self.readList = self:loadMails()
	end
	return self.readList
end

--------------------------------------------
function MailData:encodeMail(mail)
	local data = {
		id 			= mail.id,
		mailId 		= mail.mailId,
		items 		= mail.items,
		heros 		= mail.heros,
		icon 		= mail.icon,
		from 		= mail.from,
		desc 		= mail.desc,
		type 		= mail.type,
		title 		= mail.title,
		sendtime 	= mail.sendTime,
		received 	= mail.received,
	}
	return data
end

function MailData:decodeMail(data)
	local mail = GameMail.new()
	mail.id 		= data.id
	mail.mailId 	= data.mailId
	mail.items 		= data.items
	mail.heros 		= data.heros
	mail.icon 		= data.icon
	mail.from 		= data.from
	mail.desc 		= data.desc
	mail.type 		= data.type
	mail.title 		= data.title
	mail.sendtime 	= data.sendTime
	mail.received 	= data.received

	return mail
end

function MailData:saveMails(mails)
	local arr = {}
	for i,v in ipairs(mails or {}) do
		table.insert(arr, self:encodeMail(v))
	end

	local keystr = saveMailKey .. UserData.userId .. UserData.teamId
	StoreData:save(arr, keystr)
end

function MailData:loadMails()
	local arr = {}
	local keystr = saveMailKey .. UserData.userId .. UserData.teamId
	for i,v in ipairs(StoreData:get(keystr) or {}) do
		table.insert(arr, self:decodeMail(v))
	end
	return arr
end
--------------------------------------------

return MailData




