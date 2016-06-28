--[[
进入修炼圣地界面
]]
local HolyLandVisitor = class("HolyLandVisitor", base.SceneVisitor)

local function isEnable(level, userLv, data)
	if userLv >= level and (not data) then
		return true
	end
end

function HolyLandVisitor:toScene(totype)
	local lv = UserData:getUserLevel();

	if isEnable(OpenLvData.holyLight.openLv, lv, TrialData:getLight(1)) or 
		isEnable(OpenLvData.holyHouse.openLv, lv, TrialData:getHouse(1)) or 
		isEnable(OpenLvData.holyMount.openLv, lv, TrialData:getMount(1)) then -- 有新解锁
		self:netToScene(toType)
	else 
		self:didToScene(totype)
	end	
end

function HolyLandVisitor:didToScene(totype)
	self:toScene_("HolyLandScene", totype)
end

function HolyLandVisitor:netToScene(totype)
	self:sendData("OpenTrials", nil, function()
		self:didToScene(totype)
	end)
end

function HolyLandVisitor:getNetOrder()
	return "OpenTrials"
end

return HolyLandVisitor