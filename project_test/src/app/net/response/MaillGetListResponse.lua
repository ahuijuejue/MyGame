local MaillGetListResponse = class("MaillGetListResponse")
function MaillGetListResponse:MaillGetListResponse(data)
	if data.result == 1 then
		MailData:resetList()

		function formatParams(str, arr)
			return string.format(str, unpack(arr))
		end


		for i,v in ipairs(data.a_param1) do
			local info = json.decode(v)
			-- dump(info, "info")
			local item = {
				id 		= 	info.onlyId, 				-- 邮件id
				mailId 	= 	info.mailId, 				-- 邮件配置id
				param 	= 	info.param, 				-- 邮件描述的数据参数
				sendTime = 	info.createtime, 			-- 发送时间
				sender 	= info.sender,
				desc 	= info.content,
				type 	= info.type,
				title 	= info.title,
			}

			local mail = MailData:createMail(item)

			-- 增加物品
			if info.itemids then
				local items = info.itemids
				local nums = info.itemnums
				local count = #items
				for i=1,count do
					if string.len(items[i]) > 0 then
						mail:addItem(items[i], tonumber(nums[i]))
					end
				end
			end
			-- 增加英雄
			if info.heroid then
				local heros = string.split(info.heroid or "", ",")
				for i,v in ipairs(heros) do
					if string.len(v) > 0 then
						mail:addHero(v, 1)
					end
				end
			end

			MailData:addMail(mail)
		end
		MailData:sortMail()
	end

end
function MaillGetListResponse:ctor()
	--响应消息号
	self.order = 10011
	--返回结果,如果成功才会返回下面的参数：1 成功,
	self.result =  ""
	--邮件内容
	self.a_param1 =  ""
end

return MaillGetListResponse
