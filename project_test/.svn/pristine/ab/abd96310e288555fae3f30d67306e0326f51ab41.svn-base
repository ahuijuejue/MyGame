--[[
进入城建
]]
local CityVisitor = class("CityVisitor", base.SceneVisitor)

function CityVisitor:toScene(totype)
	if UserData:getUserLevel() >= OpenLvData.city.openLv then
        self:toScene_("CityScene", totype)
    else
        local param = {text = OpenLvData.city.openLv.."级开启",size = 30,color = display.COLOR_RED}
        showToast(param)
    end
end

return CityVisitor