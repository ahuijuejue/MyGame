
local SceneElement = class("SceneElement")

function SceneElement:ctor()
	
end

function SceneElement:pushScene(visitor)
	visitor:pushScene()
end

function SceneElement:enterScene(visitor)
	visitor:enterScene()
end

function SceneElement:netPushScene(visitor)
	visitor:netPushScene()
end

function SceneElement:netEnterScene(visitor)
	visitor:netEnterScene()
end

return SceneElement
