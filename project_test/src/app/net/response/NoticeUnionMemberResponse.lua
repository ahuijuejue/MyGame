local NoticeUnionMemberResponse = class("NoticeUnionMemberResponse")
local UnionModel = import("app.data.UnionModel")

function NoticeUnionMemberResponse:NoticeUnionMemberResponse(data)
    if data.result == 1 then

    	if data.param1 == 1 then      -- 审批成员
    		if UnionListData:getUnionDuty() ~= "0" then
    			-- 移除申请人信息
    			for i,v in ipairs(UnionListData.applyData) do
    				if v.userId == data.param2 then
		    			table.remove(UnionListData.applyData, i)
		    			break
		    		end
    			end
    			if data.param3 == "0" then  -- 拒绝
	    		elseif data.param3 == "1" then  -- 同意 加入申请人信息 刷新成员列表
	    			UnionListData.unionData.memberNums = tostring(tonumber(UnionListData.unionData.memberNums) + 1)
		    	 	local UnionModel = UnionModel.new(UnionListData.unionData)
			    	UnionListData:insertUnionMemberData(UnionModel:unionMember(data.a_param1[1]))
	    		end
	    	else
	    		if data.param3 == "0" then  -- 拒绝
	    			for i,v in ipairs(UnionListData.unionShowList) do
						if v.id == data.param4 then
							v.isApply = 0
							break
						end
					end
				elseif data.param3 == "1" then
					UnionListData.isApplyPass = 1
					if data.param4 then
						UserData.unionLevel = tonumber(data.param4)
					end
	    		end
    		end
        elseif data.param1 == 2 then  -- 成员退出
        	if data.param2 ~= UserData.userId then  -- 刷新成员信息
        		UnionListData.unionData.memberNums = tostring(tonumber(UnionListData.unionData.memberNums) - 1)
		    	for i,v in ipairs(UnionListData.unionMemberData) do
		    		if v.id == data.param2 then
		    			table.remove(UnionListData.unionMemberData, i)
		    			break
		    		end
		    	end
        	end
        elseif data.param1 == 3 then  -- 职位变动
            for i,v in ipairs(UnionListData.unionMemberData) do
                if v.id == data.param2 then
                    v.duty = tostring(data.param3)
                    break
                end
	    	end
        elseif data.param1 == 4 then  -- 申请公会成员列表刷新
    		local a_param1 = data.a_param1[1]
    		local tableData = {
			    		userId   = a_param1.userid,
	        			name     = a_param1.name,
	        			icon     = a_param1.headSrc,
	        			exp      = tonumber(a_param1.exp),  -- 经验
	        			power    = tostring(math.ceil(a_param1.combat)),  -- 战力
	        			vipLevel = tostring(a_param1.vipLevel),
	        		}
			UnionListData:insertApplyData(tableData)
		elseif data.param1 == 5 then  -- 增加公会经验
			UnionListData:setUnionExp(tonumber(data.param3))
			if data.param4 then
				UserData.unionLevel = tonumber(data.param4)
			end
        end

    	GameDispatcher:dispatchEvent({name = EVENT_CONSTANT.NET_CALLBACK,data = data})

    end
end

function NoticeUnionMemberResponse:ctor()
	--响应消息号
	self.order = 30021
	--通知内容,1:成员加入,2:成员退出,3:职位变动,4:申请公会
	self.param1 =  ""
	--相关成员userid
	self.param2 =  ""
	--相关参数:职位
	self.param3 =  ""
	--返回结果,1:成功
	self.result =  ""
	--公会成员UserID
	self.userid =  ""
	--公会成员ID
	self.teamid =  ""
	--战队经验值
	self.exp =  ""
	--公会成员昵称
	self.name =  ""
	--公会职位,1:会长,2:副会长3:管理员,4:普通会员
	self.duty =  ""
	--头像
	self.headSrc =  ""
	--上次登录时间
	self.logintime =  ""
	--战斗力
	self.combat =  ""
	--总贡献
	self.totalPay =  ""
	--今日贡献
	self.dailyPay =  ""
	--VIP等级
	self.viplevel =  ""
	--头像
	self.headSrc =  ""
end

return NoticeUnionMemberResponse
