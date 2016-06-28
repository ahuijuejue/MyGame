local NoticeData = class("NoticeData")

function NoticeData:ctor()
	self.notice = {}
end

function NoticeData:insertNotice(text)
	table.insert(self.notice,text)
end

function NoticeData:removeNotice()
	table.remove(self.notice,1)
end

function NoticeData:clean()
	self.notice = {}
end

return NoticeData
