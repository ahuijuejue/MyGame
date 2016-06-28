local UnionModel = class("UnionModel")

function UnionModel:ctor(param)
	-- 公告
	self.notice = param.notice or ""
	-- 工会名
	self.name = param.name or ""
	-- 工会id
	self.id = param.id or ""
	-- 工会介绍
	self.info = param.info or ""
	-- 工会经验
	self.exp = param.exp or ""
	-- 工会icon
	self.icon = param.icon or ""
	-- 工会成员
	self.memberList = param.memberList or {}
	-- 工会申请成员
	self.applyList = param.applyList or {}
	-- 公会已有成员人数
	self.memberNums = param.memberNums or 0
	-- 公会最大成员人数
    self.memberMaxNums = param.memberMaxNums or 0
    -- 申请等级
    self.applyLv = param.applyLv or 0
    -- 申请类型  是否需要审批
    self.applyType = param.applyType or 0
    -- 是否申请过的标识
    self.isApply = param.isApply or 0

end

function UnionModel:unionMember(param)
	local member = {
		id        = param.userid or "",  -- 唯一标识
		teamId    = param.teamid or "",
		name      = param.name or "",
		duty      = param.duty or "4",
		headIcon  = param.headSrc or "",
		loginTime = param.logintime or "",
		totalCon  = param.totalPay or "",
		todayCon  = param.dailyPay or "",
		totalPower = tostring(tonumber(param.combat)) or "",
		exp        = tonumber(param.exp) or 0,
	}
	return member
end

return UnionModel