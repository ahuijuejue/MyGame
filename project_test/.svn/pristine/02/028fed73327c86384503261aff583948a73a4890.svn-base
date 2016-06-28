local BasicScene = class("BasicScene",function ()
	return display.newScene()
end)

function BasicScene:ctor(name)
	self.name = name
	self.isExit = false
end

function BasicScene:onEnter()
	if self.isExit then
		self.isExit = false
	end
end

function BasicScene:onExit()
	self.isExit = true
end

return BasicScene